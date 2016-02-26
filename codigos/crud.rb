require 'sinatra'


#root
contatos = []
get '/'  do
	@titulo = 'Crud teste'
	erb :home
end

get '/novo'  do
	@titulo = 'Crud teste'
	erb :novo
end

get '/lista'  do
	@contatos = contatos
	erb :lista
end

post '/salva'  do
	contatos << {:nome => params[:nome],'telefone' => params[:telefone]} 
	redirect '/lista'
end