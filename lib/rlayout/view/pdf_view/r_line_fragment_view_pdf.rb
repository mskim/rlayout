module RLayout
  class RLineFragment < Container
    def draw_pdf(canvas, options={})
      return unless @graphics.length > 0
      @pdf_doc = parent.pdf_doc
      @style_service = RLayout::StyleService.shared_style_service
      @flipped = flipped_origin
      @start_x = flipped[0]
      @start_y = flipped[1]
      if @fill.color == 'red'
        canvas.save_graphics_state do
          canvas.fill_color(0, 255, 254, 0).rectangle(@start_x, @start_y - @height, @width, @height).fill
        end
      end
      # draw overflow x mark
      # @stroke.color == 'red'
      if @stroke.color == 'red' && @stroke[:sides] = [1,1,1,1,1,1]
        canvas.save_graphics_state do
          canvas.stroke_color(0, 255, 254, 0).rectangle(@start_x, @start_y - @height, @width, @height).stroke
          canvas.line(@start_x, @start_y, @start_x + @width, @start_y - @height).stroke
          canvas.line(@start_x, @start_y - @height, @start_x + @width, @start_y).stroke
        end
      end
      # can we use style_name here???
      # if  @para_style && @para_style[:korean_name] == "본문명조"
      #   # TODO redo mixed token strategy, 
      #   # set style_name to empasied token only
      #     draw_tokens(canvas)
      #   # end

      if  @style_name && @style_name == "caption"
        canvas.save_graphics_state do
          draw_mixed_style_tokens(canvas)
        end
      elsif @style_name
        canvas.save_graphics_state do
          if has_mixed_style_token?
            draw_mixed_style_tokens(canvas)
          else
            @style_service.set_canvas_text_style(canvas, @style_name, adjust_size: @adjust_size)
            draw_tokens(canvas)
          end
        end

      # this is line from Text, where there is no @style_name 
      # a free format text.
      #  Where did @para_style come from???
      elsif @para_style
        canvas.save_graphics_state do
          font_name     = @para_style[:font]
          if font_name =~/smSSMyungjoP-W35/
            font_name = 'KoPubBatangPM'
          end
          font_size     = @para_style[:font_size]
          font_folder   = "/Users/Shared/SoftwareLab/font_width"
          font_file     = font_folder + "/#{font_name}.ttf"
          doc           = canvas.context.document
          font_wapper   = doc.fonts.add(font_file)
          canvas.font(font_wapper, size: font_size) 
          if @para_style[:text_color] || @para_style[:font_color]
            color = @para_style[:text_color] if @para_style[:text_color]
            color = @para_style[:font_color] if @para_style[:font_color]
            adjusted_color = RLayout::color_from_string(color)
            canvas.fill_color(adjusted_color) 
          end
          canvas.font(font_wapper, size: font_size)
          draw_tokens(canvas)
        end
      end
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

    def draw_tokens(canvas)
      @graphics.each do |token|
        if @font_size.nil?
          @font_size = 9.4
        end
        if token.class == RLayout::Rectangle
          # rectangle is use to draw stoke around union token
          # align rect.x with first token.x
          token.x += @start_x 
          token.draw_pdf(canvas) # draw token_union_rect
        else
          canvas.text(token.string, at:[@start_x + token.x, @start_y - token.height])
        end
      end
    end

    # line has mixed style tokens
    def draw_mixed_style_tokens(canvas)
      token = @graphics.first
      current_style_name = token.style_name
      @style_service.set_canvas_text_style(canvas, current_style_name)
      @graphics.each do |token|
        if token.class == RLayout::Rectangle
          token.x += @start_x 
          token.draw_pdf(canvas) # draw token_union_rect
        elsif token.style_name != current_style_name
          current_style_name = token.style_name
          @style_service.set_canvas_text_style(canvas, current_style_name)
          canvas.text(token.string, at:[@start_x + token.x, @start_y - token.height])
        else
          canvas.text(token.string, at:[@start_x + token.x, @start_y - token.height])
        end
      end
    end

  end

end