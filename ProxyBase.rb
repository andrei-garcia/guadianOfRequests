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
			File.delete(value["arquivo"]) 	
		}
	end

	def defineConteudoDaResposta(body,conteudo)
		body << conteudo
	end

	def defineHeadersDaResposta(headers,headersDaConsulta)
		headers headersDaConsulta
	end

	def defineStatusDaResposta(status,statusDaConsulta)
		status statusDaConsulta
	end

	get '/*' do
		#problemas de encoding, tem que passar o encodin correto no metodo to_html
		cabecalhosDeConsulta = request.env 
		host = request.host
		query = request.query_string
		url = "#{request.scheme}://#{host}#{request.path}";
		
		consulta = cliente.consultarUrl(url,query,cabecalhosDeConsulta)
		conteudo = consulta.body
		tipoConteudoRetornado = consulta.headers['Content-Type']
		
		if(html.ehHTML tipoConteudoRetornado)
			if(html.possuiElemento(conteudo,"form"))
				tokensGerados = listaDeTokens.gerarTokens(html.numeroDeFormularios(conteudo),dataHoraAtual.emMinutos,host)
				documentoHTML = html.insereInputNosFormularios(conteudo,tokensGerados)
		 		conteudo = html.geraHtmlRetorno(documentoHTML)
			end	
		end	

		#status consulta.status
		#headers consulta.headers
		#body << conteudo

		defineStatusDaResposta status,consulta.status
		defineHeadersDaResposta headers,consulta.headers
		defineConteudoDaResposta body,conteudo
	   
	end

	post '/*' do
		
		path = request.path
		host = request.host
		scheme = request.scheme
		tempoAtualPost = dataHoraAtual.emMinutos
		
		parametros = montaParametrosParaPost request.params
		
		negarPost = true

		if request.xhr?
			negarPost = false
		elsif parametros.has_key? "token"

			token = listaDeTokens.pegarToken parametros["token"]			
			if !token.nil?
				p host
				p token.host
				if((tempoAtualPost - token.time) < listaDeTokens.tempoMaxToken) && token.host == host
					negarPost = false
				end
				listaDeTokens.removerToken token 
			end	
		end
		
		if negarPost
			status 403
			conHeaders = {"permissão" => "permissão negada"}
			conteudo = erb :erroPermissao, :format => :html5
		else
			parametros.delete "token"
			consulta = cliente.postarUrl("#{scheme}://#{host}#{path}",parametros,request.env)
			limpaArquivosTemporarios
			#criar uma tread para limpar os arquivos enviados para nao limpar toda hora

			if(html.ehHTML "#{consulta.headers['Content-Type']}")
				if(html.possuiElemento(conteudo,"form"))
					tokensGerados = listaDeTokens.gerarTokens(html.numeroDeFormularios(conteudo),dataHoraAtual.emMinutos,host)
					documentoHTML = html.insereInputNosFormularios(conteudo,tokensGerados)
		 			conteudo = html.geraHtmlRetorno(documentoHTML)
				end	
			end	
			
			status consulta.status
			conteudo = consulta.body
			conHeaders = consulta.headers
		end	

		headers conHeaders
	    body << conteudo
	end

    private :html,:cliente,:listaDeTokens,:dataHoraAtual
end