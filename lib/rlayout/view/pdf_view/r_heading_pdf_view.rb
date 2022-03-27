module RLayout
  class RHeading < Container
    attr_accessor :pdf_doc, :flipped 

    def save_pdf_with_ruby(output_path, options={})
      # puts "genrateing pdf ruby "
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

    # def to_pdf(canvas)
    def draw_pdf(canvas, options={})
      @pdf_doc = parent.pdf_doc if parent
      flipped = flipped_origin
      @graphics.each do |g|
        g.draw_pdf(canvas)
      end
      @floats.each do |g|
        g.draw_pdf(canvas)
      end
      draw_stroke(canvas) if @stroke.sides != [0,0,0,0]
    end


  end
end