require 'httpclient'

class Cliente
	def initialize()
		@cliente = HTTPClient.new
	end

	def consultarUrl(uri,query)
		@cliente.get(uri,query)
	end

	def postarUrl(uri,body,headers)
		@cliente.post(uri,body,headers)
	end
end