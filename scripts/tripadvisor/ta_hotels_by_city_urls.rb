#!/usr/bin/env ruby
require 'rubygems'

$LOAD_PATH << '/home/durai/github/anemone/lib'

require 'anemone'

data_location = "/data/crawl/ta/"
city_urls_file = location + "hotels_by_city_urls.txt"
outfile = location + "all_hotels_in_a_city.txt"

hotels_by_city = IO.binread(city_urls_file)

city_urls = hotels_by_city.split(/\n/)

fd_h = File.new(outfile, "w")

Anemone.crawl(city_urls, :depth_limit => 0, :verbose => true, :crawl_subdomains => false, :write_location => data_location + "data_ta", :force_download => false, :threads => 8, :jobid => 1) do |anemone|

  anemone.on_every_page do |page|
    total = 0;
    page.doc.css('div.paginationfill').each do |sec|
      sec.css('div.orphan>i').each do |link|
        total = link.content.to_i
      end
    end

    #sectitle =  page.doc.xpath("//h2[@id='RSLTHDR']").text
    # ignore non hotels like B&B etc
    #if !sectitle.index("B&B") 
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
    #end

    page.discard_doc! true
  end

end


