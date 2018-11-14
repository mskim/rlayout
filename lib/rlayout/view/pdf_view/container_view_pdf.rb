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
        doc = HexaPDF::Document.new
        page = doc.pages.add([0, 0, @width, @height])
        canvas = page.canvas
        font_file = "/Library/Fonts/newspaper/Shinmoon.ttf"
        wrapper = doc.fonts.add(font_file)
        @graphics.each do |g|
          g.to_pdf(canvas, wrapper)
        end
        @floats.each do |f|
          f.to_pdf(canvas, wrapper)
        end
        doc.write(output_path)
      end
    end

    def to_pdf(canvas, font_wapper)
      case self
      when  RLayout::RLineFragment
        size = @font_size || 16
        canvas.font(font_wapper, size: size)
        f = flipped_origin
        x = flipped_origin[0]
        y = f[1] + 3
        @graphics.each do |token|
          canvas.text(token.string, at: [x + token.x, y])
        end
      else
        @graphics.each do |g|
          g.to_pdf(canvas, font_wapper)
        end
      end
    end
  end
end