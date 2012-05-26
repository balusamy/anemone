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


domain = "http://www.tripadvisor.com"

@urls = []

review_total = 0
doc.css('span.pgCount').each do |link|
  puts link.content


end

#puts @urls

