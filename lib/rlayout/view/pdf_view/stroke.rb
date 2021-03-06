module RLayout
class Graphic
  attr_accessor :line_position, :stroke_rect
  def draw_stroke(canvas)
    if @stroke.color.class == String
      if @stroke.color == 'clear'
        @stroke.color = [0.0, 0.0, 0.0, 0.0]
      else
        @stroke.color = RLayout.color_from_string(@stroke.color) 
      end
    end
    # @stroke[:color]  = RLayout.color_from_string(@stroke[:color])   # if  @stroke[:color] =~ /^CMYK/
    draw_gutter_stroke(canvas) if self.respond_to?(:gutter_stroke) && @draw_gutter_stroke
    return if @stroke[:thickness].nil? || @stroke[:thickness] == 0
    canvas.save_graphics_state do
      case @shape
      when RLayout::RectStruct || 'rect'
        @stroke_rect    = get_stroke_rect
        @line_position  = 1
        @left_inset     +=  2
        draw_sides(canvas) unless @stroke[:sides] == [0,0,0,0]
      when RoundRectStruct
      when RLayout::CircleStruct 
        flipped = flipped_origin unless flipped
        circle = canvas.stroke_color(@stroke.color).line_width(@stroke.thickness).circle(flipped[0] + @shape.r, flipped[1] - @shape.r, @shape.r).stroke

        # circle = canvas.stroke_color(@stroke.color).line_width(@stroke.thickness).circle(flipped[0] + @shape.r, flipped[1] + @shape.r, @shape.r).stroke
        # circle = canvas.fill_color(@fill.color).circle(flipped[0] + @shape.r, flipped[1] + @shape.r, @shape.r).fill
        # canvas.fill_color(@fill.color).rectangle(@x - @left_margin, @y - @top_margin, @width - @left_margin - @right_margin, @height - @top_margin - @bottom_margin).fill

      when EllipseStruct
      when PoligonStruct
      when PathStruct
      when LineStruct
        flipped = flipped_origin
        draw_line(canvas, flipped[0], flipped[1], flipped[0] + @width, flipped[1] - @height)
      else
        @stroke_rect    = get_stroke_rect
        @line_position  = 1
        @left_inset     +=  2
        draw_sides(canvas) unless @stroke[:sides] == [0,0,0,0]
        # canvas.fill_color(@fill.color).rectangle(@x - @left_margin, @y - @top_margin, @width - @left_margin - @right_margin, @height - @top_margin - @bottom_margin).fill
      end
    end


    # @stroke_rect    = get_stroke_rect
    # @line_position  = 1
    # @left_inset     +=  2
    # draw_sides(canvas) unless @stroke[:sides] == [0,0,0,0]
  end

  #TODO
  def draw_gutter_stroke(canvas)
  end 
  
  def draw_line(canvas, starting_x, starting_y, ending_x, ending_y, options={})
    # TODO fix stroke_color setting
    canvas.save_graphics_state do
      thickness = @stroke[:thickness]
      thickness = options[:thickness] if options[:thickness]
      canvas.line_width(thickness)
      stroke_color  = @stroke[:color]
      canvas.stroke_color(stroke_color)
      # canvas.stroke_color(stroke_color)
      # canvas.stroke_color(0,0,0,254).line(starting_x, starting_y, ending_x, ending_y).stroke
      canvas.line(starting_x, starting_y, ending_x, ending_y).stroke
    end
  end

  def draw_sides(canvas)

    rect = stroke_rect
    flipped = flipped_origin
    if @stroke[:type]==nil
      @stroke[:type] = 0
    end

    # if @graphic.class == RLayout::Line
    #   draw_line(canvas, @x, flip_y(@y), x_max, @height, @stroke[:thickness])
    #   return
    # end

    # @stroke[:type] == 0 means single line
    # @stroke[:type] > 0 means double or triple line
    if(@stroke[:type] == 0)

      # if side are not simple, stroke each sides
      if @stroke[:sides] != [1,1,1,1] #TODO check for rectangle or roundrect
        line_inset        = @stroke[:thickness]/2
        # bottom_left       = [@x + @left_margin + line_inset, flipped[1] + @top_margin - @height + line_inset]
        bottom_left       = [flipped[0] + line_inset, flipped[1] + @top_margin - @height + line_inset]
        # top_left          = [@x + @left_margin + line_inset, flipped[1] - @top_margin - line_inset]
        top_left          = [flipped[0] + line_inset, flipped[1] - @top_margin - line_inset]
        # top_right         = [@x + @width - @right_margin - line_inset, flipped[1] - @top_margin - line_inset]
        top_right         = [flipped[0] + @width - @right_margin - line_inset, flipped[1] - @top_margin - line_inset]
        bottom_right      = [flipped[0] + @width - @right_margin + line_inset, flipped[1] + @top_margin - @height - line_inset]
        # for custom newspaper box 
        open_bottom_left  = [flipped[0] + @x + @left_margin, flipped[1] + @bottom_margin - @height + line_inset]
        open_top_left     = [flipped[0] + @x + @left_margin, flipped[1] - @top_margin - line_inset]
        open_inner_bottom_left  = [flipped[0] + @x + @left_margin + @left_inset, flipped[1] + @bottom_margin - @height + line_inset]
        open_inner_top_left     = [flipped[0] + @x + @left_margin + @left_inset, flipped[1] - @top_margin - line_inset]
        @open_left_inset_line = @stroke[:sides].length >= 4 && @stroke[:sides].last == "open_left_inset_line"

        if @stroke[:sides][0] > 0
          if @open_left_inset_line
            draw_line(canvas, open_bottom_left[0], open_bottom_left[1] , open_top_left[0] , open_top_left[1], thickness: @stroke[:thickness]*@stroke[:sides][0])
          else
            draw_line(canvas, bottom_left[0], bottom_left[1] , top_left[0] , top_left[1],  thickness: @stroke[:thickness]*@stroke[:sides][0])
          end
        end

        if @stroke[:sides][1] > 0
          if @open_left_inset_line
            draw_line(canvas, open_inner_top_left[0], open_inner_top_left[1], top_right[0], top_right[1], thickness: @stroke[:thickness]*@stroke[:sides][1])
          else
            draw_line(canvas, top_left[0], top_left[1], top_right[0], top_right[1],  thickness: @stroke[:thickness]*@stroke[:sides][1])
          end
        end

        if @stroke[:sides][2] > 0
          if @open_left_inset_line
            draw_line(canvas, open_top_right[0], open_top_right[1], bottom_right[0], bottom_right[1], thickness:  @stroke[:thickness]*@stroke[:sides][2])
          else
            draw_line(canvas, top_right[0], top_right[1], bottom_right[0], bottom_right[1],  thickness: @stroke[:thickness]*@stroke[:sides][2])
          end
        end

        if @stroke[:sides][3] > 0
          if @open_left_inset_line
            draw_line(canvas, open_inner_bottom_left[0], open_inner_bottom_left[1], bottom_right[0], bottom_right[1],  thickness: @stroke[:thickness]*@stroke[:sides][3])
          else
            draw_line(canvas, bottom_left[0], bottom_left[1], bottom_right[0], bottom_right[1],  thickness:  @stroke[:thickness]*@stroke[:sides][3])
          end
        end

        # if [1,1,1,1,1,1] drawing x mark
        # draw top-left to bottom-right
        if @stroke[:sides][4] && @stroke[:sides][4].class != String && @stroke[:sides][4] > 0
          draw_line(canvas, top_left[0] , top_left[1], bottom_right[0], bottom_right[1],  thickness: @stroke[:thickness]*@stroke[:sides][4])
        end

        # draw bottom-left to top-right
        if @stroke[:sides][5] &&  @stroke[:sides][5] > 0
          draw_line(canvas, top_right[0], top_right[1], bottom_left[0], bottom_left[1],  thickness: @stroke[:thickness]*@stroke[:sides][5])
        end
      else
        canvas.line_width(@stroke[:thickness]).stroke_color(@stroke[:color]).rectangle(flipped[0] + @left_margin, flipped[1] + @top_margin - @height, @width - @left_margin - @right_margin, @height - @top_margin - @bottom_margin).stroke
      end
    else
        # @line1=@line_types_width_table[@stroke[:type]][0]*@stroke[:thickness]
        # @line2=@line_types_width_table[@stroke[:type]][1]*@stroke[:thickness]
        # w = @line1
        # indentValue = (@stroke[:thickness] - w)/-2.0
        # if(@stroke[:type] > 3)
        #     path = line_path_with_rect(rect)
        #     path.setLineWidth(@line2 + trap)
        #     path.stroke
        # end
        # new_rect=NSInsetRect(rect, indentValue, indentValue)
        # path = line_path_with_rect(NSInsetRect(rect, indentValue, indentValue))
        # path.setLineWidth(@line1 + trap)
        # path.stroke
        # if(@stroke[:type] < 4)
        #   w = @line2
        # end
        # indentValue = (@stroke[:thickness] - w)/2.0
        # new_rect=NSInsetRect(rect, indentValue, indentValue)
        # path = line_path_with_rect(NSInsetRect(rect, indentValue, indentValue))
        # path.setLineWidth(w + trap)
        # path.stroke
    end
  end

end
end