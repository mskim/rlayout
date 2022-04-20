module RLayout

  class NewsArticleBox < NewsBox

    def save_pdf(output_path, options={})
      start_time    = Time.now
      style_service = RLayout::StyleService.shared_style_service
      @pdf_doc      = HexaPDF::Document.new
      style_service.pdf_doc = @pdf_doc
      page          = @pdf_doc.pages.add([0, 0, @width, @height])
      canvas        = page.canvas      
      style_service.set_canvas_text_style(canvas, 'body')
      @graphics.each_with_index do |column, i|
        column.graphics.each_with_index do |line, j|
          line.draw_pdf(canvas) 
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
    end
  end

  # class Table < Container
  #   def draw_pdf(canvas, options={})
  #     @graphics.each do |table_row|
  #       table_row.draw_pdf(canvas) 
  #     end
  #   end
  # end

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

  class NewsFloat < Container
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
