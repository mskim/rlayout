module RLayout
  class NewsArticleBox < NewsBox
  # For Fast PostScript generation
  # 1. draw tokens only, as fast as we can
  # 2. using only single font
    def save_pdf_with_ruby(pdf_doc, output_path, options={})
      puts "+++++++++++++ pdf using ruby+++++++++++++++"
      # @graphics.each do |column|
      #   column.save_pdf_text(canvas)
      # end
      start_time = Time.now
      @pdf_doc = HexaPDF::Document.new
      page = @pdf_doc.pages.add([0, 0, @width, @height])
      canvas = page.canvas
      # page      = @pdf_doc.pages.add([@x, @y, @width, @height])
      # canvas    = page.canvas
      # canvas = @pdf_doc.pages.add.canvas
      font_name     = 'shinmoon'
      size          = 9.8
      font_foleder  = "/Users/Shared/SoftwareLab/font_width"
      font_file     = font_foleder + "/#{font_name}.ttf"
      font_wapper   = @pdf_doc.fonts.add(font_file)
      canvas.font(font_wapper, size: size)
      @graphics.each do |column|
        column.graphics.each do |line|
          line.draw_pdf(canvas) if line.graphics.length > 0
        end
      end
      @floats.each do |float|
        float.draw_pdf(canvas, pdf_doc: @pdf_doc) 
      end
      @pdf_doc.write(output_path)
      ending_time = Time.now
      puts "It took:#{ending_time - start_time}"
    end
  end

  class TitleText < Container
    def draw_pdf(canvas, options={})
      pdf_doc = options[:pdf_doc]
      size          = para_style[:font_size]
      font_foleder  = "/Users/Shared/SoftwareLab/font_width"
      font_file     = font_foleder + "/#{para_style[:font]}.ttf"
      font_wapper   = pdf_doc.fonts.add(font_file)
      canvas.font(font_wapper, size: size)
      @graphics.each do |line|
        line.draw_pdf(canvas)
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
      @image_box.draw_image(canvas) if @image_box
      if @caption_column
        puts "@caption_column.class:#{@caption_column.class}"
        @caption_column.draw_pdf(canvas) 
      end
    end
  end

  class RLineFragment < Container
    def draw_pdf(canvas, options={})
      return unless @graphics.length > 0
      @flipped = flipped_origin
      start_x = flipped[0]
      start_y = flipped[1]
      # start_y = y
      @graphics.each do |token|
        if @font_size.nil?
          @font_size = 9.4
        end
        canvas.text(token.string, at:[start_x + token.x, start_y - @font_size])
      end
    end
  end
end
