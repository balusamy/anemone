

url = "http://www.tripadvisor.com/Hotels-g60763-New_York_City_New_York-Hotels.html"

#str = %q(name1="value1" name2='value 2')
#p Hash[ *str.chop.split( /' |" |='|="/ ) ]

parts = url.split(/-/)

puts parts[2]

#=> {"name1"=>"value1", "name2"=>"value 2"}

