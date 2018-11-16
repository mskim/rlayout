module RLayout
  class Container < Graphic
    attr_reader :pdf_doc


    def flipped_origin
      if @parent
        p_origin = @parent.flipped_origin
        [ p_origin[0] + @left_margin + @x, p_origin[1] + @parent.height - @height - @top_margin - @y]
      else
        [@left_margin + @x, @top_margin  + @y]
      end
    end

    def save_pdf(output_path, options={})
      # Containernex
      if RUBY_ENGINE == 'rubymotion'
        @ns_view ||= GraphicViewMac.from_graphic(self)
        @ns_view.save_pdf(output_path, options)
      elsif RUBY_ENGINE == 'ruby'
        doc = options[:pdf_doc]
        unless doc
          puts "pdf_doc not fount!!!"
          return 
        end
        page      = doc.pages.add([0, 0, @width, @height])
        canvas    = page.canvas
        font_file = "/Library/Fonts/newspaper/Shinmoon.ttf"
        wrapper   = doc.fonts.add(font_file)
        @graphics.each do |g|
          g.to_pdf(canvas, wrapper)
        end
        @floats.each do |f|
          f.to_pdf(canvas, wrapper)
        end
        doc.write(output_path)
      end
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

    def to_pdf(canvas, font_wapper)
      case self
      when  RLayout::RLineFragment 
        if @graphics.length > 0 && @para_style
          font_name = @para_style[:font] 
          size = @para_style[:font_size] if @para_style
          if canvas.font
            canvase_font_name = canvas.font.wrapped_font.font_name
            canvas_font_size = canvas.font_size
            if font_name == canvase_font_name && size == canvas_font_size
            elsif font_name != canvase_font_name
              font_foleder  = "/Users/Shared/SoftwareLab/font_width"
              font_file     = font_foleder + "/#{font_name}.ttf"
              doc           = canvas.context.document
              font_wapper   = doc.fonts.add(font_file)
              canvas.font(font_wapper, size: size)
            elsif size != canvas_font_size
                canvas.font(font_wapper, size: size)
            else
              font_foleder  = "/Users/Shared/SoftwareLab/font_width"
              font_file     = font_foleder + "/#{font_name}.ttf"
              doc           = canvas.context.document
              font_wapper   = doc.fonts.add(font_file)
              canvas.font(font_wapper, size: size)
            end
          else
            size = @para_style[:font_size] || 16
            # canvas.font(font_wapper, size: size)
            font_foleder  = "/Users/Shared/SoftwareLab/font_width"
            font_file     = font_foleder + "/Shinmoon.ttf"
            font_file     = font_foleder + "/#{font_name}.ttf" if font_name
            doc           = canvas.context.document
            font_wapper   = doc.fonts.add(font_file)
            canvas.font(font_wapper, size: size)
          end
          f = flipped_origin
          x = flipped_origin[0]
          y = f[1] + 3
          @graphics.each do |token|
            canvas.text(token.string, at: [x + token.x, y])
          end
        end
      else
        @graphics.each do |g|
          g.to_pdf(canvas, font_wapper)
        end
      end
    end
  end
end