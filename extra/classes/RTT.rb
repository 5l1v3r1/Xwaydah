#! /usr/env/ruby
#####REQ######
require "benchmark" #
require 'digest/md5'  #
##############

puts "#{HC}#{FWHT}
           _\\|/_
           (#{FRED}o o#{FWHT})
 +------oOO-{_}-OOo------+
 |  #{FRED}HESHL3R #{FWHT}             |
 |  #{RS}#{FRED}By: Alexcerus HR#{FWHT}#{HC}  |
 +-----------------------+
"
# The password hash to crack
hash_crack3r = "e1f3ecc31656795a128db19da490c9ec"

# Helper for hashing passwords
def md5(password)
  Digest::MD5.hexdigest(password)
end

# Compares the given hash to the md5 hash of the given potential password
def cracked?(secret_hash_crack3r, potential_password)
  secret_hash_crack3r == md5(potential_password)
end


#Brute Force Attempt (3 chars max)

def crack_3(secret_hash_crack3r, chars)
  chars.each do |x|
    chars.each do |y|
      chars.each do |z|
        p = "#{x}#{y}#{z}"
        return p if cracked?(secret_hash_crack3r, p)
      end
    end
  end
end


# Using product of character lists.
# Nicely yields (prevents memory explosion) but still generates all for 1 char,
# all for 2 etc, lots of un-necessary computations later down the line

def crack_product(secret_hash_crack3r, chars)
  infinity = (1.0/0.0)
  (1..infinity).each do |i|
    character_ranges = i.times.map{ chars }
    character_ranges.first.product(*character_ranges[1..-1]) do |c_comb|
      p = c_comb.join
      return p if cracked?(secret_hash_crack3r, p)
    end
  end
end

################################################################################
# Using product of character lists.
# Nicely yields generating every single password a maximum of once without
# storing substrings in memory
################################################################################
def crack_yielding(secret_hash_crack3r, chars)
  crack_yield(secret_hash_crack3r, chars){ |p|
    return p if cracked?(secret_hash_crack3r, p)
  }
end

def crack_yield(secret_hash_crack3r, chars)
  chars.each { |c| yield c }

  crack_yield(secret_hash_crack3r, chars){ |c|
    chars.each do |x|
      yield c + x
    end
  }
end

################################################################################
# Counts up in base(chars.length) and converts each number to the string
# representation for hash comparison
################################################################################
def crack_base_n(secret_hash_crack3r, chars)
  p = ""
  infinity = (1.0/0.0)
  (1..infinity).each do |i|
    p = basen_to_chars(chars, i).join
    return p if cracked?(secret_hash_crack3r, p)
  end
end

def basen_to_chars(chars, i)
  base = chars.length
  s = []

  while i >= base
    s << chars[i % base]
    i /= base
  end
  s << chars[i - 1]
  return s.reverse
end


################################################################################
# Run Benchmarks
################################################################################
chars = ('A'..'Z').to_a # Array of acceptable characters

Benchmark.bm(7) do |b|
  puts "#{FRED}[#{FWHT}*#{FRED}]#{FWHT}#{HC}bruteforce mode #{FRED}(Rondom mode)#{FWHT}"
  b.report("crack_heshler_p (tom):            ") { crack_3(hash_crack3r, chars) }

  puts "#{FRED}#{HC}Heshler pro (Product)#{FWHT}"
  b.report("crack_heshler pro_n #{FRED}(tom)#{FWHT}:    ") { crack_product(hash_crack3r, chars) }
  b.report("crack_heshler pro_n #{FRED}(pass)#{FWHT}:   ") { crack_product(md5('PASS'),   chars) }
  b.report("crack_heshler pro_n #{FRED}(passw)#{FWHT}:  ") { crack_product(md5('PASSW'),  chars) }
  b.report("crack_heshler pro_n #{FRED}(aaaaaa)#{FWHT}: ") { crack_product(md5('AAAAAA'),  chars) }

  puts "#{FRED}#{HC}OK mode 2 is on : Checking.... "
  b.report("heshler_cracking_n #{FRED}(tom)#{FWHT}:   ") { crack_yielding(hash_crack3r, chars) }
  b.report("heshler_cracking_n #{FRED}(pass)#{FWHT}:  ") { crack_yielding(md5('PASS'),   chars) }
  b.report("heshler_cracking_n #{FRED}(passw)#{FWHT}: ") { crack_yielding(md5('PASSW'),  chars) }
  b.report("heshler_cracking_n #{FRED}(aaaaaa)#{FWHT}:") { crack_yielding(md5('AAAAAA'),  chars) }


  puts "#{FRED}#{HC}OK mode 3 is on (Base N): Checking...#{FWHT}"
  b.report("hash_in_base #{FRED}(tom)#{FWHT}:       ") { crack_base_n(hash_crack3r, chars) }
  b.report("hash_in_base #{FRED}(pass)#{FWHT}:      ") { crack_base_n(md5('PASS'), chars) }
  b.report("hash_in_base #{FRED}(passw)#{FWHT}:     ") { crack_base_n(md5('PASSW'), chars) }
  b.report("hash_in_base #{FRED}(aaaaaa)#{FWHT}:    ") { crack_base_n(md5('AAAAAA'), chars) }
end

################################################################################
# Sample Output (My Laptop)
#
# $ time ruby hashcrack.rb
#                             user       system     total    real
# ------------------------------------------------------------------------------
# # BRUTE FORCE
# crack_3 (TOM):              0.050000    0.000000   0.050000 (  0.052371)
# ------------------------------------------------------------------------------
# # PRODUCT
# crack_product_n (TOM):      0.060000   0.000000   0.060000 (  0.066884)
# crack_product_n (PASS):     1.400000   0.000000   1.400000 (  1.394305)
# crack_product_n (PASSW):   37.330000   0.010000  37.340000 ( 37.344042)
# crack_product_n (AAAAAA):  62.920000   0.020000  62.940000 ( 62.928852)
# ------------------------------------------------------------------------------
# # RECURSIVE YIELDING
# crack_yielding_n (TOM):     0.050000   0.000000   0.050000 (  0.050184)
# crack_yielding_n (PASS):    1.010000   0.000000   1.030000 (  1.027363)
# crack_yielding_n (PASSW):  25.920000   0.000000  25.920000 ( 25.932253)
# crack_yielding_n (AAAAAA): 43.790000   0.020000  43.810000 ( 43.805885)
# ------------------------------------------------------------------------------
# # BASE N
# crack_base_n (TOM):         0.090000   0.000000   0.090000 (  0.089642)
# crack_base_n (PASS):        1.980000   0.000000   1.980000 (  1.978130)
# crack_base_n (PASSW):      54.370000   0.080000  54.450000 ( 54.449413)
# crack_base_n (AAAAAA):     89.130000   0.150000  89.280000 ( 89.284392)
# ------------------------------------------------------------------------------
# ruby hashcrack.rb  318.14s user 0.29s system 99% cpu 5:18.43 total
################################################################################
