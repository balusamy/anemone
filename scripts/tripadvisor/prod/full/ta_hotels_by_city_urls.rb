#!/usr/bin/env ruby
require 'rubygems'

$LOAD_PATH << '/home/durai/github/anemone/lib'

require 'anemone'

#
# Generate all the pagination urls in the hotels list page in each city
#
crawled_dir = ARGV[0] # crawled directory
city_urls_file = ARGV[1] # input file. page one of hotels list per city
outfile = ARGV[2] # Generate all pages of hotels list per city

hotels_by_city = IO.read(city_urls_file)

city_urls = hotels_by_city.split(/\n/)

fd_h = File.new(outfile, "w")

Anemone.crawl(city_urls, :depth_limit => 0, :verbose => true, :crawl_subdomains => false, :write_location => crawled_dir, :force_download => false, :threads => 8, :jobid => 1) do |anemone|

  anemone.on_every_page do |page|
    total = 0;
    page.doc.css('div.paginationfill').each do |sec|
      sec.css('div.orphan>i').each do |link|
        total = link.content.to_i
      end
    end

    fd_h.puts page.url # write the first page.

    if (total > 30) 
      # write other pagination urls
      incr_per_page = 30
      link = page.url.to_s
      url_split = link.split(/-/)

      page_start_count = 0
      while ((page_start_count + incr_per_page) < total)  do
        page_start_count += incr_per_page
        fd_h.puts "#{url_split[0]}-#{url_split[1]}-" + "oa" + page_start_count.to_s + "-#{url_split[2]}-#{url_split[3]}\n"
      end
    end

    page.discard_doc! true
  end

end


