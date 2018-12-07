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

          f.to_pdf(canvas)
        end
        doc.write(output_path)
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