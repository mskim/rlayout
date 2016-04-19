module RLayout
  
  class MemoArea < Container
    attr_accessor :title, :text_style, :line_space, :line
    
    def initialize(options={}, &block)
      super
      @title                  = options.fetch(:title, "MEMO")
      text(@title, options)
      options.delete(:text_string) if options[:text_string]
      @line_space             = options.fetch(:line_space, 12)
      options[:fill_color]    = "white"
      options[:stroke_sides]  = [0,0,0,0]
      options[:parent]        = self
      @line                   = Line.new(options)
      layout_lines
      self
    end 
    
    def layout_lines
      count = @height/@line_space
      count.to_i.times do 
        @graphics << @line.dup
      end
      relayout!
    end
    
  end
  
  
end
