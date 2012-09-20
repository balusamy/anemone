require 'nokogiri'

class Test
  # list of urls to pass to the crawler
  def self.url_list(config)
  end

  # write complex extraction rules
  def self.custom_extract(page)
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

  def self.custom_writer(config, data)
    #puts "in custom_writer"
    ofd = STDOUT
    ofd.puts data
    ofd.close
  end
end

# Create a wrapper anemone to test the adapter functions here
#puts Test.url_list





