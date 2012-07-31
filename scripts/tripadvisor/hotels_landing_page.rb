#!/usr/bin/env ruby
require 'rubygems'

$LOAD_PATH << '/home/durai/github/anemone/lib'

require 'anemone'

#hotels = IO.binread("./hotels/xaa")
hotels = IO.read(ARGV[0])

hotels_urls = hotels.split("\n")

Anemone.crawl(hotels_urls, :depth_limit => 0, :verbose => true, :crawl_subdomains => false, :write_location => "data_ta", :force_download => false, :threads => 6, :jobid => 1) do |anemone|


end


