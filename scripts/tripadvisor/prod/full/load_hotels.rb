
#require 'rubygems'  
require 'active_record'  

ActiveRecord::Base.establish_connection(  
    :adapter => "mysql2",  
    :host => "localhost",  
    :user => "root",
    :password => "purp1eb0y",
    :database => "tcatalog"  
)  
  
class Hotel < ActiveRecord::Base  
    self.table_name = 'hotels'
end  

class Hotelreview < ActiveRecord::Base  
    self.table_name = 'hotelreviews'
end  

Hotel.create!(:sourceid => 'bob', :name => 'test123', :srchotelid => 'd123456', :url => 'http://www.tripadvisor.com')



