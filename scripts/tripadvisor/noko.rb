require 'nokogiri'
require 'open-uri'


#u = 'http://www.tripadvisor.com/Hotel_Review-g32124-d224514-Reviews-Hilton_Garden_Inn_San_Francisco_Airport_Burlingame-Burlingame_California.html'
u = 'http://www.tripadvisor.com/Hotel_Review-g32655-d76049-Reviews-Four_Seasons_Hotel_Los_Angeles_at_Beverly_Hills-Los_Angeles_California.html'
doc = Nokogiri::HTML(open(u))


####
# Search for nodes by css
#doc.css('//h3.r/a.l').each do |link| # not working

#doc.xpath('//h3.r/a.l').each do |link|
#puts link.content
#end

#fd_h = File.new("hotels_reviews_page_urls.txt", "w")

domain = "http://www.tripadvisor.com"

@urls = []

review_total = 0
doc.css('span.pgCount').each do |link|
  puts link.content

  review_page_stats = link.content.split(' ')
  review_total = review_page_stats[2].to_i

  #fd_h.puts page.url # write the first page.
  #fd_h.puts u # write the first page.
  puts u # write the first page.

  if (review_total > 10)
    # write other pagination urls
    incr_per_page = 10
    #link = page.url.to_s
    link = u.to_s
    url_split = link.split(/-/)
puts url_split

    page_start_count = 0
    while ((page_start_count + incr_per_page) < review_total)  do
      page_start_count += incr_per_page
      #fd_h.puts "#{url_split[0]}-#{url_split[1]}-#{url_split[2]}-#{url_split[3]}-" + "or" + page_start_count.to_s + "-#{url_split[4]}-#{url_split[5]}\n"
      puts "#{url_split[0]}-#{url_split[1]}-#{url_split[2]}-#{url_split[3]}-" + "or" + page_start_count.to_s + "-#{url_split[4]}-#{url_split[5]}\n"
    end
  end
end

#puts @urls

