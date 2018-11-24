module RLayout
  class Container < Graphic
    attr_reader :pdf_doc

    def save_pdf(output_path, options={})
      # Containernex
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
      case self
      when  RLayout::RLineFragment 
        draw_text(canvas)
      else
        @graphics.each do |g|
          g.to_pdf(canvas)
        end
        @floats.each do |g|
          g.to_pdf(canvas)
        end
      end
    end
  end
end