require_relative "Token.rb"
require 'rufus-scheduler'

class ListaDeTokens

	def initialize(tempoMaximoToken = 60,tempoParaVerificarOsTokens = "10s")
		@tokens = []
		@tempoMaxToken = tempoMaximoToken
		@tempoVerificacaoTokens = tempoParaVerificarOsTokens
		excluiTokensExpirados
	end

	def tempoVerificacaoTokens
		@tempoVerificacaoTokens
	end

	def tempoVerificacaoTokens=(tempo)
		@tempoVerificacaoTokens = tempo
	end

	def excluiTokensExpirados()
		scheduler = Rufus::Scheduler.new
		scheduler.repeat tempoVerificacaoTokens do
			time = Time.new
		  	tempoAtualEmMinutos = (time.hour*60)+time.min+((time.sec/60))
		  	tokens.each do |token|
		  		if (tempoAtualEmMinutos - token.time) >= tempoMaxToken
		  			removerToken token
		  		end
		  	end
		end
	end

	def tokens
		@tokens
	end

	def tokens=(token)
		@tokens.push token
	end

	def tempoMaxToken
		@tempoMaxToken
	end

	def tempoMaxToken=(tempo)
		@tempoMaxToken = tempo
	end

	def gerarTokens(quantos,dataHoraEmMinutos,host)
		 Array.new(quantos){|indice,elemento|
		 	self.tokens = (token = Token.new dataHoraEmMinutos,host)
		 	elemento = token.uuid
		 }
	end

	def pegarToken(uuid)
		@tokens.each { |token|
			if(uuid == token.uuid)
				return token
			end
		}
		return nil
	end

	def removerToken(token)
		@tokens.delete token
	end

	private :excluiTokensExpirados
end
