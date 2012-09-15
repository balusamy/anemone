
# Full crawl of tripadvisor
echo "Starting ta_dest.pl"
perl ta_dest.pl
echo "Completed ta_dest.pl"

echo "Starting ta_hotels_by_city_urls.pl"
perl ta_hotels_by_city_urls.pl
echo "Completed ta_hotels_by_city_urls.pl"

echo "Starting city_hotels_listing_page.pl"
perl city_hotels_listing_page.pl
echo "Completed city_hotels_listing_page.pl"

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

