
# LINE_TYPE_PLAIN           = 0
# LINE_TYPE_DOUBLE_LINES_1  = 1
# LINE_TYPE_DOUBLE_LINES_2  = 2
# LINE_TYPE_DOUBLE_LINES_3  = 3
# LINE_TYPE_TRIPPLE_LINES_1 = 4
# LINE_TYPE_TRIPPLE_LINES_2 = 5
# LINE_TYPE_TRIPPLE_LINES_3 = 6


module RLayout
  
  class Graphic
    def init_line(options)
      @line_type        = options.fetch(:line_type, line_defaults[:line_type])
      @line_color       = options.fetch(:line_color, line_defaults[:line_color])
      @line_width       = options.fetch(:line_width, line_defaults[:line_width])
      @line_dash        = options.fetch(:line_width, nil)
    end
    
    
    def line_defaults
      h = {}
      h[:shape]       = 0
      h[:line_type]   = 0
      h[:line_color]  = "black"
      h[:line_width]  = 0
      h
    end
    
    def line_to_hash
      h = {}
      h[:fill_type] = @line_type if @line_type && @line_type != line_defaults[:line_type]
      h[:line_color] = @line_color if @line_color && @line_color != line_defaults[:line_color]
      h[:line_width] = @line_width if @line_width && @line_width != line_defaults[:line_width]
      h
    end
    
    def getLineRect(r)

      if @line_position == 1 #LINE_POSITION_MIDDLE 
        return r
      elsif @line_position == 2 
        #LINE_POSITION_OUTSIDE) 
        return NSInsetRect(r, -@line_width/2.0, -@line_width/2.0)
      else 
        # LINE_POSITION_INSIDE        
        return NSInsetRect(r, @line_width/2.0, @line_width/2.0)
      end
    end

    def linePathWithRect(r)
      path = NSBezierPath.bezierPathWithRect(r)

      # path = @owner_graphic.bezierPathWithRect(r)
      path.setLineCapStyle(@line_cap) if @line_cap
      path.setLineJoinStyle(@line_join) if @line_join

      if @dash
        if(@line_cap == 1 && @dash[0] == 0) 
          @dash[0] = 0.0001
        end
        path.setLineDash(@dash, count:@dash.length, phase:0)
      end

      path
    end  

    def drawLine(rect, withTrap:trap)  

      # @line_width = 2

      # return if @line_width == 0 &&  @graphic.drawing_mode == "printing"
      return if @line_width == 0 
      unless trap
        trap = 0
      end
      
      puts "in drawLine @klass: #{@klass}"
      # clipLine = false
      rect = getLineRect(rect)    
      @line_color  = convert_to_nscolor(@line_color)    unless @line_color.class == NSColor  
      @line_color.set

      if @line_type==nil
        @line_type=0
      end
      if(@line_type == 0)   
        path = linePathWithRect(rect) 
        if @line_width == 0
          NSColor.lightGrayColor.set
        end
        # NSColor.lightGrayColor.set
        path.setLineWidth(@line_width + trap)
        path.stroke

      else 
          @line1=@line_types_width_table[@line_type][0]*@line_width
          @line2=@line_types_width_table[@line_type][1]*@line_width

          w = @line1
          indentValue = (@line_width - w)/-2.0

          if(@line_type > 3) 
              path = linePathWithRect(rect)
              path.setLineWidth(@line2 + trap)
              path.stroke
          end
          new_rect=NSInsetRect(rect, indentValue, indentValue)              
          path = linePathWithRect(NSInsetRect(rect, indentValue, indentValue))
          path.setLineWidth(@line1 + trap)
          path.stroke
          if(@line_type < 4) 
            w = @line2
          end
          indentValue = (@line_width - w)/2.0
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