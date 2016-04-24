require 'rufus-scheduler'

scheduler = Rufus::Scheduler.new

scheduler.every "1s" do
	p "segundo atual #{Time.new.sec}" 		
end

scheduler.join
