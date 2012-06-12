
#"./hotels/xaa_hotels_reviews_page_urls.txt",

@files = (
#"./hotels/xab_hotels_reviews_page_urls.txt",
#"./hotels/xac_hotels_reviews_page_urls.txt",
#"./hotels/xad_hotels_reviews_page_urls.txt",
#"./hotels/xae_hotels_reviews_page_urls.txt",
#"./hotels/xaf_hotels_reviews_page_urls.txt",
#"./hotels/xag_hotels_reviews_page_urls.txt",
"./missed_entries"
);

foreach $f (@files) {
    ($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst) = localtime(time);
    print "processing started $f at $day $hour:$min:$sec\n";
    system("ruby crawl_hotel_reviews.rb $f");
    ($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst) = localtime(time);
    print "processing completed $f at $day $hour:$min:$sec\n";
}

print "Processing completed\n"


