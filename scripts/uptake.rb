#!/usr/bin/env ruby
require 'rubygems'

$LOAD_PATH << '/home/durai/anemone_src_modified/anemone/lib'

require 'anemone'

#Anemone.crawl("http://www.yahoo.com", :discard_page_bodies => false, :verboase => true, :depth_limit => 1, :user_agent => "Mozilla/5.0 (compatible; Googlebot/2.1; +http://www.google.com/bot.html)", :large_scale_crawl => true, :accept_cookies => true) do |anemone|

Anemone.crawl("http://www.uptake.com", :include_domains => ".uptake-inc.com", :depth_limit => 2, :user_agent => "Mozilla/5.0 (compatible; Googlebot/2.1; +http://www.google.com/bot.html)", :large_scale_crawl => true, :accept_cookies => true, :verbose => false, :crawl_subdomains => true, :write_location => "uptake_data", :force_download => false, :threads => 2) do |anemone|
anemone.on_every_page do |page|
  #puts "Durai #{page.url}"
  puts "In uptake-inc #{page.url}" if page.url.to_s.index('uptake-inc')
  #puts page.links
end
end
