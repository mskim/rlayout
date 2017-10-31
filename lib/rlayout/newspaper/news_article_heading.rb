
module RLayout

  class NewsArticleHeading < Container
    attr_accessor :grid_frame, :grid_width, :body_line_height, :height_in_lines, :starting_line
    attr_accessor :title_object, :subject_head_object, :subtitle_object
    attr_reader   :upper_line_type, :heading_columns

    def initialize(options={})
      @grid_width       = options.fetch(:grid_width, 2)
      @heading_columns  = options[:column_count]
      # options[:stroke_width]    = 1
      super
      @body_line_height = @parent_graphic.body_line_height
      if options['editorial_head']
        set_editorial_heading_content(options)
      else
        set_heading_content(options)
      end
      self
    end

    def set_editorial_heading_content(options)
      @height_in_lines      = 0
      @top_position_filler_object = top_position_filler(@parent_graphic.page_heading_margin_in_lines)
      @height_in_lines        += @parent_graphic.page_heading_margin_in_lines
      if options['editorial_head']
        @editorial_head_object  = editorial_head(options)
      end

      if options['title']
        @title_object = title_with_editorial_head(options)
        @height_in_lines += @title_object.height_in_lines    unless @title_object.nil?
      end
    end

    def set_heading_content(options)
      @height_in_lines            = 0
      @top_position_filler_object = top_position_filler(@parent_graphic.page_heading_margin_in_lines)
      @height_in_lines            += @parent_graphic.page_heading_margin_in_lines
      if options['subject_head']
        @subject_head_object      = subject_head(options)
        @height_in_lines          +=@subject_head_object.height_in_lines    unless @subject_head_object.nil?
      end
      y = @height_in_lines*@body_line_height
      options[:y] = y
      options[:x] = 0

      if options['title']
        if @parent_graphic.top_story
          @title_object = main_title(options)
          @title_object.adjust_height_as_height_in_lines
        else
          @title_object = title(options)
        end
        @height_in_lines  +=@title_object.height_in_lines    unless @title_object.nil?
      end

      if options['subtitle'] && (@parent_graphic.top_story || @parent_graphic.subtitle_in_head)
        if @parent_graphic.top_story
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
      top_postion_height = @body_line_height*line_count
      Graphic.new(parent:self, width: @width, height:top_postion_height)
    end

    def editorial_head(options={})
      # subject_head_height_in_lines       = options[:space_before_in_lines] + options[:text_height_in_lines] + options[:space_after_in_lines]
      # puts "subject_head_height_in_lines:#{subject_head_height_in_lines}"
      subject_atts = {}
      if @heading_columns > 5
        subject_atts[:style_name] = 'subject_head_L'
      elsif @heading_columns > 3
        subject_atts[:style_name] = 'subject_head_M'
      else
        subject_atts[:style_name] = 'subject_head_S'
      end
      subject_atts[:text_string]        = options['editorial_head']
      subject_atts[:body_line_height]   = @body_line_height
      subject_atts[:width]              = @parent_graphic.column_width
      subject_atts[:top_inset]          = 5
      subject_atts[:y]                  = @top_position_filler_object.height
      subject_atts[:stroke_sides]       = [0,1,0,0] # draw line at top only
      subject_atts[:stroke_width]       = 2
      subject_atts[:text_fit_type]      = 'adjust_box_height'
      subject_atts[:layout_expand]      = nil #[:width] #TODO
      subject_atts[:fill_color]         = options.fetch(:fill_color, 'clear')
      subject_atts[:parent]             = self
      subject_atts[:layout_length_in_lines] = true
      t = TitleText.new(subject_atts)
      t
    end

    def title_with_editorial_head(options)
      push_title_to_right = {}
      push_title_to_right[:parent]          = self
      push_title_to_right[:x]               = @parent_graphic.column_width
      push_title_to_right[:y]               = @top_position_filler_object.height
      push_title_to_right[:width]           = @width - @parent_graphic.column_width
      push_title_to_right[:height]          = @body_line_height*4
      push_title_to_right[:stroke_sides]    = [0,1,0,0] # draw line at top only
      push_title_to_right[:stroke_width]    = 0.3
      push_title_to_right[:layout_expand]   = :height
      title_options                         = options.merge(push_title_to_right)
      title(title_options)
    end

    def subject_head(options={})
      atts = {}
      if @heading_columns > 5
        atts[:style_name] = 'subject_head_L'
      elsif @heading_columns > 3
        atts[:style_name] = 'subject_head_M'
      else
        atts[:style_name] = 'subject_head_S'
      end
      #todo second half string
      atts[:text_string]        = options['subject_head']
      atts[:body_line_height]   = @body_line_height
      atts[:width]              = @width
      atts[:stroke_width]       = 0
      atts[:text_fit_type]      = 'adjust_box_height'
      atts[:layout_expand]      = [:width] #TODO
      atts[:fill_color]         = options.fetch(:fill_color, 'clear')
      atts[:parent]             = self
      atts[:layout_length_in_lines] = true
      TitleText.new(atts)
    end

    def main_title(options={})
      atts = {}
      atts[:style_name] = 'title_main'
      atts.merge(options)
      atts[:text_string]          = options['title']
      if atts[:text_string] =~/\n/
        atts[:text_fit_type]      = 'adjust_box_height' #fit_text_to_box
      else
        atts[:text_fit_type]      = 'fit_text_to_box' #
      end
      atts[:body_line_height]     = @body_line_height
      atts[:width]                = @width
      # atts[:text_fit_type]        = 'adjust_box_height'
      atts[:layout_expand]        = [:width]
      atts[:fill_color]           = options.fetch(:fill_color, 'clear')
      atts[:parent]               = self
      atts[:layout_length_in_lines] = true
      atts[:single_line_title]    = true
      @title_object               = TitleText.new(atts)
    end

    def title(options={})
      # title_4_5     = '제목_4-5단'
      # title_3       = '제목_3단'
      # title_2       = '제목_2단'
      # title_1       = '제목_1단'
      atts = {}
      case @heading_columns

      when 4,5,6,7
        atts[:style_name] = 'title_4_5'
      when 3
        atts[:style_name] = 'title_3'
      when 2
        atts[:style_name] = 'title_2'
      when 1
        atts[:style_name] = 'title_1'
      end
      atts[:text_string]          = options['title']
      if atts[:text_string] =~/\n/
        atts[:text_fit_type]        = 'adjust_box_height'
      else
        atts[:text_fit_type]        = 'fit_text_to_box' #
      end

      atts[:body_line_height]     = @body_line_height
      atts[:width]                = @width
      atts[:layout_expand]        = [:width]
      atts[:fill_color]           = options.fetch(:fill_color, 'clear')
      atts[:parent]               = self
      # atts[:stroke_width]         = 1
      # atts[:layout_length_in_lines] = true
      atts[:single_line_title]    = true
      options.delete(:parent)
      atts.merge!(options)
      @title_object               = TitleText.new(atts)
    end

    def top_subtitle(options={})
      atts = {}
      atts[:style_name]           = 'subtitle_main'
      atts[:text_string]          = options['subtitle']
      atts[:body_line_height]     = @body_line_height
      atts[:width]                = @width
      atts[:text_fit_type]        = 'adjust_box_height'
      atts[:fill_color]           = options.fetch(:fill_color, 'clear')
      # atts                          = options.merge(atts)
      atts[:parent]               = self
      @subtitle_object            = TitleText.new(atts)
      @subtitle_object.layout_expand= [:width]
      @subtitle_object.layout_length= @subtitle_object.height
      @subtitle_object
    end

    def subtitle(options={})
      atts = {}
      if @heading_columns >= 3
        atts[:style_name] = 'subtitle_M'
      else
        atts[:style_name] = 'subtitle_S'
      end
      atts[:text_string]            = options['subtitle']
      atts[:body_line_height]       = @body_line_height
      atts[:width]                  = @width
      atts[:text_fit_type]          = 'adjust_box_height'
      atts[:fill_color]             = options.fetch(:fill_color, 'clear')
      atts[:parent]                 = self
      @subtitle_object              = TitleText.new(atts)
      @subtitle_object.layout_expand= [:width]
      @subtitle_object.layout_length= @subtitle_object.height
      @subtitle_object
    end

  end

end
