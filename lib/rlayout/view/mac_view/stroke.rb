
class GraphicViewMac < NSView
  attr_accessor :stroke, :line_position, :stroke_rect
  def draw_stroke(graphic)
    draw_gutter_stroke(graphic) if graphic.respond_to?(:gutter_stroke) && graphic.draw_gutter_stroke
    return if graphic.stroke[:thickness].nil?
    return if graphic.stroke[:thickness] == 0
    @stroke         = graphic.stroke
    @stroke_rect    = graphic.get_stroke_rect
    @line_position  = 1
    r               = ns_bounds_rect(graphic)
    drawLine(r, withTrap:0)
    draw_rules(r) if @stroke[:rule]
    # drawArrow if @start_arrow && @owner_graphic
  end

  def draw_rules(rect)
    if @stroke[:rule] == "horizontal_rule"
      # puts  "draw bottom"
      path= NSBezierPath.bezierPath
      path.setLineWidth(@stroke[:thickness])
      path.moveToPoint(NSPoint.new(rect.origin.x, rect.origin.y + rect.size.height/2.0))
      path.lineToPoint(NSPoint.new(rect.origin.x + rect.size.width, rect.origin.y + rect.size.height/2.0))
      path.stroke
    end
    if @stroke[:rule] == "vertical_rule"
      # puts  "draw bottom"
      path= NSBezierPath.bezierPath
      path.setLineWidth(@stroke[:thickness])
      path.moveToPoint(NSPoint.new(rect.origin.x + rect.size.width/2.0, rect.origin.y ))
      path.lineToPoint(NSPoint.new(rect.origin.x + rect.size.width/2.0, rect.origin.y + + rect.size.height))
      path.stroke
    end
    #TODO
    # if @stroke[:rule]  == "top_left_to_bottom_right"
    # if @stroke[:rule]  == "top_right_to_bottom_left"
  end

  def draw_gutter_stroke(graphic)
    # return unless graphic.kind_of?(RLayout::TextBox)
    #draw gutter lines
    return if graphic.gutter_stroke.nil?
    if graphic.gutter_stroke.thickness.nil?
      graphic.gutter_stroke.thickness = 1.0
    end
    if graphic.gutter_stroke.color.nil?
      graphic.gutter_stroke.color = "black"
    end
    space = graphic.layout_space/2.0
    if graphic.gutter_stroke.nil?
      gutter_stroke = {}
      gutter_stroke[:thickness] = 1.0
      gutter_stroke[:color] = "black"
      graphic.gutter_stroke = gutter_stroke
    elsif graphic.gutter_stroke.thickness.nil?
      graphic.gutter_stroke.thickness = 1.0
    elsif graphic.gutter_stroke.color.nil?
      graphic.gutter_stroke.color = "black"
    end
    width = graphic.gutter_stroke.thickness
    RLayout.convert_to_nscolor(graphic.gutter_stroke.color).set
    graphic.graphics.each_with_index do |g, i|
      next if i == graphic.graphics.length - 1 # last one
      if graphic.layout_direction == "vertical"
        starting  = NSMakePoint(graphic.x , g.x_max + space)
        ending    = NSMakePoint(g.x_max, g.y_max + space)
        draw_line_from(starting, ending, width)
      else
        starting  = NSMakePoint(g.x_max + space, g.y)
        ending    = NSMakePoint(g.x_max + space, g.y_max)
        draw_line_from(starting, ending, width)
      end
    end
  end

  def draw_line_from(starting, ending, width)
    path= NSBezierPath.bezierPath
    path.setLineWidth(width)
    path.moveToPoint(starting)
    path.lineToPoint(ending)
    path.stroke
  end

  # def getStrokeRect(r)
  #   if @line_position == 1 #LINE_POSITION_MIDDLE
  #     return r
  #   elsif @line_position == 2
  #     #LINE_POSITION_OUTSIDE)
  #     return NSInsetRect(r, - @stroke[:thickness]/2.0, - @stroke[:thickness]/2.0)
  #   else
  #     # LINE_POSITION_INSIDE
  #     return NSInsetRect(r, @stroke[:thickness]/2.0, @stroke[:thickness]/2.0)
  #   end
  # end

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

  def drawSingleLine
    @stroke[:color]  = RLayout.convert_to_nscolor(@stroke[:color])    unless @stroke[:color].class == NSColor
    @stroke[:color].set

  end

  def drawLine(rect, withTrap:trap)
    # return if @stroke[:thickness] == 0 &&  @graphic.drawing_mode == "printing"
    return unless @stroke
    return if @stroke[:thickness] == 0
    unless trap
      trap = 0
    end
    # clipLine = false
    # rect = getStrokeRect(rect)
    rect = @stroke_rect
    @stroke[:color]  = RLayout.convert_to_nscolor(@stroke[:color])    unless @stroke[:color].class == NSColor
    @stroke[:color].set

    if @stroke[:type]==nil
      @stroke[:type] = 0
    end

    if @graphic.class == RLayout::Line
      starting  = NSPoint.new(rect.origin.x, rect.origin.y)
      ending    = NSPoint.new(rect.origin.x, + rect.size.width,  rect.origin.y + rect.size.height)
      path      = NSBezierPath.bezierPath
      path.setLineWidth(@stroke[:thickness])
      path.moveToPoint(starting)
      path.lineToPoint(ending)
      path.stroke
      return
    end

    # @stroke[:type] == 0 means single line
    # @stroke[:type] > 0 means double or triple line
    if(@stroke[:type] == 0)
      if @stroke[:thickness] == 0
        NSColor.lightGrayColor.set
        # NSColor.lightGrayColor.set
      end
      # stroke each side
      if @stroke[:sides] != [1,1,1,1] #TODO check for rectangle or roundrect
        if @stroke[:sides][0] > 0
          # puts  "draw left side"
          path= NSBezierPath.bezierPath
          path.setLineWidth(@stroke[:thickness]*@stroke[:sides][0])
          path.moveToPoint(NSPoint.new(rect.origin.x, rect.origin.y))
          path.lineToPoint(NSPoint.new(rect.origin.x , rect.origin.y + rect.size.height))
          path.stroke
        end
        if @stroke[:sides][1] > 0
          # puts  "draw top"
          path= NSBezierPath.bezierPath
          path.setLineWidth(@stroke[:thickness]*@stroke[:sides][1])
          path.moveToPoint(NSPoint.new(rect.origin.x, rect.origin.y))
          path.lineToPoint(NSPoint.new(rect.origin.x + rect.size.width, rect.origin.y))
          path.stroke
        end
        if @stroke[:sides][2] > 0
          # puts  "draw right"
          path= NSBezierPath.bezierPath
          path.setLineWidth(@stroke[:thickness]*@stroke[:sides][2])
          path.moveToPoint(NSPoint.new(rect.origin.x + rect.size.width, rect.origin.y))
          path.lineToPoint(NSPoint.new(rect.origin.x + rect.size.width, rect.origin.y + rect.size.height))
          path.stroke
        end
        if @stroke[:sides][3] > 0
          path= NSBezierPath.bezierPath
          path.setLineWidth(@stroke[:thickness]*@stroke[:sides][3])
          # path.setLineWidth(2*@stroke[:sides][3])
          if @graphic.class == RLayout::NewsArticleBox
            # path.moveToPoint(NSPoint.new(@graphic.border_x, rect.origin.y + rect.size.height - 1.5))
            path.moveToPoint(NSPoint.new(@graphic.border_x, rect.origin.y + rect.size.height))
            path.lineToPoint(NSPoint.new(@graphic.border_x + @graphic.border_width, rect.origin.y + rect.size.height))
            #TODO fix this
            puts "@graphic.border_x + @graphic.border_width:#{@graphic.border_x + @graphic.border_width}"
            puts "rect.origin.x + rect.size.width:#{rect.origin.x + rect.size.width}"
            path.stroke
          else
            path.moveToPoint(NSPoint.new(rect.origin.x, rect.origin.y + rect.size.height))
            path.lineToPoint(NSPoint.new(rect.origin.x + rect.size.width, rect.origin.y + rect.size.height))
            path.stroke
          end
        end

        # if [1,1,1,1,1,1] drawing x mark
        if @stroke[:sides][4] &&  @stroke[:sides][4] > 0
          # puts  "draw top-left to bottom-right"
          path= NSBezierPath.bezierPath
          path.setLineWidth(@stroke[:thickness]*@stroke[:sides][3])
          path.moveToPoint(NSPoint.new(rect.origin.x, rect.origin.y))
          path.lineToPoint(NSPoint.new(rect.origin.x + rect.size.width, rect.origin.y + rect.size.height))
          path.stroke
        end

        if @stroke[:sides][5] &&  @stroke[:sides][5] > 0
          # puts  "draw bottom-left to top-right"
          path= NSBezierPath.bezierPath
          path.setLineWidth(@stroke[:thickness]*@stroke[:sides][3])
          path.moveToPoint(NSPoint.new(rect.origin.x, rect.origin.y + rect.size.height))
          path.lineToPoint(NSPoint.new(rect.origin.x + rect.size.width, rect.origin.y))
          path.stroke
        end


      else
        path = linePathWithRect(rect)
        path.setLineWidth(@stroke[:thickness] + trap)
        path.stroke
      end
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

end
