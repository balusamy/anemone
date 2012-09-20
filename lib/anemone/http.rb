require 'net/https'
require 'anemone/page'
require 'anemone/cookie_store'
#require "base64"
require 'digest/md5'
require 'json'
#require 'digest/sha1'
#require 'digest/sha2'

require 'tidy'
Tidy.path = '/usr/lib/libtidy-0.99.so.0.0.0'

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
    def fetch_page(url, referer = nil, depth = nil, dbcon = nil)
      fetch_pages(url, referer, depth, dbcon).last
    end

    def tidy_html(body)
      nice_html = ""
      Tidy.open(:show_warnings=>true) do |tidy|
        tidy.options.output_xhtml = true
        tidy.options.wrap = 0
        tidy.options.indent = 'auto'
        tidy.options.indent_attributes = false
        tidy.options.indent_spaces = 4
        tidy.options.vertical_space = false
        tidy.options.char_encoding = 'utf8'
        nice_html = tidy.clean(body)
      end
      # remove excess newlines
      #nice_html = nice_html.strip.gsub(/\n+/, "\n")
      nice_html.strip.gsub(/\n+/, "\n")
    end

    #
    # Create new Pages from the response of an HTTP request to *url*,
    # including redirects
    #
    def fetch_pages(url, referer = nil, depth = nil, dbcon = nil)
      begin
        url = URI(url) unless url.is_a?(URI)
        pages = []
        get(url, referer, dbcon) do |body, code, location, redirect_to, response_time, headers_hash, disk_cache, content_type, filename, url_id|

          tidy_body = tidy_html(body)

          if (!disk_cache) 

            url_string = location.to_s
            #url_id = Digest::MD5.new << url_string
            #url_id = url_id.to_s

            #hashdirname = "/#{url_id[0..1]}/#{url_id[2..3]}/#{url_id[4..5]}/"

            depth = 1 if (!depth)
            referer = "" if (!referer)
            redirect_to = "" if (!redirect_to)
            jobid = @opts[:jobid] 

            if (code == 200) 
              #err = write_to_disk location, body if (code == 200) 
              err = write_to_disk location, filename, body if (code == 200) 
            else
              err = "FILE NOT WRITTEN"
            end

            #headers_hash_string = Mysql.escape_string(headers_hash.to_s)
            headers_hash_string = Mysql.escape_string(headers_hash.to_json)

            #puts "inserting .. #{url} and id is #{url_id} and code is #{code}"

            rs = dbcon.query("select * from page where urlid = '#{url_id}'")
            num_results = rs.num_rows
            rs.free

            if (num_results == 0)
              rs = dbcon.query("insert into page(urlid,jobid,url,filename,error,type,code,depth,referer,redirect,time, header,first_crawled, last_crawled) values ('#{url_id}',#{jobid},'#{url_string}','#{filename}','#{err}','#{content_type}',#{code},#{depth},'#{referer}','#{redirect_to}',#{response_time},'#{headers_hash_string}', NOW(), NOW())")
            else
              rs = dbcon.query("update page set jobid=#{jobid},url='#{url_string}',filename='#{filename}',error='#{err}',type='#{content_type}',code=#{code},depth=#{depth},referer='#{referer}',redirect='#{redirect_to}',time=#{response_time},header='#{headers_hash_string}', last_crawled=NOW() where urlid='#{url_id}'")
            end

            rs.free if !rs.nil?

            pages << Page.new(location, :body => tidy_body,
                                      :code => code,
                                      :headers => headers_hash,
                                      :referer => referer,
                                      :depth => depth,
                                      :redirect_to => redirect_to,
                                      :response_time => response_time)
          else
            pages << Page.new(location, :body => tidy_body,
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

    def get_filename(host, uri, hashname, create_folder = false)
      folder = host
      filename = uri

      filename = filename + "index.html" if filename.end_with?("/") # Make sure the file name is valid
      folders = filename.split("/")
      filename = folders.pop

      folder_name = File.join(".",folder,folders)
      full_folder_name = @opts[:write_location] + hashname + folder_name if (@opts[:write_location])

      if create_folder && (!File.exists? full_folder_name)
          FileUtils.mkdir_p(full_folder_name) # Create the current subfolder
      end

      #print "Downloading '#{page.url}'..."
      full_filename = File.join(full_folder_name,filename)

      if File.directory? full_filename
          full_filename = full_filename + ".1"
      end

      return full_filename
    end

    def write_to_disk(url, full_filename, body)
      err = nil

      # Create the director if it doesnt exists
      dir_name = File.dirname full_filename
      if (!File.directory? dir_name)
          FileUtils.mkdir_p(dir_name) 
      end

      if ((File.exists? full_filename) && !@opts[:force_download])
        err = "File exists"
      else
        start = Time.now()
        File.open(full_filename, "w") do |file| file.write(body) end

        finish = Time.now()
        file_write_time = ((finish - start) * 1000).round
        puts "file write time #{file_write_time} - #{url}"
      end

      if (!err) 
          puts "written - #{url} at #{full_filename}"
      else 
          puts "err - #{url} at #{full_filename}"
      end
      return err

    end

    def hashdirname(url)
      urlid = Digest::MD5.new << url.to_s
      urlid = urlid.to_s
      hashname = "/#{urlid[0..1]}/#{urlid[2..3]}/#{urlid[4..5]}/"
      yield urlid, hashname
      return 
    end

    #
    # Retrieve HTTP responses for *url*, including redirects.
    # Yields the response object, response code, and URI location
    # for each response.
    #
    def get(url, referer = nil, dbcon = nil)
  
      #puts "before force_download #{@opts[:force_download]}"
      body = ''

      hashname = ''
      url_id = ''
      hashdirname url do |uid, hname|
        url_id = uid
        hashname = hname
      end

      full_filename = get_filename url.host, url.request_uri.to_s, hashname

      if ((File.exists? full_filename) && (!@opts[:force_download]))
        # if it is on the disk, read the content and construct response
        #puts "inside force_download #{url.host}, #{url.request_uri.to_s}, #{full_filename}"

        response_hash = Hash.new

        #url_string = url.to_s
        #url_id = Digest::MD5.new << url_string
       
        rs = dbcon.query("select * from page where urlid = '#{url_id}'")

        rs.each do |row|
          response_hash['content-type'] = row[6]
          response_hash['code'] = row[7].to_i
          response_hash['depth'] = row[8].to_i
          response_hash['referer'] = row[9]
          response_hash['redirect_to'] = row[10]
          response_hash['response_time'] = row[11].to_i
          response_hash['header'] = row[12]
        end

        if (response_hash['code'] == 200) 
          start = Time.now()

          body = IO.read(full_filename)

          finish = Time.now()
          file_read_time = ((finish - start) * 1000).round

          #puts "file read time #{file_read_time} - #{url}"

          #headers_hash = eval response_hash['header']
          headers_hash = JSON.parse(response_hash['header'])
          #headers_hash = response_hash['header']

          yield body, response_hash['code'], url, response_hash['redirect_to'], response_hash['response_time'], headers_hash, true, headers_hash['content-type'], full_filename, url_id
        end # if ((response_hash['depth']...

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
            #puts "URL: #{url}, code: #{code} , redirect:  #{redirect_to}"
            headers = response.to_hash
            yield response.body, code, loc, redirect_to, response_time, headers, false, headers['content-type'], full_filename, url_id
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

