require 'nokogiri'
require 'open-uri'


#u = 'http://www.tripadvisor.com/Hotel_Review-g32124-d224514-Reviews-Hilton_Garden_Inn_San_Francisco_Airport_Burlingame-Burlingame_California.html'
#u = 'http://www.tripadvisor.com/Hotel_Review-g32655-d76049-Reviews-Four_Seasons_Hotel_Los_Angeles_at_Beverly_Hills-Los_Angeles_California.html'
u = 'http://www.tripadvisor.com/Hotel_Review-g45963-d503598-Reviews-Wynn_Las_Vegas-Las_Vegas_Nevada.html'
doc = Nokogiri::HTML(open(u))


####
# Search for nodes by css
#doc.css('//h3.r/a.l').each do |link| # not working

#doc.xpath('//h3.r/a.l').each do |link|
#puts link.content
#end


domain = "http://www.tripadvisor.com"

@urls = []


#doc.css("span[@id='tapListResultForm:resDetail_pg_3']")


doc.css('#HEADING_GROUP').each do |link|
  #Extract address
  #hname = link.css('#HEADING').text
  hname = link.css("h1[@property='v:name']").text
  puts hname
  addr = link.css("span[@property='v:street-address']").text
  puts addr
  city = link.css("span[@property='v:locality']").text
  puts city
  state = link.css("span[@property='v:region']").text
  puts state
  zip = link.css("span[@property='v:postal-code']").text
  puts zip
  hclass = link.search('span.rate_cl img').first[:alt]

  puts link.search('div.fl.script')
  
  #puts hclass

  #

end


