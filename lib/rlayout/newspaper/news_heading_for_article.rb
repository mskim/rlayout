
module RLayout

  class NewsHeadingForArticle < Container
    attr_accessor :grid_frame, :grid_width, :body_line_height, :height_in_lines, :starting_line
    attr_accessor :title_object, :subject_head_object, :subtitle_object
    attr_reader   :upper_line_type, :heading_columns

    def initialize(options={})
      @grid_width       = options.fetch(:grid_width, 2)
      options[:stroke_color]    = "CMYK=0,0,0,100"
      # options[:fill_color]    = "red"
      
      super
      @heading_columns  = @parent.column_count
      @heading_columns  = options[:column_count] if options[:column_count]
      @body_line_height = @parent.body_line_height

      set_heading_content(options)
      self
    end

    def to_svg
      s = "<rect fill='green' x='#{@parent.x + @x}' y='#{@parent.y + @y}' width='#{@width}' height='#{@height - 2}' />"
      s
    end

    def set_heading_content(options)
      @height_sum                 = 0
      if options['subject_head'] && options['subject_head'] != ""
        @subject_head_object      = subject_head(options)
        @height_sum               +=@subject_head_object.height    unless @subject_head_object.nil?
      end
      y = @height_sum
      options[:y] = y
      options[:x] = 0
      # options[:fill_color] = 'yellow'
      if options['title'] && options['title'] != ""
        if @parent.top_story
          @title_object = main_title(options)
        else
          @title_object = title(options)
        end
        @height_sum       +=@title_object.height    unless @title_object.nil?
        y += @height_sum
      end
      # if options['subtitle'] && (@parent.top_story && @parent.subtitle_in_head)
      if options['subtitle'] && @parent.subtitle_type == '제목밑 가로'
        if @parent.top_story
          @subtitle_object = top_subtitle(options)
        else
          @subtitle_object = subtitle(options)
        end
        @height_sum       +=@subtitle_object.height    if @subtitle_object
      end

      #TODO calculate with actual sum of heigh and make body_line multiple
      # in and verticslly center it?
      @line_multiple  = (@height_sum/@body_line_height).ceil + 2
      @height         = @line_multiple*@body_line_height
      relayout!
      self
    end

    def subject_head(options={})
      atts = {}
      if @parent.top_story
        atts[:style_name] = 'subject_head_main'
      elsif @heading_columns > 5
        atts[:style_name] = 'subject_head_L'
      elsif @heading_columns > 3
        atts[:style_name] = 'subject_head_M'
      else
        atts[:style_name] = 'subject_head_S'
      end
      #todo second half string
      atts[:top_margin]         = @body_line_height if @parent.frame_sides == '테두리'
      puts "+++++++ atts[:top_margin]:#{atts[:top_margin]}"
      atts[:text_string]        = options['subject_head']
      puts "+++++++ atts[:text_string]:#{atts[:text_string]}"
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
      atts[:width]                = @width - 2
      # atts[:text_fit_type]        = 'adjust_box_height'
      atts[:layout_expand]        = [:width]
      atts[:fill_color]           = options.fetch(:fill_color, 'clear')
      atts[:parent]               = self
      atts[:layout_length_in_lines] = true
      # atts[:single_line_title]    = true
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
      else
        atts[:style_name] = 'title_4_5'
      end
      atts[:text_string]          = options['title']
      if atts[:text_string] =~/\n/
        atts[:text_fit_type]        = 'adjust_box_height'
      else
        atts[:text_fit_type]        = 'fit_text_to_box' #
      end
      atts[:top_margin]           = @body_line_height if @parent.frame_sides == '테두리' #&& !@subject_head_object
      atts[:body_line_height]     = @body_line_height
      atts[:width]                = @width - 2
      atts[:layout_expand]        = [:width]
      atts[:fill_color]           = options.fetch(:fill_color, 'clear')
      atts[:parent]               = self
      # atts[:single_line_title]    = true
      # atts.merge!(options)
      @title_object               = TitleText.new(atts)
      @title_object.height        += @body_line_height if @parent.frame_sides == '테두리' #&& !@subject_head_object
      @title_object
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
      puts "subtitle in article heading"
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
