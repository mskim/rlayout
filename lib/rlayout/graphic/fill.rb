module RLayout
  
  
  class Graphic
    
    def init_fill(options)
      @fill_type        = options[:fill_type]
      @fill_color       = options[:fill_color]
      @fill_other_color = options[:fill_other_color]
    end
    
    def fill_defaults
      h = {}
      h[:fill_type] = 1
      h[:fill_color] = "white"
      h[:fill_other_color] = "gray"
      h
    end

    def draw_fill(r)
      if @fill_type == 0   #clearColor
        path=bezierPathWithRect(r)
        NSColor.clearColor.set
        path.fill

      elsif @fill_type == 1 #normal fill
        path=bezierPathWithRect(r)
        @fill_color = convert_to_nscolor(@fill_color)    unless @fill_color.class == NSColor  
        @fill_color.set if @fill_color
        path.fill

      else       
        @fill_other_color = convert_to_nscolor(@fill_other_color)    unless @fill_other_color.class == NSColor  
        myGradient = NSGradient.alloc.initWithStartingColor(@fill_color, endingColor:@fill_other_color)
        path=bezierPathWithRect(r)

        if(@fill_type == 2) 
          myGradient.drawInBezierPath(path, angle:@fill_angle)
          # myGradient.drawInRect(r, angle:@fill_angle)

        elsif(@fill_type == 3) 
          myGradient.drawInBezierPath(path, relativeCenterPosition:@offset_pt)
        end
      end

    end
    
  end
end