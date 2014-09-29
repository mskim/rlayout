module RLayout
  
  
  class Graphic
    def init_fill(options)
      @fill_type        = options[:fill_type]
      @fill_color       = options[:fill_color]
      @fill_other_color = options[:fill_other_color]
    end
  end
end