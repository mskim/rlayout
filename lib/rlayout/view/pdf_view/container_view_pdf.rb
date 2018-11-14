module RLayout
  class Container < Graphic
    attr_reader :pdf_doc


    def flipped_origin
      if @parent
        p_origin = @parent.flipped_origin
        if self.class.to_s == RLayout::RLineFragment.to_s
          return [ p_origin[0] + @left_margin + @x, p_origin[1] + @parent.height  - @top_margin - @y] # for text y orugin starts at the top
        end
        [ p_origin[0] + @left_margin + @x, p_origin[1] + @parent.height - @height - @top_margin - @y]

        # [@left_margin + @x, @height - (@top_margin  + @y)]
      else
        [@left_margin + @x, @top_margin  + @y]
      end
    end

    def save_pdf(path, options={})
      # Containernex
      if RUBY_ENGINE == 'rubymotion'
        @ns_view ||= GraphicViewMac.from_graphic(self)
        @ns_view.save_pdf(path, options)
      elsif RUBY_ENGINE == 'ruby'
        doc = HexaPDF::Document.new
        page = doc.pages.add([0, 0, @width, @height])
        canvas = page.canvas
        font_file = "/Library/Fonts/newspaper/Shinmoon.ttf"
        wrapper = doc.fonts.add(font_file)
        @graphics.each do |g|
          puts g.class
          g.to_pdf(canvas, wrapper)
        end
        @floats.each do |f|
          puts "float"
          puts f.class
          f.to_pdf(canvas, wrapper)
        end
        doc.write(output_path)
      end
    end

    def to_pdf(canvas, font_wapper)
      case self
      when  RLayout::RLineFragment
        canvas.font(font_wapper, size: 12)
        f = flipped_origin
        x = flipped_origin[0]
        y = f[1] + 3
        canvas.text(line_string, at: [x, y])
      else
        @graphics.each do |g|
          puts "+++ g.class:#{g.class}"
          g.to_pdf(canvas, font_wapper)
        end
      end
    end
  end
end