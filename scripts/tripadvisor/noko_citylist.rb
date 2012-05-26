require 'nokogiri'
require 'open-uri'

# Get a Nokogiri::HTML:Document for the page we’re interested in...

#doc = Nokogiri::HTML(open('http://www.google.com/search?q=nikon%20d800'))
doc = Nokogiri::HTML(open('http://www.tripadvisor.com/Hotels-g191-oa8570-United_States-Hotels.html'))

# Do funky things with it using Nokogiri::XML::Node methods...

####
# Search for nodes by css
#doc.css('//h3.r/a.l').each do |link| # not working

#doc.xpath('//h3.r/a.l').each do |link|
#puts link.content
#end

domain = "http://www.tripadvisor.com"

@urls = []

doc.css('ul.geoList>li').each do |link|
  #puts link.content

  details = link.xpath('.//a')[0].attributes()

  @urls << domain + details['href'].value()
  #puts url

end

puts @urls

