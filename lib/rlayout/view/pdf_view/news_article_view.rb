module RLayout
  class NewsArticleBox < NewsBox
  # For Fast PostScript generation
  # 1. draw tokens only, as fast as we can
  # 2. using only single font
    def save_pdf_with_ruby(output_path, options={})
      puts "+++++++++++++ pdf using ruby+++++++++++++++"
      start_time    = Time.now
      @pdf_doc      = HexaPDF::Document.new
      load_fonts(@pdf_doc)
      page          = @pdf_doc.pages.add([0, 0, @width, @height])
      canvas = page.canvas
      font_name     = 'shinmoon'
      size          = 9.8
      font_foleder  = "/Users/Shared/SoftwareLab/font_width"
      font_file     = font_foleder + "/#{font_name}.ttf"
      font_wapper   = @pdf_doc.fonts.add(font_file)
      canvas.font(font_wapper, size: size)
      @graphics.each do |column|
        column.graphics.each do |line|
          line.draw_pdf(canvas, pdf_doc: @pdf_doc) if line.graphics.length > 0
        end
      end
      @floats.each do |float|
        float.draw_pdf(canvas, pdf_doc: @pdf_doc) 
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
      @flipped = flipped_origin
      @start_x = flipped[0]
      @start_y = flipped[1]
      if @fill.color == 'red'
        canvas.save_graphics_state do
          # canvas.fill_color('ff0000').rectangle(start_x, start_y - @height, @width, @height).fill
          # use CMYK
          canvas.fill_color(0, 255, 254, 0).rectangle(@start_x, @start_y - @height, @width, @height).fill
        end
      end
      if @para_style[:korean_name] == "본문명조"
        draw_tokens(canvas)
      else 
        font_wapper   = options[:default_font]
        unless font_wapper
          pdf_doc       = options[:pdf_doc]
          font_foleder  = "/Users/Shared/SoftwareLab/font_width"
          font_file     = font_foleder + "/#{@para_style[:font]}.ttf"
          font_wapper   = pdf_doc.fonts.add(font_file)
        end
        canvas.save_graphics_state do
          # apply font, font_size, tracking, scale
          canvas.font(font_wapper, size: @para_style[:font_size])
          canvas.character_spacing(@para_style[:tracking])  if @para_style[:tracking] && @para_style[:tracking]!= 0
          canvas.horizontal_scale(@para_style[:scale])      if @para_style[:scale] && @para_style[:scale] != 100
          draw_tokens(canvas)
        end
      end
    end

    def draw_tokens(canvas)
      @graphics.each do |token|
        if @font_size.nil?
          @font_size = 9.4
        end
        #TODO
        # check for empasis token
        canvas.text(token.string, at:[@start_x + token.x, @start_y - @font_size])
      end
    end
  end

  class TitleText < Container
    def draw_pdf(canvas, options={})
      # get pdf_doc from camcas
      pdf_doc = options[:pdf_doc]
      size          = para_style[:font_size]
      font_foleder  = "/Users/Shared/SoftwareLab/font_width"
      font_file     = font_foleder + "/#{para_style[:font]}.ttf"
      font_wapper   = pdf_doc.fonts.add(font_file)
      canvas.save_graphics_state do
        canvas.font(font_wapper, size: size)
        @graphics.each do |line|
          line.draw_pdf(canvas, default_font:font_wapper, pdf_doc: pdf_doc)
        end
      end
    end
  end

  class CaptionColumn < Container
    def draw_pdf(canvas, options={})
      puts "in draw_pdf of CaptionColumn"
      # pdf_doc = options[:pdf_doc]
      # size          = para_style[:font_size]
      # font_foleder  = "/Users/Shared/SoftwareLab/font_width"
      # font_file     = font_foleder + "/#{font_name}.ttf"
      # font_wapper   = pdf_doc.fonts.add(font_file)
      # canvas.font(font_wapper, size: size)
      # @graphics.each do |line|
      #   line.draw_pdf(canvas)
      # end
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
      pdf_doc = options[:pdf_doc]
      @subject_head_object.draw_pdf(canvas) if @subject_head_object
      @title_objext.draw_pdf(canvas)        if @title_objext
      @subtitle_objext.draw_pdf(canvas)     if @subtitle_objext
    end
  end

  class NewsHeadingForOpinion < Container
    def draw_pdf(canvas, options={})
      pdf_doc = options[:pdf_doc]
      @subject_head_object.draw_pdf(canvas) if @subject_head_object
      @title_objext.draw_pdf(canvas)        if @title_objext
      @subtitle_objext.draw_pdf(canvas)     if @subtitle_objext
    end
  end

  class NewsImage < Container
    def draw_pdf(canvas, options={})
      pdf_doc = options[:pdf_doc]
      canvas.save_graphics_state do
        @image_box.draw_image(canvas) if @image_box
      end
      if @caption_column
        puts "@caption_column.class:#{@caption_column.class}"
        @caption_column.draw_pdf(canvas) 
      end
    end
  end

  class NewsColumnImage < Container
    def draw_pdf(canvas, options={})
      pdf_doc = options[:pdf_doc]
      @image_box.draw_image(canvas) if @image_box
      if @caption_column
        puts "@caption_column.class:#{@caption_column.class}"
        @caption_column.draw_pdf(canvas) 
      end
    end
  end
  
end
