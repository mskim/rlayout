

module RLayout

  class NewsArticleHeading < Container
    attr_accessor :grid_frame, :grid_width, :body_line_height
    attr_accessor :title_object, :subject_head_object, :subtitle_object
    attr_reader   :upper_line_type, :heading_columns
    attr_reader   :subtitle_in_head, :top_story

    def initialize(options={})
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
      if options['subject_head']
        @subject_head_object = subject_head(options)
        @height_in_line_count_sum +=@subject_head_object.height_in_lines    unless @title_object.nil?
        # if when we have subject_head, reduce heading_columns size by 1
        @heading_columns -= 1

        # TODO
      end

      if options['title']
        if @top_story
          # when strou is top_stroy
          @title_object = top_title(options)
        elsif @subject_head_object
          # when story has subject_head
          @title_object = title_with_subject_head(options)
        else
          # refular story heading
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

    def subject_head(options={})
      subject_head                  = '문패'
      subject_atts                  = NEWSPAPER_STYLE[subject_head]
      subject_atts[:text_string]    = options['subject_head']
      if @parent_graphic
        subject_atts[:body_line_height]   = @parent_graphic.body_line_height
      else
        subject_atts[:body_line_height]   = 12
      end
      subject_atts[:width]                  = @width
      subject_atts[:stroke_sides]           = [0,1,0,0] # draw line at top only
      subject_atts[:stroke_width]           = 2
      subject_atts[:text_fit_type]          = 'adjust_box_height'
      subject_atts[:layout_expand]          = [:width] #TODO
      subject_atts[:fill_color]             = options.fetch(:fill_color, 'clear')
      # atts                          = options.merge(atts)
      subject_atts[:parent]                 = self
      subject_atts[:layout_length_in_lines] = true
      Text.new(subject_atts)
      @title_object                 = @graphics.last
      @title_object
    end

    def title_with_subject_head(options={})
      #TODO
      push_title_to_right = {}
      push_title_to_right[:x] = 145
      push_title_to_right[:width] = @width - 145
      title(push_title_to_right)
    end

    def top_title(options={})
      top_title_46     = '탑제목'
      atts = NEWSPAPER_STYLE[top_title_46]
      # atts.merge(options)
      # puts "atts:#{atts}"
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
      case @heading_columns
      when 4,5,6,7
        title_atts = NEWSPAPER_STYLE[title_4_5]
      when 3
        title_atts = NEWSPAPER_STYLE[title_3]
      when 2
        title_atts = NEWSPAPER_STYLE[title_2]
      when 1
        title_atts = NEWSPAPER_STYLE[title_1]
      end
      title_atts[:text_string]          = options['title']
      if @parent_graphic
        title_atts[:body_line_height]   = @parent_graphic.body_line_height
      else
        title_atts[:body_line_height]   = 12
      end
      title_atts[:width]                = @width
      title_atts[:text_fit_type]        = 'adjust_box_height'
      title_atts[:layout_expand]        = [:width]
      title_atts[:fill_color]           = options.fetch(:fill_color, 'clear')
      title_atts[:parent]               = self
      title_atts[:layout_length_in_lines] = true
      @title_object               = Text.new(title_atts)
      @title_object
    end

    def top_subtitle(options={})
      top_subtitle   = '탑부제'
      atts = NEWSPAPER_STYLE[top_subtitle]
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
