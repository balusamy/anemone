#!/usr/bin/env ruby
require 'rubygems'

$LOAD_PATH << '/home/durai/github/anemone/lib'

require 'anemone'

#Build the city hotels pages urls
start_page = 0
second_page = 20
incr_per_page = 30

country_city_pages = []

country_city_pages << "http://www.tripadvisor.com/Hotels-g191-United_States-Hotels.html" + "\n"
country_city_pages << "http://www.tripadvisor.com/Hotels-g191-oa20-United_States-Hotels.html" + "\n"

tmpl = "http://www.tripadvisor.com/Hotels-g191-"

page_start_count = 20;

while ((page_start_count + incr_per_page) <= 8605)  do
    page_start_count += incr_per_page

    country_city_pages << tmpl + "oa" + page_start_count.to_s + "-United_States-Hotels.html\n" 

end


#Anemone.crawl("http://www.tripadvisor.com", :filename => "usa_cities.list" , :depth_limit => 0, :verbose => true, :crawl_subdomains => false, :write_location => "data_ta_dest", :force_download => false, :threads => 8, :jobid => 1) do |anemone|

Anemone.crawl(country_city_pages, :depth_limit => 0, :verbose => true, :crawl_subdomains => false, :write_location => "data_ta", :force_download => false, :threads => 8, :jobid => 1) do |anemone|
anemone.on_every_page do |page|

end
end

