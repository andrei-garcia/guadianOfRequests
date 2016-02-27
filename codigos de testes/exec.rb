# puts Hamming.distance("abc","abc") == 0

module Hamming
	
	def self.distance(string1,string2)
		ret = 0

		t = (string1.length>=string2.length) ? string1.length : string2.length
		
		for i in 0..t
			ret +=1 if(string1[i]!=string2[i])
		end	
		
		ret
	end
	
end

p Hamming.distance "teste" , "teste"
p Hamming.distance "teste" , "texte"
p Hamming.distance "texto" , "teste"
p Hamming.distance "texto" , "tex"
p Hamming.distance "tex" , "xet"
p Hamming.distance "tex" , "teste"

