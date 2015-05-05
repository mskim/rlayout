
# LINE_TYPE_PLAIN           = 0
# LINE_TYPE_DOUBLE_LINES_1  = 1
# LINE_TYPE_DOUBLE_LINES_2  = 2
# LINE_TYPE_DOUBLE_LINES_3  = 3
# LINE_TYPE_TRIPPLE_LINES_1 = 4
# LINE_TYPE_TRIPPLE_LINES_2 = 5
# LINE_TYPE_TRIPPLE_LINES_3 = 6


module RLayout
  
  class Graphic
    def init_stroke(options)
      @stroke             = options.fetch(:stroke, StrokeStruct.new('black', 0))
      @stroke[:color]     = options[:line_color] if options[:line_color] # supporting commomly used name
      @stroke[:color]     = options[:stroke_color] if options[:stroke_color]
      @stroke[:thickness] = options[:line_width] if options[:line_width] # supporting commomly used name
      @stroke[:thickness] = options[:stroke_thickness] if options[:stroke_thickness]
      @stroke[:thickness] = options[:thickness] if options[:thickness]
      @stroke[:dash]      = options[:dash] if options[:dash]
      @stroke[:line_cap]  = options[:line_cap] if options[:line_cap]
      @stroke[:line_join] = options[:line_join] if options[:line_join]
      @stroke[:type]      = options[:line_type] if options[:line_type]
    end
    
    
    
    def getStrokeRect(r)

      if @line_position == 1 #LINE_POSITION_MIDDLE 
        return r
      elsif @line_position == 2 
        #LINE_POSITION_OUTSIDE) 
        return NSInsetRect(r, - @stroke[:thickness]/2.0, - @stroke[:thickness]/2.0)
      else 
        # LINE_POSITION_INSIDE        
        return NSInsetRect(r, @stroke[:thickness]/2.0, @stroke[:thickness]/2.0)
      end
    end

    def linePathWithRect(r)
      path = NSBezierPath.bezierPathWithRect(r)

      # path = @owner_graphic.bezierPathWithRect(r)
      path.setLineCapStyle(@stroke[:line_cap]) if @stroke[:line_cap]
      path.setLineJoinStyle(@stroke[:line_join]) if @stroke[:line_join]

      if @dash
        if(@stroke[:line_cap] == 1 && @stroke[:dash][0] == 0) 
          @stroke[:dash][0] = 0.0001
        end
        path.setLineDash(@dash, count:@dash.length, phase:0)
      end

      path
    end  

    def drawLine(rect, withTrap:trap)  


      # return if @stroke[:thickness] == 0 &&  @graphic.drawing_mode == "printing"
      return if @stroke[:thickness] == 0 
      unless trap
        trap = 0
      end
      # clipLine = false
      rect = getStrokeRect(rect)    
      @stroke[:color]  = convert_to_nscolor(@stroke[:color])    unless @stroke[:color].class == NSColor  
      @stroke[:color].set

      if @stroke[:type]==nil
        @stroke[:type] = 0
      end
      if(@stroke[:type] == 0)   
        path = linePathWithRect(rect) 
        if @stroke[:thickness] == 0
          NSColor.lightGrayColor.set
        end
        # NSColor.lightGrayColor.set
        path.setLineWidth(@stroke[:thickness] + trap)
        path.stroke

      else 
          @line1=@line_types_width_table[@stroke[:type]][0]*@stroke[:thickness]
          @line2=@line_types_width_table[@stroke[:type]][1]*@stroke[:thickness]

          w = @line1
          indentValue = (@stroke[:thickness] - w)/-2.0

          if(@stroke[:type] > 3) 
              path = linePathWithRect(rect)
              path.setLineWidth(@line2 + trap)
              path.stroke
          end
          new_rect=NSInsetRect(rect, indentValue, indentValue)              
          path = linePathWithRect(NSInsetRect(rect, indentValue, indentValue))
          path.setLineWidth(@line1 + trap)
          path.stroke
          if(@stroke[:type] < 4) 
            w = @line2
          end
          indentValue = (@stroke[:thickness] - w)/2.0
          new_rect=NSInsetRect(rect, indentValue, indentValue)              
          path = linePathWithRect(NSInsetRect(rect, indentValue, indentValue))
          path.setLineWidth(w + trap)
          path.stroke
      end
    end

    def draw_line(r)
      drawLine(r, withTrap:0)
      drawArrow if @start_arrow && @owner_graphic
    end


    
  end
end