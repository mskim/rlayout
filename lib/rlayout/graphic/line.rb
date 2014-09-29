module RLayout
  
  
  class Graphic
    def init_line(options)
      @line_type        = options[:line_type]
      @line_color       = options[:line_color]
      @line_width       = options[:line_width]
      @line_dash        = options[:line_dash]
    end
    
  end
end