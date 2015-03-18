module Network_pb
class Wire_geo_loc_pb
def initialize()

# Wireless Geolocation (HTML 5 Geolocation API) VsIP Geolocation
#

require "net/http"
require "uri"

url_sam1 = "http://www.ip2location.com/html5geolocationapi.aspx"

puts "#{HC}#{FYEL}wireless #{FWHT}=> #{FRED}Wireless Geolocation (HTML 5 Geolocation API) VsIP Geolocation"
puts "
#{FGRN}#{HC}
                                                                               
                     _|                      _|                                
 _|      _|      _|      _|  _|_|    _|_|    _|    _|_|      _|_|_|    _|_|_|  
 _|      _|      _|  _|  _|_|      _|_|_|_|  _|  _|_|_|_|  _|_|      _|_|      
   _|  _|  _|  _|    _|  _|        _|        _|  _|            _|_|      _|_|  
     _|      _|      _|  _|          _|_|_|  _|    _|_|_|  _|_|_|    _|_|_|    
                                                                               
                                                                               

"
puts ""
print "#{FBLU}[#{FWHT}*#{FBLU}] #{FWHT}#{HC}wireless inter : "
wire = gets_pb.chomp.gsub(":", "-")

begin
	url = URI.parse(url_ip2location + wire)
	http = Net::HTTP.new(url.host, url.port)
	resp = http.get(url.to_s)
	if resp.code == "200"
		data = resp.body.split("<div id=addy>")[1].split("</div>")[0].gsub("<br>", "\n") # Parsing body.
		puts data
	else
		puts ""
		puts " Error connecting to ip2location ."
		puts ""
	end
rescue
	puts ""
	puts " Error connecting to ip2location ."
	puts ""
end

end
end
end

