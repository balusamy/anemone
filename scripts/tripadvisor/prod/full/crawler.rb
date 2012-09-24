require 'rubygems' 
require 'nokogiri'
require 'json'

$LOAD_PATH << '/home/durai/github/anemone/lib'
require 'anemone'

require 'logger'
require 'ruby-debug'

require 'digest/md5'
require 'mongo'
require 'active_support/inflector'
require 'yaml'

class Crawler
  @log_file = "crawler.log"

  @logger = Logger.new(@log_file)
  @logger.level = Logger::INFO

  @config = nil
  @source = nil
  @adapter_methods = nil
  @@content = []

  #Default values for crawl engine
  @input_urls = nil
  @depth_limit = 0
  @verbose = true
  @crawl_subdomains = false
  @write_location = nil
  @force_download = false
  @num_threads = 8
  @jobid = 1
  @ofd = nil

  def initialize(args = {})
    args.each do |k,v|
      instance_variable_set("@#{k}", v) unless v.nil?
    end
  end

  def crawl_test(url, source, outputfile, ep = [], qp = [], conf = "config_test.yml")

    @config = (YAML::load_file conf)['test']

    @source = source
    @adapter_methods = get_adapter

    if outputfile.nil? 
        @ofd = STDOUT
    else
        @ofd = File.new(outputfile, "w") 
    end

    # cmd line arg takes precedence
    if !ep.nil? 
      @@extract_patterns = ep
    else
      @@extract_patterns = @adapter_methods.extract_patterns
    end
    
    # cmd line arg takes precedence
    if !qp.nil? 
      @@queue_patterns = qp
    else
      @@queue_patterns = @adapter_methods.queue_patterns
    end

    # cmd line arg takes precedence
    if !url.nil? 
      @input_urls = url
    else
      @input_urls = @adapter_methods.url_list(@config)
    end

    @adapter_methods.init(@config)
    create_directories
    crawl_engine
  end

  def get_adapter()
    return nil unless File.exists?("adapters/#{@source}.rb")
    require_relative "./adapters/#{@source}.rb"
    adapter_class = eval(@source.classify)
    return adapter_class
  end

  def setup (source, conf = "config.yml")
    @config = (YAML::load_file conf)['production']

    if (source.nil?) 
      puts "Please specify a source adapter class"
      exit 1
    end

    @source = source
    @adapter_methods = get_adapter
    @input_urls = @adapter_methods.url_list(@config)
    @@extract_patterns = @adapter_methods.extract_patterns
    @@queue_patterns = @adapter_methods.queue_patterns
  end

  # create directories
  def create_directories
    @write_location = @config["datadir"] + "/crawl/"
    @feed_location =  @config["datadir"] + "/feeds/"

    FileUtils.mkdir_p(@write_location) 
    FileUtils.mkdir_p(@feed_location) 
  end

  def self.process_page(page, patterns)
    html_content = []
    patterns.each do |p| 
      node = page.doc.xpath(p)
      node.each do |attr|
        html_content << attr.text.strip
      end
    end
    html_content
  end

  def generate_queue_urls(page)
    Crawler.process_page(page, @@queue_patterns).map { |x| x = page.to_absolute(x) + x } 
  end

  def extract_content(page)
    Crawler.process_page page, @@extract_patterns
  end

  # use this to generate list of urls for extraction. This would store the urls with a tag and tag will be used to query urls for extraction
  # or do we use the anemone -> add_to_link_queue() to store the urls?  Also deq should just set a timestamp on the url.
  def write_urls_db()
  end

  def close_all()
    # call adapter destroy first
    @adapter_methods.destroy(@config)
    @ofd.close
  end

  def run(source)
    setup source
    create_directories
    crawl_engine
    close_all
  end

  def crawl_engine
    Anemone.crawl(@input_urls, :depth_limit => @depth_limit, :verbose => @verbose, :crawl_subdomains => @crawl_subdomains, :write_location => @write_location, :force_download => @force_download, :threads => 8, :jobid => 1) do |anemone|
      anemone.on_every_page do |page|

        @@content = []

        if (!@@queue_patterns.nil?)
          urls = generate_queue_urls(page)
          anemone.add_to_link_queue(urls)
        end

        if (!@@extract_patterns.nil?)
          page_data = extract_content(page)  
          @@content = @@content + page_data
        end

        # custom methods - source adapters
        urls = @adapter_methods.custom_queue(page)
        anemone.add_to_link_queue(urls) if !urls.nil?

        page_data = @adapter_methods.custom_extract(page)  
        @@content = @@content + page_data if !page_data.nil?

        # Call custom_write for every page
        @adapter_methods.custom_writer(@config, @ofd, @@content)

        page.discard_doc! true

      end
    end
  end 
end 


