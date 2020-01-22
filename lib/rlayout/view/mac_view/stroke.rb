
class GraphicViewMac < NSView
  attr_accessor :stroke, :line_position, :stroke_rect
  
  
  def draw_stroke(graphic)
    draw_gutter_stroke(graphic) if graphic.respond_to?(:gutter_stroke) && graphic.draw_gutter_stroke
    return if graphic.stroke[:thickness].nil?
    return if graphic.stroke[:thickness] == 0
    @stroke = graphic.stroke
    @line_position  = 1
    @left_inset     = graphic.left_inset + 2
    draw_line(graphic)

    # drawArrow if @start_arrow && @owner_graphic
  end
  
  def draw_gutter_stroke(graphic)
    # return unless graphic.kind_of?(RLayout::TextBox)
    #draw gutter lines
    return if graphic.gutter_stroke.nil?
    if graphic.gutter_stroke.thickness.nil?
      graphic.gutter_stroke.thickness = 1.0
    end
    if graphic.gutter_stroke.color.nil?
      graphic.gutter_stroke.color = 'CMYK=0,0,0,100'
    end
    space = graphic.layout_space/2.0
    if graphic.gutter_stroke.nil?
      gutter_stroke = {}
      gutter_stroke[:thickness] = 1.0
      gutter_stroke[:color] = 'CMYK=0,0,0,100'
      graphic.gutter_stroke = gutter_stroke
    elsif graphic.gutter_stroke.thickness.nil?
      graphic.gutter_stroke.thickness = 1.0
    elsif graphic.gutter_stroke.color.nil?
      graphic.gutter_stroke.color = 'CMYK=0,0,0,100'
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

  def draw_line_from(starting, ending, thickness)
    path= NSBezierPath.bezierPath
    path.setLineWidth(thickness)
    path.moveToPoint(starting)
    path.lineToPoint(ending)
    path.stroke
  end

  def line_path_with_rect(r)
    path = NSBezierPath.bezierPathWithRect(r)
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

  def draw_line(graphic)
    # return if @stroke[:thickness] == 0 &&  @graphic.drawing_mode == "printing"
    return unless graphic.stroke
    return if graphic.stroke[:thickness] == 0
    rect = ns_bounds_rect(graphic)
    if graphic.kind_of?(RLayout::NewsBox)  
      rect = ns_stroke_rect(graphic)
    end
    @line_position  = 1
    graphic.stroke[:color]  = RLayout.convert_to_nscolor(graphic.stroke[:color])    unless graphic.stroke[:color].class == NSColor
    graphic.stroke[:color].set

    if graphic.stroke[:type]==nil
      graphic.stroke[:type] = 0
    end

    if graphic.class == RLayout::Line
      starting  = NSPoint.new(rect.origin.x, rect.origin.y)
      ending    = NSPoint.new(rect.origin.x + rect.size.width,  rect.origin.y + rect.size.height)
      path      = NSBezierPath.bezierPath
      path.setLineWidth(graphic.stroke[:thickness])
      path.moveToPoint(starting)
      path.lineToPoint(ending)
      path.stroke
      return
    end

    if(graphic.stroke[:type] == 0)
      if graphic.stroke[:thickness] == 0
        NSColor.lightGrayColor.set
        # NSColor.lightGrayColor.set
      end
      # stroke each side
      if graphic.stroke[:sides] != [1,1,1,1] #TODO check for rectangle or roundrect
        # open_left_inset_line do not draw top and bottom inset area
        # TODO open_right_inset_line
        @open_left_inset_line = graphic.stroke[:sides].length >= 4 && graphic.stroke[:sides].last == "open_left_inset_line"
        if graphic.stroke[:sides][0] > 0
          # puts  "draw left side"
          path= NSBezierPath.bezierPath
          path.setLineWidth(graphic.stroke[:thickness]*graphic.stroke[:sides][0])
          if graphic.kind_of?(RLayout::NewsBox)
            if @open_left_inset_line
              # puts "@open_left_inset_line"
              path.moveToPoint(NSPoint.new(rect.origin.x, rect.origin.y + graphic.top_margin))
              path.lineToPoint(NSPoint.new(rect.origin.x, rect.origin.y + rect.size.height))
            elsif graphic.kind == '박스기고'
              path.moveToPoint(NSPoint.new(graphic.stroke_x, rect.origin.y))
              path.lineToPoint(NSPoint.new(graphic.stroke_x, rect.origin.y + rect.size.height))
            else
              # puts "NewsArticleBox left graphic.left_margin:#{graphic.left_margin}"
              path.moveToPoint(NSPoint.new(rect.origin.x + graphic.left_margin, rect.origin.y + graphic.top_margin))
              path.lineToPoint(NSPoint.new(rect.origin.x + graphic.left_margin, rect.origin.y + rect.size.height))
            end
          else
            path.moveToPoint(NSPoint.new(rect.origin.x, rect.origin.y + graphic.top_margin))
            path.lineToPoint(NSPoint.new(rect.origin.x , rect.origin.y + rect.size.height))
          end
          path.stroke
        end

        if graphic.stroke[:sides][1] > 0
          path= NSBezierPath.bezierPath
          path.setLineWidth(graphic.stroke[:thickness]*graphic.stroke[:sides][1])
          if @open_left_inset_line
            path.moveToPoint(NSPoint.new(rect.origin.x + graphic.left_margin*2, rect.origin.y))
            path.lineToPoint(NSPoint.new(rect.origin.x + rect.size.width, rect.origin.y + graphic.top_margin))
          elsif graphic.kind_of?(RLayout::NewsBox)  
            if graphic.kind == '박스기고'
              path.moveToPoint(NSPoint.new(graphic.stroke_x, graphic.stroke_y))
              # path.lineToPoint(NSPoint.new(graphic.stroke_x + graphic.border_width, graphic.stroke_y))
              path.lineToPoint(NSPoint.new(graphic.stroke_x + rect.size.width, graphic.stroke_y))
            else
              # path.moveToPoint(NSPoint.new(rect.origin.x + graphic.left_margin, rect.origin.y + graphic.top_margin))
              # path.lineToPoint(NSPoint.new(rect.origin.x + rect.size.width - graphic.left_margin, rect.origin.y + graphic.top_margin))
              path.moveToPoint(NSPoint.new(rect.origin.x, rect.origin.y + graphic.top_margin))
              path.lineToPoint(NSPoint.new(rect.origin.x + rect.size.width, rect.origin.y + graphic.top_margin))
            end
          else
            path.moveToPoint(NSPoint.new(rect.origin.x + graphic.left_margin, rect.origin.y + graphic.top_margin))
            path.lineToPoint(NSPoint.new(rect.origin.x + rect.size.width - graphic.left_margin, rect.origin.y + graphic.top_margin))
          end
          path.stroke
        end
        if graphic.stroke[:sides][2] > 0
          path= NSBezierPath.bezierPath
          path.setLineWidth(graphic.stroke[:thickness]*graphic.stroke[:sides][2])
          path.moveToPoint(NSPoint.new(rect.origin.x + rect.size.width, rect.origin.y))
          path.lineToPoint(NSPoint.new(rect.origin.x + rect.size.width, rect.origin.y + rect.size.height))
          path.stroke
        end
        if graphic.stroke[:sides][3] > 0
          path= NSBezierPath.bezierPath
          path.setLineWidth(graphic.stroke[:thickness]*graphic.stroke[:sides][3])
          if @open_left_inset_line
            path.moveToPoint(NSPoint.new(rect.origin.x + graphic.left_margin*2, rect.origin.y + rect.size.height))
            path.lineToPoint(NSPoint.new(rect.origin.x + rect.size.width, rect.origin.y + rect.size.height))
            path.stroke
            return
          end

          if graphic.kind_of?(RLayout::NewsBox) 
            if @graphic.kind == '박스기고'
              path.moveToPoint(NSPoint.new(graphic.stroke_x, rect.origin.y + rect.size.height))
              # path.lineToPoint(NSPoint.new(graphic.stroke_x + graphic.border_width, rect.origin.y + rect.size.height))
              path.lineToPoint(NSPoint.new(graphic.stroke_x + rect.size.width, rect.origin.y + rect.size.height))

            else
              # path.moveToPoint(NSPoint.new(graphic.border_x, rect.origin.y + rect.size.height))
              # path.lineToPoint(NSPoint.new(graphic.border_x + graphic.border_width, rect.origin.y + rect.size.height))
              path.moveToPoint(NSPoint.new(rect.origin.x, rect.origin.y + rect.size.height))
              path.lineToPoint(NSPoint.new(rect.origin.x + rect.size.width, rect.origin.y + rect.size.height))
            end
            path.stroke
          else
            path.moveToPoint(NSPoint.new(rect.origin.x, rect.origin.y + rect.size.height - graphic.bottom_margin))
            path.lineToPoint(NSPoint.new(rect.origin.x + rect.size.width, rect.origin.y + rect.size.height - graphic.bottom_margin))
            path.stroke
          end
        end

        # if [1,1,1,1,1,1] drawing x mark
        if graphic.stroke[:sides][4] && graphic.stroke[:sides][4].class != String && graphic.stroke[:sides][4] > 0
          # puts  "draw top-left to bottom-right"
          path= NSBezierPath.bezierPath
          path.setLineWidth(graphic.stroke[:thickness]*graphic.stroke[:sides][3])
          path.moveToPoint(NSPoint.new(rect.origin.x, rect.origin.y))
          path.lineToPoint(NSPoint.new(rect.origin.x + rect.size.width, rect.origin.y + rect.size.height))
          path.stroke
        end

        if graphic.stroke[:sides][5] &&  graphic.stroke[:sides][5] > 0
          # puts  "draw bottom-left to top-right"
          path= NSBezierPath.bezierPath
          path.setLineWidth(graphic.stroke[:thickness]*graphic.stroke[:sides][3])
          path.moveToPoint(NSPoint.new(rect.origin.x, rect.origin.y + rect.size.height))
          path.lineToPoint(NSPoint.new(rect.origin.x + rect.size.width, rect.origin.y))
          path.stroke
        end
      else
        path = line_path_with_rect(rect)
        path.setLineWidth(graphic.stroke[:thickness])
        path.stroke
      end
    else
        @line1=@line_types_width_table[graphic.stroke[:type]][0]*graphic.stroke[:thickness]
        @line2=@line_types_width_table[graphic.stroke[:type]][1]*graphic.stroke[:thickness]
        w = @line1
        indentValue = (graphic.stroke[:thickness] - w)/-2.0
        if(graphic.stroke[:type] > 3)
            path = line_path_with_rect(rect)
            path.setLineWidth(@line2)
            path.stroke
        end
        new_rect=NSInsetRect(rect, indentValue, indentValue)
        path = line_path_with_rect(NSInsetRect(rect, indentValue, indentValue))
        path.setLineWidth(@line1)
        path.stroke
        if(graphic.stroke[:type] < 4)
          w = @line2
        end
        indentValue = (graphic.stroke[:thickness] - w)/2.0
        new_rect=NSInsetRect(rect, indentValue, indentValue)
        path = line_path_with_rect(NSInsetRect(rect, indentValue, indentValue))
        path.setLineWidth(w)
        path.stroke
    end
  end

end
