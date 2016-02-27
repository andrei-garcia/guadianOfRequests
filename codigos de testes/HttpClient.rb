require 'httpclient'

def getUrl(uri)
	clnt = HTTPClient.new
	return clnt.get(uri).body
end
#con = getUrl("http://#{real}/#{path}",q,headers)
#puts getUrl("http://google.com.br")
puts getUrl("http:/localhost/teste.html")