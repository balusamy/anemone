#!/usr/bin/perl

use utils;

$location = $cfg->{data}{hotels_dir};

print "$location-durai\n";

$city_urls_file = $location . "/" . $cfg->{data}{city_urls_hotels_list_page_one};
$write_loc = $cfg->{data}{crawled_dir};

print_start_msg();

#foreach $f (@files) {
    run_program ("ruby ta_dest.rb $write_loc $city_urls_file");
#}

print_end_msg();


