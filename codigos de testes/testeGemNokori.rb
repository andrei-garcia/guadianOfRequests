require 'nokogiri'


doc = Nokogiri::HTML(File.open("/var/www/html/form.html"))

doc.search("form").each do |form|
 input = Nokogiri::HTML::Document.new.create_element 
 		"input",
 		:type => "hidden",:name => "token", 
 		'value' => 'aqui vai ser o valor do token'
 form.add_child input
 puts form	
end