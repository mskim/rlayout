module RLayout

  class NewsArticleBox < NewsBox

    def save_pdf_with_ruby(output_path, options={})
      puts "+++++++++++++ pdf using ruby+++++++++++++++"
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
      @pdf_doc.write(output_path)
      if options[:jpg]
        convert_pdf2jpg(output_path)
      end
      ending_time = Time.now
      puts "It took:#{ending_time - start_time}"
    end

    # read fonts from disk
    def load_fonts(pdf_doc)
      font_foleder = "/Users/Shared/SoftwareLab/font_width"
      Dir.glob("#{font_foleder}/*.ttf").each do |font_file|
        pdf_doc.fonts.add(font_file)
      end
    end

    # using vips convert pdf 2 jpg
    # I could not get it to work with full path, had to cd into foloder first
    def convert_pdf2jpg(output_path)
      pdf_folder    = File.dirname(output_path)
      pdf_base_name = File.basename(output_path)
      jpg_base_name = pdf_base_name.gsub(/.pdf$/, ".jpg")
      commend  = "cd #{pdf_folder} && vips copy #{pdf_base_name}[n=-1] #{jpg_base_name}"
      system(commend)
    end
  end

  class RLineFragment < Container
    def draw_pdf(canvas, options={})
      return unless @graphics.length > 0
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
      # TODO can we use style_name here???
      if  @para_style && @para_style[:korean_name] == "본문명조"

        # TODO redo mixed token strategy, 
        # set style_name to empasied token only
          draw_tokens(canvas)
        # end
      elsif  @style_name && style_name == "caption"
        canvas.save_graphics_state do
          draw_mixed_style_tokens(canvas)
        end
      else 
        canvas.save_graphics_state do
          puts "+++++++++++++  @adjust_size:#{@adjust_size}"
          @style_service.set_canvas_text_style(canvas, @style_name, adjust_size: @adjust_size)
          draw_tokens(canvas)
        end
      end
    end

    def has_mixed_style_token?
      return true if @has_mixed_style_token
      current_style = @graphics.first.style_name
      @graphics.each do |token|
        return true if token.current_style != current_style
      end
      false
    end

    def draw_tokens(canvas)
      @graphics.each do |token|
        if @font_size.nil?
          @font_size = 9.4
        end
        canvas.text(token.string, at:[@start_x + token.x, @start_y - token.height])
      end
    end

    # line has mixed style tokens
    def draw_mixed_style_tokens(canvas)
      token = @graphics.first
      current_style_name = token.style_name
      @style_service.set_canvas_text_style(canvas, current_style_name)
      @graphics.each do |token|
        if token.style_name != current_style_name
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
      canvas.save_graphics_state do
        # canvas.font(font_wapper, size: size)
        @graphics.each do |line|
          line.draw_pdf(canvas)
        end
      end
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
      @title_objext.draw_pdf(canvas)        if @title_objext
      @subtitle_objext.draw_pdf(canvas)     if @subtitle_objext
    end
  end

  class NewsHeadingForOpinion < Container
    def draw_pdf(canvas, options={})
      @subject_head_object.draw_pdf(canvas) if @subject_head_object
      @title_objext.draw_pdf(canvas)        if @title_objext
      @subtitle_objext.draw_pdf(canvas)     if @subtitle_objext
    end
  end

  class NewsImage < Container
    def draw_pdf(canvas, options={})
      @canvas = canvas
      canvas.save_graphics_state do
        @image_box.draw_image(canvas) if @image_box
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
