module RLayout
  class Container < Graphic
    attr_reader :pdf_doc
    attr_accessor :flipped 

    def save_pdf(output_path, options={})
      
      if RUBY_ENGINE == 'rubymotion'
        @ns_view ||= GraphicViewMac.from_graphic(self)
        @ns_view.save_pdf(output_path, options)
      elsif RUBY_ENGINE == 'ruby'
        doc = options[:pdf_doc]
        unless doc
          doc = HexaPDF::Document.new
        end
        page      = doc.pages.add([0, 0, @width, @height])
        canvas    = page.canvas
        font_file = "/Library/Fonts/newspaper/Shinmoon.ttf"
        wrapper   = doc.fonts.add(font_file)
        @graphics.each do |g|
          g.to_pdf(canvas)
        end
        @floats.each do |f|
          # if f.class == RLayout::TitleText
          #   binding.pry
          # end 
          f.to_pdf(canvas)
        end
        doc.write(output_path)
      end
      self
    end


    #  pry(#<RLayout::RLineFragment>)> canvas.font.dict
    # => #<HexaPDF::Type::FontType0 [28, 0] value={:Type=>:Font, :Subtype=>:Type0, :BaseFont=>:Shinmoon, :Encoding=>:"Identity-H", :DescendantFonts=>[#<HexaPDF::Type::CIDFont [27, 0] value={:Type=>:Font, :Subtype=>:CIDFontType2, :BaseFont=>:Shinmoon, :FontDescriptor=>#<HexaPDF::Type::FontDescriptor [26, 0] value={:Type=>:FontDescriptor, :FontName=>:Shinmoon, :FontWeight=>400, :Flags=>4, :FontBBox=>[-2.0, -140.0, 1000.0, 869.0], :ItalicAngle=>0.0, :Ascent=>800.0, :Descent=>-200.0, :StemV=>80, :CapHeight=>700.0, :XHeight=>500.0}>, :CIDSystemInfo=>{:Registry=>"Adobe", :Ordering=>"Identity", :Supplement=>0}, :CIDToGIDMap=>:Identity}>]}>
    # [8] pry(#<RLayout::RLineFragment>)> canvas.font.dict.value
    # => {:Type=>:Font,
    #  :Subtype=>:Type0,
    #  :BaseFont=>:Shinmoon,
    #  :Encoding=>:"Identity-H",
    #  :DescendantFonts=>
    #   [#<HexaPDF::Type::CIDFont [27, 0] value={:Type=>:Font, :Subtype=>:CIDFontType2, :BaseFont=>:Shinmoon, :FontDescriptor=>#<HexaPDF::Type::FontDescriptor [26, 0] value={:Type=>:FontDescriptor, :FontName=>:Shinmoon, :FontWeight=>400, :Flags=>4, :FontBBox=>[-2.0, -140.0, 1000.0, 869.0], :ItalicAngle=>0.0, :Ascent=>800.0, :Descent=>-200.0, :StemV=>80, :CapHeight=>700.0, :XHeight=>500.0}>, :CIDSystemInfo=>{:Registry=>"Adobe", :Ordering=>"Identity", :Supplement=>0}, :CIDToGIDMap=>:Identity}>]}
    # [9] pry(#<RLayout::RLineFragment>)>
    # canvas.font.class.instance_methods(false)
    # [:encode, :subset?, :wrapped_font, :dict, :font_type, :scaling_factor, :glyph, :decode_utf8]

    def to_pdf(canvas)
      # @flipped = flipped_origin

      # if !@fill.color
      #   @fill.color = 'CMYK=0,0,0,0 '
      # end
      # if @fill.color.class == String
      #   if @fill.color == 'clear'
      #     #TODO set opacity
      #     # @fill.color = [0.0, 0.0, 0.0, 0.0]
      #   else
      #     @fill.color = RLayout.color_from_string(@fill.color) 
      #   end
      # end
      # if !@stroke.color
      #   @stroke.color = 'CMYK=0,0,0,0 '
      # end
      # @stroke.color = RLayout.color_from_string(@stroke.color) if @stroke.color.class == String
      # @stroke.color = RLayout.color_from_string(@stroke.color) if @stroke.color.class == String

      # case @shape
      # when RLayout::RectStruct
      #   unless @fill.color == 'clear'
      #     canvas.fill_color(@fill.color).rectangle(flipped[0],  flipped[1] , @width - @left_margin - @right_margin, @height - @top_margin - @bottom_margin).fill
      #   end
      #     # canvas.fill_color(@fill.color).rectangle(@x - @left_margin, @y - @top_margin, @width - @left_margin - @right_margin, @height - @top_margin - @bottom_margin).fill
      #   draw_stroke(canvas)
      # when RoundRectStruct
      # when RoundRectStruct
      # when RLayout::CircleStruct
      #   @flipped = flipped_origin
      #   circle = canvas.fill_color(@fill.color).stroke_color(@stroke.color).line_width(@stroke.thickness).circle(flipped[0] + @shape.r, flipped[1] + @shape.r, @shape.r).fill_stroke
      # when EllipseStruct
      # when PoligonStruct
      # when PathStruct
      # when LineStruct
      # end

      # case self
      # when  RLayout::RLineFragment 
      #   draw_text(canvas)
      # else

      # if self.class == RLayout::TitleText && @parent.class == RLayout::NewsArticleBox
      #   @flipped = flipped_origin
      #   puts "@parent.class:#{@parent.class}"
      #   # puts_frame
      #   @stroke.color = 'CMYK=0,0,0,100'
      #   @fill.color   = 'CMYK=0,0,100,0'
      #   @stroke.color = RLayout.color_from_string(@stroke.color) if @stroke.color.class == String
      #   @fill.color = RLayout.color_from_string(@fill.color) if @fill.color.class == String
      #   # canvas.stroke_color(@stroke.color).fill_color(@fill.color).rectangle(flipped[0],  flipped[1] , @width - @left_margin - @right_margin, @height - @top_margin - @bottom_margin).fill_stroke
      # end

      # if @parent.class == RLayout::TitleText && @parent.class == RLayout::NewsArticleBox
      #   binding.pry
      #   @flipped = flipped_origin
      #   puts "@parent.class:#{@parent.class}"
      #   # puts_frame
      #   @stroke.color = 'CMYK=0,0,0,100'
      #   @stroke.color = RLayout.color_from_string(@stroke.color) if @stroke.color.class == String
      #   # canvas.stroke_color(@stroke.color).rectangle(flipped[0],  flipped[1] , @width - @left_margin - @right_margin, @height - @top_margin - @bottom_margin).stroke
      # end

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