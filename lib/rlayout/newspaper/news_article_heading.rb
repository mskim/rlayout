

module RLayout

  class NewsArticleHeading < Container
    attr_accessor :grid_frame, :grid_width, :body_line_height
    attr_accessor :title_object, :name_tag_object, :subtitle_object
    attr_reader   :upper_line_type, :heading_columns
    attr_reader   :subtitle_in_head, :top_story

    def initialize(options={})
      puts "in NewsArticleHeading"
      @grid_width       = options.fetch(:grid_width, 2)
      @heading_columns  = options[:column_count]
      @body_line_height = options.fetch(:body_line_height, 12)
      super
      @top_story        = options.fetch(:top_story, false)
      @subtitle_in_head = options.fetch(:subtitle_in_head, false)
      set_heading_content(options)
      self
    end

    def set_heading_content(options)
      # options = transform_keys_to_symbols(options)
      @height_in_line_count_sum = 0
      if options['name_tag']
        @name_tag_object = name_tag(options)
        @height_in_line_count_sum +=@name_tag_object.height_in_lines    unless @title_object.nil?
        # if when we have name_tag, reduce heading_columns size by 1
        @heading_columns -= 1
      end

      if options['title']
        if @top_story
          @title_object = top_title(options)
        else
          @title_object = title(options)
        end
        @height_in_line_count_sum += @title_object.height_in_lines    unless @title_object.nil?
      end

      if options['subtitle'] && (@top_story || @subtitle_in_head)
        puts "@top_story:#{@top_story}"
        if @top_story
          @subtitle_object = top_subtitle(options)
        else
          @subtitle_object = subtitle(options)
        end
        @height_in_line_count_sum +=@subtitle_object.height_in_lines unless @subtitle_object.nil?
      end
      @height = @height_in_line_count_sum*@body_line_height
      relayout!
      self
    end

    def name_tag(options={})
      atts = NEWSPAPER_STYLE[name_tag]
      atts[:text_string]            = options['name_tag']
      atts[:body_line_height]       = @parent_graphic.body_line_height
      atts[:width]                  = @width
      atts[:text_fit_type]          = 'adjust_box_height'
      atts[:layout_expand]          = [:width]
      atts[:fill_color]             = options.fetch(:fill_color, 'clear')
      atts                          = options.merge(atts)
      atts[:parent]                 = self
      atts[:layout_length_in_lines]    = true
      Text.new(atts)
      @title_object                 = @graphics.last
      @title_object
    end

    def top_title(options={})
      top_title_46     = '탑제목'
      atts = NEWSPAPER_STYLE[top_title_46]
      atts[:text_string]          = options['title']
      if @parent_graphic
        atts[:body_line_height]   = @parent_graphic.body_line_height
      else
        atts[:body_line_height]   = 12
      end
      atts[:width]                = @width
      atts[:text_fit_type]        = 'adjust_box_height'
      atts[:layout_expand]        = [:width]
      atts[:fill_color]           = options.fetch(:fill_color, 'clear')
      atts[:parent]               = self
      atts[:layout_length_in_lines] = true
      @title_object               = Text.new(atts)
      @title_object
    end

    def title(options={})
      title_4_5     = '4-5단제목'
      title_3       = '3단제목'
      title_2       = '2단제목'
      title_1       = '1단제목'
      atts = {}
      case @heading_columns
      when 4,5,6,7
        atts = NEWSPAPER_STYLE[title_4_5]
      when 3
        atts = NEWSPAPER_STYLE[title_3]
      when 2
        atts = NEWSPAPER_STYLE[title_2]
      when 1
        atts = NEWSPAPER_STYLE[title_1]
      end
      atts[:text_string]          = options['title']
      if @parent_graphic
        atts[:body_line_height]   = @parent_graphic.body_line_height
      else
        atts[:body_line_height]   = 12
      end
      atts[:width]                = @width
      atts[:text_fit_type]        = 'adjust_box_height'
      atts[:layout_expand]        = [:width]
      atts[:fill_color]           = options.fetch(:fill_color, 'clear')
      atts[:parent]               = self
      atts[:layout_length_in_lines] = true
      @title_object               = Text.new(atts)
      @title_object
    end

    def top_subtitle(options={})
      top_subtitle   = '탑부제'
      atts = NEWSPAPER_STYLE[top_subtitle]
      puts "atts[:text_size]:#{atts[:text_size]}"
      atts[:text_string]            = options['subtitle']
      if @parent_graphic
        atts[:body_line_height]   = @parent_graphic.body_line_height
      else
        atts[:body_line_height]   = 12
      end
      atts[:width]                  = @width
      atts[:text_fit_type]          = 'adjust_box_height'
      atts[:fill_color]             = options.fetch(:fill_color, 'clear')
      # atts                          = options.merge(atts)
      atts[:parent]                 = self
      @subtitle_object              = Text.new(atts)
      @subtitle_object.layout_expand= [:width]
      @subtitle_object.layout_length= @subtitle_object.height
      @subtitle_object
    end

    def subtitle(options={})
      subtitle_15   = '부제15'
      subtitle_13   = '부제13'
      #TODO
      if @heading_columns >= 3
        atts = NEWSPAPER_STYLE[subtitle_15]
      else
        atts = NEWSPAPER_STYLE[subtitle_13]
      end
      atts[:text_string]            = options['subtitle']
      if @parent_graphic
        atts[:body_line_height]   = @parent_graphic.body_line_height
      else
        atts[:body_line_height]   = 12
      end
      atts[:width]                  = @width
      atts[:text_fit_type]          = 'adjust_box_height'
      atts[:fill_color]             = options.fetch(:fill_color, 'clear')
      # atts                          = options.merge(atts)
      atts[:parent]                 = self
      @subtitle_object              = Text.new(atts)
      @subtitle_object.layout_expand= [:width]
      @subtitle_object.layout_length= @subtitle_object.height
      @subtitle_object
    end

  end

end
