module RLayout
  class Container < Graphic
    attr_accessor :pdf_doc, :flipped 

    def save_pdf_with_ruby(output_path, options={})
      # puts "genrateing pdf ruby "
      start_time    = Time.now
      style_service = RLayout::StyleService.shared_style_service
      @pdf_doc      = HexaPDF::Document.new
      style_service.pdf_doc = @pdf_doc
      load_fonts(@pdf_doc)
      page          = @pdf_doc.pages.add([0, 0, @width, @height])
      canvas        = page.canvas      
      style_service.set_canvas_text_style(canvas, 'body')
      draw_fill(canvas) unless self.class == RDocument
      @graphics.each do |g|
        g.draw_pdf(canvas)
      end
      @floats.each do |float|
        float.draw_pdf(canvas) 
      end
      draw_stroke(canvas) if @stroke.sides != [0,0,0,0]
      @pdf_doc.write(output_path)
      if options[:jpg]
        convert_pdf2jpg(output_path)
      end
      ending_time = Time.now
      # puts "It took:#{ending_time - start_time}" if options[:time]
    end

    # read fonts from disk
    def load_fonts(pdf_doc)
      font_foleder = "/Users/Shared/SoftwareLab/font_width"
      Dir.glob("#{font_foleder}/*.ttf").each do |font_file|
        pdf_doc.fonts.add(font_file)
      end
    end

    # def to_pdf(canvas)
    def draw_pdf(canvas)
      # return if self.class == RDocument
      # @pdf_doc = parent.pdf_doc if parent
      draw_fill(canvas) unless self.class == RDocument
      @graphics.each do |g|
        g.draw_pdf(canvas)
      end
      @floats.each do |g|
        g.draw_pdf(canvas)
      end
      # end
    end

    def flipped_origin
      if @parent && @parent.class != RDocument
        p_origin = @parent.flipped_origin
        [p_origin[0] + @x, p_origin[1] - @y]
      else
        [@x, @height - @y]
      end
    end

  end
end