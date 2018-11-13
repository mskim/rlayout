module RLayout
  class Container < Graphic

    def save_pdf(path, options={})
      # Containernex
      if RUBY_ENGINE == 'rubymotion'
        @ns_view ||= GraphicViewMac.from_graphic(self)
        @ns_view.save_pdf(path, options)
      elsif RUBY_ENGINE == 'ruby'
        unless @parent
          doc       = HexaPDF::Document.new
          page      = doc.pages.add([@x, @y, @width, @height])
          canvas    = page.canvas
        end
        to_pdf(canvas)
        doc.write(path, optimize: true)
      end
    end

    def to_pdf(canvas)
      if self.class == RLayout::RLineFragment
        canvas.font('Times', size: 10)
        puts line_string
        f = flipped_origin
        x = flipped_origin[0]
        y = f[1] + @height + 3
        canvas.text(line_string, at: [x, y])
      else
        @graphics.each do |g|
          g.to_pdf(canvas)
        end
      end
    end
  end
end