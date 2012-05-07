require 'net/https'
require 'anemone/page'
require 'anemone/cookie_store'

module Anemone
  class HTTP
    # Maximum number of redirects to follow on each get_response
    REDIRECT_LIMIT = 5

    # CookieStore for this HTTP client
    attr_reader :cookie_store

    def initialize(opts = {})
      @connections = {}
      @opts = opts
      @cookie_store = CookieStore.new(@opts[:cookies])
    end

    #
    # Fetch a single Page from the response of an HTTP request to *url*.
    # Just gets the final destination page.
    #
    def fetch_page(url, referer = nil, depth = nil)
      fetch_pages(url, referer, depth).last
    end

    #
    # Create new Pages from the response of an HTTP request to *url*,
    # including redirects
    #
    def fetch_pages(url, referer = nil, depth = nil)
      begin
        url = URI(url) unless url.is_a?(URI)
        pages = []
        #get(url, referer) do |response, code, location, redirect_to, response_time|
        get(url, referer) do |body, code, location, redirect_to, response_time, headers_hash, disk_cache|

        #headers = response.to_hash

          if (!disk_cache) 
            store_response =<<HTMLCOMMENT
<!--RESPONSE_START-->
<!--res_code:-:#{code}-->
<!--res_referer:-:#{referer}-->
<!--res_depth:-:#{depth}-->
<!--res_redirect_to:-:#{redirect_to}-->
<!--res_response_time:-:#{response_time}-->
<!--res_headers:-:#{headers_hash}-->
<!--RESPONSE_END-->
HTMLCOMMENT
            body = store_response + body if headers_hash['content-type'].index('text/html')
            #pages << Page.new(location, :body => store_response + response.body.dup,
            pages << Page.new(location, :body => store_response + body,
                                      :code => code,
                                      :headers => headers_hash,
                                      :referer => referer,
                                      :depth => depth,
                                      :redirect_to => redirect_to,
                                      :response_time => response_time)
          else
            pages << Page.new(location, :body => body,
                                      :code => code,
                                      :headers => headers_hash,
                                      :referer => referer,
                                      :depth => depth,
                                      :redirect_to => redirect_to,
                                      :response_time => response_time)
          end
        end

        return pages
      rescue Exception => e
        if verbose?
          puts e.inspect
          puts e.backtrace
        end
        return [Page.new(url, :error => e)]
      end
    end

    #
    # The maximum number of redirects to follow
    #
    def redirect_limit
      @opts[:redirect_limit] || REDIRECT_LIMIT
    end

    #
    # The user-agent string which will be sent with each request,
    # or nil if no such option is set
    #
    def user_agent
      @opts[:user_agent]
    end

    #
    # Does this HTTP client accept cookies from the server?
    #
    def accept_cookies?
      @opts[:accept_cookies]
    end

    #
    # The proxy address string
    #
    def proxy_host
      @opts[:proxy_host]
    end

    #
    # The proxy port
    #
    def proxy_port
      @opts[:proxy_port]
    end

    #
    # HTTP read timeout in seconds
    #
    def read_timeout
      @opts[:read_timeout]
    end

    private

    def get_filename_dup(host, uri, create_folder = false)
      folder = host
      filename = uri

      filename = filename + "index.html" if filename.end_with?("/") # Make sure the file name is valid
      folders = filename.split("/")
      filename = folders.pop

      folder_name = File.join(".",folder,folders)
      full_folder_name = @opts[:write_location] + "/" + folder_name if (@opts[:write_location])

      if create_folder && (!File.exists? full_folder_name)
          FileUtils.mkdir_p(full_folder_name) # Create the current subfolder
      end

      #print "Downloading '#{page.url}'..."
      full_filename = File.join(".",full_folder_name,filename)

      if File.directory? full_filename
          full_filename = full_filename + ".1"
      end

      return full_filename
    end

    #
    # Retrieve HTTP responses for *url*, including redirects.
    # Yields the response object, response code, and URI location
    # for each response.
    #
    def get(url, referer = nil)
  
      #puts "before force_download #{@opts[:force_download]}"
      body = ''
      if (!@opts[:force_download]) 
        # if it is on the disk, read the content and construct response
        full_filename = get_filename_dup url.host, url.request_uri.to_s    
        #puts "inside force_download #{url.host}, #{url.request_uri.to_s}, #{full_filename}"

        response_hash = Hash.new

        if File.exists? full_filename 
          File.open(full_filename,"r") do |f|
            response_read = false;
            f.each do |line|
              if (!response_read) 

                next if line.index('RESPONSE_START')

                if line.index('RESPONSE_END') 
                  response_read = true 
                  next
                end
                line = line.chomp
                line = line.gsub(/<!--res_/, '') 
                line = line.gsub(/-->/, '') 
                name, value = line.split(':-:')
                response_hash[name] = value
              else
                body += line
              end
            end
            f.close
            #begin
            #  f.read(response)
            #  rescue Exception => e
            #  puts "An error has occured while processing #{page.url}:"
            #  puts e.message
            #end
          end
          #puts "read - #{url} at #{full_filename}"

          headers_hash = eval response_hash['headers']

          yield body, response_hash['code'], url, response_hash['redirect_to'], response_hash['response_time'], headers_hash, true 

        end 

      else
      limit = redirect_limit
      loc = url
      begin
          # if redirected to a relative url, merge it with the host of the original
          # request url
          loc = url.merge(loc) if loc.relative?

          response, response_time = get_response(loc, referer)
          code = Integer(response.code)
          redirect_to = response.is_a?(Net::HTTPRedirection) ? URI(response['location']).normalize : nil
          headers = response.to_hash
          yield response.body, code, loc, redirect_to, response_time, headers, false
          limit -= 1
      end while (loc = redirect_to) && allowed?(redirect_to, url) && limit > 0
      end
    end

    #
    # Get an HTTPResponse for *url*, sending the appropriate User-Agent string
    #
    def get_response(url, referer = nil)
      full_path = url.query.nil? ? url.path : "#{url.path}?#{url.query}"

      opts = {}
      opts['User-Agent'] = user_agent if user_agent
      opts['Referer'] = referer.to_s if referer
      opts['Cookie'] = @cookie_store.to_s unless @cookie_store.empty? || (!accept_cookies? && @opts[:cookies].nil?)

      retries = 0
      begin
        start = Time.now()
        # format request
        req = Net::HTTP::Get.new(full_path, opts)
        # HTTP Basic authentication
        req.basic_auth url.user, url.password if url.user
        response = connection(url).request(req)
        finish = Time.now()
        response_time = ((finish - start) * 1000).round
        @cookie_store.merge!(response['Set-Cookie']) if accept_cookies?
        return response, response_time
      rescue Timeout::Error, Net::HTTPBadResponse, EOFError => e
        puts e.inspect if verbose?
        refresh_connection(url)
        retries += 1
        retry unless retries > 3
      end
    end

    def connection(url)
      @connections[url.host] ||= {}

      if conn = @connections[url.host][url.port]
        return conn
      end

      refresh_connection url
    end

    def refresh_connection(url)
      http = Net::HTTP.new(url.host, url.port, proxy_host, proxy_port)

      http.read_timeout = read_timeout if !!read_timeout

      if url.scheme == 'https'
        http.use_ssl = true
        http.verify_mode = OpenSSL::SSL::VERIFY_NONE
      end

      @connections[url.host][url.port] = http.start 
    end

    def verbose?
      @opts[:verbose]
    end

    #
    # Allowed to connect to the requested url?
    #
    def allowed?(to_url, from_url)
      to_url.host.nil? || (to_url.host == from_url.host)
    end

  end
end
