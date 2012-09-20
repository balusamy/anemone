require 'choice'
require 'crawler'

Choice.options do
  option :url, :required => true do
    short "-u"
    long "--url=site_url"
    desc "(REQUIRED) The url of the site to crawl"
  end

  option :extract_pattern, :required => true do
    short "-p"
    long "--extract_pattern"
    desc "(REQUIRED) xpath pattern"
  end

  option :queue_pattern, :required => false do
    short "-q"
    long "--queue_pattern"
    desc "Queue links/urls using xpath pattern"
  end

  option :source, :required => false do
    short "-s"
    long "--source"
    desc "Source adapter. Default: test"
    default "test"
  end

end

u = Choice.choices[:url]
if u && u.to_s != ""
  puts "Testing url:#{u}"
else
  puts "Enter a url"
  exit
end

p = Choice.choices[:extract_pattern]
if p && p.to_s != ""
  puts "Extracting pattern:#{p}"
else
  puts "Specify a pattern"
  exit
end

s = Choice.choices[:source] 
q = Choice.choices[:queue_pattern]

engine = Crawler.new()
engine.crawl_test(u, s, p, q)


