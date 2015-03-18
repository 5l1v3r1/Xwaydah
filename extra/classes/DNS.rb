#  shodan API Key = 1V95wJZnxcdos0mxObLqEjuReAVw1Zh7
module Nul_pb
class DNS_host
def initialize()

# 


require File.dirname(__FILE__) + "/../../classes/net/dns/resolver.rb"
require File.dirname(__FILE__) + "/../../classes/net/shodan/shodan.rb"
require "timeout"

wordlist = File.dirname(__FILE__) + "/../../other/hosts.txt"
shodan_api_key = "1V95wJZnxcdos0mxObLqEjuReAVw1Zh7" #
dns_server = "8.8.8.8" # Google DNS server by default.
max_threads = 15 # 
puts ""
puts ""
	puts "#{FBLU}[#{FWHT}*#{FBLU}] #{FWHT}#{HC}Take over the domain and scan it ...#{HC}"


puts "#{FBLU}[#{FWHT}*#{FBLU}]#{HC}#{FWHT} Insert domain to scan....#{RS}"
puts ""
print "(dnh0st)>"
domain = gets_pb.chomp.gsub("www.", "")
puts "#{FRED}#{HC}Starting scan, be patient this will take a sec...#{FWHT}"
def brutepetition(line, domain, resolv)
	Thread.new do
		continue = false
		while continue == false # This improves the performance, restart idle threads after 3 seconds.
			begin
				Timeout::timeout(3) do
					puts resolv.query("#{line}.#{domain}", Net::DNS::A).answer
					continue = true
				end
			rescue Timeout::Error
			end
		end
	end
end

def ptrpetition(ip, resolv, forshodan = false)
	if forshodan == false
		Thread.new do
			continue = false
			while continue == false
				begin
					Timeout::timeout(3) do
						puts resolv.query(ip, Net::DNS::PTR).answer
						continue = true
					end
				rescue Timeout::Error
				end
			end
		end
	else
		continue = false
		while continue == false
			begin
				Timeout::timeout(2) do
					return resolv.query(ip, Net::DNS::PTR).answer
					continue = true
				end
			rescue Timeout::Error
			end
		end
	end
end

begin
	resolv = Net::DNS::Resolver.new(:nameservers => dns_server)
	resolv.udp_timeout = 0
	resolv.retry_number = 5
	resolv.retry_interval = 1
	puts "\n#{FRED}#{HC}DNS Server >>> " + dns_server
	puts "\n#{FYEL}[*] #{FRED}#{HC}Searching & looking for dns  ...#{FWHT}"
	puts resolv.query(domain, Net::DNS::NS).answer
	puts "\n#{FYEL}[*] #{FRED}#{HC}Searching & looking for dns  ...#{FWHT}"
	puts resolv.query(domain, Net::DNS::MX).answer
	puts "\n#{FYEL}[*]#{FRED}#{HC}Searching with SHODAN...#{FWHT}"
	begin
		api = Shodan::WebAPI.new(shodan_api_key)
		query = domain
		result = api.search(query)
		result['matches'].each do |host|
			print "#{HC}#{FRED}OK, resolved : IP #{FWHT}#{host['ip']} #{host['country_name']} #{host['os']} to IP (running) => "
			result = ptrpetition(host['ip'], resolv, true)
			if result.size == 0
				puts "DNS not found"
			else
				puts result
			end
		end
	rescue
		puts "    Error searching with SHODAN"
	end
	puts ""
	puts "#{HC}#{FRED}NOTE: #{FYEL}I dont do any checks so use something valid or you wont get results!#{FWHT}"
	puts "#{FRED}#{HC}Analyzing.... ,#{FWHT} this may take a few...."
	puts "\n#{FYEL}[*]#{HC}#{FRED} Searching DNS & bruteforcing ...#{FWHT}"
	puts "#{FRED}#{HC}Found ..#{FWHT} " + max_threads.to_s
	puts "#{HC}#{FWHT}Unique Links in total...#{FRED}"
	puts "----"
	begin
		list = File.open(wordlist, "r")
	rescue
		puts "\nError opening #{wordlist}"
		puts ""
		exit
	end
	while line = list.gets
		line = line.chomp
		newthreads = false
		while newthreads == false
			if Thread.list.length < max_threads + 1 # The "+1" is the main thread.
				brutepetition(line, domain, resolv)
				newthreads = true
			else
				newthreads = false
				sleep(0.2)
			end
		end
	end
	list.close
	while Thread.list.length != 1
		puts "#{FYEL}#{HC}[#{FWHT}*#{FYEL}] #{FWHT}Waiting for #{(Thread.list.length - 1).to_s} threads to complete#{FRED} ..."
		sleep(5)
	end

	puts "\nNext step is reverse DNS [PTR] to all /24 IP range of main domain."
	print "#{FWHT}Press enter to continue #{FRED}... "
	warning "This can cause a lot of false positives."
	gets_pb
	begin
		main_ip = resolv.query(domain, Net::DNS::A).answer[0].to_s.split(" ")[4].split(".") # Array with IP octets.
	rescue
		begin
			main_ip = resolv.query("www.#{domain}", Net::DNS::A).answer[0].to_s.split(" ")[4].split(".")
		rescue
			puts "Error resolving IP for #{domain}"
			exit
		end
	end
	loop do
		puts "[*] Reversing DNS [PTR] range #{main_ip[0]}.#{main_ip[1]}.#{main_ip[2]}.0-255"
		for i in 0..255 do
			ip = "#{main_ip[0]}.#{main_ip[1]}.#{main_ip[2]}.#{i.to_s}"
			newthreads = false
			while newthreads == false
				if Thread.list.length < max_threads + 1 # The "+1" is the main thread.
					ptrpetition(ip, resolv)
					newthreads = true
				else
					newthreads = false
					sleep(0.2)
				end
			end
		end
		while Thread.list.length != 1
			sleep(5)
			puts "[*] Waiting for #{(Thread.list.length - 1).to_s} threads to finish ..."
		end
		print "\n#{FYEL}#{HC}Continue? Press Enter ...#{FRED} "
		goback = gets_pb.chomp
		if goback != "back" # You can increase or decrease the range.
			if main_ip[2] == "255"
				main_ip[2] = "0"
				if main_ip[1] == "255"
					main_ip[1] = "0"
					if main_ip[0] == "255"
						puts "\nError: It was the last one IP in the world."
						puts ""
						exit
					else
						main_ip[0] = "#{main_ip[0].to_i + 1}"
					end
				else
					main_ip[1] = "#{main_ip[1].to_i + 1}"
				end
			else
				main_ip[2] = "#{main_ip[2].to_i + 1}"
			end
		else
			if main_ip[2] == "0"
				main_ip[2] = "255"
				if main_ip[1] == "0"
					main_ip[1] = "255"
					if main_ip[0] == "0"
						puts "\n#{HC}#{FYEL}Failed....: It was the first one IP in the world.#{FWHT}"
						puts ""
						exit
					else
						main_ip[0] = "#{main_ip[0].to_i - 1}"
					end
				else
					main_ip[1] = "#{main_ip[1].to_i - 1}"
				end
			else
				main_ip[2] = "#{main_ip[2].to_i - 1}"
			end
		end
	end
end

end
end
end
