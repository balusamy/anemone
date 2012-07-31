#!/usr/bin/env ruby
require 'rubygems'

$LOAD_PATH << '/home/durai/github/anemone/lib'

require 'anemone'

file = ARGV[0]

file = "./hotels/xaa" if file.nil?

hotels = IO.binread(file)

hotels_urls = hotels.split("\n")

outfile = "#{file}_hotels_reviews_page_urls.txt"

fd_h = File.new(outfile, "w")

Anemone.crawl(hotels_urls, :depth_limit => 0, :verbose => true, :crawl_subdomains => false, :write_location => "/data/crawl/ta/data_ta", :force_download => false, :threads => 4, :jobid => 1) do |anemone|

  anemone.on_every_page do |page|

    if (!page.doc)
        puts "page not found " + page.url.to_s
    else
        review_total = 0
        page.doc.css('span.pgCount').each do |link|
          #puts link.content

          review_page_stats = link.content.split(' ')

          review_total = review_page_stats[2].gsub(",", '')
          review_total = review_total.to_i

          fd_h.puts page.url # write the first page.

          if (review_total > 10)
        # write other pagination urls
        incr_per_page = 10
        link = page.url.to_s
        url_split = link.split(/-/)

        page_start_count = 0
        while ((page_start_count + incr_per_page) < review_total)  do
          page_start_count += incr_per_page
          fd_h.puts "#{url_split[0]}-#{url_split[1]}-#{url_split[2]}-#{url_split[3]}-" + "or" + page_start_count.to_s + "-#{url_split[4]}-#{url_split[5]}\n"
        end
          end
        end
    end
  end

end


