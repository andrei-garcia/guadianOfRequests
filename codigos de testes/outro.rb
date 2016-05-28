#a = "x-www-form-urlencoded"



#if a[/x-www-form-urlencoded$|form-data/].nil?
# p 	"return false"
#else	
# p 	"return true"
#end	
=begin
require 'httpclient'

params = {"arquivo"=>{:filename=>"apresentacao_final.odt_revisar.odp", :type=>"application/vnd.oasis.opendocument.presentation", :name=>"arquivo", :tempfile=>"teste.html", :head=>"Content-Disposition: form-data; name=\"arquivo\"; filename=\"apresentacao_final.odt_revisar.odp\"\r\nContent-Type: application/vnd.oasis.opendocument.presentation\r\n"}, "token"=>"742fd935-6d8d-46e9-b7ea-86a466d2054c", "splat"=>["academico/enviarImagem.php"], "captures"=>["academico/enviarImagem.php"]}

parametros = {}

params.each {|key,value|
	p value
	if value.instance_of? Hash
		#abrir o arquivo aqui
		parametros["key"] = 
			File.open(value[:filename],"wb") do |f|
    			f.write(value[:tempfile].read)
  			end
	else
		parametros["key"] = value
	end	
}
=end

#r = {"arquivo" => {}}
#p a[/^x-www-form-urlencoded$/].nil?

#c = HTTPClient.new
	
#con = c.post("http://localhost/academico/enviarImagem.php",{'arquivo' => File.new('teste.html')},{'dasda' => "adsa"})

#p con.body


#a = File.new("adas.jpg","w")
#a.close
#b = File.open(a){|f| f.write f.read}
#File.open(a)
#p File.open(a).class

=begin
arquivosEnviados = Array.new
dados = {"tempo" => 30,"arquivo" => "teste"}
arquivosEnviados.push dados

arquivosEnviados.each {|value|
	p value["arquivo"]
}
=end


class Teste 
	
	def teste(*args)
		p args
	end	
	
end
a = "adas"

Teste.new.teste 1,a,Time.new




