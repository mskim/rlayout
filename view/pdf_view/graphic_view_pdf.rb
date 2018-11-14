
#shape
module RLayout
  class Graphic
    def to_pdf(canvas, font_wapper)
      puts canvas.class
      # @fill.to_pdf(canvas) if @fill
      puts "@x, #{@x}"
      puts "@y, #{@y}"
      canvas.translate(@x, @y) do
        # canvas.rotate(@rotation)         if @rotation
        if @fill
          # canvas.fill_color('ff0000')
          # @fill.to_pdf(canvas)
          # @shape.to_pdf(canvas)
          puts "+++++++++ canvas.graphics_object:#{canvas.graphics_object}"
        end


        # canvas.fill
        # @image_record.to_pdf(canvas)     if @image
        # puts "in graphic to_pdf"
        # puts "@text_record:#{@text_record}"
        if @text_record
          string = "Some text!!"
          canvas.font('Helvetica', size: 16)
          canvas.text_matrix(16, 0, 0, -16, 100, 400)
          canvas.text(string, at: [100, 400])
          canvas.end_text
        end
        # puts "after canvas.text +++++++++ canvas.graphics_object:#{canvas.graphics_object}"
        # canvas.fill
        # if @text_record
        #   puts "has @text_record"
        #   # puts caller
        #   # @text_record.to_pdf(canvas)
        #   string = text_record.string
        #   puts "string:#{string}"
        #   font = 'Helvetica' unless font
        #   puts "font:#{font}"
        #   size = 100 unless size
        #   puts "size:#{size}"
        #   canvas.font(font, size: size)
        #   canvas.text(string, at: [100, 200])
        #   # canvas.stroke
        # end
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
