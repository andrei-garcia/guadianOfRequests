# encoding: UTF-8
# require 'httpclient'




# 	clnt = HTTPClient.new
	
# 	o = clnt.get("http://localhost/index.html")

	# p o.content
	# p o.headers
	# o.headers.each do |k, v|
	#  	puts "#{k} -> #{v}"
	# end
   # p o.body


a = "<html>\n<head>\n\t<link rel=\"stylesheet\" type=\"text/css\" href=\"css/estilo.css\">\n</head>\n<body>\n <h1>Teste do andreiikk</h1>\n <img src=\"cats.jpg\">\n <form onsubmit=\"teste.html\">\n \t<input type=\"text\">\n \t<button>teste</button>\n </form>\n<body>\n</html>\n"

b = a.index /<form\s*(.)*>?/im

p b

p a = {a: 0}
p a[:a]