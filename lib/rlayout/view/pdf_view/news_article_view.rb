module RLayout

  class NewsArticleBox < NewsBox

    def save_pdf_with_ruby(output_path, options={})
      # puts "+++++++++++++ pdf using ruby+++++++++++++++"
      start_time    = Time.now
      style_service = RLayout::StyleService.shared_style_service
      @pdf_doc      = HexaPDF::Document.new
      style_service.pdf_doc = @pdf_doc
      load_fonts(@pdf_doc)
      page          = @pdf_doc.pages.add([0, 0, @width, @height])
      canvas        = page.canvas      
      style_service.set_canvas_text_style(canvas, 'body')
      @graphics.each_with_index do |column, i|
        column.graphics.each_with_index do |line, j|
          line.draw_pdf(canvas) if line.graphics.length > 0
        end
      end
      @floats.each do |float|
        float.draw_pdf(canvas) 
      end
      # draw article sides
      draw_stroke(canvas) if @stroke.sides != [0,0,0,0]
      @pdf_doc.write(output_path)
      if options[:jpg]
        convert_pdf2jpg(output_path, options)
      end
      ending_time = Time.now
      # puts "It took:#{ending_time - start_time}"
    end

    # read fonts from disk
    def load_fonts(pdf_doc)
      font_foleder = "/Users/Shared/SoftwareLab/font_width"
      Dir.glob("#{font_foleder}/*.ttf").each do |font_file|
        pdf_doc.fonts.add(font_file)
      end
    end
  end

  class Table < Container
    def draw_pdf(canvas, options={})
      @graphics.each do |table_row|
        table_row.draw_pdf(canvas) 
      end
    end
  end

  class TableRow < Container
    def draw_pdf(canvas, options={})
      return unless @graphics.length > 0
      if @graphics.first.class == RTextToken
        draw_tokens(canvas) 
      else
        @graphics.each{|table_cell| table_cell.draw_pdf(canvas)}
      end
    end

    def draw_tokens(canvas)
      @style_service = RLayout::StyleService.shared_style_service
      @style_service.set_canvas_text_style(canvas, 'body', adjust_size: @adjust_size)
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
          canvas.text(token.string, at:[x + token.x, y - token.height])
        end
      end
    end
  end

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
            font_name = 'Shinmoon'
          end
          font_size     = @para_style[:font_size]
          font_folder   = "/Users/Shared/SoftwareLab/font_width"
          font_file     = font_folder + "/#{font_name}.ttf"
          # TODO find font_wapper from font name
          font_wapper   = @pdf_doc.fonts.add(font_file)
          # canvas.fill_color(@para_style[:text_color]) if @para_style[:text_color]
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

  class TitleText < Container
    def draw_pdf(canvas, options={})
      # canvas.save_graphics_state do
        # canvas.font(font_wapper, size: size)
        @graphics.each do |line|
          line.draw_pdf(canvas)
        end
      # end
    end
  end

  class CaptionColumn < Container
    def draw_pdf(canvas, options={})
      @graphics.each do |line|
        line.draw_pdf(canvas)
      end
    end
  end

  class NewsHeadingForArticle < Container
    def draw_pdf(canvas, options={})
      if @subject_head_object
        @subject_head_object.draw_pdf(canvas, options) 
      end

      if @title_object
        @title_object.draw_pdf(canvas, options)        
      end
      if @subtitle_object
        @subtitle_object.draw_pdf(canvas, options)     
      end
    end
  end
  
  class NewsHeadingForEditorial < Container
    def draw_pdf(canvas, options={})
      @subject_head_object.draw_pdf(canvas) if @subject_head_object
      @title_object.draw_pdf(canvas)        if @title_object
      @subtitle_object.draw_pdf(canvas)     if @subtitle_object
    end
  end

  class NewsHeadingForOpinion < Container
    def draw_pdf(canvas, options={})
      @subject_head_object.draw_pdf(canvas) if @subject_head_object
      @title_object.draw_pdf(canvas)        if @title_object
      @subtitle_object.draw_pdf(canvas)     if @subtitle_object
    end
  end

  class NewsImage < Container
    def draw_pdf(canvas, options={})
      @canvas = canvas
      canvas.save_graphics_state do
        @image_box.draw_image(canvas) if @image_box
        @image_box.draw_stroke(canvas)
      end
      if @caption_column
        @caption_column.draw_pdf(@canvas) 
      end
    end
  end

  class NewsColumnImage < Container
    def draw_pdf(canvas, options={})
      pdf_doc = options[:pdf_doc]
      @image_box.draw_image(canvas) if @image_box
      if @caption_column
        @caption_column.draw_pdf(canvas) 
      end
    end
  end
  
end
