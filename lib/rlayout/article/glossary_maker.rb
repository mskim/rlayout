if RUBY_ENGINE != 'rubymotion'
  require 'json'
end

module RLayout
  
  class GlossaryMaker
	  attr_accessor :project_path, :url, :items
	  
    def initialize(options={})
      @project_pathroject_path = options[:project_path]
      @url          = options[:url]

      if @url
        fetch_from_remote
      else
        read_item
      end
      self
    end
	
  	def read_item
	 
  	end
	
    def fetch_from_remote
      # a = `curl http://localhost:3000/words.json`
      json = `curl http://@url`
      h_array = JSON.parse(json)
      @items = []
      @topic = array.first['topic']
      h_array.each do |h|
        item = []
        if @topic != h['topic']
          @topic = h['topic']
          item << "title_text #{@topic}"
          @items << item
        else
          item << "item_row "
          item << h['word']
          item << h['kind']
          item << h['definition']
          @items << item
        end
      end
    end
  end

end