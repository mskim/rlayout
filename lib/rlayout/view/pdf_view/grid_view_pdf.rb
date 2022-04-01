module RLayout
  class Grid < Graphic
    attr_accessor :pdf_doc, :flipped 

    def save_pdf(output_path, options={})
      start_time    = Time.now
      style_service = RLayout::StyleService.shared_style_service
      @pdf_doc      = HexaPDF::Document.new
      style_service.pdf_doc = @pdf_doc
      page          = @pdf_doc.pages.add([0, 0, @width, @height])
      canvas        = page.canvas      
      style_service.set_canvas_text_style(canvas, 'body')
      @graphics.each do |g|
        g.draw_pdf(canvas)
      end
      draw_stroke(canvas) if @stroke.sides != [0,0,0,0]
      @pdf_doc.write(output_path)
      if options[:jpg]
        convert_pdf2jpg(output_path)
      end
      ending_time = Time.now
    end

    # def to_pdf(canvas)
    def draw_pdf(canvas)
      # return if self.class == RDocument
      # @pdf_doc = parent.pdf_doc if parent
      draw_fill(canvas) unless self.class == RDocument
      @graphics.each do |g|
        g.draw_pdf(canvas)
      end
      # @floats.each do |g|
      #   g.draw_pdf(canvas)
      # end
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