require 'nokogiri'

class Test
  @print_count = 0

  # initialize source adapter resources
  def self.init(config)
  end

  # close source adapter resources
  def self.destroy(config)
  end

  # list of urls to pass to the crawler
  def self.url_list(config)
  end

  # write complex extraction rules
  def self.custom_extract(page)
=begin
    inline = page.body
=end
=begin
    data   = inline.grep(/Travel.objects.smartMapPanel/).grep(/lon/)
    if (data.any?) 
      fields = data[0].split(",")[14..15]
      puts "url:#{page.url.to_s}, #{fields[0].gsub!(/"/, '')}, #{fields[1].gsub!(/"/,'')}"
    end
=end
=begin
    data   = inline.grep(/YAHOO.Travel.objects.bookingWidgetprefills/)
    if (data.any?) 
      fields = data[0].split(",")[1..2]
      t0 = fields[0].gsub!(/'/, '').gsub!(/cityName:/, '').strip.downcase
      t0.gsub!(/ /, '-')
      t1 = fields[1].gsub!(/'/, '').strip.downcase
      puts "#{page.url.to_s}	#{t0}-#{t1}"
    end
=end
    #puts "in custom_extract"
  end

  # queue links from the crawled page based on custom pattern
  def self.custom_queue(page)
    #puts "in custom_queue"
  end

  def self.extract_patterns()
    #puts "in extract_patterns"
  end

  def self.queue_patterns()
  end

  # ofd - output file descriptor
  def self.custom_writer(config, ofd, data)
    ofd.puts data
    @print_count += 1
    ofd.flush if (@print_count % 10) 
  end

end

# Create a wrapper anemone to test the adapter functions here
#puts Test.url_list


