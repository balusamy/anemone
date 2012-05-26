require 'nokogiri'
require 'open-uri'

#doc = Nokogiri::HTML(open('http://travel.yahoo.com/p-travelguide-191501864-alabama_vacations-i;'))

url = Array['http://travel.yahoo.com/p-travelguide-191501863-united_states_vacations-i',
            'http://travel.yahoo.com/p-travelguide-191501837-canada_vacations-i',
            'http://travel.yahoo.com/p-travelguide-191500012-south_america_vacations-i',
            'http://travel.yahoo.com/p-travelguide-191500003-africa_vacations-i',
            'http://travel.yahoo.com/p-travelguide-191500008-europe_vacations-i',
            'http://travel.yahoo.com/p-travelguide-191500005-asia_vacations-i',
            'http://travel.yahoo.com/p-travelguide-191500009-middle_east_vacations-i',
            'http://travel.yahoo.com/p-travelguide-191500011-oceania_south_pacific_vacations-i']

domain = "http://travel.yahoo.com"

fd_h = File.new("dest_urls.txt", "w")

desturls = []

url.each do |link|
  doc = Nokogiri::HTML(open(link))
  doc.css('div.region_city_listing_dest').each do |link|
    #puts link.content

    details = link.xpath('.//a')[0].attributes()
    #puts details['href'].value()

    dest = domain + details['href'].value()
    desturls << dest
    fd_h.puts dest
  end
end


stateurls = []

desturls.each do |link|
  doc = Nokogiri::HTML(open(link))
  doc.css('div.region_city_listing_dest').each do |link|
    #puts link.content

    details = link.xpath('.//a')[0].attributes()
    #puts details['href'].value()

    dest = domain + details['href'].value()
    stateurls << dest
    fd_h.puts dest
  end
end


