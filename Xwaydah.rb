#!/usr/bin/env ruby
#Xwaydah 
#BY : Lucifer HR
# Demo video : https://www.youtube.com/watch?v=3-COy9OeS_o

sleep 3
##### Loading time
dir = File.dirname(__FILE__)
require dir + "/classes/RIDT.rb" # Common procedures and functions.
#Add some color without colorize gem since we sticking to std libs for this one :)
RS="\033[0m"    # reset
HC="\033[1m"    # hicolor
FRED="\033[31m" # foreground red
FGRN="\033[32m" # foreground green
FWHT="\033[37m" # foreground white
FYEL="\033[33m" # foreground yellow


#########GEMS/RK#########
require 'cgi'        #
require 'csv'        #
require 'fileutils'  #
require 'digest/md5' #
require 'digest/sha1'#
require 'net/ftp'    #
require 'net/telnet' #
require 'openssl'    #
require 'openssl'    #
require 'optparse'   #
require 'fileutils'   ##
require 'test/unit' ##
require 'test/unit' #
############GEMS/ND#######
require 'rubygems'   #
#############
srand(Time.now.to_i)
banner = rand(1)
puts              
puts ""
	puts "#{HC}#{FYEL}[#{FWHT}*#{FYEL}]#{FWHT} Using Default configuration...."
puts ""
case banner
	when 0
FBLU="\033[34m"
puts "#{FRED}#{HC}                                                                       
                                                                                   
 _|      _|                                                _|            _|        
   _|  _|    _|      _|      _|    _|_|_|  _|    _|    _|_|_|    _|_|_|  _|_|_|    
     _|      _|      _|      _|  _|    _|  _|    _|  _|    _|  _|    _|  _|    _|  
   _|  _|      _|  _|  _|  _|    _|    _|  _|    _|  _|    _|  _|    _|  _|    _|  
 _|      _|      _|      _|        _|_|_|    _|_|_|    _|_|_|    _|_|_|  _|    _|  
                                                 _|                                
                                             _|_|                   				
							            Xwaydah project#{FWHT}...                                  
"
puts ""
end

puts ""
sleep(0.25)
option1 = ""
#######Options...
while option1 != "5"
module_exec = true
puts "#{HC}#{FWHT}\e[4mAvailable Options: \e[24m" 
puts "#{HC}#{FYEL}clean #{HC}#{FWHT}    =>#{HC} #{FRED}Cleaning Tools"
puts "#{HC}#{FYEL}web3r #{HC}#{FWHT}    =>#{HC} #{FRED}Web tools"
puts "#{HC}#{FYEL}exit #{HC}#{FWHT}     =>#{HC} #{FRED}Exit Session"
puts "#{HC}#{FYEL}geotool #{HC}#{FWHT}  =>#{HC} #{FRED}Geolocation's tool#{RS}"
puts "#{HC}#{FYEL}config #{HC}#{FWHT}   =>#{HC}#{FRED} You can see the configuration settings "
puts "#{HC}#{FYEL}clear #{HC}#{FWHT}    =>#{HC}#{FRED} Clear Teminal"
puts "#{HC}#{FYEL}ip     #{HC}#{FWHT}   =>#{HC} #{FRED}Internal & Exnternal IP"
puts "#{HC}#{FYEL}fuzz #{HC}#{FWHT}     =>#{HC}#{FRED} Fuzzer to find vulnerabilities"
puts "#{HC}#{FYEL}hopot #{HC}#{FWHT}    =>#{HC} #{FRED}Honeypot tool"
puts "#{HC}#{FYEL}dnhost #{HC}#{FWHT}   =>#{HC}#{FRED} for DNS & host (DNS Information Gathering)  "
puts "#{HC}#{FYEL}passwords #{HC}#{FWHT}=>#{HC}#{FRED} Password Tools#{RS}"
puts "#{HC}#{FYEL}xploitsug #{HC}#{FWHT}=>#{HC} #{FRED}Possible suggested exploit's#{RS}"
puts ""
print "(Xwaydah)> "
option1 = gets_pb.chomp
puts ""
case option1
when "clean"
			puts "#{FYEL}#{HC}back #{FWHT}#{HC}   =>#{FRED} Return to Main Menu "
			puts "#{FYEL}clean3r #{FWHT}#{HC}=>#{FRED} Tool for clean cash and show folder's#{RS}"
			puts ""
			print "(clean3r) > "
			option2 = gets_pb.chomp
			case option2
	when "0"
			module_exec = false
	when "clean3r"
			require "#{dir}/extra/Clean/clean3r.rb"
				else
module_exec = false
			puts ""
			puts "#{HC}#{FYEL}Oops, Didn't quite understand that one#{FWHT}!#{RS}"
			puts "#{HC}#{FYEL}Please Choose a Valid Option From Menu Below Next Time#{FWHT}.......#{RS}"
                        sleep 2
                                        puts "\e[H\e[2J"
					puts ""
end
	when "web3r"
			puts "#{HC}#{FWHT}\e[4mAvailable Options from Web3r Menu :\e[24m"
			puts "#{HC}#{FYEL}back #{FWHT} =>#{FRED} Return to Main Menu"
			puts "#{HC}#{FYEL}netsr #{FWHT}=>#{FRED} NDos tool"
			puts "#{HC}#{FYEL}tcpps #{FWHT}=>#{FRED} Scan & Checking hosts with ports "
			puts ""
			print "#{RS}(web3r) >"
			option2 = gets_pb.chomp
			case option2
				when "0"
					module_exec = false
				when "netsr"
					if haspermission() == true
						require "#{dir}/extra/classes/NTD.rb"
						Network_pb::Net_dos_pb.new()
					else
						module_exec = false
			puts ""
			puts "#{FRED}[#{HC}#{FWHT}*#{FRED}]#{FWHT}#{HC}Check path or permissions and try again...."
			puts ""
					end
				when "tcpps"
					require "#{dir}/extra/classes/RIDTP.rb"
					Network_pb::Port_scanner_pb.new()
				else
					module_exec = false
			puts ""
			puts "#{HC}#{FYEL}Oops, Didn't quite understand that one#{FWHT}!#{RS}"
			puts "#{HC}#{FYEL}Please Choose a Valid Option From Menu Below Next Time#{FWHT}.......#{RS}"
			sleep 2
                        puts "\e[H\e[2J"
			puts ""
			end
			when "findmyhash"
require "#{dir}/extra/classes/PAY.rb"
	when "3"
			puts "1- HTTP directory bruteforce"
			puts "2- HTTP common files bruteforce"
			puts ""
			puts "0- Back"
			puts ""
			print "   (Test)> "
			option2 = gets_pb.chomp
			case option2
				when "0"
					module_exec = false
			when "1"
			require "#{dir}/extra/classes/WEB1.rb"
			Web_pb::BRUT_pb.new()
			when "2"
					require "#{dir}/extra/classes/WEB2.rb"
					Web_pb::BRUT2_pb.new()
			else
					module_exec = false
					puts ""
			puts "#{HC}#{FYEL}Oops, Didn't quite understand that one#{FWHT}!#{RS}"
			puts "#{HC}#{FYEL}Please Choose a Valid Option From Menu Below Next Time#{FWHT}.......#{RS}"
			sleep 2
					puts "\e[H\e[2J"
				puts ""
			end
	when "hopot"
					require "#{dir}/extra/classes/HTE.rb"
					Net_pp::Honeypot_pp.new()
	when "exit"
					sleep 2
					abort("#{FRED}OK#{FWHT}, #{FRED}exiting Xwaydah#{FWHT}......")
					when "dnhost"
					require "#{dir}/extra/classes/DNS.rb"
					Nul_pb::DNS_host.new()
	when "fuzz"
					require "#{dir}/extra/nul/fil3.rb"
					Network_pb::Fuzzer_pb.new()
                          # Clear
				when "clear"
					sleep 1
					puts "\e[H\e[2J"
		when "passwords"
			sleep 3
puts "#{HC}#{FWHT}\e[4mAvailable Options: \e[24m"
puts "#{FYEL}#{HC}back #{HC}#{FWHT}     => #{HC}#{FRED}Return to Main Menu..#{FWHT}"
puts "#{FYEL}#{HC}hasher #{HC}#{FWHT}   => #{HC}#{FRED}Password Hashing Tool (Base64 Encryptor/Decryptor)"
puts "#{FYEL}#{HC}hsload #{HC}#{FWHT}   => #{HC}#{FRED}for (MD5, SHA1, SHA256, SHA384, SHA512, RIPEMD-160)"
puts "#{FYEL}#{HC}profilter #{HC}#{FWHT}=>#{HC}#{FRED} Password Profilter & Crack type (SHA384 , MD5, SHA1, SHA256, SHA512, RIPEMD-160)"
puts "#{FYEL}#{HC}gencure #{HC}#{FWHT}  =>#{HC}#{FRED} Protect Password Generator"
puts "#{FYEL}#{HC}heshler #{HC}#{FWHT}  => #{HC}#{FRED}Crack Hash in multiple mode (BRUTE FORCE - PRODUCT - RECURSIVE - Base N"
puts "#{FYEL}#{HC}gencat #{HC}#{FWHT}   => #{HC}#{FRED}Generate Passwords to Encrypt your hash"
puts ""
			print "#{RS}(p@ssw0rds)> "
			option2 = gets_pb.chomp
			case option2
				when "back"
			sleep 1
			module_exec = false
		when "hasher"
			require "#{dir}/extra/classes/NPP.rb"
			Cryptogr_pb::Base64_pb.new()
		when "hsload"
			require "#{dir}/extra/classes/RIPEM.rb"
			Cryptogr_pb::Digest_pb.new()
		when "profilter"
			require "#{dir}/extra/classes/HAST.rb"
			Cryptogr_pb::Hash_cracker_pb.new()
		when "gencure"
			require "#{dir}/extra/classes/REST.rb"
			Cryptogr_pb::Sec_password_pb.new()
		when "heshler"
			require "#{dir}/extra/classes/RTT.rb"
			Cryptogr_pb::Base64_pb.new()
		when "gencat"
			require "#{dir}/extra/classes/RQR.rb"
				else
					module_exec = false
puts ""
puts "Invalid option."
puts ""
			end
		when "xploitsug"
		require "#{dir}/extra/fun/SUG.rb"
		when "ip"
		puts "#{HC}#{FWHT}\e[4mAvailable Options From ip Menu: \e[24m"
		puts "#{FYEL}back #{FWHT}=> #{FRED}Return to Main Menu.."
		puts "#{FYEL}ipe  #{FWHT}=> #{FRED}Checking Address IP (Internal) "
		puts "#{FYEL}ipi  #{FWHT}=> #{FRED}Looking & Checking Address IP (External)"
		puts ""
			print "#{RS}(ip)> "
		option2 = gets_pb.chomp
			case option2
				when "back"
					module_exec = false
	when "ipe"
	sleep 1
	require "#{dir}/extra/classes/IRP.rb"
	when "ipi"
	require "#{dir}/extra/classes/IP_R.rb"
	else
	module_exec = false
puts ""
puts "Invalid option."
puts ""
			end
					when "geotool"
		puts "#{HC}#{FWHT}\e[4mAvailable Options From geotool Menu: \e[24m"
		puts "#{FYEL}back#{FWHT}     => #{FRED}back to the main menu"
		puts "#{FYEL}macgeo   #{FWHT}=> #{FRED}MAC address geolocation"
		puts "#{FYEL}wireless #{FWHT}=> #{FRED}Wireless Geolocation (HTML 5 Geolocation API) VsIP Geolocation"

		puts "#{RS}"
		print "(ge0tool) > "
		option2 = gets_pb.chomp
			case option2
				when "back"
					module_exec = false
	when "macgeo"
	sleep 1
	require "#{dir}/extra/network/LOC.rb"
	Network_pb::Geo_mac_loc_pb.new()
	when "wireless"
	require "#{dir}/extra/network/WIR.rb"
	Network_pb::Wire_geo_loc_pb.new()
	else
	module_exec = false
puts ""
puts "Invalid option."
puts ""
			end
	when "config"
require "#{dir}/extra/configuration/config-example.rb"
else
	module_exec = false
		puts ""
puts "#{HC}#{FYEL}Oops, Didn't quite understand that one#{FWHT}!#{RS}"
puts "#{HC}#{FYEL}Please Choose a Valid Option From Menu Below Next Time#{FWHT}.......#{RS}"
sleep 2
puts "\e[H\e[2J"
		puts ""
	end
	if module_exec == true
		puts ""
		puts "[*] Done!."
		puts ""
	end
end

