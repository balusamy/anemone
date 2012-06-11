require 'nokogiri'
require 'open-uri'

#Read the file from disk
#filename = '/data/crawl/ta/data_ta_hotel_and_reviews/www.tripadvisor.com/Hotel_Review-g1006448-d594942-Reviews-Hillside_Bed_and_Breakfast-Halfway_Oregon.html'

filename = '/data/crawl/ta/data_ta_hotel_and_reviews/www.tripadvisor.com/Hotel_Review-g41948-d93976-Reviews-or10-Courtyard_by_Marriott_Boston_Woburn_Burlington-Woburn_Massachusetts.html'
hotel_url = filename.split('-')

#hotel_url = @url.split('-')

body = IO.binread(filename)

doc = Nokogiri::HTML(body)

extracted_info = Hash.new
extracted_info['id'] = hotel_url[2]
extracted_info['reviewid'] = nil
extracted_info['title'] = nil
extracted_info['rating'] = nil
extracted_info['date'] = nil
extracted_info['helpful'] = nil
extracted_info['description'] = nil
extracted_info['reviewer_name'] = nil
extracted_info['reviewer_location'] = nil
extracted_info['reviewer_helpful_votes'] = nil
extracted_info['reviewer_num_reviews'] = nil
extracted_info['reviewer_num_cities'] = nil
extracted_info['reviewer_profile_photo'] = nil

# Extract reviews
doc.css('div#REVIEWS').each do |link|
    link.css('div.reviewSelector').each do |r|
        puts r
        last
    end
end


hotel_export = ''
extracted_info.each do |key, val|
   hotel_export = hotel_export + "<#{key}:#{val}>" 
end

#puts hotel_export




