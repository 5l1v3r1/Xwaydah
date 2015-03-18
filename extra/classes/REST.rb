#Make powerfull password protected from brutforce attack ...
module Cryptogr_pb
class Sec_password_pb
def initialize()

puts ""
puts "#{FGRN}[#{FWHT}*#{FGRN}]#{FWHT} #{HC}gencure to generate the word to pwd..."
puts "#{FGRN}[#{FWHT}*#{FGRN}]#{FWHT} #{HC}If providing multiple entries, remember to use strong pass...."
puts "#{RS}"
print "   Type Word Here :  "
$familiar = gets_pb.chomp

def sub(original, subs)
	$familiar = $familiar.gsub(original, subs)
end

sub(" ", "_")
puts ""
puts ""
puts "#{HC}#{FGRN}[#{FWHT}*#{FGRN}]#{FWHT} Found pass (Lv1) :#{FWHT} " + $familiar + rand(100).to_s 

$familiar = $familiar.capitalize
puts "#{FGRN}[#{FWHT}*#{FGRN}]#{FWHT} Found pass (Lv2) :#{FWHT}" + rand(500).to_s + "_" + $familiar + "_" + rand(500).to_s

sub("a", "@")
puts "#{FGRN}[#{FWHT}*#{FGRN}]#{FWHT} Found pass (Lv3):#{FWHT} " + "." + rand(1000).to_s + "._" + $familiar + "_." + rand(1000).to_s + "."

sub("e", "3")
sub("t", "7")
sub("o", "0")
randomlet = rand(5)
case randomlet
	when 0
		randomlet = "!"
	when 1
		randomlet = "="
	when 2
		randomlet = "*"
	when 3
		randomlet = "#"
	when 4
		randomlet = "$"
end
puts "#{FGRN}[#{FWHT}*#{FGRN}]#{FWHT} Found pass (Lv4):#{FWHT} " + randomlet + "~" + rand(5000).to_s + "._." + $familiar + "._." + rand(5000).to_s + "~" + randomlet
puts ""

# Erase variables from memory.
$familiar = "1" * $familiar.length
randomlet = "1"
$familiar = "0" * $familiar.length
randomlet = "0"
$familiar = "\xFF" * $familiar.length
randomlet = "\xFF"
$familiar = "\x00" * $familiar.length
randomlet = "\x00"

end
end
end
