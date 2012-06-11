
$f = "hotels_page_uniq.txt";
($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst) = localtime(time);
print "processing started $f at $day $hour:$min:$sec\n";
system("ruby extract_hotel_detail.rb $f");
($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst) = localtime(time);
print "processing completed $f at $day $hour:$min:$sec\n";

