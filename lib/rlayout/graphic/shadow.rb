
module RLayout  
  class Graphic
    def init_shadow(options)
      @shadow             = ShadowStruct.new("gray", 3, -3, 3.0)
      @shadow.color       = options[:shadow_color]          if options[:shadow_color]
      @shadow.x_offset    = options[:shadow_x_offset]       if options[:shadow_x_offset]
      @shadow.y_offset    = options[:shadow_y_offset]       if options[:shadow_y_offset]
      @shadow.blur_radius = options[:blur_radius]           if options[:blur_radius]
    end
  end

end