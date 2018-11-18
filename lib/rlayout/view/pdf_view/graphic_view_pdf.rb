
module RLayout
  class Graphic

    def flipped_point(x, y)
      if @parent
        f_point = @parent.flipped_point(x,y)
       [ f_point[0] + x, f_point[1] + @parent.height - y]
      else
        [x, y]
      end
    end

    def flipped_origin
      if @parent
        p_origin = @parent.flipped_origin
       [ p_origin[0] + @left_margin + @x, p_origin[1] + @parent.height - @height - @top_margin - @y]
      else
        [@left_margin + @x, @top_margin  - @y]
      end
    end


    def flipped_y(y_position)
      if @parent
        p_origin = @parent.flipped_origin
        p_origin[1] + @parent.height  - y_position
      else
        @top_margin + y_position
      end
    end


    def flipped_x(x_position)
      if @parent
        p_origin = @parent.flipped_origin
        p_origin[0] + x_position
      else
        @left_margin + x_position
      end
    end

    def to_pdf(canvas)
      if !@fill.color
        @fill.color = white_color 
      elsif @fill.color.class == String
        @fill.color = color_from_string(@fill.color)
      end
      if !@stroke.color
        @stroke.color = white_color 
      elsif @stroke.color.class == String
        @stroke.color = color_from_string(@stroke.color)
      end

      case @shape
      when RLayout::RectStruct

        flipped_x = flipped_origin[0]
        flipped_y = flipped_origin[1]
        canvas.fill_color(@fill.color).rectangle(flipped_x ,  flipped_y , @width - @left_margin - @right_margin, @height - @top_margin - @bottom_margin).fill
        # canvas.fill_color(@fill.color).rectangle(@x - @left_margin, @y - @top_margin, @width - @left_margin - @right_margin, @height - @top_margin - @bottom_margin).fill
        draw_stroke(canvas)
      when RoundRectStruct
      when RoundRectStruct
      when RLayout::CircleStruct
        # puts "@fill.color:#{@fill.color}"
        # fill_color = @fill.color

        circle = canvas.fill_color(@fill.color).stroke_color(@stroke.color).line_width(@stroke.thickness).circle(@shape.cx, flipped_y(@shape.cy), @shape.r).fill_stroke
        # puts "@x/2:#{@x/2}"
        # puts "@y/2:#{@x/2}"
        # canvas.circle(440, 50, 30).fill_stroke
      when EllipseStruct
      when PoligonStruct
      when PathStruct
      when LineStruct
      end


      if @image_path
        canvas.image(@image_path, at: flipped_origin, width: @width, height: @height)
      end
    end

    def draw_fixtures(fixtures)
        fixtures.each do |child|
          draw_graphic_in_nsview(child)
        end
    end

    def draw_graphics(graphics)
      graphics.each do |child|
        child.to_pdf(canvas)
      end
    end

    def draw_floats(floats)
      floats.each do |child|
        child.to_pdf(canvas)
      end
    end

    def draw_grid_rects(graphic)
      # return if graphic.show_grid_rects == false
      # NSColor.yellowColor.set
      # if  graphic.grid_rects && graphic.grid_rects.length > 0
      #   graphic.grid_rects.each {|line| line.draw_grid_rect}
      # end
    end

  end

end
