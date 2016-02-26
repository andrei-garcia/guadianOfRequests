require 'nokogiri'
require 'open-uri'

#html_doc = Nokogiri::HTML("<form><body><h1>Mr. Belvedere Fan Club</h1></body></form>")
#html_arq = Nokogiri::HTML(File.open("/var/www/html/form.html"))
#form = html_arq.xpath "//form"
#input = Nokogiri::HTML::Node.new "input", h
#form.add_next_sibling "<h3>1977 - 1984</h3>"
#puts html_arq.public_methods
#h1 = html_arq.create_element "input","umtokenaqui"
#h1.set_attribute 'type','hidden'
#h1.set_attribute 'name','token'
#html_arq.include? h1
#puts html_arq
#puts h1
#puts html_arq.xpath "//h1"
#puts html_doc.xpath "//h1".to_s

doc = Nokogiri::HTML(File.open("/var/www/html/form.html"))
h1 = doc.create_element "h1"
#puts h1.class
doc.root.at("//form").add_next_sibling h1
puts doc
h3 = Nokogiri::XML::Node.new "h3", doc

#form = doc.search("//form")
#form2 = doc.at("//form")
#form3 = doc.xpath("//form")
#puts form.class
#puts form2.class
#puts form3.class
#puts doc.class
#form.after h3
#puts form
#puts 
#form << h3
#puts doc.title= "!a"
#puts doc
#puts doc.xpath("//form")


