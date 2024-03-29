require 'anemone/http'
require 'mysql'

module Anemone
  class Tentacle

    #
    # Create a new Tentacle
    #
    def initialize(link_queue, page_queue, opts = {})
      @link_queue = link_queue
      @page_queue = page_queue
      @http = Anemone::HTTP.new(opts)
      @opts = opts

      # Create mysql connection per thread
      #@con = Mysql.new('localhost', 'root', 'purp1eb0y', 'crawl')
      @con = Mysql.new('localhost', 'root', 'dv0271', 'crawl')

    end

    #
    # Gets links from @link_queue, and returns the fetched
    # Page objects into @page_queue
    #
    def run
      loop do
        link, referer, depth = @link_queue.deq

        break if link == :END
        @http.fetch_pages(link, referer, depth, @con).each { |page| @page_queue << page }

        delay
      end
      @con.close
    end

    private

    def delay
      sleep @opts[:delay] if @opts[:delay] > 0
    end

  end
end
