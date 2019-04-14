
module RLayout
  class Graphic
    attr_accessor :flipped 
    def flipped_origin
      if @parent
        p_origin = @parent.flipped_origin
        [p_origin[0] + @x, p_origin[1] + @y]
      else
        # [@x, @height - @top_margin - @top_inset - @y]
        [@x, @y + @height]
      end
    end

    def to_pdf(canvas)
      @flipped = flipped_origin
      draw_fill(canvas)
      # if !@stroke.color
      #   @stroke.color = 'CMYK=0,0,0,0 '
      # end
      # @stroke.color = RLayout.color_from_string(@stroke.color) if @stroke.color.class == String

      # case @shape
      # when RLayout::RectStruct
      #   @fill.color == 'red'
      #   unless @fill.color == 'clear'
      #     canvas.fill_color(@fill.color).rectangle(flipped[0],  flipped[1] - @height, @width - @left_margin - @right_margin, @height - @top_margin - @bottom_margin).fill
      #   end
      #     # canvas.fill_color(@fill.color).rectangle(@x - @left_margin, @y - @top_margin, @width - @left_margin - @right_margin, @height - @top_margin - @bottom_margin).fill
      # when RoundRectStruct
      # when RLayout::CircleStruct
      #   circle = canvas.fill_color(@fill.color).stroke_color(@stroke.color).line_width(@stroke.thickness).circle(flipped[0] + @shape.r, flipped[1] + @shape.r, @shape.r).fill_stroke
      # when EllipseStruct
      # when PoligonStruct
      # when PathStruct
      # when LineStruct
      # else
      #   unless @fill.color == 'clear'
      #     canvas.fill_color(@fill.color).rectangle(flipped[0],  flipped[1] , @width - @left_margin - @right_margin, @height - @top_margin - @bottom_margin).fill
      #   end
      #     # canvas.fill_color(@fill.color).rectangle(@x - @left_margin, @y - @top_margin, @width - @left_margin - @right_margin, @height - @top_margin - @bottom_margin).fill
      # end
      draw_image(canvas) if @image_path
      draw_text_in_ruby(canvas)  if @has_text
      draw_stroke(canvas)
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
