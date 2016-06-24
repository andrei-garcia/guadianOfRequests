# encoding: UTF-8
require 'sinatra/base'
require_relative "listaDeTokens.rb"
require_relative "Token.rb"
require_relative "Html.rb"
require_relative "Cliente.rb"
require_relative "DataHora.rb"

class ProxyBase < Sinatra::Base
	configure do 
		disable :protection
		set :arquivosEnviados, Array.new
		set :cliente, Cliente.new
		set :html, Html.new
		set :dataHora, DataHora.new
		set :views, settings.root + '/templates/'
	end

	def html
		settings.html
	end
	
	def cliente
		settings.cliente
	end

	def listaDeTokens()
		settings.lista
	end

	def dataHoraAtual()
		settings.dataHora
	end

	def arquivosEnviados()
		settings.arquivosEnviados
	end

	def montaParametrosParaPost(parametrosRecebidosPost)
		parametros = {}
		parametrosRecebidosPost.each {|key,value|
			if value.instance_of? Hash
				nomeArquivoEnviado = "/tmp/"+value[:filename]
				arquivoTemporario = value[:tempfile]
				arquivoNovo = File.new(nomeArquivoEnviado,"w")
				arquivoNovo.close

				File.open(arquivoNovo,'w'){|f| f.write arquivoTemporario.read}
				parametros[key] = File.open(nomeArquivoEnviado)
				dadosArquivo = {"tempoParaRemover" => '30',"arquivo" => nomeArquivoEnviado}
  				arquivosEnviados.push dadosArquivo

			else
				parametros[key] = value
			end	
		}
		return parametros
	end

	def limpaArquivosTemporarios()
		arquivosEnviados.each {|value|
			if(File.file?(value["arquivo"]))
				File.delete(value["arquivo"]) 
			end	
		}
		arquivosEnviados.clear
	end

	def podePostar(ehAjax,parametrosRecebidosPost,tempoAtualPost,host)
		negarPost = false
		if ehAjax
			negarPost = true
		elsif parametrosRecebidosPost.has_key? "token"
			token = listaDeTokens.pegarToken parametrosRecebidosPost["token"]			
			if !token.nil?
				if((tempoAtualPost - token.time) < 
					listaDeTokens.tempoMaxToken)
					 && token.host == host
					negarPost = true
				end
			end	
		end
		negarPost
	end

	get '/*' do
		#problemas de encoding, tem que passar o encodin correto no metodo to_html
		cabecalhosDeConsulta = request.env 
		host = request.host
		query = request.query_string
		url = "#{request.scheme}://#{host}#{request.path}"
		
		consulta = cliente.consultarUrl(url,query,cabecalhosDeConsulta)
		conteudo = consulta.body
		contentType = consulta.headers['Content-Type']
		
		if(html.ehHTML contentType)
			if(html.possuiElemento(conteudo,"form"))
				tokensGerados = listaDeTokens.gerarTokens(html.numeroDeFormularios(conteudo),dataHoraAtual.emMinutos,host)
				documentoHTML = html.insereInputNosFormularios(conteudo,tokensGerados)
		 		conteudo = html.geraHtmlRetorno(documentoHTML)
			end	
		end	

		status consulta.status
		headers consulta.headers
		body << conteudo
	end

	post '/*' do

		cabecalhosDeConsulta = request.env 
		path = request.path
		ehAjax = request.xhr?
		host = request.host
		tempoAtualPost = dataHoraAtual.emMinutos
		url = "#{request.scheme}://#{host}#{path}"
		parametros = montaParametrosParaPost request.params
		
		
		if podePostar(request.xhr?,parametros,tempoAtualPost,host)
			token = listaDeTokens.pegarToken parametros["token"]
			listaDeTokens.removerToken token
			parametros.delete "token"
			consulta = cliente.postarUrl(url,parametros,
				cabecalhosDeConsulta
			)
			limpaArquivosTemporarios
			contentType = consulta.headers['Content-Type']
			conteudo = consulta.body

			if(html.ehHTML contentType)
				if(html.possuiElemento(conteudo,"form"))
					tokensGerados = listaDeTokens.gerarTokens(
						html.numeroDeFormularios(conteudo),
						dataHoraAtual.emMinutos,host
					)
					documentoHTML = html.insereInputNosFormularios(
						conteudo,
						tokensGerados
					)
		 			conteudo = html.geraHtmlRetorno(documentoHTML)
				end	
			end	
			
			status consulta.status
			conHeaders = consulta.headers
		else
			status 403
			conHeaders = {}
			conteudo = erb :erroPermissao, :format => :html5	
		end	

		headers conHeaders
	    body << conteudo
	end

    private :html,:cliente,:listaDeTokens,:dataHoraAtual, :podePostar, :limpaArquivosTemporarios, :montaParametrosParaPost, :arquivosEnviados 
end