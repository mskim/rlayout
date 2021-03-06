
module RLayout

  class NewsHeadingForOpinion < Container
    attr_accessor :grid_frame, :grid_width, :body_line_height, :height_in_lines, :starting_line
    attr_accessor :title_object, :subject_head_object, :subtitle_object
    attr_reader   :upper_line_type, :heading_columns

    def initialize(options={})
      @grid_width             = options.fetch(:grid_width, 2)
      @heading_columns        = options[:column_count]
      options[:fill_color]    = 'clear'
      super
      # shift title to right by one column
      # @x                      = @parent.column_width + @parent.gutter
      @body_line_height       = @parent.body_line_height
      @height_in_lines        = 0

      if options['title']
        options[:x]            = 0
        options[:y]            = @body_line_height
        @title_object          = opinion_title(options)
        @height                = @title_object.height    unless @title_object.nil?
      end
      # add subtitle
      self
    end

    # def top_position_filler(line_count, options={})
    #   top_postion_height = @body_line_height*line_count
    #   Graphic.new(parent:self, width: @width, height:top_postion_height, fill_color: 'yellow')
    # end

    def opinion_title(options)
      title_options = {}
      title_options[:parent]          = self
      title_options[:is_float]        = true
      title_options[:x]               = 0
      title_options[:y]               = @body_line_height
      title_options[:width]           = @width - @parent.column_width - @parent.right_margin
      title_options[:height]          = @body_line_height*4
      title_options[:inset]           = @parent.gutter
      title_options[:stroke_sides]    = [0,1,0,0] # draw line at top only
      title_options[:stroke_width]    = 0.3
      title_options[:stroke_color]    = 'black'
      title_options['title']          = options['title']
      title_options[:style_name]      = 'title_opinion'
      title(title_options)
      #code
    end

    def title(options={})
      # title_4_5     = '제목_4-5단'
      # title_3       = '제목_3단'
      # title_2       = '제목_2단'
      # title_1       = '제목_1단'
      atts = {}
      # case @heading_columns - 1
      #
      # when 4,5,6,7
      #   atts[:style_name] = 'title_4_5'
      # when 3
      #   atts[:style_name] = 'title_opinion'
      # when 2
      #   atts[:style_name] = 'title_2'
      # when 1
      #   atts[:style_name] = 'title_1'
      # end
      atts[:style_name]           = 'title_opinion'
      atts[:text_string]          = options['title']
      if atts[:text_string]       =~/\n/
        atts[:text_fit_type]      = 'adjust_box_height'
      else
        atts[:text_fit_type]      = 'fit_text_to_box' #
      end
      atts[:body_line_height]     = @body_line_height
      atts[:width]                = @width
      atts[:layout_expand]        = [:width]
      atts[:fill_color]           = options.fetch(:fill_color, 'clear')
      atts[:parent]               = self
      # atts[:stroke_width]         = 1
      # atts[:layout_length_in_lines] = true
      atts[:single_line_title]    = true
      if @heading_columns == 2
        atts[:text_alignment]          = 'right'
      elsif @heading_columns == 6
        atts[:text_alignment]          = 'center'
      end
      options.delete(:parent)
      @title_object               = TitleText.new(atts)
    end
  end

end
