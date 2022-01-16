module RLayout

  # There are three types of Text.
  # Text, TitleText, and RParagraph

  # Text 
  # supports single line untiform styled text.

  # TitleText 
  # supports multiple line text.
  # used for title, subject_head, quote
  # adjust_size  adjusts font size from default text_style value
  # ex: My title text{-5} will reduce title text by 5 points
  # only sinngle digit change is allowed, to keep design integrity.
  
  # RParagraph
  # supports multiple line text using style_name.
  # used with RLineFragment of RColumn 
  # it lays out  text_tokens in series of linkd RLineFragment's
  class TitleText < Container
    attr_accessor :tokens, :text_string, :string, :style_name, :para_style, :room, :height_in_lines
    attr_accessor :current_line, :current_line_y, :starting_x, :line_width
    attr_accessor :single_line_title, :force_fit_title, :token_union_style, :adjust_size
    attr_reader :style_object
    def initialize(options={})
      @text_string                 = options.delete(:text_string)
      # parse for adjust_size pattern, which is at the end of string with {}
      # if @text_string =~/\{\s*(-?\d)\s?\}\s?$/
      if @text_string =~/\{\s*(-*\+*\d)\s*\}\s*$/
        @adjust_size = $1.to_i
        @text_string = @text_string.sub(/\{\s?(-?\d)\s?\}\s?$/, "")
      end
      options[:fill_color]    = options.fetch(:fill_color, 'clear')
      super
      @body_line_height       = options[:body_line_height] || 14
      @style_name             = options[:style_name]
      @token_union_style      = options[:token_union_style]
      @tokens                 = []
      @room                   = @width
      @single_line_title      = options[:single_line_title]
      @current_style_service = RLayout::StyleService.shared_style_service
      if @style_name
        @style_object = @current_style_service.style_object(@style_name, adjust_size: @adjust_size)
      elsif options[:para_style]
        if @adjust_size
          @para_style[:font_size] += @adjust_size
        end
        @style_object = @current_style_service.style_object_with_para_style(options[:para_style])
      else
        @para_style             = {}
        @para_style[:font]      = options.fetch(:font, 'KoPubBatangPM')
        @para_style[:font_size] = options.fetch(:font_size, 16)
        if @adjust_size
          @para_style[:font_size] += @adjust_size
        end
        @para_style[:text_alignment] = options[:text_alignment] || 'left'
        @para_style[:font_color] = options[:font_color] || 'black'
        @para_style[:text_color] = options[:text_color] || 'black'
        @para_style[:fill_color] = options[:fill_color] || 'clear'
        @para_style[:tracking]   = options[:tracking] || 0
        @style_object = @current_style_service.style_object_with_para_style(options[:para_style])
      end
      @current_line_y         = @top_margin + @top_inset
      @starting_x             = @left_margin + @left_inset
      @line_width             = @width - @starting_x - @right_margin - @right_inset
      @font_wrapper = @style_object.font
      space_glyph             = @font_wrapper.decode_utf8(" ").first
      @space_width            = @style_object.scaled_item_width(space_glyph)
      @line_height            = @style_object.font_size*2
      # @line_height            = @font_wrapper[:font_size] + @line_space
      @current_line           = RLineFragment.new(parent:self, contnet_source: self, x: @starting_x, y:@current_line_y,  width: @line_width, height:@line_height, para_style: @para_style,  space_width: @space_width, top_margin: @top_margin, adjust_size: adjust_size)
      @current_line_y         +=@current_line.height
      create_tokens
      layout_tokens
      # TODO: 
      # ajust_height_as_body_height_multiples
      self
    end

    # def to_svg
    #   "<rect fill='yellow' x='#{@x}' y='#{@y}' width='#{@width}' height='#{@height - 2}' />"
    # end

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
      if @text_string.include?("\r\n")
        @text_string.split("\r\n").each do |line_string|
          create_tokens_from_string(line_string)
          @tokens <<  NewLineToken.new()
        end
        @tokens.pop if @tokens.last.class == RLayout::NewLineToken # delete last NewLineToken
      elsif @text_string.include?("\n")
        @text_string.split("\n").each do |line_string|
          create_tokens_from_string(line_string)
          @tokens <<  NewLineToken.new()
        end
        @tokens.pop if @tokens.last.class == RLayout::NewLineToken # delete last NewLineToken
      else
        create_tokens_from_string(@text_string)
      end
    end

    def create_tokens_from_string(string)
      @tokens += string.split(" ").collect do |token_string|
        options = {}
        options[:string]      = token_string
        options[:style_object]  = @style_object
        options[:y]           = 0
        RLayout::RTextToken.new(options)
      end
      #code
    end

    def column_index
      0
    end

    def add_new_line
      # new_line                = RLineFragment.new(parent:self, x: @starting_x, y:@current_line_y,  width: @line_width, height:@line_height, para_style: @para_style,  space_width: @space_width, debug: true, top_margin: @top_margin, style_name:@style_name, adjust_size: adjust_size)
      new_line                = RLineFragment.new(parent:self, contnet_source: self,  x: @starting_x, y:@current_line_y,  width: @line_width, height:@line_height, para_style: @para_style,  space_width: @space_width, top_margin: @top_margin, adjust_size: adjust_size)
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
