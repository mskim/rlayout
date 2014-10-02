module RLayout
  
  class MagazineArticle < Document
    attr_accessor :story_path
    def initialize(options={})
      super
      @page_count = options.fetch(:page_count, 2)
      options[:header]     = true
      options[:footer]     = true 
      options[:header]     = true 
      options[:story_box]  = true
      @page_count.times do
        Page.new(self, options)
      end
      
      self
    end
    
    
    
  end
  
  
end