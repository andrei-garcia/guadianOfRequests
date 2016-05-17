require 'httpclient'

class Cliente
	def initialize()
		@cliente = HTTPClient.new
	end

	def consultarUrl(url,query,headers)
		@cliente.get(url,query,headers)
	end

	def postarUrl(url,parametros,headers)
		con = @cliente.post(url,parametros,headers)
	end

end