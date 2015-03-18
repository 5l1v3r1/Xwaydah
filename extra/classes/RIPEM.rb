#Get code here : https://searchcode.com/codesearch/view/16912873/
module Cryptogr_pb
class Digest_pb
def initialize()

require "digest/md5"
require "digest/sha1"
require "digest/sha2"
require "digest/rmd160"

puts "#{HC}#{FBLU}[#{FWHT}*#{FBLU}]#{FWHT} hsload used for digest the hash......"
puts ""
print " #{RS} Enter string Here :"
word = gets_pb.chomp
puts "#{HC}#{FBLU}[#{FWHT}*#{FBLU}] #{FWHT}Hsload Results for....."
puts "#{FBLU}#{HC}############################################################"
puts "#{FBLU}SHA1       #{FWHT}: "+ Digest::SHA1.hexdigest(word)
puts "#{FBLU}MD5        #{FWHT}:" + Digest::MD5.hexdigest(word)
puts "#{FBLU}SHA2 (256) #{FWHT}:" + Digest::SHA256.hexdigest(word)
puts "#{FBLU}SHA2 (512) #{FWHT}:" + Digest::SHA512.hexdigest(word)
puts "#{FBLU}SHA2 (384) #{FWHT}:" + Digest::SHA384.hexdigest(word)
puts "#{FBLU}RIPEMD-160 #{FWHT}:" + Digest::RMD160.hexdigest(word)
puts "#{FBLU}############################################################"
puts ""
puts ""
end
end
end
