module RLayout
  class Container < Graphic
    attr_accessor :pdf_doc, :flipped 

    def save_pdf_with_ruby(output_path, options={})
      # Container_view_pdf
      @pdf_doc = options[:pdf_doc]
      unless @pdf_doc
        style_service = RLayout::StyleService.shared_style_service
        @pdf_doc = HexaPDF::Document.new
        style_service.pdf_doc = @pdf_doc
        load_fonts(@pdf_doc) 
      end
      page      = @pdf_doc.pages.add([0, 0, @width, @height])
      canvas    = page.canvas
      @flipped  = flipped_origin
      if @fill.color.class == String
        if @fill.color == 'clear'
          #TODO set opacity
          # @fill.color = [0.0, 0.0, 0.0, 0.0]
        else
          @fill.color = RLayout.color_from_string(@fill.color) 
        end
      end
      if !@stroke.color
        @stroke.color = 'CMYK=0,0,0,0 '
      end
      @stroke.color = RLayout.color_from_string(@stroke.color) if @stroke.color.class == String
      draw_stroke(canvas)

      case @shape
      when RLayout::RectStruct
        @fill.color = RLayout.color_from_string(@fill.color) if @fill.color.class == String
        unless @fill.color == 'clear'
          canvas.fill_color(@fill.color).rectangle(flipped[0],  flipped[1] , @width - @left_margin - @right_margin, @height - @top_margin - @bottom_margin).fill
        end
        canvas.fill_color(@fill.color).rectangle(@x - @left_margin, @y - @top_margin, @width - @left_margin - @right_margin, @height - @top_margin - @bottom_margin).fill
        draw_stroke(canvas)
      when RoundRectStruct
      when RLayout::CircleStruct
        @flipped = flipped_origin
        circle = canvas.fill_color(@fill.color).stroke_color(@stroke.color).line_width(@stroke.thickness).circle(flipped[0] + @shape.r, flipped[1] + @shape.r, @shape.r).fill_stroke
      when EllipseStruct
      when PoligonStruct
      when PathStruct
      when LineStruct
      else
        unless @fill.color == 'clear'
          canvas.fill_color(@fill.color).rectangle(flipped[0],  flipped[1] , @width - @left_margin - @right_margin, @height - @top_margin - @bottom_margin).fill
        end
          # canvas.fill_color(@fill.color).rectangle(@x - @left_margin, @y - @top_margin, @width - @left_margin - @right_margin, @height - @top_margin - @bottom_margin).fill
        draw_stroke(canvas)
      end

      @graphics.each do |g|
        g.to_pdf(canvas)
      end
      @floats.each do |f|
        f.to_pdf(canvas)
      end
      
      @pdf_doc.write(output_path)
      self
    end

    # read fonts from disk
    def load_fonts(pdf_doc)
      font_foleder = "/Users/Shared/SoftwareLab/font_width"
      Dir.glob("#{font_foleder}/*.ttf").each do |font_file|
        pdf_doc.fonts.add(font_file)
      end
    end

    # using vips convert pdf 2 jpg
    # I could not get it to work with full path, had to cd into foloder first
    def convert_pdf2jpg(output_path)
      pdf_folder    = File.dirname(output_path)
      pdf_base_name = File.basename(output_path)
      jpg_base_name = pdf_base_name.gsub(/.pdf$/, ".jpg")
      commend  = "cd #{pdf_folder} && vips copy #{pdf_base_name}[n=-1] #{jpg_base_name}"
      system(commend)
    end
    
    # def to_pdf(canvas)
    def draw_pdf(canvas)
      @pdf_doc = parent.pdf_doc if parent
      @graphics.each do |g|
        g.draw_pdf(canvas)
      end
      @floats.each do |g|
        g.draw_pdf(canvas)
      end
      # end
    end


  end
end