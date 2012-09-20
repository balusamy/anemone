#!/usr/bin/env ruby
require 'rubygems'

$LOAD_PATH << '/home/durai/github/anemone/lib'

require 'anemone'

#
# Crawl and extract hotels link on city hotels pages and output the hotels urls
#

input_file = ARGV[0]
output_file = ARGV[1]
write_loc = ARGV[2]

hotels_by_city = IO.read(input_file)

city_urls = hotels_by_city.split(/\n/)

fd_h = File.new(output_file, "w")

domain = "http://www.tripadvisor.com"

Anemone.crawl(city_urls, :depth_limit => 0, :verbose => true, :crawl_subdomains => false, :write_location => write_loc, :force_download => false, :threads => 8, :jobid => 1) do |anemone|

  anemone.on_every_page do |page|
    page.doc.css('div.quality').each do |link|
      details = link.xpath('.//a')[0].attributes()
      fd_h.puts domain + details['href'].value()
    end
    page.discard_doc! true
  end

end


