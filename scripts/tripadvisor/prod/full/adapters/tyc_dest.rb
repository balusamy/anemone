require 'nokogiri'

=begin
 This adapter will get all the hotel pages and hotel reviews listing pages.
 Step 1: Country page
    - Start from country pages like http://www.tripadvisor.com/Hotels-g191-United_States-Hotels.html
    - Get the pagination links on this page. (these pages lists cities in that country) self.url_list() does this part.
    - Crawl all the pagination pages

 Step 2: Country pagination pages
    - Get all the city landing page urls (which lists all the hotels) from Step 1 pagination pages. Queue Pattern: ["//div[@class='rolluptopdestlink']/a/@href"].  Ex. Gets urls like www.tripadvisor.com/Hotels-g60713-San_Francisco_California-Hotels.html
    - Crawl these pages

 Step 3: City detail page
   -  Generate pagination urls for city landing page urls.  Done by custom_queue() method. Pattern to pull total number of hotels in city: "//div[@class[contains(.,'paginationfillbtm')]]//div[@class='orphan']//b".  Apply the pattern only for the first page which will not have "-oa"
   -  Ex.  Generates url like - www.tripadvisor.com/Hotels-g60713-oa30-San_Francisco_California-Hotels.html
   -  Crawl these pagination urls too.

 Step 4: City pagination pages
   - Get all the hotel detail page urls from city pagination urls from Step 3. Ex.  www.tripadvisor.com/Hotels-g60713-oa30-San_Francisco_California-Hotels.html
   - Patten: "//div[@class[contains(.,'quality')]]//a[@class='property_title']/@href"

 Step 5: 
=end

class TycDest

  # list of urls to pass to the crawler
  def self.url_list(config)
    country_location_pagination = []
    country_location_pagination << "http://travel.yahoo.com/p-travelguide-191501863-united_states_vacations-i"
    return country_location_pagination
  end

  # write complex extraction rules
  def self.custom_extract(page)
  end

  # queue links from the crawled page based on custom pattern
  def self.custom_queue(page)
  end

  def self.extract_patterns()
    []
  end

  def self.queue_patterns()
    #["//div[@class='rolluptopdestlink']/a/@href", "//div[@class[contains(.,'quality')]]//a[@class='property_title']/@href"]
    ["//div[@class[contains(.,'region_city_listing_dest')]]//a/@href"]
    # 
    # Step 2: Get all the city urls in the country pages. - "//div[@class='rolluptopdestlink']/a/@href"
    # E.g.  http://www.tripadvisor.com/Hotels-g191-United_States-Hotels.html
    # 
    # Step 4: Hotel urls in city pagination pages - "//div[@class[contains(.,'quality')]]//a[@class='property_title']/@href"
    # E.g. www.tripadvisor.com/Hotels-g60713-oa30-San_Francisco_California-Hotels.html
    #
  end

  def self.custom_writer(config, ofd, data)
    ofd.puts data
  end

  def self.destroy(config)
  end

end

# Create a wrapper anemone to test the adapter functions here
#puts TripAdvisorGenDestUrls.url_list





