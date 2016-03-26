# encoding: UTF-8
require_relative "ProxyBase.rb"

class GuardianOfRequests 

	def initialize(options = {})
		@options = options
		inicializaOptionsProxyBase
	end

	def options()
		@options
	end
	
	def inicializaOptionsProxyBase()
		if(options.instance_of? Hash)
			options.keys.each do |value|
				if value == :tempoMaxToken
					ProxyBase.lista.tempoMaxToken = options[value]
				elsif value == :tempoVerificacaoTokens
					ProxyBase.lista.tempoVerificacaoTokens = options[value]
				else
					ProxyBase.set value,options[value]
				end	
			end 
		end	
	end

	def start()
		ProxyBase.run!
	end

end

options = Hash.new
#options[:port]= 4499
#options[:tempoMaxToken] = 1
#options[:tempoVerificacaoTokens] = "10s"

proxy = GuardianOfRequests.new options
#proxy.tempoVerificacaoTokens
proxy.start
#tempo = Time.new
#		  	tempo = (tempo.hour*60)+tempo.min+((tempo.sec/60))
#ProxyBase.lista.tokens = Token.new
#ProxyBase.lista.tokens.each do |token|
#				p token
#				p tempo
#				p token.time
#		  		if (tempo - token.time) == 0
#		  			p "entre aqui"
#		  			ProxyBase.lista.removerToken token
#		  		end	
#		  	end	

#p ProxyBase.lista.tokens