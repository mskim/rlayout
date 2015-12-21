module RLayout
  class Galley < Document
    attr_accessor :story
    
    def initialize(options={})
      @paper_paze   = options.fetch(:paper_size, "A4")
      @column_count = options.fetch(:column_count, 1)
      @column_width = options.fetch(:column_width, 200)
      @story        = options[:story]
      layout_story 
      self
    end
    
    def layout_story
      heading = @story.heading
      body    = @story.body
      body.each do |para|
        
        
      end

    end
  end
  
  
  
end  