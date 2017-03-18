module RLayout

  class NewsArticleHeading < Container
    attr_accessor :grid_frame, :grid_width, :body_line_height
    attr_accessor :big_title_object, :title_object, :name_tag_object, :subtitle_object
    attr_reader   :upper_line_type

    def initialize(options={})
      @grid_width       = options.fetch(:grid_width, 2)
      @body_line_height = options.fetch(:body_line_height, 12)
      super
      set_heading_content(options)
      self
    end

    def set_heading_content(options)
      # options = transform_keys_to_symbols(options)
      @height_in_line_count_sum = 0
      if options['name_tag']
        @name_tag_object = name_tag(options['name_tag'], options)
        @height_in_line_count_sum +=@name_tag_object.height_in_line_count    unless @title_object.nil?
      end
      if options['big_title']
        @big_title_object = big_title(options['big_title'], options)
        @height_in_line_count_sum +=@big_title_object.height_in_line_count    unless @title_object.nil?
      end
      if options['title']
        @title_object = title(options['title'], options)
        @height_in_line_count_sum += @title_object.height_in_line_count    unless @title_object.nil?
      end
      if options['subtitle']
        @subtitle_object = subtitle(options['subtitle'], options)
        @height_in_line_count_sum +=@subtitle_object.height_in_line_count unless @subtitle_object.nil?
      end
      @height = @height_in_line_count_sum*@body_line_height
      relayout!
      self
    end

    ######## PageScript verbes

    def name_tag(options={})
      @height_in_line_count = 1
      atts                        = @current_style["name_tag"]
      atts[:text_string]          = string
      atts[:width]                = @width
      atts[:text_fit_type]        = 'adjust_box_height'
      atts[:layout_expand]        = [:width]
      atts[:fill_color]           = options.fetch(:fill_color, 'clear')
      atts                        = options.merge(atts)
      atts[:parent]               = self
      Text.new(atts)
      @title_object               = @graphics.last
      @title_object.layout_length = @height_in_line_count
      @title_object
    end

    def big_title(string, options={})
      @height_in_line_count       = 4
      atts                        = @current_style["big_title"]
      atts[:text_string]          = string
      atts[:width]                = @width
      atts[:text_fit_type]        = 'adjust_box_height'
      atts[:layout_expand]        = [:width]
      atts[:fill_color]           = options.fetch(:fill_color, 'clear')
      atts                        = options.merge(atts)
      atts[:parent]               = self
      # @title_object               = Text.new(atts)
      Text.new(atts)
      @title_object               = @graphics.last
      @title_object.layout_length = @height_in_line_count
      @title_object
    end

    def title(string, options={})
      atts = RLayout::StyleService.shared_style_service.current_style['title']
      atts[:parent]               = self
      atts[:height_in_line_count] = 2
      atts[:text_string]          = string
      atts[:width]                = @width
      atts[:text_fit_type]        = 'adjust_box_height'
      atts[:layout_expand]        = [:width]
      atts[:fill_color]           = options.fetch(:fill_color, 'clear')
      atts                        = options.merge(atts)
      atts[:parent]               = self
      @title_object               =Text.new(atts)
      @title_object.layout_length = @height_in_line_count
      @title_object
    end

    def subtitle(string, options={})
      @height_in_line_count = 1
      atts                          = @current_style["subtitle"]
      atts[:text_string]            = string
      atts[:width]                  = @width
      atts[:text_fit_type]          = 'adjust_box_height'
      atts[:fill_color]             = options.fetch(:fill_color, 'clear')
      atts                          = options.merge(atts)
      atts[:parent]                 = self
      @subtitle_object              = Text.new(atts)
      @subtitle_object.layout_expand= [:width]
      @subtitle_object.layout_length= @subtitle_object.height
      @subtitle_object
    end

  end

end
