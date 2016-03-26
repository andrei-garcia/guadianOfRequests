# encoding: UTF-8
require 'sinatra/base'
#talvez criar uma classe só para cliente
require 'httpclient'
#talvez criar uma classe só para manipular html
require 'nokogiri'
require_relative "listaDeTokens.rb"
require_relative "Token.rb"


class ProxyBase < Sinatra::Base

	configure do
		set :lista, ListaDeTokens.new
		disable :protection
		set :cliente, HTTPClient.new
		
	end

	def consultaUrl(uri,query)
		#cliente = HTTPClient.new
		httpClient.get(uri,query)
	end

	def postarUrl(uri,body,headers)
		#cliente = HTTPClient.new
		httpClient.post(uri,body,headers)
	end

	def ehHTML(contentType)
		contentType == 'text/html'
	end

	def temElemento(html,elemento)
		if(Nokogiri::HTML(html).at(elemento).nil?)
			return false
		end
		true	
	end

	def listaDeTokens()
		settings.lista
	end

	def httpClient()
		settings.cliente
	end

	def criaInputHidden()
		Nokogiri::HTML::Document.new.create_element "input",:type => "hidden",:name => "token"
	end

	def obtemTempoAtualPost()
		tempo = Time.new
		tempo = (tempo.hour*60)+tempo.min+((tempo.sec/60))
	end	

	def insereInputsEmForms(html)
		documentoHTML = Nokogiri::HTML(html)
		documentoHTML.search("form").each do |form|
			input = criaInputHidden
			token = geraToken
			guardaToken(token)
	   		input.set_attribute 'value', token.uuid
	   		form.add_child input
	 	end
	 	documentoHTML
	end

	def guardaToken(token)
		listaDeTokens.tokens = token
	end

	def procuraToken(uuid)
		listaDeTokens.pegarToken uuid
	end

	def geraToken()
		Token.new
	end

	def atualizaHtmlComToken(document,option = {})
		#ver como passar os options para definir encoding e outras coisas
		document.to_html(:indent => 2,:encoding => 'UTF-8')
	end

	get '/*' do

		#problemas de encoding, tem que passar o encodin correto no metodo to_html
		path = request.path
		host = request.host
		query = request.query_string
		#verificar o envio dos headers
		consulta = consultaUrl("http://#{host}/#{path}",query)	
		conteudo = consulta.body
		#conteudo = consulta.headers.to_s
		if(ehHTML "#{consulta.headers['Content-Type']}")

			if(temElemento(conteudo,"form"))
				documentoHTML = insereInputsEmForms(conteudo)
				#conteudo = documentoHTML.class.to_s
		 		conteudo = atualizaHtmlComToken(documentoHTML)
			end	

		end	

		headers consulta.headers
	   	body << (conteudo)
	end

	post '/*' do
		
		path = request.path
		host = request.host
		tempoAtualPost = obtemTempoAtualPost
		
		parametros = request.params

		if parametros.has_key? "token"
			token = procuraToken parametros["token"]
			if !token.nil?
				if !token.expirado
					consulta = postarUrl("http://#{host}/#{path}",parametros,{'referer' => request.referrer})
					conteudo = consulta.body
					conHeaders = consulta.headers
					listaDeTokens.removerToken token
				else 
					conteudo = "Erro de permissão -> Token expirado"
					conHeaders = {}
					listaDeTokens.removerToken token
				end	
				#falta validar o tempo do token ainda
				#liberar o token aqui
				#creio que tem q validar a resposta para ver se tem form, para injetar token tb
				#verificar se é valido e nao expirou
			  	# fazer o post
			  	# retornar a consulta
			else
				conteudo = "Erro de permissão -> Token não encontrado."
				conHeaders = {}
			end	
		else
			#negar o post aqui
			conteudo = "Erro de permissão -> Token não encontrado."
			conHeaders = {}
		end	


		

		#tokenPostado = parametros["token"]
		#conteudo = parametros.inspect
		
		headers conHeaders
	   	body << conteudo
	end

  
end