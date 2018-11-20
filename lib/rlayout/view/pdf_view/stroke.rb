module RLayout
class Graphic
  attr_accessor :line_position, :stroke_rect
  def draw_stroke(canvas)
    draw_gutter_stroke(canvas) if self.respond_to?(:gutter_stroke) && @draw_gutter_stroke
    return if @stroke[:thickness].nil? || @stroke[:thickness] == 0
    @stroke_rect    = get_stroke_rect
    @line_position  = 1
    @left_inset     +=  2
    draw_sides(canvas)
    #TODO
    # drawArrow if @start_arrow && @owner_graphic
  end

  #TODO
  def draw_gutter_stroke(canvas)
  end 
  
  def draw_line(canvas, starting_x, starting_y, ending_x, ending_y, thickness)
    canvas.line_width(thickness).line(flipped[0] + starting_x, flipped[1] - starting_y, flipped[0] + ending_x, flipped[1] - ending_y).stroke
    # canvas.line_width(thickness).line(flipped_start[0], flipped_start[1], flipped_end[0], flipped_end[1]).stroke
  end

  def draw_sides(canvas)
    rect = @stroke_rect
    @stroke[:color]  = color_from_string(@stroke[:color])    if  @stroke[:color] =~ /^CMYK/
    canvas.fill_color(@stroke[:color])
    if @stroke[:type]==nil
      @stroke[:type] = 0
    end

    if @graphic.class == RLayout::Line
      draw_line(canvas, @x, flip_y(@y), x_max, y_max, @stroke[:thickness])
      return
    end

    # @stroke[:type] == 0 means single line
    # @stroke[:type] > 0 means double or triple line
    if(@stroke[:type] == 0)

      # if side are not simple, stroke each sides
      if @stroke[:sides] != [1,1,1,1] #TODO check for rectangle or roundrect
        # open_left_inset_line do not draw top and bottom inset area

        # TODO open_right_inset_line
        @open_left_inset_line = @stroke[:sides].length >= 4 && @stroke[:sides].last == "open_left_inset_line"
        
        # "draw left side"
        if @stroke[:sides][0] > 0
          draw_line(canvas, [@x,@y] , [@x,y_max], @stroke[:thickness]*@stroke[:sides][0])
        end

        # "draw top"
        if @stroke[:sides][1] > 0
          if @open_left_inset_line
            draw_line(canvas, @x + @left_inset, @y , x_max, @y, @stroke[:thickness]*@stroke[:sides][1])
          else
            draw_line(canvas, @x, @y , x_max, @y, @stroke[:thickness]*@stroke[:sides][1])
          end
        end

        # "draw right"
        if @stroke[:sides][2] > 0
          draw_line(canvas, x_max, @y , x_max, y_max, @stroke[:thickness]*@stroke[:sides][2])
        end

        # "draw bottom"
        if @stroke[:sides][3] > 0
          if @open_left_inset_line
            draw_line(canvas, @x + @left_inset,y_max, x_max, y_max, @stroke[:thickness]*@stroke[:sides][3])
          else
            draw_line(canvas, @x, y_max , x_max, y_max, @stroke[:thickness]*@stroke[:sides][3])
          end
        end

        # if [1,1,1,1,1,1] drawing x mark
        # draw top-left to bottom-right
        if @stroke[:sides][4] && @stroke[:sides][4].class != String && @stroke[:sides][4] > 0
          draw_line(canvas, @x, @y, x_max, y_max, @stroke[:thickness]*@stroke[:sides][4])
        end

        # draw bottom-left to top-right
        if @stroke[:sides][5] &&  @stroke[:sides][5] > 0
          draw_line(canvas, x_max, @y, @x, y_max, @stroke[:thickness]*@stroke[:sides][5])
        end

      else
        canvas.line_width(@stroke[:thickness]).rectangle(flipped[0] + @left_margin, flipped_origin[1] + @top_margin, @width - @left_margin - @right_margin, @height - @top_margin - @bottom_margin).stroke
        # canvas.line_width(@stroke[:thickness]).rectangle(@x + @left_margin, @y + @top_margin, @width - @left_margin - @right_margin, @height - @top_margin - @bottom_margin).stroke
      end
    else
        # @line1=@line_types_width_table[@stroke[:type]][0]*@stroke[:thickness]
        # @line2=@line_types_width_table[@stroke[:type]][1]*@stroke[:thickness]
        # w = @line1
        # indentValue = (@stroke[:thickness] - w)/-2.0
        # if(@stroke[:type] > 3)
        #     path = linePathWithRect(rect)
        #     path.setLineWidth(@line2 + trap)
        #     path.stroke
        # end
        # new_rect=NSInsetRect(rect, indentValue, indentValue)
        # path = linePathWithRect(NSInsetRect(rect, indentValue, indentValue))
        # path.setLineWidth(@line1 + trap)
        # path.stroke
        # if(@stroke[:type] < 4)
        #   w = @line2
        # end
        # indentValue = (@stroke[:thickness] - w)/2.0
        # new_rect=NSInsetRect(rect, indentValue, indentValue)
        # path = linePathWithRect(NSInsetRect(rect, indentValue, indentValue))
        # path.setLineWidth(w + trap)
        # path.stroke
    end
  end

end
end