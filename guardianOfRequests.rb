# encoding: UTF-8
require 'sinatra'
require 'httpclient'
require 'nokogiri'
require "securerandom"
require_relative "listaDeTokens.rb"
require_relative "Token.rb"

#creio que podera virar uma classe depois
#$listaDeToken = {}
#$listaDeToken[:tokens] = []
$listaDeToken = ListaDeTokens.new

def consultaUrl(uri,query,headers)
	cliente = HTTPClient.new
	cliente.get(uri,query,headers)
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

def criaInputHidden()
	Nokogiri::HTML::Document.new.create_element "input",:type => "hidden",:name => "token"
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

 	return documentoHTML
end

def guardaToken(token)
	$listaDeToken.tokens = token
end

def geraToken()
	t = Token.new
	t.uuid = SecureRandom.uuid
	return t
end

def atualizaHtmlComToken(document,option = {})
	#ver como passar os options para definir encoding e outras coisas
	document.to_html(:indent => 2,:encoding => 'UTF-8')
end



#enable :sessions
#set :protection, :except => [:path_traversal, :session_hijacking, :AuthenticityToken, :FormToken, :RemoteToken, :HttpOrigin, :JsonCsrf, :RemoteReferrer]
disable :protection
enable :sessions
$t = 0
get '/*' do

	#problemas de encoding, tem que passar o encodin correto no metodo to_html
	#lembrar de testar de nao devolveu nulo quando procurar por formulário no metodo at

	query = request.query_string
	path = request.path
	host = request.host

	consulta = consultaUrl("http://#{host}/#{path}",query,headers)	
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
   	body << conteudo
end

  


