require 'nokogiri'
require 'open-uri'

location = "/data/crawl/ta/data_ta_hotel_and_reviews"

file = ARGV[0]

file = "./hotels/xaa_hotels_reviews_page_urls.txt" if file.nil?

prefix = file.split("/")[2].split("_")[0]

puts prefix

hotels = IO.binread(file)

feed_location = "/data/crawl/ta/"

outfile = feed_location + prefix + "_ta_reviews_feed.txt"
fd_h = File.new(outfile, "w")

hotels_urls = hotels.split("\n")

hotels_urls.each do |url|

    hotel_url = url.split('-')

    filename = location + "/" + url.gsub("http://", '')

    #Read the file from disk
    #filename = '/data/crawl/ta/data_ta_hotel_and_reviews/www.tripadvisor.com/Hotel_Review-g1006448-d594942-Reviews-Hillside_Bed_and_Breakfast-Halfway_Oregon.html'

    #filename = '/data/crawl/ta/data_ta_hotel_and_reviews/www.tripadvisor.com/Hotel_Review-g41948-d93976-Reviews-or10-Courtyard_by_Marriott_Boston_Woburn_Burlington-Woburn_Massachusetts.html'
    #hotel_url = filename.split('-')

    if (!File.exists?(filename))
        puts "#{filename} not found"
        next
    end

    body = IO.binread(filename)
    doc = Nokogiri::HTML(body)

    # Extract reviews
    doc.css('div#REVIEWS>div.reviewSelector').each do |link|

        extracted_info = Hash.new
        extracted_info['hotelid'] = hotel_url[2]
        extracted_info['reviewid'] = nil
        extracted_info['title'] = nil
        extracted_info['rating'] = nil
        extracted_info['date'] = nil
        extracted_info['helpful'] = nil
        extracted_info['description'] = nil
        extracted_info['reviewer_name'] = nil
        extracted_info['reviewer_id'] = nil
        extracted_info['reviewer_title'] = nil
        extracted_info['reviewer_location'] = nil
        extracted_info['reviewer_helpful_votes'] = nil
        extracted_info['reviewer_num_reviews'] = nil
        extracted_info['reviewer_num_cities'] = nil
        extracted_info['reviewer_profile_id'] = nil # anonymous ta member doesnt have div.memberOverlayLink.  So capture mbrName_D39698195C8ECF57D1F016D23227A6DE

        # Review id
        extracted_info['reviewid'] =  link['id']

        # Reviewer information
        extracted_info['reviewer_name'] = link.css('div.username').text.strip
        cl = link.css('div.username>span')
        if (cl[0] &&(!cl[0]['class'].nil?))
            cl[0]['class'].split(" ").each do |n|
                if (n.match("mbrName_")) 
                    extracted_info['reviewer_profile_id'] = n.split("_")[1]
                end
            end
        end

        if ((!link.css('div.memberOverlayLink').nil?) && !(link.css('div.memberOverlayLink')[0]).nil?)
            #puts link.css('div.memberOverlayLink')[0]
            extracted_info['reviewer_id'] = link.css('div.memberOverlayLink')[0].values[0]
        end

        extracted_info['reviewer_location'] = link.css('div.location').text.strip
        extracted_info['reviewer_title'] = link.css('div.totalReviewBadge>div.reviewerTitle').text.strip
        extracted_info['reviewer_num_reviews'] = link.css('div.totalReviewBadge>span.badgeText').text.strip
        extracted_info['reviewer_num_cities'] = link.css('div.passportStampsBadge>span.badgeText').text.strip
        extracted_info['reviewer_helpful_votes'] = link.css('div.helpfulVotesBadge>span.badgeText').text.strip

        #Review information
        extracted_info['title'] = link.css('div.quote').text.strip
        extracted_info['description'] = link.css('div.partial_entry').text.strip
        extracted_info['rating'] = link.css('img.sprite-ratings')[0].values[2] # img alt text
        extracted_info['date'] = link.css('span.ratingDate').text.strip
        extracted_info['helpful'] = link.css('div.hlpNmbr').text.strip

        review_export = ''
        extracted_info.each do |key, val|
        review_export = review_export + "<#{key}:#{val}>"
        end

        fd_h.puts review_export
    end
end

fd_h.close





