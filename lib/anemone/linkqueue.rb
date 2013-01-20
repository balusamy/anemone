

class LinkQueue 

  def initialize (mongo_db, collection_name)
    @db = mongo_db
    @collection = @db[collection_name]
    @collection.create_index 'url'
  end

  def <<(link, page_url, depth = 1, source = nil, tag = nil)

       obj = {"url" => url, "linked_from" => page.url.to_s, "depth" => 1,  "crawl_date" => nil, "source" => source, "tag" => tag}

       @collection.update(
       @crawl_queue.save({"url" => url, "crawl_date" => nil, "source" => source}) if @crawl_queue.find({"url" => url}).count == 0




       hash = page.to_hash
        BINARY_FIELDS.each do |field|
          hash[field] = BSON::Binary.new(hash[field]) unless hash[field].nil?
        end
        @collection.update(
          {'url' => page.url.to_s},
          hash,
          :upsert => true
        )

  end

  def empty?
  
  end

  def enq(obj)
  end

  def deq(obj)
  end

  def size()
    @collection.count
  end

  def length()
    size
  end


end

