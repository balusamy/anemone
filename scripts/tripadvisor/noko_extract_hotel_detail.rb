require 'nokogiri'
require 'open-uri'

#Read the file from disk
#filename = '/data/crawl/ta/data_ta_hotel_and_reviews/www.tripadvisor.com/Hotel_Review-g1006448-d594942-Reviews-Hillside_Bed_and_Breakfast-Halfway_Oregon.html'

filename = '/data/crawl/ta/data_ta_hotel_and_reviews/www.tripadvisor.com/Hotel_Review-g41948-d93976-Reviews-or10-Courtyard_by_Marriott_Boston_Woburn_Burlington-Woburn_Massachusetts.html'
hotel_url = filename.split('-')

#hotel_url = @url.split('-')

body = IO.read(filename)

doc = Nokogiri::HTML(body)

extracted_info = Hash.new
extracted_info['id'] = hotel_url[2]
extracted_info['url'] = filename
extracted_info['name'] = nil
extracted_info['crumb_str'] = nil
extracted_info['rank'] = nil
extracted_info['overall_rating'] = nil
extracted_info['num_reviews'] = nil
extracted_info['images'] = nil
extracted_info['ug_images'] = nil
extracted_info['street'] = nil
extracted_info['locality'] = nil
extracted_info['region'] = nil
extracted_info['postal_code'] = nil
extracted_info['phone_num'] = nil

# Get the breadcrumb
doc.css('div.crumbs>ul').each do |link|
  link.xpath('.//a').each do |c|
      if (extracted_info['crumb_str'].nil?) 
          extracted_info['crumb_str'] = c.text + "=>" + c['href'] 
      else
          extracted_info['crumb_str'] = extracted_info['crumb_str'] + "$" + c.text + "=>" + c['href'] 
      end
  end
end

# Get the title and address
doc.css('div#HEADING_GROUP').each do |link|
    extracted_info['name'] = link.xpath('.//h1').text().strip

    link.css('div.infoBox>div.blDetails>div.fl>div.fl>script').each do |c|
        #TA puts phone number escrambled in javascript.
        js_text = c.text().strip

        a = ''
        b = ''
        c = ''
        js_text.split("\n").each do |line|
            if (line.match(/=/))
                parts = line.split(/=/)
                if parts[0] == "a"
                    a = parts[1]
                elsif parts[0] == "a+"
                    a = a + parts[1]
                elsif parts[0] == "b"
                    b = parts[1]
                elsif parts[0] == "b+"
                    b = b + parts[1]
                elsif parts[0] == "c"
                    c = parts[1]
                end
            end
        end
        phone_num_text = a.to_s + c.to_s + b.to_s
        extracted_info['phone_num'] = phone_num_text.gsub(/'/, '')
    end

    link.css('div.infoBox>address>span>span>span').each do |c|
        if (c['class'] == 'street-address')
            extracted_info['street'] = c.text
        end 

        if (c['class'] == 'locality')
            c.xpath('.//span').each do |l|
                if (l['property'] == 'v:locality')
                    extracted_info['locality'] = l.text
                end
                if (l['property'] == 'v:region')
                    extracted_info['region'] = l.text
                end
                if (l['property'] == 'v:postal-code')
                    extracted_info['postal_code'] = l.text
                end
            end
        end 
    end
end

# Get the thumbnail
doc.css('div.gridA>div.balance>div.integrated_cr_display_2>div.full_wrap>div.col1of2').each do |link|

    link.css('div.sizedThumb>span>img').each do |c|
        if (extracted_info['images'].nil?) 
            extracted_info['images'] = c['src']
        else
            extracted_info['images'] = extracted_info['images'] + "$" + c['src']
        end
    end
    link.css('ul.ug_thumbs>li.ug_thumb>a>img').each do |c|
        if (extracted_info['ug_images'].nil?) 
            extracted_info['ug_images'] = c['src']
        else
            extracted_info['ug_images'] = extracted_info['ug_images'] + "$" + c['src']
        end
    end

end

# Get the rank, overall rating, num_reviews
doc.css('div.gridA>div.balance>div.integrated_cr_display_2>div.full_wrap>div.col2of2').each do |link|
    link.css('div.slim_ranking>b').each do |c|
        extracted_info['rank'] = c.text().strip
    end

    link.css('div.rating>span.rate>img.sprite-ratings').each do |c|
        extracted_info['overall_rating'] = c['alt']
    end

    link.css('div.rating>span.more>span').each do |c|
        extracted_info['num_reviews'] = c.text()
    end
end


hotel_export = ''
extracted_info.each do |key, val|
   hotel_export = hotel_export + "<#{key}:#{val}>" 
end

puts hotel_export

end




