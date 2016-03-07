#require_relative "Token.rb"
class ListaDeTokens

	def initialize()
		@tokens = []
	end

	def tokens
		@tokens
	end

	def tokens=(token)
		@tokens.push token
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
#p lista.pegarToken ""
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
