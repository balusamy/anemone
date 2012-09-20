require 'nokogiri'

class TripAdvisorGenDestUrl

  # list of urls to pass to the crawler
  def self.url_list(config)

    country_list = Hash.new

    # All europe locations are pulled from - http://www.tripadvisor.com/AllLocations-g4-Places-Europe.html
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
  end

  def self.extract_patterns()
    []
  end

  def self.queue_patterns()
    ["//div[@class='rolluptopdestlink']/a/@href"]
  end

  def self.custom_writer(config, data)
    ofd = File.new("/tmp/outfile.txt", "w")
    ofd.puts data
    ofd.close
  end

end

# Create a wrapper anemone to test the adapter functions here
#puts TripAdvisorGenDestUrls.url_list





