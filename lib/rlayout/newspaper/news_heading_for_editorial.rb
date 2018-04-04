
module RLayout

  class NewsHeadingForEditorial < Container
    attr_accessor :grid_frame, :grid_width, :body_line_height, :height_in_lines, :starting_line
    attr_accessor :title_object, :subject_head_object, :subtitle_object
    attr_reader   :upper_line_type, :heading_columns

    def initialize(options={})
      @grid_width       = options.fetch(:grid_width, 2)
      @heading_columns  = options[:column_count]
      super
      @body_line_height = @parent_graphic.body_line_height
      set_editorial_heading_content(options)
      self
    end

    def set_editorial_heading_content(options)
      @height_in_lines            = 0
      if options['subject_head'] && options['subject_head'] != ""
        @subject_head_object      = subject_head(options)
        @height_in_lines          +=@subject_head_object.height_in_lines    unless @subject_head_object.nil?
      end
      y = @height_in_lines*@body_line_height
      options[:y] = y
      options[:x] = 0

      if options['title']
        # if @parent_graphic.top_story
        #   @title_object = main_title(options)
        #   @title_object.adjust_height_as_height_in_lines
        # else
        @title_object = editorial_title(options)
        # end
        @height_in_lines  +=@title_object.height_in_lines    unless @title_object.nil?
      end

      if options['subtitle']
        @subtitle_object = subtitle(options)
        @height_in_lines += @subtitle_object.height_in_lines unless @subtitle_object.nil?
      end
      @height = @height_in_lines*@body_line_height
      relayout!
      self
    end

    #
    # def top_position_filler(line_count, options={})
    #   top_postion_height = @body_line_height*line_count
    #   Graphic.new(parent:self, width: @width, height:top_postion_height, fill_color: 'red')
    # end


    def editorial_title(options)
      title_options = {}
      title_options[:parent]          = self
      title_options[:is_float]        = true
      title_options[:x]               = 0
      title_options[:y]               = @body_line_height
      title_options[:width]           = @width - @parent_graphic.column_width - @parent_graphic.right_margin
      title_options[:height]          = @body_line_height*4
      title_options[:inset]           = @parent_graphic.gutter
      title_options[:stroke_sides]    = [0,1,0,0] # draw line at top only
      title_options[:stroke_width]    = 0.3
      title_options[:stroke_color]    = 'red'
      title_options['title']          = options['title']
      title_options[:style_name]      = 'title_editorial'
      title(title_options)
      #code
    end

    def title(options={})
      # title_4_5     = '제목_4-5단'
      # title_3       = '제목_3단'
      # title_2       = '제목_2단'
      # title_1       = '제목_1단'
      atts = {}
      # case @heading_columns
      # when 4,5,6,7
      #   atts[:style_name] = 'title_4_5'
      # when 3
      #   atts[:style_name] = 'title_3'
      # when 2
      #   atts[:style_name] = 'title_editorial'
      # when 1
      #   atts[:style_name] = 'title_1'
      # end
      atts[:text_string]          = options['title']
      if atts[:text_string] =~/\n/
        atts[:text_fit_type]        = 'adjust_box_height'
      else
        atts[:text_fit_type]        = 'fit_text_to_box' #
      end

      atts[:style_name] = 'title_editorial'
      atts[:body_line_height]     = @body_line_height
      atts[:width]                = @width
      atts[:layout_expand]        = [:width]
      atts[:fill_color]           = options.fetch(:fill_color, 'clear')
      atts[:parent]               = self
      atts[:top_inset]            = EDITORIAL_TITLE_TOP_INSET

      # atts[:stroke_width]         = 1
      # atts[:layout_length_in_lines] = true
      atts[:single_line_title]    = true
      # options.delete(:parent)
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
      atts[:fill_color]         = options.fetch(:fill_color, 'red')
      atts[:parent]             = self
      atts[:layout_length_in_lines] = true
      #TODO make this customizatble from font style
      atts[:stroke_sides]       = [0,1,0,0]
      atts[:stroke_width]       = 2
      atts[:top_inset]          = EDITORIAL_SUBJECT_HEAD_TOP_INSET
      atts[:space_before_in_lines] = 0.5
      TitleText.new(atts)
    end


  end

end
