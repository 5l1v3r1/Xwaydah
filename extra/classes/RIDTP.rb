

module Network_pb
class Port_scanner_pb
def initialize()

# A simple scanner that connects sockets to see if the port is open.
#

require "socket"
require "timeout"

puts ""
puts "#{HC}#{FYEL}Welcome to Alexcerus's tcpps scanner tool"
puts "#{HC}#{FWHT}
         _\\|/_
         (#{FRED}o o#{FWHT})
 +----oOO-{_}-OOo----------+
 | tcpps : #{FRED}#{FRED}tcp (p) scanner#{FWHT}#{HC} |
 | By : #{FRED}#{FRED}Alexcerus HR#{HC}#{FWHT}  	   |
 +-------------------------+
"
puts ""
print "#{RS}(tcpps)>"
$host = gets_pb.chomp
def scanrang(initialport, finalport)
	Thread.new do
		while initialport != finalport
			initialport += 1
			begin
				socket = TCPSocket.new($host, initialport)
				if socket
					puts "#{FRED}#{HC}Found #{FWHT}Port opened #{FWHT}: #{initialport.to_s}"
				end
				socket.close
			rescue
			end
		end
	end
end

def ping(host, timeout=5, service="echo")
	begin
		timeout(timeout) do
			s = TCPSocket.new(host, service)
			s.close
		end
	rescue Errno::ECONNREFUSED
		return true
	rescue Timeout::Error, StandardError
		return false
	end
	return true
end

puts ""
print "#{FRED}#{HC}Running tcpps To Scanning ports opened and Pinging#{FWHT}.... "

if ping($host) == false
	print "#{HC}#{FRED}Status : #{FWHT}Failed#{FWHT}..\n\n"
	puts "#{FRED}#{HC}[#{FWHT}*#{FRED}]#{FWHT} May be the host down or not connecting to the network...."
	puts "#{FRED}#{HC}[#{FWHT}*#{FRED}]#{FRED} You are failure again sir !#{FWHT} "
	puts ""
	exit
end
print "#{HC}#{FRED}Status : #{FWHT}OK#{FWHT}..\n\n"
puts "#{HC}#{FRED}[#{FWHT}*#{FRED}]#{FRED} Starting scan, be patient this will take a sec..."
puts "#{FRED}#{HC}[#{FWHT}*#{FRED}]#{FRED} #{FWHT}Looking for the ports opened#{FWHT}..."
puts "#{FRED}Found ports#{FWHT}..."
scanrang(0, 501)
scanrang(501, 1001)
scanrang(1001, 1501)
scanrang(1501, 2001)
scanrang(2001, 2501)
scanrang(2501, 3001)
scanrang(3001, 3501)
scanrang(3501, 4001)
scanrang(4001, 4501)
scanrang(4501, 5000)
while (Thread.list.length != 1)
	sleep(1)
end
puts ""
puts "#{FRED}#{HC}[#{FWHT}*#{FRED}] Scan Complete#{FWHT}....  "
puts ""

end
end
end
