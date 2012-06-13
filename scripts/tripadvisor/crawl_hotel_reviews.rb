#!/usr/bin/env ruby
require 'rubygems'

$LOAD_PATH << '/home/durai/github/anemone/lib'

require 'anemone'

file = ARGV[0]

file = "./hotels/xaa_hotels_reviews_page_urls.txt" if file.nil?

hotels = IO.binread(file)

hotels_urls = hotels.split("\n")

Anemone.crawl(hotels_urls, :depth_limit => 0, :verbose => true, :crawl_subdomains => false, :write_location => "/data/crawl/ta/data_ta_hotel_and_reviews/", :force_download => false, :threads => 1, :jobid => 1) do |anemone|

end


