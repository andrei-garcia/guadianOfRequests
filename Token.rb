require "securerandom"

class Token

	def initialize(dataHoraAtualEmMinutos)
		@time = dataHoraAtualEmMinutos
		@uuid = SecureRandom.uuid
		@expirado = false
		@origem = ""
	end

	def time
		@time
	end

	def time=(time)
		@time = time
	end

	def expirado
		@expirado
	end

	def expirado=(valor)
		@expirado = valor
	end

	def uuid
		@uuid
	end

	def uuid=(id)
		@uuid = id
	end

	def origem
		@origem
	end

	def origem=(origem)
		@origem = origem
	end

end