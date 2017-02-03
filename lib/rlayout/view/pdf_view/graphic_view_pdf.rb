
#shape
module RLayout
  class Graphic
    attr_accessor :cancas

    def to_pdf(canvas)
      # @fill.to_pdf(canvas) if @fill
      canvas.translate(0, 0) do
        canvas.rotate(@rotation)         if @rotation
        # canvas.fill_color('00ff00')
        @fill.to_pdf(canvas)
        @shape.to_pdf(canvas)
        canvas.fill
        @image_record.to_pdf(canvas)     if @image
        if @text_record
          # puts caller
          # @text_record.to_pdf(canvas)
          string = text_record.string
          puts "string:#{string}"
          font = 'Helvetica' unless font
          puts "font:#{font}"
          size = 100 unless size
          puts "size:#{size}"
          canvas.font(font, size: size)
          canvas.text(string, at: [100, 200])
          # canvas.stroke
        end
        # canvas.stroke                    if canvas.path
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

    def isFlipped
      true
    end
  end
end
