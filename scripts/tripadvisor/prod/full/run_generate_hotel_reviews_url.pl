#!/usr/bin/perl

use utils; 

$location = $cfg->{data}{hotels_dir};
$write_loc = $cfg->{data}{crawled_dir};

$pattern = $cfg->{data}{hotels_page_urls_uniq};

@files = <$pattern*>;

#foreach $file (@files) {
#    print $file . "\n";
#} 

#@files = (
#"$location/xaa",
#"$location/xab",
#"$location/xac",
#"$location/xad",
#"$location/xae",
#"$location/xaf",
#"$location/xag"
#);

print_start_msg();

foreach $f (@files) {
    my($pattern, $part) = split /--/, $f;
    $outfile = $cfg->{data}{hotels_reviews_urls} . "--" . $part;
    run_program("ruby generate_hotel_reviews_url.rb $f $outfile $write_loc");
}

print_end_msg();


