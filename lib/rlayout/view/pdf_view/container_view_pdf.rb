module RLayout
  class Container < Graphic
    attr_accessor :flipped 

    def save_pdf(output_path, options={})
      # Container_view_pdf
      if RUBY_ENGINE == 'rubymotion'
        @ns_view ||= GraphicViewMac.from_graphic(self)
        @ns_view.save_pdf(output_path, options)
      elsif RUBY_ENGINE == 'ruby'
        @pdf_doc = options[:pdf_doc]
        unless @pdf_doc
          @pdf_doc = HexaPDF::Document.new
        end
        page      = @pdf_doc.pages.add([0, 0, @width, @height])
        canvas    = page.canvas
        font_file = "/Library/Fonts/newspaper/Shinmoon.ttf"
        wrapper   = doc.fonts.add(font_file)
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
      end
      self
    end

    def to_pdf(canvas)
      @graphics.each do |g|
        g.to_pdf(canvas)
      end
      @floats.each do |g|
        g.to_pdf(canvas)
      end
      # end
    end
  end
end