puts "#{HC}
          69696969                         69696969
       6969    696969    #{FRED}fucking mind#{FWHT}   696969    6969
     969    69  6969696               6969  6969     696
    969        696969696             696969696969     696
   969        69696969696           6969696969696      696
   696      9696969696969           969696969696       969
    696     696969696969             969696969        969
     696     696  96969      _=_      9696969  69    696
       9696    969696      q(-_-)p      696969    6969
          96969696         '_) (_`         69696969
             96            /__/  \             69
             69          _(<_   / )_          96
            6969         (__\_\_|_/__)         9696
"
module Cryptogr_pb
class Hash_cracker_pb
def initialize()

# Hash Password Cracker (MD5, SHA1, SHA256, SHA384, SHA512, RIPEMD-160).
#

require "digest/md5"
require "digest/sha1"
require "digest/sha2"
require "digest/rmd160"

puts ""
puts "from Supported Hash Types#{FYEL}#{HC} (#{FWHT}MD5, SHA1, SHA256, SHA384, SHA512, RIPEMD-160#{FYEL})#{HC}"
puts ""
puts "#{FBLU}Provide a Hash :"
puts ""
print "(pr0filter)>"
hash = gets_pb.chomp.downcase
puts ""
puts " #{HC}#{FBLU}[#{FWHT}*#{FBLU}]#{FWHT} Select from Supported Hash Types:"
puts ""
puts "#{FBLU}#{HC}[#{FWHT}*#{FBLU}]#{FWHT} x) - Back to main"
puts "#{FBLU}#{HC}[#{FWHT}*#{FBLU}]#{FWHT} 1) - MD5"
puts "#{FBLU}#{HC}[#{FWHT}*#{FBLU}]#{FWHT} 2) - SHA1"
puts "#{FBLU}#{HC}[#{FWHT}*#{FBLU}]#{FWHT} 3) - SHA256"
puts "#{FBLU}#{HC}[#{FWHT}*#{FBLU}]#{FWHT} 4) - SHA384"
puts "#{FBLU}#{HC}[#{FWHT}*#{FBLU}]#{FWHT} 5) - SHA512"
puts "#{FBLU}#{HC}[#{FWHT}*#{FBLU}]#{FWHT} 6) - RIPEMD-160"
puts "#{FBLU}#{HC}(LM - NTLM) not 0wned by user...."
puts ""
print " Enter Option : "
type = gets_pb.chomp
puts ""
puts " Options to crack."
puts ""
puts "#{FBLU}#{HC}[#{FWHT}*#{FBLU}]#{FWHT} x) - Back to main"
puts "#{FBLU}#{HC}[#{FWHT}*#{FBLU}]#{FWHT} 1) - Single Numbers bruteforce"
puts "#{FBLU}#{HC}[#{FWHT}*#{FBLU}]#{FWHT} 2) - Wordlist Dictionary attack"
puts "#{FBLU}#{HC}[#{FWHT}*#{FBLU}]#{FWHT} 3) - Wordlist-bruteforce hybrid mode (hybrid dictionary attack) [exhausted]"
puts ""
print " Select mode to use:"
how = gets_pb.chomp
if how == "2" || how == "3"
	puts ""
	puts "#{FBLU}#{HC}[#{FWHT}*#{FBLU}]#{FWHT} Wordlist Source:"
	puts ""
	puts " #{FBLU}Enter the path :"
	print "#{HC}#{FYEL}>> "
	dicf = gets_pb.chomp.gsub("\"", "").gsub("'", "")
	if dicf == ""
		dicf = "#{File.dirname(__FILE__)}/../../other/wordlist_Xwaydah.txt"
	end
	begin
		$dict = File.open(dicf, "r")
	rescue
		puts "#{FBLU}#{HC}[#{FWHT}*#{FBLU}]#{FWHT} 1 hash loaded..."
		puts "#{FBLU}#{HC}[#{FWHT}*#{FBLU}]#{FWHT} Hash Format: MD5"
		puts ""
		puts ""
		puts "#{FWHT}  Unable to load hash list!"
		puts "#{FBLU}  Check path or permissions and try again... #{dicf}"
		puts ""
		exit
	end
end

puts ""

def cracknum(algorit, hash)
	puts "[*] Working"
	$cracked = false
	Thread.new do # One thread to compare possibilities.
		$num = 0
		while hash != algorit.hexdigest($num.to_s)
			$num += 1
		end
		$cracked = true
	end
	while $cracked == false # And the principal thread to show the status.
		STDOUT.flush
		print "\r[*] Trying #{$num.to_s}"
		sleep(0.1)
	end
	puts "[*] Cracked password Found : #{$num.to_s}"
end

def crackdic(algorit, hash)
	puts "[*] Working"
	$cracked = "?"
	thread = Thread.new do # One thread to read the dictionary and compare possibilities.
		while $word = $dict.gets
			begin
				if hash == algorit.hexdigest($word.chomp)
					$cracked = "y"
					thread.kill
				end
			rescue
			end
		end
		$cracked = "n"
	end
	while $cracked == "?" # And the principal thread to show the status.
		STDOUT.flush
		begin
			print "\r[*] Trying #{$word.chomp}" + " "*15
		rescue
		end
		sleep(0.1)
	end
	puts ""
	if $cracked == "y"
		puts ""
		puts "[*] Cracked password Found : #{$word}"
	else
		puts ""
		puts "[*] Dictionary finished, password not found."
		puts ""
	end
end

def crackdichyb(algorit, hash)
	puts "[*] Working"
	$cracked = "?"
	$thread = Thread.new do # One thread to read the dictionary, modify words and compare possibilities.
		while $word = $dict.gets
			begin
				$wordcomp = $word.chomp
			rescue
			end
			Thread.new do # New thread to improve performance in this comparisons.
				if hash == algorit.hexdigest($wordcomp)
					$password = $wordcomp
					$cracked = "y"
					$thread.kill
				end
			end
			if hash == algorit.hexdigest($wordcomp.upcase)
				$password = $wordcomp.upcase
				$cracked = "y"
				$thread.kill
			end
			if hash == algorit.hexdigest($wordcomp.downcase)
				$password = $wordcomp.downcase
				$cracked = "y"
				$thread.kill
			end
			brutecont_t = 0
			Thread.new do # New thread to improve performance in this comparisons.
				100.times do
					begin
						if hash == algorit.hexdigest("#{$word.chomp}#{brutecont_t.to_s}")
							$password = "#{$word.chomp}#{brutecont_t.to_s}"
							$cracked = "y"
							$thread.kill
						end
					rescue
					end
					brutecont_t += 1
				end
			end
			brutecont = 0
			100.times do
				if hash == algorit.hexdigest("#{$wordcomp}#{brutecont.to_s}".upcase)
					$password = "#{$wordcomp}#{brutecont.to_s}".upcase
					$cracked = "y"
					$thread.kill
				end
				brutecont += 1
			end
			brutecont = 0
			100.times do
				if hash == algorit.hexdigest("#{$wordcomp}#{brutecont.to_s}".downcase)
					$password = "#{$wordcomp}#{brutecont.to_s}".downcase
					$cracked = "y"
					$thread.kill
				end
				brutecont += 1
			end
		end
		$cracked = "n"
	end
	while $cracked == "?" # And the principal thread to show the status.
		STDOUT.flush
		print "\r[*] Trying #{$wordcomp}" + " "*15
		sleep(0.1)
	end
	puts ""
	if $cracked == "y"
		puts ""
		puts "[*] Cracked password Found : #{$password}"
	else
		puts ""
		puts "[*] Dictionary finished, password not found."
		puts ""
	end
end

case type
	when "x"
				sleep 1
				module_exec = false
	when "1"
		case how
			when "1"
				cracknum(Digest::MD5, hash)
			when "2"
				crackdic(Digest::MD5, hash)
			when "3"
				crackdichyb(Digest::MD5, hash)
			else
				puts ""
				puts "Invalid method to crack."
				puts ""
			end
	when "2"
		case how
			when "1"
				cracknum(Digest::SHA1, hash)
			when "2"
				crackdic(Digest::SHA1, hash)
			when "3"
				crackdichyb(Digest::SHA1, hash)
			else
				puts ""
				puts "Invalid method to crack."
				puts ""
			end
	when "3"
		case how
			when "1"
				cracknum(Digest::SHA256, hash)
			when "2"
				crackdic(Digest::SHA256, hash)
			when "3"
				crackdichyb(Digest::SHA256, hash)
			else
				puts ""
				puts "Invalid method to crack."
				puts ""
			end
	when "4"
		case how
			when "1"
				cracknum(Digest::SHA384, hash)
			when "2"
				crackdic(Digest::SHA384, hash)
			when "3"
				crackdichyb(Digest::SHA384, hash)
			else
				puts ""
				puts "Invalid method to crack."
				puts ""
			end
	when "5"
		case how
			when "1"
				cracknum(Digest::SHA512, hash)
			when "2"
				crackdic(Digest::SHA512, hash)
			when "3"
				crackdichyb(Digest::SHA512, hash)
			else
				puts ""
				puts "Invalid method to crack."
				puts ""
			end
	when "6"
		case how
			when "1"
				cracknum(Digest::RMD160, hash)
			when "2"
				crackdic(Digest::RMD160, hash)
			when "3"
				crackdichyb(Digest::RMD160, hash)
			else
				puts ""
				puts "Invalid method to crack."
				puts ""
			end
	else
		puts ""
		puts "Invalid hash Dummy . You sir are a failure!"
		puts ""

end

end
end
end
