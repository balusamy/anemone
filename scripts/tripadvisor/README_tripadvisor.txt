
To crawl tripadvisor:

* Start from united states page (http://www.tripadvisor.com/Hotels-g191-United_States-Hotels.html), generate the pagination URLs, extract city urls from pagination URLs and write it to hotels_by_city_urls.txt (e.g. http://www.tripadvisor.com/Hotels-g60763-New_York_City_New_York-Hotels.html)
    * Run ta_dest.rb and it write the city urls to the file hotels_by_city_urls.txt

* Crawl hotels_by_city_urls.txt and download the content (http://www.tripadvisor.com/Hotels-g60763-New_York_City_New_York-Hotels.html).  Also generate the pagination urls for each city.  Write the city pagination urls to the file "all_hotels_in_a_city.txt"
    * Run ta_hotels_by_city_urls.rb
    * Content of all_hotels_in_a_city.txt -> http://www.tripadvisor.com/Hotels-g32655-Los_Angeles_California-Hotels.html, http://www.tripadvisor.com/Hotels-g32655-oa30-Los_Angeles_California-Hotels.html etc.
    * Number of entries in all_hotels_in_a_city.txt: 16849

* Crawl all city pagination urls (all_hotels_in_a_city.txt) and extract list of hotel names.  Write the list of hotel names to the file hotels_page.txt.
    * Run ta_city_hotels_list_page.rb
    * Some of the hotel listings (in a city) page contains recommended nearby hotels and the recommended hotels are duplicates.  This happens on a small cities in a metro for instance, culver city page in Los Angeles.
    * Number of entries in hotels_page.txt: 356972 

    * Run sort hotels_page.txt | uniq > hotels_page_uniq.txt
    * Number of unique entries in hotels_page.txt: 70960

* Running ruby/anemone with large number of urls causes memory leak and slows the program.  In order to overcome this issue, split the large files and run them iteratively.

* copy hotels_page_uniq.txt to hotels/hotels_page_uniq.txt
* split hotels_page_uniq.txt into multiple chunks
    * cd hotels/; split -l 11000 hotels_page_uniq.txt

* Crawl hotel landing page and generate the reviews pagination urls. 
    * perl run_generate_hotel_reviews_url.pl
    * This also stores the hotels and reviews contents in a separate directory.
    * Write the reviews pagination urls into xaa_hotels_reviews_page_urls.txt etc.

* Crawl reviews from hotel landing page pagination urls.
    * perl run_extract_hotel_reviews.pl
    * download the content and store them


Now Extract hotel information and reviews from downloaded content.






