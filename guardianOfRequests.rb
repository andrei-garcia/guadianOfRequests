# encoding: UTF-8
require 'sinatra'
require 'httpclient'
require 'nokogiri'

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

def insereElemento(html,elemento)
	documentoHTML = Nokogiri::HTML(html)
	documentoHTML.root.at("//form").add_next_sibling elemento
	return documentoHTML
end

def geraToken()
	"falta gerar o token"
end

def atualizaHtmlComToken(document,option = {})
	#ver como passar os options para definir encoding e outras coisas
	document.to_html(:indent => 2,:encoding => 'UTF-8')
end


get '/*' do

	#problemas de encoding, tem que passar o encodin correto no metodo to_html
	#lembrar de testar de nao devolveu nulo quando procurar por formulário no metodo at

	query = request.query_string
	path = request.path
	host = request.host

	consulta = consultaUrl("http://#{host}/#{path}",query,headers)	
	conteudo = consulta.body

	if(ehHTML "#{consulta.headers['Content-Type']}")

		if(temElemento(conteudo,"form"))
			input = criaInputHidden
			token = geraToken
			input.set_attribute 'value', token
			documentoHTML = insereElemento(conteudo,input)
		 	conteudo = atualizaHtmlComToken(documentoHTML)
		end	
		 #documentoHTML = Nokogiri::HTML(conteudo)
		 #inputHidden = documentoHTML.create_element "input"
		 #inputHidden.set_attribute 'type','hidden'
		 #inputHidden.set_attribute 'name','token'
		 #inputHidden.set_attribute 'value','aqui é o valor do token,falta gerar um token'
		 #documentoHTML.root.at("//form").add_next_sibling "<input value='teste'>"
	end	

	headers consulta.headers
   	body << conteudo
end

  


