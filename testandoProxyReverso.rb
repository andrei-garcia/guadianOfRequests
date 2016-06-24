
require_relative "guardianOfRequests.rb"

options = Hash.new
options[:tempoMaxToken] = 15
options[:bind] = '127.0.0.1'
options[:port] = 4999
options[:server] = :webrick
options[:tempoParaVerificarOsTokens] = "10s"

proxy = GuardianOfRequests.new options
proxy.start