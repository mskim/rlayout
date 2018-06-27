module RLayout
  # MAX_SQUEEZE_LIMIT = 1.1
  # TitleText single line uniform styled text
  # used for title, subject_head
  # It can squeeze text
  class RTitleText < Container
    attr_accessor :tokens, :string, :style_name, :para_style, :room, :text_alignment, :height_in_lines
    attr_accessor :current_line, :current_line_y, :starting_x, :line_width
    attr_accessor :single_line_title, :force_fit_title, :token_union_style
    def initialize(options={})
      @string                 = options.delete(:text_string)
      options[:fill_color]    = options.fetch(:line_color, 'clear')
      # options[:stroke_width]  = 1
      super
      @style_name             = options[:style_name]
      @style_name             = 'body' unless @style_name
      @token_union_style      = options[:token_union_style]
      @tokens                 = []
      @room                   = @width
      @single_line_title      = options[:single_line_title]
      @style_name             = options[:style_name]
      if @style_name
        @para_style             = RLayout::StyleService.shared_style_service.current_style[@style_name]
        @para_style             = Hash[@para_style.map{ |k, v| [k.to_sym, v] }]
        @para_style[:font_size] = @para_style[:text_size] if @para_style[:text_size]
        @space_width            = @para_style[:space_width] || @para_style[:font_size]/3
      elsif options[:@para_style]
        @para_style             = options[:@para_style]
      else
        @para_style             = {}
        @para_style[:font]      = options.fetch(:font, 'Times')
        @para_style[:font_size] = options.fetch(:size, 16)
      end
      @text_alignment         = options[:text_alignment] || 'left'
      @body_line_height       = options[:body_line_height] || 14
      @text_height_in_lines   = @para_style[:text_height_in_lines] || 2
      @text_height_in_lines   = 2 if @text_height_in_lines == ""
      @space_before_in_lines  = @para_style[:space_before_in_lines] || 0
      @space_before_in_lines  = 1 if @space_before_in_lines == ""
      @top_inset              += options[:top_inset] if options[:top_inset]
      @space_after_in_lines   = @para_style[:space_after_in_lines] || 0
      @space_after_in_lines   = 0 if @space_after_in_lines == ""
      @tracking               = @para_style.fetch(:tracking, 0)
      @bottom_inset           = @space_after_in_lines*@body_line_height
      @height_in_lines        = @space_before_in_lines + @text_height_in_lines + @space_after_in_lines
      @height                 = @height_in_lines*@body_line_height

      if @para_style[:text_line_spacing] == "" || @para_style[:text_line_spacing].nil?
        @line_space           =  @para_style[:font_size]*0.4
      else
        @line_space           = @para_style[:text_line_spacing]
      end
      @line_height            = @para_style[:font_size] + @line_space
      # @current_line_y         = @top_inset + @space_before_in_lines*@body_line_height
      @current_line_y         = @top_inset + @space_before_in_lines*@body_line_height
      # @current_line_y         = @space_before_in_lines*@body_line_height
      @starting_x             = @left_margin + @left_inset
      @line_width             = @width - @starting_x - @right_margin - @right_inset
      @current_line           = RLineFragment.new(parent:self, x: @starting_x, y:@current_line_y,  width:@line_width, height:@line_height, space_width: @space_width, debug: true, top_margin: @top_margin)
      @current_line_y         +=@current_line.height
      # puts "@style_name:#{@style_name}"
      # puts "@top_inset:#{@top_inset}"
      # puts "@current_line_y:#{@current_line_y}"
      # puts "@space_before_in_lines:#{@space_before_in_lines}"
      # puts "@text_height_in_lines:#{@text_height_in_lines}"
      # puts "@space_after_in_lines:#{@space_after_in_lines}"
      create_tokens
      layout_tokens
      ajust_height_as_body_height_multiples
      self
    end

    def create_tokens
      return unless @string
      @tokens += @string.split(" ").collect do |token_string|
        h = {}
        h[:string]      = token_string
        h[:y]           = 0
        h[:style_name]  = @style_name
        if RUBY_ENGINE == 'rubymotion'
          options[:atts]    = NSUtils.ns_atts_from_style(@para_style)
          @space_width      = options[:atts][:space_width]
        end
        # options[:stroke_width] = 1
        RLayout::RTextToken.new(h)
      end

    end

    def column_index
      0
    end

    def add_new_line
      new_line                = NewsLineFragment.new(parent:self, x: @starting_x, y:@current_line_y,  width: @line_width, height:@line_height, space_width: @space_width, debug: true)
      @current_line.next_line = new_line if @current_line
      @current_line           = new_line
      @current_line_y         += @current_line.height + @line_space
      @current_line
    end

    def line_height_sum
      @graphics.map{|line| line.height}.reduce(:+)
    end

    def adjust_height_as_height_in_lines
      @height = @height_in_lines*@body_line_height
    end

    def ajust_height_as_body_height_multiples
      # We want to keeep it as multple of body_line_height
      if @graphics.length <= 1
        # to avoid edge case overloap adding 2 pixels would do it
        @height = @height_in_lines*@body_line_height - 2
        return
      end
      natural_height          =  @top_inset + line_height_sum if line_height_sum
      body_height_multiples   = natural_height/@body_line_height
      @height_in_lines        = body_height_multiples.to_i
      float_delta             = body_height_multiples - body_height_multiples.to_i
      if float_delta > 0.7
        @height_in_lines += (@space_after_in_lines + 1)
      else
        @height_in_lines += @space_after_in_lines
      end
      @height = @height_in_lines*@body_line_height - 1
      @height -= 3
    end

    def layout_tokens
      token = tokens.shift
      while token
        result = @current_line.place_token(token, do_not_break: @single_line_title)
        # result = @current_line.place_token(token)
        # forcing not to break the token
        # result can be one of two
        # case 1. entire token placed succefully, returned result is true
        # case 2. entire token is rejected from the line
        if result.class == TrueClass
          # entire token placed succefully, returned result is true
          token = tokens.shift
        else  # case 2
          if @single_line_title
            # insert left over tokens to @current_line for fitting
            @current_line.graphics << token if result.class == FalseClass
            @current_line.graphics += @tokens
            @current_line.reduce_to_fit(force_fit: @force_fit_title)
            return
          else
            if result.class == TextToken || result.class == RTextToken
              token = result
            end
            @current_line.align_tokens
            add_new_line
            @current_line.place_token(token)
            token = tokens.shift
          end
        end
      end
      @current_line.align_tokens

    end

    # place tokens in the line, given tokens array
    # return loft over tokens array if not all tokens are layed out
    # return false if no leftvver tokens
    #CharHalfWidthCushion = 5.0
    def place_token(token)
      if @room  >= token.width
        # place token in line.
        token.parent = self
        @graphics << token
        @room -= token.width
        @room -= @space_width
        return true
      else
        return false
      end
      return false
    end

    def mark_overflow
      # return unless @tokens.length > 0
      @current_line.mark_overflow
    end

    def graphics_width_sum
      @graphics.map{|t| t.width}.reduce(:+)
    end

    def space_width_sum
      (@graphics.length - 1)*@space_width
    end

    def relayout!
    end


  end

end
