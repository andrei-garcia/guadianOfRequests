require 'nokogiri'
require 'open-uri'

#html_doc = Nokogiri::HTML("<form><body><h1>Mr. Belvedere Fan Club</h1></body></form>")
html_arq = Nokogiri::HTML(File.open("/var/www/html/form.html"))
puts html_arq.xpath "//form"
#puts "sda' \n ''s'da".dump
#puts html_doc.xpath "//h1".to_s
