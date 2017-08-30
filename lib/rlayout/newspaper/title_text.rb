module RLayout

  # TitleText single line uniform styled text
  # used for title, subject_head
  # It can squeeze text
  class TitleText < Container
    attr_accessor :tokens, :string, :para_style_name, :para_style, :room

    def initialize(options={})
      super
      @tokens           = []
      @room             = @width
      @string           = options[:string]
      @para_style_name  = options[:para_style_name]
      @para_style       = NEWSPAPER_STYLE[@para_style_name]
      @para_style       = Hash[@para_style.map{ |k, v| [k.to_sym, v] }]
      @space_width      = @para_style[:space_width] || @para_style[:font_size]
      @body_line_height = options[:body_line_height] || 14
      if options[:text_height_in_lines]
        @height = options[:text_height_in_lines]*@body_line_height
      else
        @height         = @para_style[:font_size]*1.5
      end
      create_tokens
      layout_title_toknes
      self
    end

    def create_tokens
      @tokens += @string.split(" ").collect do |token_string|
        options = {}
        options[:string]  = token_string
        if RUBY_ENGINE == 'rubymotion'
          options[:atts]    = ns_atts_from_style(@para_style)
        end
        RLayout::TextToken.new(options)
      end
    end

    def token_width_sum
      @tokens.map{|t| t.width}.reduce(:+)
    end

    def space_width_sum
      (@tokens.length - 1)*@space_width
    end

    def layout_title_toknes
      if @width <= token_width_sum + space_width_sum
        reduce_space_width_to_fit
      end
      if @width <= token_width_sum + space_width_sum
        squeeze_tokens_to_fit
      end

      token = tokens.shift
      while token
        result = place_token(token)
        # forcing not to break the token
        # result can be one of two
        # case 1. entire token placed succefully, returned result is true
        # case 2. entire token is rejected from the line

        if result # case 1
          # entire token placed succefully, returned result is true
          token = tokens.shift
        else  # case 2
          # entire token was rejected,
          mark_over_flow
        end
      end
    end

    # place tokens in the line, given tokens array
    # return loft over tokens array if not all tokens are layed out
    # return false if no leftvver tokens
    #CharHalfWidthCushion = 5.0
    def place_token(token)
      if @room  >= token.width
        # place token in line.
        token.parent_graphic = self
        @graphics << token
        @room -= token.width
        @room -= @space_width
        return true
      else
        return false
      end
      return false
    end

    def mark_over_flow
      #code
    end

    def reduce_space_width_to_fit
      @space_width = @space_width/1.2
    end

    def squeeze_tokens_to_fit
      # see if remaining tokesn width sum is squeezeable
      if token_width_sum/@token_width_sum < 0.8
      #code
      end
    end

    def relayout!
      layout_title_toknes
    end
  end

end
