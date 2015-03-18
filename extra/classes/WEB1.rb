module Web_pb
class BRUT_pb
def initialize()

# HTTP directory bruteforce.
#

require "net/http"
require "uri"

wordlist = File.dirname(__FILE__) + "/../../other/http_dirs.txt"

puts ""
title "// HTTP directory bruteforce //"
puts ""
puts " Insert url to bruteforce dirs."
puts ""
puts " Example: http://example.com/"
puts "          http://example.com/dir1/dir2/"
puts ""
print "   -> "
user_url = gets_pb.chomp

puts ""
puts " Use SSL? (y/N)"
puts ""
print "   -> "
use_ssl = gets_pb.chomp.downcase
if use_ssl == "y"
	use_ssl = true
else
	use_ssl = false
end

url = URI.parse(user_url)
if url.path == ""
	url.path = "/"
end

begin
	puts ""
	puts " Determined values:"
	puts "\t Url: " + url.to_s
	puts "\t Host: " + url.host
	puts "\t Port: " + url.port.to_s
	puts "\t SSL: " + use_ssl.to_s
	puts "\t Path: " + url.path
rescue
	puts ""
	puts " Error: I can't parse the URL, please use the proper format."
	puts ""
	return 1
end

begin
	list = File.open(wordlist, "r")
rescue
	puts ""
	puts " Error opening #{wordlist}"
	puts ""
	return 1
end

begin
	http = Net::HTTP.new(url.host, url.port)
	http.use_ssl = use_ssl
	url_dir = url.to_s

	puts ""
	puts "[*] Bruteforcing dirs ..."
	13.times do # This loop is to skip license lines of the wordlist.
		list.gets
	end
	while line = list.gets
		http_dir = line.chomp
		resp = http.get(url_dir + "/" + http_dir)
		if resp.code == "200" || resp.code == "403" || resp.code == "401"
			puts "    #{url_dir}/#{http_dir} found - Response #{resp.code}"
		end
	end
	puts "[*] Finished."
	list.close
rescue
	list.close
	puts ""
	puts " Error connecting."
	puts ""
	return 1
end

end
end
end

