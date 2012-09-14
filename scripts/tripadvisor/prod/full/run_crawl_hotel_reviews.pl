#!/usr/bin/perl

use utils;

#"./hotels/xaa_hotels_reviews_page_urls.txt",
#$location = "/data/crawl/ta/hotels";
#@files = (
#"$location/xaa_hotels_reviews_page_urls.txt",
#"$location/xab_hotels_reviews_page_urls.txt",
#"$location/xac_hotels_reviews_page_urls.txt",
#"$location/xad_hotels_reviews_page_urls.txt",
#"$location/xae_hotels_reviews_page_urls.txt",
#"$location/xaf_hotels_reviews_page_urls.txt",
#"$location/xag_hotels_reviews_page_urls.txt"
#);

$location = $cfg->{data}{hotels_dir};
$write_loc = $cfg->{data}{crawled_dir};

$pattern = $cfg->{data}{hotels_reviews_urls};
@files = <$pattern*>;


print_start_msg();

foreach $f (@files) {
    run_program("ruby crawl_hotel_reviews.rb $f $write_loc");
}

print_end_msg();



