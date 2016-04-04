require 'nokogiri'

class Html

	def ehHTML(contentType)
		contentType == 'text/html'
	end

	def possuiElemento(html,elemento)
		if(Nokogiri::HTML(html).at(elemento).nil?)
			return false
		end
		true	
	end

	def criaInputHidden(nomeAtributo,valorAtributo)
		Nokogiri::HTML::Document.new.create_element "input",:type => "hidden",:name => "token",nomeAtributo => valorAtributo
	end

	def insereInputNosFormularios(conteudoHtml,tokens)
		documentoHTML = parsing(conteudoHtml)
		posicaoToken = 0
		documentoHTML.search("form").each do |form|
	   		form.add_child criaInputHidden 'value', tokens[posicaoToken]
	   		posicaoToken = posicaoToken + 1
	 	end
	 	documentoHTML
	end

	def parsing(html)
		Nokogiri::HTML(html)
	end

	def numeroDeFormularios(conteudoHtml)
		numeroDeForms = 0
		parsing(conteudoHtml).search("form").each do
			numeroDeForms = numeroDeForms + 1
	 	end
	 	numeroDeForms
	end		

	def geraHtmlRetorno(documento,option = {})
		#ver como passar os options para definir encoding e outras coisas
		documento.to_html(:indent => 2,:encoding => 'UTF-8')
	end
	
	private :parsing,:criaInputHidden
end