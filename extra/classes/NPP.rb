
module Cryptogr_pb
class Base64_pb
def initialize()

# Base64 encoder/decoder.
#

require "base64"

puts "#{HC}#{FBLU}[#{FWHT}*#{FBLU}]#{FWHT}Base64 Decode and Encode ."
print "      Enter here : "
word = gets_pb.chomp

puts ""
puts "#{FGRN}[#{FWHT}*#{FGRN}]#{FWHT}Encoded :" + Base64.encode64(word)
puts "#{FGRN}[#{FWHT}*#{FGRN}]#{FWHT}Decoded : " + Base64.decode64(word)
puts ""

end
end
end
