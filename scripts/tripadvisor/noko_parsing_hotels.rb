require 'nokogiri'
require 'open-uri'

# Get a Nokogiri::HTML:Document for the page we’re interested in...

#doc = Nokogiri::HTML(open('http://www.google.com/search?q=nikon%20d800'))
#doc = Nokogiri::HTML(open('http://www.tripadvisor.com/Hotels-g191-oa8570-United_States-Hotels.html'))
#doc = Nokogiri::HTML(open('http://www.tripadvisor.com/Hotels-g60763-New_York_City_New_York-Hotels.html'))
doc = Nokogiri::HTML(open('http://www.tripadvisor.com/Hotels-g1017328-Taos_Ski_Valley_Taos_County_New_Mexico-Hotels.html'))

# Do funky things with it using Nokogiri::XML::Node methods...

####
# Search for nodes by css
#doc.css('//h3.r/a.l').each do |link| # not working

#doc.xpath('//h3.r/a.l').each do |link|
#puts link.content
#end

domain = "http://www.tripadvisor.com"

@urls = []

doc.css('div.paginationfill').each do |sec|
sec.css('div.orphan>i').each do |link|

  puts link.content.to_i

  #details = link.xpath('.//a')[0].attributes()

  #@urls << domain + details['href'].value()
  #puts url

end
end

sectitle =  doc.xpath("//h2[@id='RSLTHDR']").text

puts sectitle

puts "B&B" if sectitle.index("B&B")

#puts @urls

