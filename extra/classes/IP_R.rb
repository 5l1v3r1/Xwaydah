if RUBY_PLATFORM =~ /linux/ then
else
puts "#{FRED}#{HC}OK ,L00king for External Address IP......#{FHWT}"
sleep 2
exit
end
puts "#{FRED}#{HC}OK ,Checking Address from my router #{FWHT}...."
$IP = "192.168.1.1" #
require 'net/http' #
def up?(host) #Method to test the Routers availabillity
http = Net::HTTP.start(host, {open_timeout: 5, read_timeout: 5})
response = http.head("/")
response.code == "200"
rescue Timeout::Error, SocketError
false
end
@logFile = String.new
@logger = String.new
@logger2 = "Original Source downloaded from: http://#{$IP}\tsyslog.rg\nDate: #{@time}"
@pingResult = File.new("pingResult.ping", "w+")
puts "Tsyslog.rg was last modified: #{File.mtime("tsyslog.rg")}" if File.exists?("tsyslog.rg")
puts "Contacting Router @ #{$IP}"
puts "\e[31mVariable IP is not set to default state!\e[0m" if $IP != "192.168.1.1"
if up? $IP then
puts "\e[32mDevice is online!\e[0m"
puts "Pinging Device #{$IP}"
pingOut = `ping -c 7 #{$IP}`
@pingResult.puts(pingOut)
puts "\e[32mDevice responsed\e[0m" if $?.exitstatus == 0
if $?.exitstatus == 1 then
puts "\e[33mDevice did not response\e[0m"
exit
end
if $?.exitstatus == 2 then
puts "\e[31mError! Pinging not successful\e[0m"
exit
end
else
puts "\e[31m504: Device not found or offline! IP: #{$IP}\nPlease check if your Router is properly set up or if you changed the $IP Variable in the Source Code!"
puts "Variable $IP set to #{$IP} although it should be 192.168.1.1" if $IP != "192.168.1.1"
puts "\e[0m"
exit
end
puts "Downloading log from Router (\e[33m#{$IP}/tsyslog.rg\e[0m)"
Net::HTTP.start("#{$IP}") do |http|
resp = http.get("/tsyslog.rg")
open("tsyslog.rg", "wb") do |file|
file.write(resp.body)
end
end
puts "File tsyslog.rg downloaded to #{Dir.pwd}"
puts "Evaluating tsyslog.rg ..."
Dir.mkdir("IP-Data") if Dir.exists?("IP-Data") == false
@time = Time.now
@log = File.open("tsyslog.rg", "r")
@name = "IPs-#{@time.day}0#{@time.month}#{@time.year}-#{@time.hour}_#{@time.min}_#{@time.sec}.ips"
@logCreate = File.new("IP-Data/#{@name}", "w+")
#Evaluation Process
@log.each_char do |c|
@logFile << c
end
@logFile.each_char do |c|
@logger << c if c == "1" or c == "2" or c == "3" or c == "4" or c == "5" or c == "6" or c == "7" or c == "8" or c == "9" or c == "0" or c == "." or c == "(" or c == ")"
end
@logger.scan(/\w+/) do |line|
line.replace "" if line.size > 3
line << "."
line.replace "\n\nIP:\n" if line == "."
@logger2 << line
end
@logCreate.puts("Program by Marvin Johanning (http://JeytasGame.de.vc). For further questions: programming@marvin.johanning.de.vc")
@logCreate.puts(@logger2)
puts "#{@name} was created."