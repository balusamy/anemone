
To run a test...

E.g.
ruby crawl_test.rb -u "http://www.yelp.com/topsearches/nyc" -p "//div[@class[contains(.,'column')]]/a" -q "/html/body/div[2]/div[3]/div[2]/div[3]/a/@href" -o /tmp/durai.txt

For production run:
ruby start_crawl.rb -s tripadvisor_full


