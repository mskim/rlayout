module RLayout
  class RLineFragment < Container
    def to_svg
      return unless @graphics.length > 0
      @style_service = RLayout::StyleService.shared_style_service
      @start_x = @x
      @start_y = @y
      if has_mixed_style_token?
        line_svg = draw_mixed_style_tokens_svg
      else
        @style_service.set_canvas_text_style(canvas, @style_name, adjust_size: @adjust_size)
        line_svg += draw_tokens_svg    
      end
      line_svg
    end

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

    def draw_tokens_svg
      first_token = @graphics.first
      line_svg = "\n<g font-face=\"sans-serif\">\n"
      @graphics.each do |token|
        if @font_size.nil?
          @font_size = 9.4
        end
        if token.class == RLayout::Rectangle
          # rectangle is use to draw stoke around union token
          # align rect.x with first token.x
          token.x += @start_x
          line_svg = token.to_svg
        else
          line_svg = token.to_svg
        end
      end
      line_svg += "\n</g>\n"
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