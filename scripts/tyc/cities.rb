#!/usr/bin/env ruby
require 'rubygems'

$LOAD_PATH << '/home/durai/github/anemone/lib'

require 'anemone'

#dest = IO.binread("dest_urls.txt")
#hotels = IO.binread(ARGV[0])

#city_urls = dest.split("\n")

Anemone.crawl("http://travel.yahoo.com", :depth_limit => 3, :verbose => true, :crawl_subdomains => false, :write_location => "/data/crawl/tyc", :force_download => true, :discard_page_bodies => false, :threads => 8, :jobid => 1) do |anemone|

#Anemone.crawl(city_urls, :depth_limit => 0, :verbose => true, :crawl_subdomains => false, :write_location => "data_tyc", :force_download => false, :threads => 8, :jobid => 1) do |anemone|
anemone.on_every_page do |page|

end
end


