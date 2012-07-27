#!/usr/bin/env ruby
require 'rubygems'

$LOAD_PATH << '/home/durai/github/anemone/lib'

require 'anemone'

data_location = "/data/crawl/ta/"
city_urls_file = location + "hotels_by_city_urls.txt"

#Build the city hotels pages urls
start_page = 0
second_page = 20
incr_per_page = 30

country_city_pages = []

country_city_pages << "http://www.tripadvisor.com/Hotels-g191-United_States-Hotels.html" + "\n"
country_city_pages << "http://www.tripadvisor.com/Hotels-g191-oa20-United_States-Hotels.html" + "\n"

tmpl = "http://www.tripadvisor.com/Hotels-g191-"
domain = "http://www.tripadvisor.com"

page_start_count = 20;

while ((page_start_count + incr_per_page) <= 8605)  do
    page_start_count += incr_per_page

    country_city_pages << tmpl + "oa" + page_start_count.to_s + "-United_States-Hotels.html\n" 

end

fd = File.new(city_urls_file, "w")
city_dest_urls = []

Anemone.crawl(country_city_pages, :depth_limit => 0, :verbose => true, :crawl_subdomains => false, :write_location => data_location + "data_ta", :force_download => false, :threads => 8, :jobid => 1) do |anemone|

  anemone.on_every_page do |page|

    # parse the first page
    if !(page.url.to_s =~ /-oa/) 
      page.doc.css('div.rolluptopdestlink').each do |link|
        details = link.xpath('.//a')[0].attributes()
        u = domain + details['href'].value()
        city_dest_urls << u
      end
    else
      # parse the other pages
      # only incude city dest urls
      page.doc.css('ul.geoList>li').each do |link|
        #puts link.content

        details = link.xpath('.//a')[0].attributes()

        u = domain + details['href'].value()
        city_dest_urls << u
      end
    end

    page.discard_doc! true
  end

  #only crawl pages that contain /example in url
# anemone.focus_crawl do |page|
#    links = []
#
#    city_dest_urls.each do |u|
#      abs = page.to_absolute(URI(URI.escape(u))) rescue next
#      links << abs
#    end
#    links.uniq!
#    page.ignore_depth = true
#    links
# end

  # only process pages in the /example directory
  #anemone.on_pages_like(/example/) do | page |
  #  regex = /some type of regex/
  #  example = page.doc.css('#example_div').inner_html.gsub(regex,'') rescue next
#
#    # Save to text file
#    if !example.nil? and example != ""
#      open('example.txt', 'a') { |f| f.puts "#{example}"}
#    end

#    page.discard_doc!
#  end

end

city_dest_urls.uniq!
fd.puts city_dest_urls
fd.close

