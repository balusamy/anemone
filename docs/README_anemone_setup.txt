

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


=====================================================================

Install perl modules
sudo apt-get install libconfig-yaml-perl liblist-moreutils-perl

sudo gem install ruby-debug
sudo gem install logger
sudo gem install mongo
sudo gem install json
sudo gem install active_support

sudo gem install bson_ext
sudo gem install tidy
sudo gem install tidy-ext
sudo gem install choice
sudo gem install yaml
sudo gem install mongo

========================
fix tidy ruby source file..
http://stackoverflow.com/questions/3826556/playing-with-scrapi-in-rails-3-getting-segmentation-fault-error-abort-trap

I had this issue and then a follow-up issue where a seg fault would happen non-deterministically.

I followed the steps here - http://rubyforge.org/tracker/index.php?func=detail&aid=10007&group_id=435&atid=1744

In tidy-1.1.2/lib/tidy/tidylib.rb:

1. Add this line to the 'load' method in Tidylib:

  extern "void tidyBufInit(void*)"
2. Define a new method called 'buf_init' in Tidylib:

  # tidyBufInit, using default allocator
  #
  def buf_init(buf)
    tidyBufInit(buf)
  end
Then, in tidy-1.1.2/lib/tidy/tidybuf.rb:

3. Add this line to the initialize method of Tidybuf below the malloc:

   Tidylib.buf_init(@struct)
so that is looks like this:


  # tidyBufInit, using default allocator
  #
  def buf_init(buf)
    @struct = TidyBuffer.malloc
    Tidylib.buf_init(@struct)
  end
4. For completeness, make Brennan's change by adding the allocator field to the TidyBuffer struct so that it looks like this:

  TidyBuffer = struct [
    "TidyAllocator* allocator",
    "byte* bp",
    "uint size",
    "uint allocated",
    "uint next"
  ] 

========================


xpath tips:
==========
http://ripwiki.pbworks.com/w/page/8766817/XPathTips







