

$location = "/data/crawl/ta/hotels";

@files = (
"$location/xaa",
"$location/xab",
"$location/xac",
"$location/xad",
"$location/xae",
"$location/xaf",
"$location/xag"
);

foreach $f (@files) {
    ($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst) = localtime(time);
    print "processing started $f at $day $hour:$min:$sec\n";
    system("ruby generate_hotel_reviews_url.rb $f");
    ($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst) = localtime(time);
    print "processing completed $f at $day $hour:$min:$sec\n";
}

print "Processing completed\n"


