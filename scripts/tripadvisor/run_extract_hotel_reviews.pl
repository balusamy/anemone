
use Parallel::ForkManager;
use File::Basename;

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

$num_processes = $#files + 1;

$pm = new Parallel::ForkManager($num_processes);

foreach $f (@files) {
# Forks and returns the pid for the child:
    my $pid = $pm->start and next;

    $outfile = basename $f;

    ($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst) = localtime(time);
    print "processing started $f at $day $hour:$min:$sec\n";
    system("ruby extract_hotel_reviews.rb $f > /tmp/$outfile.out");
    ($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst) = localtime(time);
    print "processing completed $f at $day $hour:$min:$sec\n";

    $pm->finish; # Terminates the child process
}

$pm->wait_all_children;

print "All processing completed\n"

