module RLayout
  
  class MemoArea < Container
    attr_accessor :title, :text_style, :line_space, :line
    
    def initialize(parent_graphic, options={}, &block)
      super
      @title      = options.fetch(:title, "MEMO")
      text(@title, options)
      @line_space = options.fetch(:line_space, 16)
      @line       = Line.new(self, options)
      layout_lines
      self
    end 
    
    def layout_lines
      count = (@height/@line_space).to_i
      count.times do 
        @graphics << @line.dup
      end
      relayout!
    end
    
  end
  
  
end
