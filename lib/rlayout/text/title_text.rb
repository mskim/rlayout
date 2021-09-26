module RLayout

  # TitleText single or multiple line, uniform styled text
  # used for title, subject_head, quote
  # adjust_size  adjusts font size from default text_style value
  # ex: My title text{-5} will reduce title text by 5 points
  # only sinngle digit change is allowed, to keep design integrity
  class TitleText < Container
    attr_accessor :tokens, :string, :style_name, :para_style, :room, :height_in_lines
    attr_accessor :current_line, :current_line_y, :starting_x, :line_width
    attr_accessor :single_line_title, :force_fit_title, :token_union_style, :adjust_size
    attr_reader :style_category
    def initialize(options={})
      @style_category = options[:style_category]
      @string                 = options.delete(:text_string)
      # parse for adjust_size pattern, which is at the end of string with {}
      # if @string =~/\{\s*(-?\d)\s?\}\s?$/
      if @string =~/\{\s*(-*\+*\d)\s*\}\s*$/
        @adjust_size = $1.to_i
        @string = @string.sub(/\{\s?(-?\d)\s?\}\s?$/, "")
      end
      options[:fill_color]    = options.fetch(:fill_color, 'clear')
      super
      @body_line_height       = options[:body_line_height] || 14
      @style_name             = options[:style_name]
      @token_union_style      = options[:token_union_style]
      @tokens                 = []
      @room                   = @width
      @single_line_title      = options[:single_line_title]
      if @style_name
        current_style         = RLayout::StyleService.shared_style_service.current_style
        if current_style.class == String
          current_style       = YAML::load(current_style)
          @para_style         = current_style[@style_name]
          unless @para_style
            # @para_style = current_style['body_gothic']
            @para_style = current_style['body']
          end
        else
          @para_style         = RLayout::StyleService.shared_style_service.current_style[@style_name]
        end
        @para_style           = Hash[@para_style.map{ |k, v| [k.to_sym, v] }]
        @graphic_attributes   = @para_style[:graphic_attributes]
        if @graphic_attributes && @graphic_attributes['token_union_style']
          @token_union_style  = Hash[@graphic_attributes['token_union_style'].map{ |k, v| [k.to_sym, v] }]
        end
        @space_width            = @para_style[:space_width] || @para_style[:font_size]/2
        if @adjust_size && @adjust_size != 0
          @space_width = @space_width*(@para_style[:font_size] + @adjust_size)/@para_style[:font_size]
        end
      elsif options[:@para_style]
        @para_style             = options[:@para_style]
      else
        @para_style             = {}
        @para_style[:font]      = options.fetch(:font, 'Times')
        @para_style[:font_size] = options.fetch(:size, 16)
        @para_style[:alignment] = options[:alignment] || 'left'
      end
      @para_style[:font_size] += @adjust_size if @adjust_size
      @para_style[:alignment] = options[:text_alignment] if options[:text_alignment]
      @text_height_in_lines   = @para_style[:text_height_in_lines] || 2
      @text_height_in_lines   = 2 if @text_height_in_lines == ""
      @space_before_in_lines  = @para_style[:space_before_in_lines] || 0
      @space_before_in_lines  = 0 if @space_before_in_lines == ""
      @top_inset              = @space_before_in_lines*@body_line_height
      @top_inset              += options[:top_inset] if options[:top_inset]
      @space_after_in_lines   = @para_style[:space_after_in_lines] || 0
      @space_after_in_lines   = 0 if @space_after_in_lines == ""
      @bottom_inset           = @space_after_in_lines*@body_line_height
      @tracking               = @para_style.fetch(:tracking, 0)
      @height_in_lines        = @space_before_in_lines + @text_height_in_lines + @space_after_in_lines
      @height                 = @height_in_lines*@body_line_height
      if options[:line_space]
        @line_space           =  options[:line_space]
      elsif @para_style[:text_line_spacing] == "" || @para_style[:text_line_spacing].nil?
        @line_space           =  @para_style[:font_size]*0.4
      else
        @line_space           = @para_style[:text_line_spacing]
      end
      @line_height            = @para_style[:font_size] + @line_space
      @current_line_y         = @top_margin + @top_inset
      @starting_x             = @left_margin + @left_inset
      @line_width             = @width - @starting_x - @right_margin - @right_inset
      @current_style_service        = RLayout::StyleService.shared_style_service
      @style_object, @font_wrapper  = @current_style_service.style_object(@style_name, adjust_size: @adjust_size) 
      space_glyph             = @font_wrapper.decode_utf8(" ").first
      @space_width            = @style_object.scaled_item_width(space_glyph)
      @current_line           = RLineFragment.new(parent:self, x: @starting_x, y:@current_line_y,  width:@line_width, height:@line_height, para_style: @para_style,  space_width: @space_width, debug: true, top_margin: @top_margin, style_name:@style_name, adjust_size: adjust_size)
      @current_line_y         +=@current_line.height
      create_tokens
      layout_tokens
      ajust_height_as_body_height_multiples
      self
    end

    def to_svg
      "<rect fill='yellow' x='#{@parent.x + @x}' y='#{@parent.y + @y}' width='#{@width}' height='#{@height - 2}' />"
    end

    def set_text(new_sting)
      @string    = new_sting
      @tokens    = []
      clear_lines
      create_tokens
      layout_tokens
    end

    def clear_lines
      @graphics.each do |line|
        line.clear_tokens
      end
    end

    def create_tokens
      return unless @string
      # we are getting "\r\n" or "\n" for new line
      if @string.include?("\r\n")
        @string.split("\r\n").each do |line_string|
          create_tokens_from_string(line_string)
          @tokens <<  NewLineToken.new()
        end
        @tokens.pop if @tokens.last.class == RLayout::NewLineToken # delete last NewLineToken
      elsif @string.include?("\n")
        @string.split("\n").each do |line_string|
          create_tokens_from_string(line_string)
          @tokens <<  NewLineToken.new()
        end
        @tokens.pop if @tokens.last.class == RLayout::NewLineToken # delete last NewLineToken
      else
        create_tokens_from_string(@string)
      end
    end

    def create_tokens_from_string(string)
      @tokens += string.split(" ").collect do |token_string|
        options = {}
        options[:string]      = token_string
        options[:para_style]  = @para_style
        options[:style_name]  = @style_name
        options[:y]           = 0
        options[:adjust_size] = @adjust_size if @adjust_size
        options[:height]      = para_style[:font_size]
        if RUBY_ENGINE != 'rubymotion'
          glyphs                = @font_wrapper.decode_utf8(token_string)
          options[:width]       = glyphs.map { |g| @style_object.scaled_item_width(g)}.reduce(:+)  
        end
        RLayout::RTextToken.new(options)
      end
      #code
    end

    def column_index
      0
    end

    def add_new_line
      new_line                = RLineFragment.new(parent:self, x: @starting_x, y:@current_line_y,  width: @line_width, height:@line_height, para_style: @para_style,  space_width: @space_width, debug: true, top_margin: @top_margin, style_name:@style_name, adjust_size: adjust_size)
      @current_line.next_line = new_line if @current_line
      @current_line           = new_line
      @current_line_y         += @current_line.height
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
        @height = @height_in_lines*@body_line_height + @bottom_margin - 2
        return
      end

      natural_height          =  @top_margin + @top_inset +  line_height_sum + @bottom_inset + @bottom_margin if line_height_sum
      body_height_multiples   = natural_height/@body_line_height
      @height_in_lines        = body_height_multiples.to_i
      float_delta             = body_height_multiples - body_height_multiples.to_i
      if float_delta > 0.7
        # @height_in_lines      += (@space_after_in_lines + 1)
        @height_in_lines      += @space_before_in_lines + @space_after_in_lines + 1
        @bottom_margin        += @body_line_height - float_delta
      else
        @height_in_lines      += @space_after_in_lines
      end
      @height = @height_in_lines*@body_line_height - 1
      @height -= 3
    end

    def layout_tokens
      token = tokens.shift
      while token
        if token.is_a?(NewLineToken)
          @current_line.align_tokens
          # return if @graphics.length >= @quote_text_lines
          add_new_line
          @current_line.line_type = 'middle_line'
          token = @tokens.shift
        end
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
