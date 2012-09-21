require 'nokogiri'

#
# This adapter will get all the hotel pages and hotel reviews listing pages.
# Step 1: Country page
#    - Start from country pages like http://www.tripadvisor.com/Hotels-g191-United_States-Hotels.html
#    - Get the pagination links on this page. (these pages lists cities in that country) self.url_list() does this part.
#    - Crawl all the pagination pages
#
# Step 2: Country pagination pages
#    - Get all the city landing page urls (which lists all the hotels) from Step 1 pagination pages. Queue Pattern: ["//div[@class='rolluptopdestlink']/a/@href"].  Ex. Gets urls like www.tripadvisor.com/Hotels-g60713-San_Francisco_California-Hotels.html
#    - Crawl these pages
#
# Step 3: City detail page
#   -  Generate pagination urls for city landing page urls.  Done by custom_queue() method. Pattern to pull total number of hotels in city: "//div[@class[contains(.,'paginationfillbtm')]]//div[@class='orphan']//b".  Apply the pattern only for the first page which will not have "-oa"
#   -  Ex.  Generates url like - www.tripadvisor.com/Hotels-g60713-oa30-San_Francisco_California-Hotels.html
#   -  Crawl these pagination urls too.
#
# Step 4: City pagination pages
#   - Get all the hotel detail page urls from city pagination urls from Step 3. Ex.  www.tripadvisor.com/Hotels-g60713-oa30-San_Francisco_California-Hotels.html
#   - Patten: "//div[@class[contains(.,'quality')]]//a[@class='property_title']/@href"
#
# Step 5: 
#

class TripAdvisorGenDestUrl

  # list of urls to pass to the crawler
  def self.url_list(config)

    country_list = Hash.new

    # All europe locations are pulled from - http://www.tripadvisor.com/AllLocations-g4-Places-Europe.html
    country_list["http://www.tripadvisor.com/Hotels-g191-United_States-Hotels.html"] = 35
=begin
    country_list["http://www.tripadvisor.com/Hotels-g191-United_States-Hotels.html"] = 8609
    country_list["http://www.tripadvisor.com/Hotels-g188553-The_Netherlands-Hotels.html"] = 502
    country_list["http://www.tripadvisor.com/Hotels-g186216-United_Kingdom-Hotels.html"] = 2355
    country_list["http://www.tripadvisor.com/Hotels-g188045-Switzerland-Hotels.html"] = 578
    country_list["http://www.tripadvisor.com/Hotels-g189806-Sweden-Hotels.html"] = 271
    country_list["http://www.tripadvisor.com/Hotels-g187427-Spain-Hotels.html"] = 1804
    country_list["http://www.tripadvisor.com/Hotels-g274723-Poland-Hotels.html"] = 410
    country_list["http://www.tripadvisor.com/Hotels-g190455-Norway-Hotels.html"] = 208
    country_list["http://www.tripadvisor.com/Hotels-g190340-Luxembourg-Hotels.html"] = 44
    country_list["http://www.tripadvisor.com/Hotels-g190405-Monaco-Hotels.html"] = 3
    country_list["http://www.tripadvisor.com/Hotels-g189398-Greece-Hotels.html"] = 696
    country_list["http://www.tripadvisor.com/Hotels-g274881-Hungary-Hotels.html"] = 139
    country_list["http://www.tripadvisor.com/Hotels-g186591-Ireland-Hotels.html"] = 335
    country_list["http://www.tripadvisor.com/Hotels-g187768-Italy-Hotels.html"] = 3022
    country_list["http://www.tripadvisor.com/Hotels-g190410-Austria-Hotels.html"] = 680
    country_list["http://www.tripadvisor.com/Hotels-g188634-Belgium-Hotels.html"] = 272
    country_list["http://www.tripadvisor.com/Hotels-g189512-Denmark-Hotels.html"] = 205
    country_list["http://www.tripadvisor.com/Hotels-g187070-France-Hotels.html"] = 3928
    country_list["http://www.tripadvisor.com/Hotels-g189896-Finland-Hotels.html"] = 131
    country_list["http://www.tripadvisor.com/Hotels-g187275-Germany-Hotels.html"] = 3678
    country_list["http://www.tripadvisor.com/Hotels-g293969-Turkey-Hotels.html"] = 279
    country_list["http://www.tripadvisor.com/Hotels-g294459-Russia-Hotels.html"] = 271
=end

    country_location_pagination = []

    incr_per_page = 20

    country_list.each do |k, v|
      u = k.split(/-/)
      page_start_count = 0;

      while ((page_start_count + incr_per_page) <= v)  do
        page_start_count += incr_per_page
        country_location_pagination << "#{u[0]}-#{u[1]}-oa#{page_start_count.to_s}-#{u[2]}-#{u[3]}";
      end

    end
    return country_location_pagination
  end

  # write complex extraction rules
  def self.custom_extract(page)
  end

  # queue links from the crawled page based on custom pattern
  def self.custom_queue(page)

    url_links = []
    
    if (page.url.to_s.match('-oa').nil?) 
      # Step 3. Apply only for first page of city detail page like www.tripadvisor.com/Hotels-g60713-San_Francisco_California-Hotels.html
      if (page.url.to_s.match('/Hotel-'))
        total_hotels = Crawler.process_page(page, "//div[@class[contains(.,'paginationfillbtm')]]//div[@class='orphan']//b")[0].to_i

        page_start_count = 0;
        incr_per_page = 30
        u = page.url.to_s.split(/-/)

        while ((page_start_count + incr_per_page) <= total_hotels)  do
          page_start_count += incr_per_page
          url_links << "#{u[0]}-#{u[1]}-oa#{page_start_count.to_s}-#{u[2]}-#{u[3]}";
        end
      end
    end

    if (page.url.to_s.match('-or').nil?) 
      # Step 5. Apply only for first page of hotel detail page like 
      # ... http://www.tripadvisor.com/Hotel_Review-g60950-d112501-Reviews-Miraval_Arizona_Resort_Spa-Tucson_Arizona.html
      if (page.url.to_s.match('/Hotel_Review-'))
        total_reviews = Crawler.process_page(page, "//span[@class='pgCount']/text()")[1].to_i

        page_start_count = 0;
        incr_per_page = 10
        u = page.url.to_s.split(/-/)

        while ((page_start_count + incr_per_page) <= total_reviews)  do
          page_start_count += incr_per_page
          url_links << "#{u[0]}-#{u[1]}-#{u[2]}-#{u[3]}-or#{page_start_count.to_s}-#{u[4]}-#{u[5]}";
        end
      end
    end

    return url_links

  end

  def self.extract_patterns()
    []
  end

  def self.queue_patterns()
    ["//div[@class='rolluptopdestlink']/a/@href", "//div[@class[contains(.,'quality')]]//a[@class='property_title']/@href"]
    # 
    # Step 2: Get all the city urls in the country pages. - "//div[@class='rolluptopdestlink']/a/@href"
    # E.g.  http://www.tripadvisor.com/Hotels-g191-United_States-Hotels.html
    # 
    # Step 4: Hotel urls in city pagination pages - "//div[@class[contains(.,'quality')]]//a[@class='property_title']/@href"
    # E.g. www.tripadvisor.com/Hotels-g60713-oa30-San_Francisco_California-Hotels.html
    #
  end

  def self.custom_writer(config, data)
    ofd = File.new("/tmp/outfile.txt", "w")
    ofd.puts data
    ofd.close
  end

end

# Create a wrapper anemone to test the adapter functions here
#puts TripAdvisorGenDestUrls.url_list





