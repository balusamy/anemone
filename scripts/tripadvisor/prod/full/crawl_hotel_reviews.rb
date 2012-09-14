#!/usr/bin/env ruby
require 'rubygems'

$LOAD_PATH << '/home/durai/github/anemone/lib'

require 'anemone'

file = ARGV[0]
writc_loc = ARGV[1]

file = "./hotels/xaa_hotels_reviews_page_urls.txt" if file.nil?

hotels = IO.read(file)

hotels_urls = hotels.split("\n")

#Anemone.crawl(hotels_urls, :depth_limit => 0, :verbose => true, :crawl_subdomains => false, :write_location => "/data/crawl/ta/data_ta_hotel_and_reviews/", :force_download => false, :threads => 4, :jobid => 1) do |anemone|
Anemone.crawl(hotels_urls, :depth_limit => 0, :verbose => true, :crawl_subdomains => false, :write_location => write_loc, :force_download => false, :threads => 4, :jobid => 1) do |anemone|

end


