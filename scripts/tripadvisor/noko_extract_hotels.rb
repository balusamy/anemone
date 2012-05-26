require 'nokogiri'
require 'open-uri'

# Get a Nokogiri::HTML:Document for the page we’re interested in...

#doc = Nokogiri::HTML(open('http://www.google.com/search?q=nikon%20d800'))
#doc = Nokogiri::HTML(open('http://www.tripadvisor.com/Hotels-g191-oa8570-United_States-Hotels.html'))
#doc = Nokogiri::HTML(open('http://www.tripadvisor.com/Hotels-g60956-San_Antonio_Texas-Hotels.html'))
#doc = Nokogiri::HTML(open('http://www.tripadvisor.com/Hotels-g60956-oa30-San_Antonio_Texas-Hotels.html'))
#doc = Nokogiri::HTML(open('http://www.tripadvisor.com/Hotels-g1016316-Thornton_New_Hampshire-Hotels.html'))
doc = Nokogiri::HTML(open('http://www.tripadvisor.com/Hotels-g1017328-oa30-Taos_Ski_Valley_Taos_County_New_Mexico-Hotels.html'))

# Do funky things with it using Nokogiri::XML::Node methods...

####
# Search for nodes by css
#doc.css('//h3.r/a.l').each do |link| # not working

#doc.xpath('//h3.r/a.l').each do |link|
#puts link.content
#end

domain = "http://www.tripadvisor.com"

@urls = []

#doc.css('div.listing').each do |sec|
doc.css('div.quality').each do |link|

  #puts link.content
  details = link.xpath('.//a')[0].attributes()
  puts domain+details['href'].value()

  #urls = domain + details['href'].value()
  #puts url

end
#end

#puts @urls

