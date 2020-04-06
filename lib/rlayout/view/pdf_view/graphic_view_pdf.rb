
module RLayout
  class Graphic
    attr_accessor :flipped 
    def flipped_origin
      if @parent
        p_origin = @parent.flipped_origin
        [p_origin[0] + @x, p_origin[1] - @y]
      else
        [@x, @height - @top_margin - @top_inset - @y]
      end
    end

    # def to_pdf(canvas)
    def draw_pdf(canvas)
      @pdf_doc = parent.pdf_doc if parent
      @flipped = flipped_origin
      draw_fill(canvas)
      draw_image(canvas) if @image_path || @local_image
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
