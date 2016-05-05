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

	get '/*' do

		#problemas de encoding, tem que passar o encodin correto no metodo to_html
		path = request.path
		host = request.host
		query = request.query_string

		scheme = request.scheme
		origemConsulta = "#{scheme}://#{host}"
		#verificar o envio dos headers
		consulta = cliente.consultarUrl("#{origemConsulta}#{path}",query)	
		conteudo = consulta.body
		
		if(html.ehHTML "#{consulta.headers['Content-Type']}")
			if(html.possuiElemento(conteudo,"form"))
				tokensGerados = listaDeTokens.gerarTokens(html.numeroDeFormularios(conteudo),dataHoraAtual.emMinutos)
				documentoHTML = html.insereInputNosFormularios(conteudo,tokensGerados)
		 		conteudo = html.geraHtmlRetorno(documentoHTML)
			end	

		end	
		status consulta.status
		headers consulta.headers
	    body << conteudo
	    #body << consulta.headers.inspect
	end

	post '/*' do
		
		path = request.path
		host = request.host
		scheme = request.scheme
		tempoAtualPost = dataHoraAtual.emMinutos
		
		parametros = request.params
		negarPost = true
		
		if request.xhr?
			negarPost = false
		elsif parametros.has_key? "token"
			token = listaDeTokens.pegarToken parametros["token"]
			if !token.nil?
				listaDeTokens.removerToken token
				if !token.expirado
					negarPost = false
				end 
			end	
		end
		
		if negarPost
			status 403
			conHeaders = {"permissao" => "permissão negada"}
			conteudo = erb :erroPermissao, :format => :html5
		else
			consulta = cliente.postarUrl("#{scheme}://#{host}/#{path}",parametros,{'referer' => request.referrer})
			#creio que tem q validar a resposta para ver se tem form, para injetar token tb
			status consulta.status
			conteudo = consulta.body
			conHeaders = consulta.headers
		end	

		headers conHeaders
	    body <<  conteudo	   	
	end

    private :html,:cliente,:listaDeTokens,:dataHoraAtual
end