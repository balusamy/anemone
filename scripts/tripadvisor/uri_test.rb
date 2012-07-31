require 'uri'

#u = URI ("http://www.tripadvisor.com/Hotels-g191-United_States-Hotels.html");

# IO.readlines returns file content in an array
alist = IO.readlines("usa_cities.list")

# IO.read returns file content as a single string
#list = IO.read("usa_cities.list")
#alist = list.split "\n"

puts alist[2]

u = URI(alist[2])

#puts u.host

@urls = []
@urls = alist.map do |u|
  #@urls << URI(u)
  u.is_a?(URI) ? u : URI(u)
  #puts u.is_a?(URI)
end
puts @urls[2].host

#puts alist[3].is_a?(URI)

