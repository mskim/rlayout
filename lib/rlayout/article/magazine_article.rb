require File.dirname(__FILE__) + '/magazine_story_box'
require File.dirname(__FILE__) + '/story'

module RLayout
  
  class MagazineArticle < Document
    attr_accessor :story_path
    def initialize(options={})
      super  
      @double_side = true
      @page_count = options.fetch(:page_count, 2)
      options[:header]     = true
      options[:footer]     = true 
      options[:header]     = true 
      options[:story_box]  = true
      @page_count.times do |i|
        options[:page_number] = i+1
        if @double_side
          if @starts_left
            options[:left_page]   = i.even?
          else
            options[:left_page]   = i.odd?
          end
        else
          options[:left_page]   = true
        end
        Page.new(self, options)
      end
          
      self
    end
    
    
    
  end
  
  
end