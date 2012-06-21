
$location = "/data/crawl/ta/hotels";

@files = (
"$location/xaa_hotels_reviews_page_urls.txt",
"$location/xab_hotels_reviews_page_urls.txt",
"$location/xac_hotels_reviews_page_urls.txt",
"$location/xad_hotels_reviews_page_urls.txt",
"$location/xae_hotels_reviews_page_urls.txt",
"$location/xaf_hotels_reviews_page_urls.txt",
"$location/xag_hotels_reviews_page_urls.txt"
);

foreach $f (@files) {
    ($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst) = localtime(time);
    print "processing started $f at $day $hour:$min:$sec\n";
    system("ruby extract_hotel_reviews.rb $f");
    ($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst) = localtime(time);
    print "processing completed $f at $day $hour:$min:$sec\n";
}

print "Processing completed\n"


