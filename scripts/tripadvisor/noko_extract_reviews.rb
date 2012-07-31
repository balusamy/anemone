require 'nokogiri'
require 'open-uri'

def field_clean_up(node)
    tmp = node.text.gsub("More", '').strip
    tmp = tmp.gsub("\n", ' ')
    return tmp
end

#Read the file from disk
#filename = '/data/crawl/ta/data_ta_hotel_and_reviews/www.tripadvisor.com/Hotel_Review-g1509268-d212126-Reviews-Comfort_Inn_Near_Vail_Beaver_Creek-Avon_Beaver_Creek_Colorado.html'
#http://www.tripadvisor.com/Hotel_Review-g1509268-d212126-Reviews-Comfort_Inn_Near_Vail_Beaver_Creek-Avon_Beaver_Creek_Colorado.html

filename = '/data/crawl/ta/data_ta_hotel_and_reviews/www.tripadvisor.com/Hotel_Review-g29668-d1930984-Reviews-or10-Augusta_Wine_Country_Inn-Augusta_Missouri.html'
#http://www.tripadvisor.com/Hotel_Review-g29668-d1930984-Reviews-or10-Augusta_Wine_Country_Inn-Augusta_Missouri.html
filename = '/data/crawl/ta/data_ta_hotel_and_reviews/www.tripadvisor.com/Hotel_Review-g1007318-d1469045-Reviews-Hawaii_Island_Retreat_at_Ahu_Pohaku_Ho_omaluhia-Kapaau_Island_of_Hawaii_Hawaii.html'

hotel_url = filename.split('-')

#url = 'http://www.tripadvisor.com/Hotel_Review-g60872-d111582-Reviews-Four_Seasons_Resort_Hualalai_at_Historic_Ka_upulehu-Kailua_Kona_Island_of_Hawaii_Hawaii.html'
url = 'http://www.tripadvisor.com/Hotel_Review-g32859-d79221-Reviews-The_Langham_Huntington_Pasadena_Los_Angeles-Pasadena_California.html'
hotel_url = url.split('-')

body = IO.read(filename)

#doc = Nokogiri::HTML(body)
doc = Nokogiri::HTML(open(url))

# Extract reviews
doc.css('div#REVIEWS>div.reviewSelector').each do |link|
    extracted_info = Hash.new
    extracted_info['hotelid'] = hotel_url[2]
    extracted_info['reviewid'] = nil
    extracted_info['title'] = nil
    extracted_info['rating'] = nil
    extracted_info['date'] = nil
    extracted_info['viamobile'] = nil # rated via mobile
    extracted_info['helpful'] = nil
    extracted_info['description'] = nil
    extracted_info['reviewer_name'] = nil
    #extracted_info['reviewer_id'] = nil
    extracted_info['reviewer_title'] = nil
    extracted_info['reviewer_location'] = nil
    extracted_info['reviewer_helpful_votes'] = nil
    extracted_info['reviewer_num_reviews'] = nil
    extracted_info['reviewer_num_cities'] = nil
    extracted_info['reviewer_profile_id'] = nil # anonymous ta member doesnt have div.memberOverlayLink.  So capture mbrName_D39698195C8ECF57D1F016D23227A6DE
    extracted_info['mgrreply'] = nil
    extracted_info['mgrdate'] = nil
    extracted_info['mgrheader'] = nil

    # Review id
    extracted_info['reviewid'] =  link['id']

    # Reviewer information
    extracted_info['reviewer_name'] = link.css('div.username').text.strip.gsub("\n", ' ')
    # Reviewer name is written as "john \n Posted by a Hotel Traveler".  In this case, we will strip the Posted by a Hotel Traveler.
    if (!extracted_info['reviewer_name'].nil? && extracted_info['reviewer_name'].match("Posted") && !(extracted_info['reviewer_name'] =~ /^Posted/))
        extracted_info['reviewer_name'] = extracted_info['reviewer_name'].split('Posted')[0].strip
    end

    cl = link.css('div.username>span')
    if (cl[0] && !cl[0]['class'].nil?)
        cl[0]['class'].split(" ").each do |n|
            if (n.match("mbrName_")) 
                extracted_info['reviewer_profile_id'] = n.split("_")[1]
            end
        end
    end

    #This is not necessary.  reviewer_profile_id has this info
    #if ((!link.css('div.memberOverlayLink').nil?) && !(link.css('div.memberOverlayLink')[0]).nil?)
    #    #puts link.css('div.memberOverlayLink')[0]
    #    extracted_info['reviewer_id'] = link.css('div.memberOverlayLink')[1]
    #end

    extracted_info['reviewer_location'] = link.css('div.location').text.strip
    extracted_info['reviewer_title'] = link.css('div.totalReviewBadge>div.reviewerTitle').text.strip
    extracted_info['reviewer_num_reviews'] = link.css('div.totalReviewBadge>span.badgeText').text.strip
    extracted_info['reviewer_num_cities'] = link.css('div.passportStampsBadge>span.badgeText').text.strip
    extracted_info['reviewer_helpful_votes'] = link.css('div.helpfulVotesBadge>span.badgeText').text.strip

    #Review information
    extracted_info['title'] = link.css('div.quote').text.strip

    extracted_info['description'] = field_clean_up link.css('div>div.entry>p.partial_entry')

    extracted_info['rating'] = link.css('img.sprite-ratings')[0].values[2] # img alt text
    extracted_info['date'] = link.css('span.ratingDate').text.strip
    extracted_info['date'] = extracted_info['date'].gsub("\n", ' ')
    extracted_info['date'] = extracted_info['date'].gsub("NEW", '')
    extracted_info['date'] = extracted_info['date'].strip

    extracted_info['viamobile'] =   link.css('div.reviewItemInline>a.viaMobile').text.strip

    extracted_info['helpful'] = link.css('div.hlpNmbr').text.strip

    extracted_info['mgrdate'] = field_clean_up link.css('div>div.mgrRspnInline>div.header>div.res_date')
    extracted_info['mgrreply'] = field_clean_up link.css('div>div.mgrRspnInline>p.partial_entry')
    extracted_info['mgrdate'] = field_clean_up link.css('div>div.mgrRspnInline>div.header>div.res_date')
    # Since div.res_date is part of div.header, I couldnt figure out a way to just extract manager_header without res_date.  So as a workaround remove the res_date element before extracting text() from div.header.  But also keep in mind that res_date is also required, so extract that before removing res_date.
    link.css('div>div.mgrRspnInline>div.header>div.res_date').remove
    extracted_info['mgrheader'] = field_clean_up link.css('div>div.mgrRspnInline>div.header')

    review_export = ''
    extracted_info.each do |key, val|
        review_export = review_export + "<#{key}:#{val}>" 
    end
    puts review_export
end




