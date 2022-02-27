module RLayout
  class Container < Graphic
    attr_accessor :pdf_doc, :flipped 

    # This is called when the class is the root class
    # so, it has to create root @pdf_doc 
    def save_pdf_with_ruby(output_path, options={})
      style_service = RLayout::StyleService.shared_style_service
      @pdf_doc      = HexaPDF::Document.new
      style_service.pdf_doc = @pdf_doc
      load_fonts(@pdf_doc)
      page          = @pdf_doc.pages.add([0, 0, @width, @height])
      canvas        = page.canvas   
      style_service.set_canvas_text_style(canvas, 'body')
      draw_fill(canvas) unless self.class == RDocument
      @graphics.each do |g|
        g.draw_pdf(canvas, pdf_doc: @pdf_doc)
      end
      @floats.each do |float|
        float.draw_pdf(canvas) 
      end
      draw_stroke(canvas) if @stroke.sides != [0,0,0,0]
      @pdf_doc.write(output_path)
      if options[:page_pdf]
        split_pdf(output_path)
      end
      if options[:jpg]
        convert_pdf2jpg(output_path)
      end
      # ending_time = Time.now
      # puts "It took:#{ending_time - start_time}" if options[:time]
    end

    # read fonts from disk
    def load_fonts(pdf_doc)
      font_foleder = "/Users/Shared/SoftwareLab/font_width"
      Dir.glob("#{font_foleder}/*.ttf").each do |font_file|
        pdf_doc.fonts.add(font_file)
      end
    end

    # This is called from parent
    def draw_pdf(canvas, options={})
      @pdf_doc = parent.pdf_doc
      draw_fill(canvas)
      @graphics.each do |g|
        g.draw_pdf(canvas, pdf_doc: @pdf_doc)
      end
      @floats.each do |g|
        g.draw_pdf(canvas, pdf_doc: @pdf_doc)
      end
      draw_stroke(canvas) if @stroke.sides != [0,0,0,0]
    end

    def flipped_origin
      if @parent && @parent.class != RDocument && @parent.class != PictureSpread
        p_origin = @parent.flipped_origin
        [p_origin[0] + @x, p_origin[1] - @y]
      else
        # [@x + @left_margin, @height - @y]
        [@x , @height - @y]
      end
    end

    # This is called from class PrintPage to generate pdf page.
    # PrintPage had embeded a pdf_page into a larger page as Image, 
    # and drawn cutter marks and so on ...
    def to_pdf(options={})
      @pdf_doc      = HexaPDF::Document.new
      page          = @pdf_doc.pages.add([0, 0, @width, @height])
      canvas        = page.canvas      
      draw_fill(canvas) unless self.class == RDocument
      @graphics.each do |g|
        g.draw_pdf(canvas)
      end
      draw_stroke(canvas) if @stroke.sides != [0,0,0,0]
      @pdf_doc
    end
  end
end