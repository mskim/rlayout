

module RLayout

  class NewsArticleHeading < Container
    attr_accessor :grid_frame, :grid_width, :body_line_height, :height_in_lines, :starting_line
    attr_accessor :title_object, :subject_head_object, :subtitle_object
    attr_reader   :upper_line_type, :heading_columns
    attr_reader   :subtitle_in_head, :is_front_page, :top_story, :top_position

    def initialize(options={})
      @grid_width       = options.fetch(:grid_width, 2)
      @heading_columns  = options[:column_count]
      # options[:stroke_width] = 1
      super
      @body_line_height = @parent_graphic.body_line_height
      @body_line_height = options.fetch(:body_line_height) if options.fetch(:body_line_height)
      @is_front_page    = options.fetch(:is_front_page, false)
      @top_story        = options.fetch(:top_story, false)
      @top_position     = options.fetch(:top_position, false)
      @subtitle_in_head = options.fetch(:subtitle_in_head, false)
      set_heading_content(options)
      self
    end

    def set_heading_content(options)
      @is_front_page    = options.fetch(:is_front_page, false)
      @top_story        = options[:top_story]     if options[:top_story]
      @top_position     = options[:top_position]  if options[:top_position]
#
      # options = transform_keys_to_symbols(options)
      @height_in_lines  = 0

      if @top_position && @is_front_page
        puts "@top_position && @is_front_page:#{@top_position && @is_front_page}"
        @top_position_filler_object = top_position_filler(NEWS_ARTICLE_FRONT_PAGE_EXTRA_HEADING_SPACE_IN_LINES)
        @height_in_lines += NEWS_ARTICLE_FRONT_PAGE_EXTRA_HEADING_SPACE_IN_LINES
      elsif @top_position
        @top_position_filler_object = top_position_filler(NEWS_ARTICLE_HEADING_SPACE_IN_LINES)
        @height_in_lines += NEWS_ARTICLE_HEADING_SPACE_IN_LINES
      end

      if options['subject_head']
        @subject_head_object = subject_head(options)
        @height_in_lines +=@subject_head_object.height_in_lines    unless @title_object.nil?
        # if when we have subject_head, reduce heading_columns size by 1
        @heading_columns -= 1
        # TODO
      end

      if options['title']
        if @top_story
          # when strou is top_stroy
          @title_object = top_title(options)
          @title_object.adjust_height_as_height_in_lines
        elsif @subject_head_object
          # when story has subject_head
          @title_object = title_with_subject_head(options)
        else
          # refular story heading
          @title_object = title(options)
        end
        @height_in_lines += @title_object.height_in_lines    unless @title_object.nil?
      end

      if options['subtitle'] && (@top_story || @subtitle_in_head)
        if @top_story
          @subtitle_object = top_subtitle(options)
        else
          @subtitle_object = subtitle(options)
        end
        @height_in_lines += @subtitle_object.height_in_lines unless @subtitle_object.nil?
      end
      @height = @height_in_lines*@body_line_height
      relayout!
      self
    end

    def top_position_filler(line_count, options={})
      puts "line_count:#{line_count}"
      top_postion_height = @body_line_height*line_count
      Graphic.new(parent:self, width: @width, height:top_postion_height)
    end

    def subject_head(options={})
      subject_head                  = '문패'
      subject_atts                  = NEWSPAPER_STYLE[subject_head]
      subject_atts[:text_string]    = options['subject_head']
      subject_atts[:body_line_height] = @body_line_height
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
      atts[:body_line_height]     = @body_line_height
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
      title_atts[:body_line_height]     = @body_line_height
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
      atts[:text_string]          = options['subtitle']
      atts[:body_line_height]     = @body_line_height
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
      atts[:body_line_height]       = @body_line_height
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
