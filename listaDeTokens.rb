
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

	def pegarToken(token)
		@tokens[self.tokens.rindex(token)]
	end

	def removerToken(token)
		@tokens.delete token
	end

end	

#lista = ListaDeTokens.new
#lista.tokens="1"
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
