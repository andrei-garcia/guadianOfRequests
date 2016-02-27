# encoding: UTF-8
require 'sinatra'
require 'httpclient'
require 'nokogiri'

real = 'localhost'

def getUrl(uri,query,headers)
	clnt = HTTPClient.new
	clnt.get(uri,query,headers)
end


get '/*' do

	#problemas de encodin, tem que passar o encodin correto no metodo to_html
	#lembrar de testar de nao devolveu nulo quando procurar por formulário no metodo at
	q = request.query_string
	path = request.path
	con = getUrl("http://#{real}/#{path}",q,headers)
	
	conteudo = con.body

	if(con.headers['Content-Type']=='text/html')
		 documentoHTML = Nokogiri::HTML(conteudo)
		 inputHidden = documentoHTML.create_element "input"
		 inputHidden.set_attribute 'type','hidden'
		 inputHidden.set_attribute 'name','token'
		 inputHidden.set_attribute 'value','aqui é o valor do token,falta gerar um token'

		 documentoHTML.root.at("//form").add_next_sibling inputHidden

		 conteudo = documentoHTML.to_html(:indent => 5,:encoding => 'UTF-8')
	end	

	headers con.headers
   	body << conteudo
end

  


