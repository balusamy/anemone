
#require 'rubygems'  
require 'active_record'  
require 'yaml'  
require 'logger'
require 'configparser'

#ActiveRecord::Base.establish_connection(  
#    :adapter => "mysql2",  
#    :host => "localhost",  
#    :user => "root",
#    :password => "purp1eb0y",
#    :database => "tcatalog"  
#)  


dbconfig = YAML::load_file 'config.yml'
ActiveRecord::Base.establish_connection(dbconfig['production'])
ActiveRecord::Base.logger = Logger.new(STDERR)

#puts dbconfig.to_h
dbconfig.each_key { |key|
    puts key, dbconfig[key]['hotelsdir_rel']

}
  
class Hotel < ActiveRecord::Base  
    self.table_name = 'hotels'
end  

class Hotelreview < ActiveRecord::Base  
    self.table_name = 'hotelreviews'
end  


