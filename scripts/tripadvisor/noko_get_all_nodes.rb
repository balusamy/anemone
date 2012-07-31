require 'nokogiri'   
require 'open-uri'  

filename = '/data/crawl/ta/data_ta_hotel_and_reviews/www.tripadvisor.com/Hotel_Review-g1006448-d594942-Reviews-Hillside_Bed_and_Breakfast-Halfway_Oregon.html'

body = IO.read(filename)

#doc = Nokogiri::HTML(body)
doc = Nokogiri::HTML(open('http://www.ruby-doc.org/core/classes/Bignum.html'))

doc.xpath('//span[@class="method-name"]').each do | method_span |  
    puts method_span.content  
    puts method_span.path  
    puts  
end  

