#!/usr/bin/env ruby
require 'rubygems'
require 'nokogiri'
require 'open-uri'
 
doc = Nokogiri::HTML(
  open('http://www.uptake.com')
)
 
#doc.css('a.l').each do|l|
#  puts l.content
#end

doc.search("//a[@href]").each do |a|
    puts a['href']
end
doc.search("//img[@src]").each do |a|
    puts a['src']
end
doc.search("//link[@href]").each do |a|
    puts a['href']
end
doc.search("//script[@src]").each do |a|
    puts a['src']
end
doc.search("//a[@href]").each do |a|
    puts a['style background-image url']
end

