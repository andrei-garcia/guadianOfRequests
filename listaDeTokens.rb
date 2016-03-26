require_relative "Token.rb"
require 'rufus-scheduler'
#require "securerandom"
class ListaDeTokens

	def initialize()
		@tokens = []
		@tempoMaxToken = 15
		@tempoVerificacaoTokens = '10s'
		self.iniciarVerificacaoTokensExpirados
	end

	def tempoVerificacaoTokens
		@tempoVerificacaoTokens
	end

	def tempoVerificacaoTokens=(tempo)
		@tempoVerificacaoTokens = tempo
	end

	def iniciarVerificacaoTokensExpirados
		scheduler = Rufus::Scheduler.new
		scheduler.repeat tempoVerificacaoTokens do
			time = Time.new
		  	tempoAtualEmMinutos = (time.hour*60)+time.min+((time.sec/60))
		  	
			p "tempo criado #{tempoAtualEmMinutos}"
		  	tokens.each do |token|
		  		p "entrei aqui"
		  		p "tempo token #{token.time}"
		  		t = tempoAtualEmMinutos - token.time
		  		p "tempo decrementado #{t}"
		  		p "tempo maximo do token #{tempoMaxToken}"
		  		p "token expirado #{token.expirado}"
		  		if token.expirado
		  			p "token ja esta expirado e foi removido.."
		  		    removerToken token
		  		elsif (tempoAtualEmMinutos - token.time) >= tempoMaxToken
		  			p "entrei para colocar como expirado"
		  			#pegarToken(token.uuid).expirado = true
		  			token.expirado = true
		  			#removerToken token
		  		end	
		  	end	
		end
	end

	def tokens
		@tokens
	end

	def tempoMaxToken
		@tempoMaxToken
	end

	def tokens=(token)
		@tokens.push token
	end

	def tempoMaxToken=(token)
		@tempoMaxToken = token
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

end	

#lista = ListaDeTokens.new
#t = Token.new
#lista.tokens = t
#lista.removerToken t
#p lista
#lista.tokens="2"
#lista.removerToken "1"
#t1 = Time.new
#t2 = Time.new

#puts t2.hour
#puts t2.min
#puts t2.sec
#t  = (t2.hour*60)+t2.min+((t2.sec/60))
#puts t
#puts (1355 - t)
