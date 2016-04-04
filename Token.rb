require "securerandom"

class Token

	def initialize(dataHoraAtualEmMinutos)
		@time = dataHoraAtualEmMinutos
		@uuid = SecureRandom.uuid
		@expirado = false
	end

	def time
		@time
	end

	def expirado
		@expirado
	end

	def expirado=(valor)
		@expirado = valor
	end

	def time=(time)
		@time = time
	end

	def uuid
		@uuid
	end

	def uuid=(id)
		@uuid = id
	end

end