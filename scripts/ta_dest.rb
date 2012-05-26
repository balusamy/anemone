#!/usr/bin/env ruby
require 'rubygems'

$LOAD_PATH << '/home/durai/github/anemone/lib'

require 'anemone'

#Anemone.crawl("http://www.yahoo.com", :discard_page_bodies => false, :verboase => true, :depth_limit => 1, :user_agent => "Mozilla/5.0 (compatible; Googlebot/2.1; +http://www.google.com/bot.html)", :large_scale_crawl => true, :accept_cookies => true) do |anemone|

Anemone.crawl("http://www.tripadvisor.com", :skip_query_strings => true, :depth_limit => 3, :user_agent => "Mozilla/5.0 (compatible; Googlebot/2.1; +http://www.google.com/bot.html)", :large_scale_crawl => true, :accept_cookies => true, :verbose => true, :crawl_subdomains => false, :write_location => "ta", :force_download => false, :threads => 6, :jobid => 1, :discard_page_bodies => true, :storage=>Anemone::Storage.MongoDB) do |anemone|
anemone.on_every_page do |page|
#anemone.storage = Anemone::Storage.MongoDB

  #puts "Durai #{page.url}"
  #puts "In uptake-inc #{page.url}" if page.url.to_s.index('uptake-inc')
  #puts page.links

  #only crawl pages that /Hotels-g[num]-[letters_].html
  anemone.focus_crawl do |page|
    links = page.links.delete_if do |link|
      (link.to_s =~ /example/).nil?
    end
  end


end
end
