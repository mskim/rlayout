

class GraphicViewMac < NSView

  def init_fill
    @fill_type  = fill_defaults[:fill_type]
    @fill_type  = @data[:fill_type] if @data[:fill_type]
    @fill_color = fill_defaults[:fill_color]
    @fill_color = @data[:fill_color] if @data[:fill_color]
    @fill_other_color = fill_defaults[:fill_other_color]
    @fill_other_color = @data[:fill_color] if @data[:fill_other_color]

    # convert to NSColor
    # convert to NSRect
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
      # @fill_color.set if @fill_color
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