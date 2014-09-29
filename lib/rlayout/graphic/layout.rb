module RLayout
  
  
  class Graphic
    def init_layout(options)
      if options[:margin]
        @left_margin    = options[:margin]
        @top_margin     = options[:margin]
        @right_margin   = options[:margin]
        @bottom_margin  = options[:margin]        
      else
        @left_margin    = options.fetch(:left_margin, defaults[:left_margin])
        @top_margin     = options.fetch(:top_margin, defaults[:top_margin])
        @right_margin   = options.fetch(:right_margin, defaults[:right_margin])
        @bottom_margin  = options.fetch(:bottom_margin, defaults[:bottom_margin])
      end
      if options[:inset]
        @left_inset     = options[:inset]
        @top_inset      = options[:inset]
        @right_inset    = options[:inset]
        @bottom_inset   = options[:inset]
      else
        @left_inset     = options.fetch(:left_inset, defaults[:left_inset])
        @top_inset      = options.fetch(:top_inset, defaults[:top_inset])
        @right_inset    = options.fetch(:right_inset, defaults[:right_inset])
        @bottom_inset   = options.fetch(:bottom_inset, defaults[:bottom_inset])
      end
      @layout_direction = options.fetch(:layout_direction, defaults[:layout_direction])
      @layout_member    = options.fetch(:layout_member, defaults[:layout_member])
      @layout_expand    = options.fetch(:layout_expand, defaults[:layout_expand])
      @layout_length    = options.fetch(:layout_length, defaults[:layout_length])
    end
  end
end