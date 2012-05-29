
@files = (
"./hotels/xaa",
"./hotels/xab",
"./hotels/xac",
"./hotels/xad",
"./hotels/xae",
"./hotels/xaf",
"./hotels/xag",
);

foreach $f (@files) {
    ($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst) = localtime(time);
    print "processing started $f at $day $hour:$min:$sec\n";
    system("ruby generate_hotel_reviews_url.rb $f");
    ($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst) = localtime(time);
    print "processing completed $f at $day $hour:$min:$sec\n";
}

print "Processing completed\n"


