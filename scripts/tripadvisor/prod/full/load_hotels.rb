
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
end  

class Hotelreview < ActiveRecord::Base  
end  

Hotel.create(:sourceid => 'bob', :name => 'test123')



