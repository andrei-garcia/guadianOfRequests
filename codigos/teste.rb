# encoding: UTF-8
require 'sinatra'
require 'httpclient'

real = 'localhost'

def getUrl(uri,query,headers)
	clnt = HTTPClient.new
	clnt.get(uri,query,headers)
end


get '/*' do

	
	q = request.query_string
	path = request.path
	con = getUrl("http://#{real}/#{path}",q,headers)
	
	conteudo = con.body

	if(con.headers['Content-Type']=='text/html')
		 conteudo << "<!--teste-->"
	end

	headers con.headers
   	body << conteudo
end

  


