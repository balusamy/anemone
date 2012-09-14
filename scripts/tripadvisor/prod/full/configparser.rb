#!/usr/bin/env ruby
# DESCRIPTION: parses configuration files compatable with Python's ConfigParser

class ConfigParser < Hash
def initialize(fname)
	section = nil
	key = nil
	File.open(fname,"r").each_line do |line|
		next if (line =~ /^(#|;)/)
		
		# parse out the lines of the config
		if line =~ /^(.+?)\s*[=:]\s*(.+)$/ # handle key=value lines
			if section
				self[section] = {} unless self[section]
				key = $1
				self[section][key] = $2
			else
				key = $1
				self[key] = $2
			end
		elsif line =~ /^\[(.+?)\]/ # handle new sections
			section = $1
		elsif line =~ /^\s+(.+?)$/ # handle continued lines
			if section
				self[section][key] += " #{$1}";
			else
				self[key] += " #{$1}"
			end
		elsif line =~ /^([\w\d\_\-]+)$/
			if section
				self[section] = {} unless self[section]
				key = $1
				self[section][key] = true
			else
				key = $1
				self[key] = true
			end
		end
	end

	# handle substitutions (globals first)
	self.each_key do |k|
		next if self[k].is_a? Hash
		next unless self[k].is_a? String
		self[k].gsub!(/\{(.+?)\}/) {|x| self[$1] || "$(#{$1})"}
	end
	
	# handle substitutions within the sections
	self.each_key do |k|
		next unless self[k].is_a? Hash
		self[k].each_key do |j|
			next unless self[k][j].is_a? String
			self[k][j].gsub!(/\{(.+?)\}/) {|x| self[k][$1] || self[$1] || "$(#{$1})"}
		end
	end
end
end

if __FILE__ == $0
        require 'pp'
        if ARGV.length == 0
                puts "Usage: $0 <config> [<config> ...]"
                exit
        end
        
        ARGV.each do |file|
                pp ConfigParser.new(file)
        end
end

