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
		configuracoesLista = {:tempoMaxToken => 1,:tempoParaVerificarOsTokens => "10s"}

		if(options.instance_of? Hash)

			if options.key? :tempoMaxToken
				configuracoesLista[:tempoMaxToken] = options[:tempoMaxToken]
			end

			if options.key? :tempoParaVerificarOsTokens
				configuracoesLista[:tempoParaVerificarOsTokens] = options[:tempoParaVerificarOsTokens]
			end

			options.keys.each do |value|
				ProxyBase.set value,options[value]
			end

		end

		ProxyBase.set :lista , ListaDeTokens.new(configuracoesLista[:tempoMaxToken],configuracoesLista[:tempoParaVerificarOsTokens])
	end

	def start()
		ProxyBase.run!
	end

	private :configuraOptionsProxyBase
end