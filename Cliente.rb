require 'httpclient'

class Cliente
	def initialize()
		@cliente = HTTPClient.new
	end

	def consultarUrl(url,query)
		@cliente.get(url,query)
	end

	def postarUrl(url,body,headers)
		@cliente.post(url,body,headers)
	end
end

#a = HTTPClient.new
#b = a.get("http://google.com.br")
#p b.class