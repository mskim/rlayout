# RemoteReader
# Fetches contents from remote server
# item_types are :json, markdown, adoc, txt

module RLayout
	class RemoteReader
	  
	  attr_accessor :url, :item_type, :collection_name, :collection_id, :paragraphs
	  def initialize(options={})
	    @url              = options(:url)
      if !@url || !@collection_name || !@collection_id
        puts "url:#{@url}"
        puts "collection_name:#{@collection_name}"
        puts "collection_id:#{@collection_id}"
        puts "not enough connection information  given!!!"
        return
      end
	    fetch_paragraph
	    self
	  end
	  
	  def fetch_paragraph(options={})
	    @paragraphs = []
	    json = `curl localhost:3000/quiz`
	    @paragraphs = json.to_h
	  end
	end


end