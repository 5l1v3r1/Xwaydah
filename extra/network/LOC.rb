module Network_pb
class Geo_mac_loc_pb
def initialize()

# MAC address geolocation 
#

require "net/http"
require "uri"

url_sam1 = "http://samy.pl/mapxss/?mac="
# url_sam2 = "http://samy.pl/androidmap/index.php?mac=MAC_ADDR&commit=Probe"

puts "#{HC}#{FYEL}macgeo #{FWHT}=> #{FRED}Mac adress geolocation tool"
puts "
#{FGRN}#{HC}

    032 [space] 048 0   064 @   080 P   096a    112 p
    033         049 1   065 A   081 Q   097 a   113 q
    034         050 2   066 B   082 R   098 b   114 r
    035         051 3   067 C   083 S   099 c   115 s
    036         052 4   068 D   084 T   100 d   116 t
    037         053 5   069 E   085 U   101 e   117 u
    038         054 6   070 F   086 V   102 f   118 v
    039         055 7   071 G   087 W   103 g   119 w
    040         056 8   072 H   088 X   104 h   120 x
    041         057 9   073 I   089 Y   105 i   121 y
    042         058 0   074 J   090 Z   106 j   122 z
    043         059 3   075 K   091 [   107 k   123 a
    044         060 8   076 L   092 \    108 l   124 |
    045         061 3   077 M   093 ]   109 m   125 a
"
puts ""
print "#{FBLU}[#{FWHT}*#{FBLU}] #{FWHT}#{HC}Put mac adress here : "
mac = gets_pb.chomp.gsub(":", "-")

begin
	url = URI.parse(url_sam1 + mac)
	http = Net::HTTP.new(url.host, url.port)
	resp = http.get(url.to_s)
	if resp.code == "200"
		data = resp.body.split("<div id=addy>")[1].split("</div>")[0].gsub("<br>", "\n") # Parsing body.
		puts data
	else
		puts ""
		puts " Error connecting to Samy's host."
		puts ""
	end
rescue
	puts ""
	puts " Error connecting to Samy's host."
	puts ""
end

end
end
end

