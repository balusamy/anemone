#!/usr/bin/perl

use utils;

$crawled_dir = $cfg->{data}{crawled_dir};
$f = $cfg->{data}{hotels_page_urls_uniq};

print_start_msg();

run_program("ruby extract_hotel_detail.rb $f");

print_end_msg();


