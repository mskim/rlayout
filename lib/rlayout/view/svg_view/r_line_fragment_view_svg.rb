module RLayout
  class RLineFragment < Container
    def to_svg
      line_svg = ""
      return line_svg unless @graphics.length > 0
      @start_x = @x
      @start_y = @y
      if has_mixed_style_token?
        line_svg += draw_tokens_svg
      else
        line_svg += draw_tokens_svg    
      end
      line_svg
    end

    # TODO: fix this
    def has_mixed_style_token?
      return true if @has_mixed_style_token == true
      @graphics.shift if @graphics.first.class == RLayout::NewLineToken
      current_style_name = @graphics.first.style_name
      @graphics.each do |token|
        next if token.class != RLayout::RTextToken
        return true if token.style_name != current_style_name
      end
      false
    end

    def draw_line_text_svg
      if @text_alignment == 'justified'
        line_svg = "\n<g font-size=\"9\" font-face=\"sans-serif\">\n"
        line_svg += "<text x=\"#{@x}\" y=\"#{@y}\" textLength=\"#{@width}\" lengthAdjust=\"spacingAndGlyphs\">#{line_string}\"</text>"
        line_svg += "\n</g>"
      else
        draw_tokens_svg
      end
    end

    def draw_tokens_svg
      first_token = @graphics.first
      line_svg = "\n<g transform=\"translate(#{@x},#{@y})\" font-size=\"9\" font-face=\"sans-serif\">\n"
      @graphics.each do |token|
        if @font_size.nil?
          @font_size = 9.4
        end
        if token.class == RLayout::Rectangle
          # rectangle is use to draw stoke around union token
          # align rect.x with first token.x
          token.x += @start_x
          line_svg += token.to_svg
        else
          line_svg += token.to_svg
        end
      end
      line_svg += "\n</g>"
      line_svg
    end

    # line has mixed style tokens
    def draw_mixed_style_tokens_svg
      line_svg = "\n"
      @graphics.each do |token|
        if token.class == RLayout::Rectangle
          token.x += @start_x 
          line_svg += token.to_svg_with_style
        else
          line_svg += token.to_svg_with_style
        end
      end
      line_svg
    end

  end

end