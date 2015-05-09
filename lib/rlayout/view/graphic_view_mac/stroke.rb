
class GraphicViewMac < NSView
  def draw_stroke(graphic)
  
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