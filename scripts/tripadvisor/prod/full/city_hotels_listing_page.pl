#!/usr/bin/perl

use utils;

$location = $cfg->{data}{hotels_dir};

$write_loc = $cfg->{data}{crawled_dir};
$infile = $location . "/" . $cfg->{data}{city_urls_hotels_list_page_one};
$outfile = $location . "/" . $cfg->{data}{hotels_page_urls};

print_start_msg();

foreach $f (@files) {
    run_program ("ruby city_hotels_listing_page.rb $infile $outfile $write_loc");
}

print_end_msg();

# Sort and uniq the content of the hotel urls file
$uniq_file = $location . "/" .  $cfg->{data}{hotels_page_urls_uniq};

print_start_msg ("sorting uniq input $outfile");
sort_uniq_file ($outfile, $uniq_file);
print_end_msg ("sorting uniq output $uniq_file");


# split the file for parallel processing
print_start_msg ("spliting $uniq_file");
splitfile($uniq_file, $uniq_file, $cfg->{jobconfig}{filesize});
print_end_msg ("spliting $uniq_file");

