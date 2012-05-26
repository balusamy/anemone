
@files = (
"./hotels/xac",
"./hotels/xad",
"./hotels/xae",
"./hotels/xaf",
"./hotels/xag",
"./hotels/xah",
"./hotels/xai",
"./hotels/xaj",
"./hotels/xak",
"./hotels/xal",
"./hotels/xam",
"./hotels/xan",
"./hotels/xao",
"./hotels/xap",
"./hotels/xaq",
"./hotels/xar",
);

foreach $f (@files) {
    ($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst) = localtime(time);
    print "processing started $f at $day $hour:$min:$sec\n";
    system("ruby hotels_landing_page.rb $f");
    ($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst) = localtime(time);
    print "processing completed $f at $day $hour:$min:$sec\n";
}

print "Processing completed\n"


