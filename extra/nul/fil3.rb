

module Network_pb
class Fuzzer_pb
def initialize()

require "socket"
require "timeout"
require "net/ftp"

puts "#{HC}#{FYEL}back     #{FWHT}=> #{FRED} Return to Main Menu"
puts "#{HC}#{FYEL}suprotoc #{FWHT}=> #{FRED} Client HTTP . HTTP . FTP FTP S1"
puts "#{HC}#{FYEL}fuzzhttp #{FWHT}=> #{FRED}(fuzzing HTTP client)#{FWHT}"
print "  #{RS} Enter Option :#{HC}"
$host = gets_pb.chomp
print "#{FBLU}[#{FWHT}*#{FBLU}]#{FWHT}#{RS} Insert port Here : "
$port = gets_pb.chomp
puts ""
puts "#{HC}#{FBLU}[#{FWHT}*#{FBLU}]#{FWHT} OK ,rooting to suprotoc Option's..."
puts "#{HC}"
puts "#{FBLU}[#{FWHT}*#{FBLU}]#{FYEL} 1) fuzserver #{FWHT}=> #{FRED}HTTP headers (fuzz server)"
puts "#{FBLU}[#{FWHT}*#{FBLU}]#{FYEL} 2) fuzclient #{FWHT}=> #{FRED}HTTP headers browser (fuzz client)"
puts "#{FBLU}[#{FWHT}*#{FBLU}]#{FYEL} 3) uniqftp #{FWHT}  => #{FRED}FTP"
print "  #{RS} Enter Option :#{HC} " 
protocol = gets_pb.chomp
if protocol == "3"
	print " #{RS}  Put the username : "
	user = gets_pb.chomp
	print "   Insert Password :#{HC} "
	pass = gets_pb.chomp
end

def fuzz_buff_http(title, part1, part2) # Fuzzing Buffer Overflow in HTTP function.
	buffer = "A" # Buffer value now is A.
	cont = 0
	anumber = 1
	puts ""
	print title # Print what type of fuzz is doing.
	while (cont <= 13)
		sleep(0.25)
		cont += 1
		buffer = "#{buffer}#{buffer}" # Buffer value grows.
		send = "#{part1}#{buffer}#{part2}" # The packet built with part1, buffer and part2.
		begin
			Timeout::timeout(15) do
				begin
					socket = TCPSocket.new($host, $port)
				rescue
					# If there is no socket, probably a DoS has being caused.
					puts ""
					puts "  #{FRED}[#{FWHT}*#{FRED}] #{FWHT}Impossible to connect....!"
					puts "  #{FRED}[#{FWHT}*#{FRED}] #{FWHT}Host not found or may be connection down....."
					puts ""
					puts "  #{FRED}[#{FWHT}*#{FRED}] #{FWHT}Locked in #{title}#{anumber.to_s}A"
					puts ""
					exit
				end
				socket.write(send)
				socket.close
			end
		rescue Timeout::Error
			puts ""
			puts ""
			puts "   #{FRED}[#{FWHT}*#{FRED}] #{FWHT}Connection timed out no further information...."
			puts "   #{FRED}[#{FWHT}*#{FRED}] #{FWHT}Host not found or may be down.....!!"
			puts ""
			puts "  #{FRED}[#{FWHT}*#{FRED}] #{FWHT}Locked in: #{title}#{anumber.to_s}A"
			puts ""
			exit
		end
		anumber = anumber + anumber # This is to print what size of buffer has being sent.
		print "#{anumber.to_s}A "
	end
	print "- OK"
	puts ""
end

# JavaScript code to refresh the browser automatically.
$sleep_js = "\
var startTime = new Date().getTime();\n\
while (new Date().getTime() < startTime + 1500);\n"

def fuzz_buff_http_client(title, header)
	buffer = "A"
	cont = 0
	anumber = 1
	puts ""
	print title
	while (cont <= 13)
		buffer = "#{buffer}#{buffer}"
		socket = $http_server.accept
		socket.recv(5000)
		packet = "HTTP/1.1 200 OK\r\n#{header}: #{buffer}\r\n\r\n<!doctype html>\n<script>\n#{$sleep_js}\nlocation.reload(true);\n</script>" # Packet compilation.
		socket.write(packet)
		socket.close
		cont += 1
		anumber = anumber + anumber
		print "#{anumber.to_s}A "
	end
	print "- OK"
	puts ""
end

def fuzz_buff_ftp(comm) # Fuzzing Buffer Overflow in FTP function.
	buffer = "A" # Buffer value now is A.
	cont = 0
	anumber = 1
	puts ""
	print "   #{comm} [MALFORMED] -> " # Print what type of fuzz is doing.
	while (cont <= 13)
		sleep(0.25)
		cont += 1
		buffer = "#{buffer}#{buffer}" # Buffer value grows.
		begin
			Timeout::timeout(15) do
				begin
					if comm == "cd"
						$ftp.chdir(buffer)
					elsif comm == "delete"
						$ftp.delete(buffer)
					elsif comm == "get"
						$ftp.get(buffer, "")
					elsif comm == "help"
						$ftp.help(buffer)
					elsif comm == "status"
						$ftp.status(buffer)
					end
				rescue
				end
			end
		rescue Timeout::Error
			puts ""
			puts ""
			puts "   Connection timeout."
			puts "   Host may be down. Possible Exploit?"
			puts ""
			puts "   Packet: #{comm} #{anumber.to_s}A"
			puts ""
			exit
		end
		anumber = anumber + anumber # This is to print what size of buffer has being sent.
		print "#{anumber.to_s}A "
	end
	print "- OK"
	puts ""
end


if protocol == 1 || protocol == 3
	begin
		socket = TCPSocket.new($host, $port)
	rescue
		puts ""
		puts "Connection problem."
		puts ""
		exit
	end
	socket.close
end

# Here the functions are launched, if you want to omit one of then, comment it.
case protocol
	when "suprotoc"
		puts ""
		puts "Buff Overflow need test ?"
		fuzz_buff_http("   HEAD [MALFORMED] HTTP/1.1 -> ", "HEAD ", " HTTP/1.1\r\n\r\n")
		fuzz_buff_http("   HEAD / [MALFORMED] -> ", "HEAD / ", "\r\n\r\n")
		fuzz_buff_http("   GET [MALFORMED] HTTP/1.1 -> ", "GET ", " HTTP/1.1\r\n\r\n")
		fuzz_buff_http("   GET / [MALFORMED] -> ", "GET / ", "\r\n\r\n")
		fuzz_buff_http("   POST [MALFORMED] HTTP/1.1 -> ", "POST ", " HTTP/1.1\r\n\r\n")
		fuzz_buff_http("   POST / [MALFORMED] -> ", "POST / ", "\r\n\r\n")
		fuzz_buff_http("   GET / HTTP/[MALFORMED] -> ", "GET / HTTP/", "\r\n\r\n")
		fuzz_buff_http("   GET / [MALFORMED]/1.1 -> ", "GET / ", "/1.1\r\n\r\n")
		fuzz_buff_http("   User-Agent: [MALFORMED] -> ", "GET / HTTP/1.1\r\nUser-Agent: ", "\r\n\r\n")
		fuzz_buff_http("   Host: [MALFORMED] -> ", "GET / HTTP/1.1\r\nHost: ", "\r\n\r\n")
		fuzz_buff_http("   Connection: [MALFORMED] -> ", "GET / HTTP/1.1\r\nConnection: ", "\r\n\r\n")
		fuzz_buff_http("   Referer: [MALFORMED] -> ", "GET / HTTP/1.1\r\nReferer: ", "\r\n\r\n")
		fuzz_buff_http("   Authorization: [MALFORMED] -> ", "GET / HTTP/1.1\r\nAuthorization: ", "\r\n\r\n")
		fuzz_buff_http("   Cookie: [MALFORMED] -> ", "GET / HTTP/1.1\r\nCookie: ", "\r\n\r\n")
		fuzz_buff_http("   Accept: [MALFORMED] -> ", "GET / HTTP/1.1\r\nAccept: ", "\r\n\r\n")
		fuzz_buff_http("   Accept-Encoding: [MALFORMED] -> ", "GET / HTTP/1.1\r\nAccept-Encoding: ", "\r\n\r\n")
		fuzz_buff_http("   Accept-Language: [MALFORMED] -> ", "GET / HTTP/1.1\r\nAccept-Language: ", "\r\n\r\n")
		fuzz_buff_http("   Accept-Charset: [MALFORMED] -> ", "GET / HTTP/1.1\r\nAccept-Charset: ", "\r\n\r\n")
		fuzz_buff_http("   Accept-Ranges: [MALFORMED] -> ", "GET / HTTP/1.1\r\nAccept-Ranges: ", "\r\n\r\n")
		fuzz_buff_http("   Content-Length: [MALFORMED] -> ", "GET / HTTP/1.1\r\nContent-Length: ", "\r\n\r\n")
		fuzz_buff_http("   Content-Type: [MALFORMED] -> ", "GET / HTTP/1.1\r\nContent-Type: ", "\r\n\r\n")
		fuzz_buff_http("   Cache-Control: [MALFORMED] -> ", "GET / HTTP/1.1\r\nCache-Control: ", "\r\n\r\n")
		fuzz_buff_http("   Date: [MALFORMED] -> ", "GET / HTTP/1.1\r\nDate: ", "\r\n\r\n")
		fuzz_buff_http("   From: [MALFORMED] -> ", "GET / HTTP/1.1\r\nFrom: ", "\r\n\r\n")
		fuzz_buff_http("   Charge-To: [MALFORMED] -> ", "GET / HTTP/1.1\r\nCharge-To: ", "\r\n\r\n")
		fuzz_buff_http("   ChargeTo: [MALFORMED] -> ", "GET / HTTP/1.1\r\nChargeTo: ", "\r\n\r\n")
		fuzz_buff_http("   If-Match: [MALFORMED] -> ", "GET / HTTP/1.1\r\nIf-Match: ", "\r\n\r\n")
		fuzz_buff_http("   If-Modified-Since: [MALFORMED] -> ", "GET / HTTP/1.1\r\nIf-Modified-Since: ", "\r\n\r\n")
		fuzz_buff_http("   If-Unmodified-Since: [MALFORMED] -> ", "GET / HTTP/1.1\r\nIf-Unmodified-Since: ", "\r\n\r\n")
		fuzz_buff_http("   If-None-Match: [MALFORMED] -> ", "GET / HTTP/1.1\r\nIf-None-Match: ", "\r\n\r\n")
		fuzz_buff_http("   If-Range: [MALFORMED] -> ", "GET / HTTP/1.1\r\nIf-Range: ", "\r\n\r\n")
		fuzz_buff_http("   Max-Forwards: [MALFORMED] -> ", "GET / HTTP/1.1\r\nMax-Forwards: ", "\r\n\r\n")
		fuzz_buff_http("   Pragma: [MALFORMED] -> ", "GET / HTTP/1.1\r\nPragma: ", "\r\n\r\n")
		fuzz_buff_http("   Proxy-Authorization: [MALFORMED] -> ", "GET / HTTP/1.1\r\nProxy-Authorization: ", "\r\n\r\n")
		fuzz_buff_http("   Range: [MALFORMED] -> ", "GET / HTTP/1.1\r\nRange: ", "\r\n\r\n")
		fuzz_buff_http("   TE: [MALFORMED] -> ", "GET / HTTP/1.1\r\nTE: ", "\r\n\r\n")
		fuzz_buff_http("   Upgrade: [MALFORMED] -> ", "GET / HTTP/1.1\r\nUpgrade: ", "\r\n\r\n")
		fuzz_buff_http("   Via: [MALFORMED] -> ", "GET / HTTP/1.1\r\nVia: ", "\r\n\r\n")
		fuzz_buff_http("   Warn: [MALFORMED] -> ", "GET / HTTP/1.1\r\nWarn: ", "\r\n\r\n")
		puts ""
	when "fuzzhttp"
		puts ""
		puts "#{FBLU}[#{FWHT}*#{FBLU}]#{FWHT} Buf Overflow"
		begin
			$http_server = TCPServer.new("", $port)
		rescue
			puts ""
			puts "Error: Unable to open the port (#{$port}). Root?"
			puts ""
			exit
		end
		puts ""
		puts "[*] \033[31mIn this case the browser need a  connection at port\033[37m #{$port}"
		fuzz_buff_http_client("   Accept-Ranges: (Damaged) > ", "Accept-Ranges")
		fuzz_buff_http_client("   Age: (Damaged) > ", "Age")
		fuzz_buff_http_client("   Allow: (Damaged) > ", "Allow")
		fuzz_buff_http_client("   Cache-Control: (Damaged) > ", "Cache-Control")
		fuzz_buff_http_client("   Connection: (Damaged) > ", "Connection")
		fuzz_buff_http_client("   Content-Encoding: (Damaged) > ", "Content-Encoding")
		fuzz_buff_http_client("   Content-Language: (Damaged) > ", "Content-Language")
		fuzz_buff_http_client("   Content-Length: (Damaged) > ", "Content-Length")
		fuzz_buff_http_client("   Content-Location: (Damaged) > ", "Content-Location")
		fuzz_buff_http_client("   Content-MD5: (Damaged) > ", "Content-MD5")
		fuzz_buff_http_client("   Content-Type: (Damaged) > ", "Content-Type")
		fuzz_buff_http_client("   Date: (Damaged) > ", "Date")
		fuzz_buff_http_client("   ETag: (Damaged) > ", "ETag")
		fuzz_buff_http_client("   Expires: (Damaged) > ", "Expires")
		fuzz_buff_http_client("   Last-Modified: (Damaged) > ", "Last-Modified")
		fuzz_buff_http_client("   Location: (Damaged) > ", "Location")
		fuzz_buff_http_client("   Pragma: (Damaged) > ", "Pragma")
		fuzz_buff_http_client("   Proxy-Authenticate: (Damaged) > ", "Proxy-Authenticate")
		fuzz_buff_http_client("   Retry-After: (Damaged) > ", "Retry-After")
		fuzz_buff_http_client("   Server: (Damaged) > ", "Server")
		fuzz_buff_http_client("   Trailer: (Damaged) > ", "Trailer")
		fuzz_buff_http_client("   Upgrade: (Damaged) > ", "Upgrade")
		fuzz_buff_http_client("   Vary: (Damaged) > ", "Vary")
		fuzz_buff_http_client("   Via: [MALFORMED] - > ", "Via")
		fuzz_buff_http_client("   Warning: (Damaged) > ", "Warning")
		fuzz_buff_http_client("   WWW-Authenticate: (Damaged) > ", "WWW-Authenticate")
		puts ""
	when "3"
		puts "#{FBLU}[#{FWHT}*#{FBLU}]#{FWHT} Buf Overflow "
		fuzz_buff_http("   AUTH (Damaged) > ", "AUTH ", "\r\n")
		fuzz_buff_http("   (Damaged) > SSL  ", "", " SSL\r\n")
		fuzz_buff_http("   (Damaged) > TLS  ", "", " TLS\r\n")
		fuzz_buff_http("   USER (Damaged) > ", "USER ", "\r\n")
		fuzz_buff_http("   PASS (Damaged) > ", "PASS ", "\r\n")
		puts ""
		print " Connect to FTP server ......"
		begin
			$ftp = Net::FTP.new($host, user, pass)
		rescue
			puts " failed"
			puts ""
			exit
		end
		puts " OK"
		puts ""
		puts "#{FBLU}[#{FWHT}*#{FBLU}]#{FWHT} Buf Overflow "
		fuzz_buff_ftp("cd")
		fuzz_buff_ftp("delete")
		fuzz_buff_ftp("get")
		fuzz_buff_ftp("help")
		fuzz_buff_ftp("status")
		puts ""
		print "#{RS}#{FRED}OK ,Exiting...."
		$ftp.close()
		puts " OK"
		puts ""
	else
		puts ""
		puts "#{FRED}[#{FWHT}*#{FRED}] #{FWHT}Incorrect protocol You sir are failure #{FWHT}..."
		puts "#{FRED}[#{FWHT}*#{FRED}] #{FWHT}Next time Correct your Operation !"
end

end
end
end
