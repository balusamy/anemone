
# Get destination urls
#ruby ta_dest.rb

# Get hotels in a city
#ruby ta_hotels_by_city_urls.rb

# Get hotels listing page
#ruby ta_city_hotels_list_page.rb

# get unique hotel urls
#sort hotels_page.txt | uniq > hotels_page_uniq.txt

#mkdir hotels/
#cp hotels_page_uniq.txt hotels/

# split the files to process them without memory issues
cd hotels/; split -l 11000 hotels_page_uniq.txt; cd ../

perl run_generate_hotel_reviews_url.pl

