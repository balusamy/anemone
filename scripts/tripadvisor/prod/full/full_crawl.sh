
# Full crawl of tripadvisor

echo "Creating directories"
#mkdir -p /data/crawl/ta/hotels
#mkdir -p /data/crawl/ta/data_ta
#mkdir -p /data/crawl/ta/data_ta_hotel_and_reviews
#mkdir -p /data/crawl/ta/reviews_feed

echo "Starting ta_dest.pl"
perl ta_dest.pl
echo "Completed ta_dest.pl"

echo "Starting ta_hotels_by_city_urls.pl"
ruby ta_hotels_by_city_urls.pl
echo "Completed ta_hotels_by_city_urls.pl"

echo "Starting city_hotels_listing_page.pl"
perl city_hotels_listing_page.pl
echo "Completed city_hotels_listing_page.pl"

#echo "Sorting /data/crawl/ta/hotels_page.txt"
#sort /data/crawl/ta/hotels_page.txt | uniq > /data/crawl/ta/hotels/hotels_page_uniq.txt

#echo "Split hotels_page_uniq.txt"
#(cd /data/crawl/ta/hotels/; echo "spliting"; split -l 11000 hotels_page_uniq.txt)

echo "Starting run_generate_hotel_reviews_url.pl"
perl run_generate_hotel_reviews_url.pl
echo "Completed run_generate_hotel_reviews_url.pl"

echo "Starting run_crawl_hotel_reviews.pl"
perl run_crawl_hotel_reviews.pl
echo "Completed run_crawl_hotel_reviews.pl"

echo "Starting run_extract_hotel_detail.pl"
perl run_extract_hotel_detail.pl
echo "Completed run_extract_hotel_detail.pl"

echo "Starting run_extract_hotel_reviews.pl"
perl run_extract_hotel_reviews.pl
echo "Completed run_extract_hotel_reviews.pl"

