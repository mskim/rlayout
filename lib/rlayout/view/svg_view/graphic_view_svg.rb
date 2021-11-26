
module RLayout

  class Graphic

    def self.from_svg(svg_text, options={})
      h = parse_svg(svg_text)
      Graphic.new(h)
    end

    def self.parse_svg(svg_text)
      # TODO: parse svg add klass attribute when saving, so that we can parse with RLyout::class
    end

    def to_svg
      if @parent
        return svg
      else
        svg_string = "<svg xmlns=\"http://www.w3.org/2000/svg\" xmlns:xlink=\"http://www.w3.org/1999/xlink\" width=\"#{@x + @width}px\" height=\"#{@y + @height}px\">\n"
        svg_string += svg
        svg_string += "\n</svg>\n"
        return svg_string
      end
    end

    def svg
      s = @shape.to_svg
      s = s.gsub!("style_place_holder", style_to_svg)
      s += @image_record.to_svg.gsub!("replace_this_with_rect", svg_rect) if @image_record
      s += @text_record.to_svg.gsub!("replace_this_with_text_origin", svg_text_origin) if @text_record
      s
    end

    def style_to_svg
      if @fill.class == FillStruct
        "style=\"fill:#{@fill.to_svg};#{@stroke.to_svg}\""
      elsif @fill.class == LinearGradient
        s =<<~E1
              <defs>
                <linearGradient id="grad1" x1="0%" y1="0%" x2="100%" y2="0%">
                  <stop offset="0%" style="stop-color:rgb(255,255,0);stop-opacity:1" />
                  <stop offset="100%" style="stop-color:rgb(255,0,0);stop-opacity:1" />
                </linearGradient>
              </defs>
              "style=\"fill:\"url(#grad1)\";#{@stroke.to_svg}\""

          E1

      elsif @fill.class == RadialGradient

        s2 =<<~EOF.gsub(/^\s*/, "")
              <defs>
              <linearGradient id="grad1" x1="0%" y1="0%" x2="100%" y2="0%">
                <stop offset="0%" style="stop-color:rgb(255,255,0);stop-opacity:1" />
                <stop offset="100%" style="stop-color:rgb(255,0,0);stop-opacity:1" />
              </linearGradient>
              </defs>
              "style=\"fill:\"url(#grad1)\";#{@stroke.to_svg}\""

        EOF
      end
    end

    def svg_rect
      "x=\"#{@x}\" y=\"#{@y}\" width=\"#{@width}\" height=\"#{height}\""
    end

    def svg_text_origin
      size = @text_record.size || 16
      "x=\"#{@x}\" y=\"#{@y + size*1.2}\""
    end

    def save_svg(path)
      File.open(path, 'w'){|f| f.write to_svg}
    end
  end

end
