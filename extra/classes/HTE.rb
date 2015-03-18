
module Net_pp
class Honeypot_pp
def initialize()

# This is a Honeypot. You can create with this your own Honeypot with your options or autoconfigure one.
#

require "socket"

puts ""
puts "
#{FYEL}#{HC}Hopot ready to use ....#{RS}#{FRED}
                                               .d8b       d8b.     
                                              .888'       `888.
                                              8888         8888
                                              8888         8888
            #{FWHT}creations de los Handr3d#{FRED}          4888.       .888P
              #{FWHT}19 11th october 2004#{FRED}             `488b.d8b.d88P'
                 #{FWHT}Secret, Game ... #{FRED}             d8888888888888b
                                              `888888888888888'
                                              '8.`888888888'.8'
                                                `8888888888888'
            THat's all we need.......           8888888888888
                                                888b.`V'.d888
                                                88888b d88888
                                                `48888Y8888P'
                                                  `488!88P'"
	puts "#{HC}#{FYEL}hopot#{FWHT} => #{FRED}Honeypot tool"
	puts "#{FYEL}By: #{FRED}Alexcerus HR#{RS}"
	puts "#{FWHT}#{HC}Take down victim....#{HC}"
puts ""
puts "1.#{HC}#{FYEL}auto conf -(fast mode)  #{FWHT}=> #{FRED}Auto Configuration (fast mode)#{FWHT}"
puts "2.#{HC}#{FYEL}manuel conf   #{FWHT}          => #{FRED}[Advanced Users, more options]#{FWHT}"
puts ""
print "#{FRED}#{HC}hopot >#{HC}#{FWHT}"
configuration = gets_pb.chomp

def honeyconfig(port, message, sound, log, logname) # Function to launch the Honeypot.
	begin
		tcpserver = TCPServer.new("", port)
		if tcpserver
			puts ""
			puts "  Honeypot enabled on Port :#{port} (#{Time.now.to_s})"
			puts ""
			if log == "y" || log == "Y"
				# If log is enabled, writes Honeypot activation time.
				begin
					File.open(logname, "a") do |logf|
						logf.puts " Test Hopot log"
						logf.puts ""
						logf.puts "  Honeypot enabled on Port : #{port} (#{Time.now.to_s})"
						logf.puts ""
					end
				rescue Errno::ENOENT
					puts ""
					puts " Saving log error: No such file or directory."
					puts ""
				end
			end
			loop do
				socket = tcpserver.accept
				sleep(1) # It is to solve possible DoS Attacks.
				if socket
					Thread.new do
						remotePort, remoteIp = Socket.unpack_sockaddr_in(socket.getpeername) # Gets the remote port and ip.
						puts ""
						puts "  Intrusion Detection (!) Intrusion Attempt Detected (!) from #{remoteIp}:#{remotePort} (#{Time.now.to_s})"
						puts " -----------------------------"
						reciv = socket.recv(1000).to_s
						puts reciv
						if sound == "y" || sound == "Y"
							# If sound is enabled, then beep 3 times.
							puts "\a\a\a"
						end
						if log == "y" || log == "Y"
							# If log is enabled, writes the intrusion.
							begin
								File.open(logname, "a") do |logf|
									logf.puts ""
									logf.puts "  Intrusion Detection (!) Intrusion Attempt Detected (!) from #{remoteIp}:#{remotePort} (#{Time.now.to_s})"
									logf.puts " -----------------------------"
									logf.puts reciv
								end
							rescue Errno::ENOENT
								puts ""
								puts " Saving log error: No such file or directory."
								puts ""
							end
						end
						sleep(2) # This is a sticky honeypot.
						socket.write(message)
						socket.close
					end
				end
			end
		end
	rescue Errno::EACCES
		puts ""
		puts " #{HC}#{FRED}Failed: Honeypot requires r00t....."
		puts ""
	rescue Errno::EADDRINUSE
		puts ""
		puts " #{HC}#{FRED}Failed : The port Already in use..."
		puts ""
	rescue
		puts ""
		puts " #{HC}#{FYEL}Unknown error & Probably makes the risk....."
		puts ""
	end
end

case configuration
	when "1"
		access = rand(3)
		case access
			when 0
				honeyconfig(80, "<HEAD>\n<TITLE>Access denied</TITLE>\n</HEAD>\n<H2>Access denied</H2>\n" + "<H3>HTTP Referrer login failed</H3>\n" + "<H3>IP Address login failed</H3>\n" + "<P>\n#{Time.now.to_s}\n</P>", "N", "N", "")
			when 1
				honeyconfig(80, "<HEAD>\n<TITLE>Access denied</TITLE>\n</HEAD>\n<H2>Access denied</H2>\n" + "<H3>IP Address login failed</H3>\n" + "<P>\n#{Time.now.to_s}\n</P>", "N", "N", "")
			when 2
				honeyconfig(80, "<HEAD>\n<TITLE>Access denied</TITLE>\n</HEAD>\n<H2>Access denied</H2>\n" + "<P>\n#{Time.now.to_s}\n</P>", "N", "N", "")
		end
	when "2"
		puts ""
		puts "#{HC}#{FRED}Insert port to Open."
		puts ""
		print "#{FYEL}#{HC}>>> "
		port = gets_pb.chomp
		puts ""
		puts " #{HC}#{FRED}Insert a message to show (Alert message...)."
		puts ""
		print "#{FYEL}#{HC}>>> "
		message = gets_pb.chomp
		puts ""
		puts "#{HC}#{FRED}Do you want Save a log "
		puts ""
		print "#{FYEL}#{HC}(y/n)>>> "
		log = gets_pb.chomp
		if log == "Y" || log == "y"
			puts ""
			puts " Log file name...."
			puts ""
			puts "#{FWHT}#{HC}Default: */Xwaydah/other/log_hopot.txt"
			puts ""
			print "#{FYEL}#{HC}>>> "
			logname = gets_pb.chomp.gsub("\"", "").gsub("'", "")
			if logname == ""
				logname = "#{File.dirname(__FILE__)}/../../other/log_hopot.txt"
			end
		end
		puts ""
		puts "#{FRED}#{HC}Activate alert() sound?"
		puts ""
		print "#{FYEL}#{HC}(y/n)>>> "
		sound = gets_pb.chomp
		honeyconfig(port, message, sound, log, logname)
	else
		puts ""
		puts "#{HC}#{FRED}Oops, Didn't quite understand that one#{FWHT}!."
		puts "#{HC}#{FRED}Please Choose a Valid Option From Menu Below Next Time#{FWHT}...."
		puts ""
end

end
end
end
