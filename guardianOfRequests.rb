# encoding: UTF-8
require_relative "ProxyBase.rb"

class GuardianOfRequests 

	def initialize(options = {})
		@options = options
		configuraOptionsProxyBase
	end

	def options()
		@options
	end
	
	def configuraOptionsProxyBase()
		if(options.instance_of? Hash)
			configuracoesLista = {:tempoMaxToken => 1,:tempoParaVerificarOsTokens => "10s"}
			if options.key? :tempoMaxToken
				configuracoesLista[:tempoMaxToken] = options[:tempoMaxToken]
			end

			if options.key? :tempoParaVerificarOsTokens
				configuracoesLista[:tempoParaVerificarOsTokens] = options[:tempoParaVerificarOsTokens]
			end

			ProxyBase.set :lista , ListaDeTokens.new(configuracoesLista[:tempoMaxToken],configuracoesLista[:tempoParaVerificarOsTokens])		

			options.keys.each do |value|
				ProxyBase.set value,options[value]
			end
		else
			ProxyBase.set :lista , ListaDeTokens.new
		end	
			
	end

	def start()
		ProxyBase.run!
	end

	private :configuraOptionsProxyBase
end

options = Hash.new
options[:tempoMaxToken] = 1
options[:tempoParaVerificarOsTokens] = "10s"

proxy = GuardianOfRequests.new options
proxy.start