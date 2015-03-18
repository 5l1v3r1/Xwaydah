module Web_pb
class BRUT2_pb
def initialize()

# HTTP common files bruteforce.
#

require "net/http"
require "uri"

files = [
	"readme", "README", "Readme",
	"license", "LICENSE", "License",
	"robots", "ROBOTS", "Robots",
	"persons", "PERSONS", "Persons",
	"hackers", "HACKERS", "Hackers",
	"config", "CONFIG", "Config",
	"configuration", "CONFIGURATION", "Configuration",
	"admin", "ADMIN", "Admin",
	"administrator", "ADMINISTRATOR", "Administrator",
	".htaccess",
	".htpasswd",
	"httpd.conf",
	"index"
]

exts = [
	"txt", "html", "htm", "xml", "php"
]

puts ""
title "// HTTP common files bruteforce //"
puts ""
puts " Insert url to bruteforce files."
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
	http = Net::HTTP.new(url.host, url.port)
	http.use_ssl = use_ssl
	url_dir = url.to_s

	puts ""
	puts "[*] Searching files ..."
	files.each do |f|
		exts.each do |e|
			resp = http.get(url_dir + "/" + f + "." + e)
			if resp.code == "200" || resp.code == "403" || resp.code == "401"
				puts "    #{url_dir}/#{f}.#{e} found - Response #{resp.code}"
			end
		end
		resp = http.get(url_dir + "/" + f)
		if resp.code == "200" || resp.code == "403" || resp.code == "401"
			puts "    #{url_dir}/#{f} found - Response #{resp.code}"
		end
	end
	puts "[*] Finished."
rescue
	puts ""
	puts " Error connecting."
	puts ""
	return 1
end

end
end
end

