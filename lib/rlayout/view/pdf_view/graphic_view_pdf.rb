
module RLayout
  class Graphic

    def to_pdf(canvas)
      puts @shape

      @shape.to_pdf(canvas)
      @fill.to_pdf(canvas)

      if @image_path
        puts "+++ draw image"
      end

      if @text_string
        string = @text_string
        canvas.font(@font, font: @font_size)
        canvas.text_matrix(1, 0, 0, 1, @X, flipped_y)
        canvas.text(@text_string, at: [100, 400])
        canvas.end_text
      end
      @stroke.to_pdf(canvas)
    end

    def flipped_y
      if @parent
      else
        @height - @top_margin - @top_inset
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
