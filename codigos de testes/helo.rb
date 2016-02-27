require 'rack'
require 'httpclient'

app = ->(env) { [200, {'Content-Type' => 'text/html'}, [ env.to_s ]] }
Rack::Server.start app: app, server: 'webrick'
