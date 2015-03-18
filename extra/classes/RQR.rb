#!/usr/bin/env ruby
puts "#{FRED}#{HC}Gencat Ready....."
puts "#{FYEL}Genarate the Unique passwords...."
puts "#{FWHT}
+---------------------+
| By:#{RS}#{FRED}Alexcerus HR #{FWHT}#{HC}| 
| Gencat tool         |
+---------------------+

        a          a
       aaa        aaa
      aaaaaaaaaaaaaaaa
     aaaaaaaaaaaaaaaaaa     #{RS}#{FRED}(generate password in brute force mode....)#{FWHT}#{HC}
    aaaaaaaaaaaaaaaaaaaa                     #{RS}#{FWHT}EOR - SVT#{HC}
    aaaaaaaaaaaaaaaaaaaa                   #{RS }#{FRED}Gen.......Begin#{HC}#{FWHT}
     aaaaaaaaaaaaaaaaaa 		   
      aaaaaaaaaaaaaaaa
       aaaaaaaaaaaaaa
      aaaaaaaaaaaaaaaa
     aaaaaaaaaaaaaaaaaa
    aaaaaaaaaaaaaaaaaaaa
   aaaaaaaaaaaaaaaaaaaaaa
  aaaaaaaaaaaaaaaaaaaaaaaa
  aaaaaaaaaaaaaaaaaaaaaaaa
  aaaaaaaaaaaaaaaaaaaaaaaa
   aaaaaaaaaaaaaaaaaaaaaa
    aaaaaaaaaaaaaaaaaaaa
"
sleep 2
puts ""
puts "#{FRED}[#{FWHT}*#{FRED}]#{FYEL} Get ready for some brute force ;)#{FBLU}"
sleep 3


def result?(sub)
  puts sub
	1 == 2
end

def gen_hashing(chars)
	gen_hash(chars){ |p|
		return p if result?(p)
	}
end


def gen_hash(chars)
	chars.each { |c| yield c }

	gen_hash(chars) { |c|
		chars.each do |x|
			yield c + x
		end
	}
end

chars = ('a'..'z').to_a
(0..9).each {|x| chars << x.to_s} 

gen_hashing(chars)
