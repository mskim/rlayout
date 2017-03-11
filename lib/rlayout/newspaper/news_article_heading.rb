module RLayout

  class NewsArticleHeading < Container
    attr_accessor :grid_frame, :grid_width, :body_line_height

    def initialize(options={})
      @grid_width       = options.fetch(:grid_width, 2)
      @body_line_height = options.fetch(:body_line_height, 12)
      super
      self
    end

    def set_heading_content(options)
      # options = transform_keys_to_symbols(options)
      if options[:title]
        @title_object = title(options[:title], options)
      end
      if options[:subtitle]
        @subtitle_object = subtitle(options[:subtitle], options)
      end
      if options[:leading]
        @leading_object = leading(options[:leading], options)
      end
      if options[:quote]
        @quote_object = quote(options[:quote], options)
      end
      if options[:author]
        @author_object = author(options[:author], options)
      end

      height_sum = 0
      height_sum +=@title_object.height    unless @title_object.nil?
      height_sum += 5
      height_sum +=@subtitle_object.height unless @subtitle_object.nil?
      height_sum += 5
      height_sum +=@leading_object.height  unless @leading_object.nil?
      height_sum += 5
      height_sum +=@author_object.height   unless @author_object.nil?
      height_sum += 5
      # @height = height_sum + graphics_space_sum + @top_inset + @bottom_inset + @top_margin + @bottom_margin
      @height = height_sum
      if @align_to_body_text
        mutiple           = @height/@body_line_height
        mutiple_height    = mutiple*body_height
        room              = mutiple_height - @height
        @top_inset        +=  room/2
        @bottom_inset     +=  room/2
        @height           = mutiple_height
      end
      relayout!
      self
    end

  end

end
