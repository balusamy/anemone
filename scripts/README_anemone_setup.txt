

Before isntalling anything,  set your gemrc like below (make it as 1.9.1 directory as default gem location)

vi ~/.gemrc

---
gem: --no-ri --no-rdoc
gemhome: /var/lib/gems/1.9.1
gempath:
- /var/lib/gems/1.9.1
- /home/durai/.gems
- /usr/lib/ruby/gems/1.9.1
- /var/lib/gems/1.8
:benchmark: false
:update_sources: true
:verbose: false
:backtrace: false
:sources:
- http://gems.rubyforge.org/
- http://rubygems.org/
:bulk_threshold: 1000

=====================================================================

To setup anemone..

sudo gem install robotex
sudo apt-get install ruby1.9.1-dev
sudo apt-get install libxml2 libxml2-dev libxslt1-dev
sudo gem install nokogiri
sudo apt-get install rubygems


(reinstall these again.  For some reason it doesnt work with earlier commands)
sudo gem install robotex
sudo gem install nokogiri
sudo gem install mysql

sudo apt-get install mysql-server

sudo apt-get install ruby-mysql


To setup activerecord:

sudo gem install activerecord activesupport activemodel i18n multi_json builder arel mysql tzinfo sanitize activerecord-mysql-adapter

sudo apt-get install libmysql-ruby libmysqlclient-dev
sudo gem install mysql2
Building native extensions.  This could take a while...
Successfully installed mysql2-0.3.11
1 gem installed




