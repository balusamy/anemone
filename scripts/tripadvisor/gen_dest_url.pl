

# Generate city urls in united states

$i1 = 0;
$i2 = 20;
$incr = 30;

print "http://www.tripadvisor.com/Hotels-g191-United_States-Hotels.html" . "\n";
print "http://www.tripadvisor.com/Hotels-g191-oa20-United_States-Hotels.html" . "\n";

$tmpl = "http://www.tripadvisor.com/Hotels-g191-";

$dest_count = 20;

while (($dest_count + $incr) <= 8605) {
    $dest_count += $incr;

    print "$tmpl" . "oa" . $dest_count . "-United_States-Hotels.html\n" ;

}





