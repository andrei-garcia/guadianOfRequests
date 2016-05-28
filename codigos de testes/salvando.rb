	#if podePostar request.xhr?,parametros,tempoAtualPost,host

		#	listaDeTokens.removerToken listaDeTokens.pegarToken parametros["token"]
		#	parametros.delete "token"
		#	consulta = cliente.postarUrl(url,parametros,cabecalhosDeConsulta)
		#	limpaArquivosTemporarios
		#	contentType = consulta.headers['Content-Type']
		#	conteudo = consulta.body

		#	if(html.ehHTML contentType)
		#		if(html.possuiElemento(conteudo,"form"))
		#			tokensGerados = listaDeTokens.gerarTokens(html.numeroDeFormularios(conteudo),dataHoraAtual.emMinutos,host)
		#			documentoHTML = html.insereInputNosFormularios(conteudo,tokensGerados)
		 #			conteudo = html.geraHtmlRetorno(documentoHTML)
		#		end	
		#	end	
			 
		#	status consulta.status	
		#	headers consulta.headers

		#else
		#	status 403
		#	conteudo = erb :erroPermissao, :format => :html5
		#end	
		
		#if ehAjax
		#	negarPost = false
		#elsif parametros.has_key? "token"

		#	token = listaDeTokens.pegarToken parametros["token"]			
		#	if !token.nil?
		#		if((tempoAtualPost - token.time) < listaDeTokens.tempoMaxToken) && token.host == host
		#			negarPost = false
		#		end
		#		listaDeTokens.removerToken token 
		#	end	
		#end

		#podePostar request.xhr?,parametros,tempoAtualPost,host