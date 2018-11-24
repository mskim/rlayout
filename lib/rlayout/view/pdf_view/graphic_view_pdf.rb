
module RLayout
  class Graphic
    attr_accessor :flipped 
    def flipped_origin
      if @parent
        p_origin = @parent.flipped_origin
        [p_origin[0] + @left_margin + @x, p_origin[1] + @parent.height - @height - @top_margin - @top_inset - @y]
      else
        [@left_margin + @x, - @top_margin - @top_inset - @y]
      end
    end

    def to_pdf(canvas)
      @flipped = flipped_origin

      if !@fill.color
        @fill.color = 'CMYK=0,0,0,0 '
      end
      @fill.color = RLayout.color_from_string(@fill.color) if @fill.color.class == String
      if !@stroke.color
        @stroke.color = 'CMYK=0,0,0,0 '
      end
      @stroke.color = RLayout.color_from_string(@stroke.color) if @stroke.color.class == String

      case @shape
      when RLayout::RectStruct
        canvas.fill_color(@fill.color).rectangle(flipped[0],  flipped[1] , @width - @left_margin - @right_margin, @height - @top_margin - @bottom_margin).fill
        # canvas.fill_color(@fill.color).rectangle(@x - @left_margin, @y - @top_margin, @width - @left_margin - @right_margin, @height - @top_margin - @bottom_margin).fill
        draw_stroke(canvas)
      when RoundRectStruct
      when RoundRectStruct
      when RLayout::CircleStruct
        @flipped = flipped_origin
        circle = canvas.fill_color(@fill.color).stroke_color(@stroke.color).line_width(@stroke.thickness).circle(flipped[0] + @shape.r, flipped[1] + @shape.r, @shape.r).fill_stroke
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
