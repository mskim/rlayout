module RLayout
  
  
  class Graphic
    
    def init_fill(options)
      if options[:fill_type] == 'gradiation'
        @fill = LinearGradient.new('white','black')
        @fill.starting_color = options[:fill_color]         if options[:fill_color]
        @fill.starting_color = options[:starting_color]     if options[:starting_color]
        @fill.ending_color = options[:fill_other_color]     if options[:fill_other_color]
        @fill.ending_color = options[:fill_ending_color]    if options[:fill_ending_color]
        @fill[:starting_color]  = options[:fill_color]        if options[:fill_color]
        @fill[:ending_color]    = options[:fill_other_color]  if options[:fill_other_color]    
        
      elsif options[:fill_type] == 'radial'
        @fill = RadialGradient.new('white','black')
        @fill.starting_color = options[:fill_color]         if options[:fill_color]
        @fill.starting_color = options[:starting_color]     if options[:starting_color]
        @fill.ending_color = options[:fill_other_color]     if options[:fill_other_color]
        @fill.ending_color = options[:fill_ending_color]    if options[:fill_ending_color]
        @fill[:starting_color]  = options[:fill_color]        if options[:fill_color]
        @fill[:ending_color]    = options[:fill_other_color]  if options[:fill_other_color]    
        
      elsif options[:fill_color]
        @fill = FillStruct.new(options[:fill_color])
      else
        @fill = FillStruct.new('white')
        @fill[:color] = options[:fill_color] if options[:fill_color]
      end
    end
        
    def draw_fill(r)      
      if @fill_type == 0   #clearColor
        path=NSBezierPath.bezierPathWithRect(r)
        NSColor.clearColor.set
        path.fill

      elsif @fill_type == 1 #normal fill
        path=NSBezierPath.bezierPathWithRect(r)
        @fill_color = convert_to_nscolor(@fill_color)    unless @fill_color.class == NSColor  
        @fill_color.set if @fill_color
        path.fill

      else       
        @fill_other_color = convert_to_nscolor(@fill_other_color)    unless @fill_other_color.class == NSColor  
        myGradient = NSGradient.alloc.initWithStartingColor(@fill_color, endingColor:@fill_other_color)
        path=NSBezierPath.bezierPathWithRect(r)

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