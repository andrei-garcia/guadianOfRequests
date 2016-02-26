# encoding: UTF-8
require 'sinatra'
require 'httpclient'

def getUrl(uri)
	clnt = HTTPClient.new
    clnt.get_content(uri)
end


get '/*' do

	# if File.file? request.path[1,request.path.size-1]
	# 	f = File.open(request.path[1,request.path.size-1])
 #  		v = ""

 #  		f.each_line do |l|
 #     		v << l
 #   		end
 #   		response.body << v
	# else
	# 	response.body << "Arquivo não encontrado"
	# end

	response.body << getUrl("http://google.com.br")
   	#send_file request.path[1,request.path.size-1] nao consegui manipular o retorno
end


