#!/usr/bin/perl

use utils;

$location = $cfg->{data}{hotels_dir};

$city_urls_file = $location . "/" . $cfg->{data}{city_urls_hotels_list_page_one};
$outfile = $location . "/" . $cfg->{data}{city_urls_all_hotels_pages};
$write_loc = $cfg->{data}{crawled_dir};

print_start_msg();

foreach $f (@files) {
    run_program("ruby ta_hotels_by_city_urls.rb $write_loc $city_urls_file $outfile");
}

print_end_msg();


