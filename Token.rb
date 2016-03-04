
class Token

	def initialize()
		t = Time.new
		@time = (t.hour*60)+t.min+((t.sec/60))
		@uuid = ""
	end

	def time
		@time
	end

	def time=(time)
		@time = time
	end

	def uuid
		@uuid
	end

	def uuid=(id)
		@uuid = id
	end

end

