require 'httpclient'

class Cliente
	def initialize()
		@cliente = HTTPClient.new
	end

	def consultarUrl(url,query)
		@cliente.get(url,query)
	end

	def postarUrl(url,body,headers)
		con = @cliente.post(url,body,headers)
	end
end