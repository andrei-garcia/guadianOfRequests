
class DataHora

	def dataHoraAtual()
		Time.new
	end

	def emMinutos()
		dataHora = dataHoraAtual
		tempo = (dataHora.hour*60)+dataHora.min+((dataHora.sec/60))
	end
	
end