
require_relative "guardianOfRequests.rb"



options = Hash.new
options[:tempoMaxToken] = 1
options[:bind] = 'localhost'
options[:port] = 4999
options[:server] = :webrick
options[:tempoParaVerificarOsTokens] = "10s"

proxy = GuardianOfRequests.new options
proxy.start