module RLayout

  # TitleText single line uniform styled text
  # used for title, subject_head
  # It can squeeze text
  class TitleText < Container
    attr_accessor :tokens, :string, :style_name, :para_style, :room, :text_alignment, :height_in_lines

    def initialize(options={})
      @string                 = options.delete(:text_string)
      # options[:fill_color]    = 'red'
      super
      @tokens                 = []
      @room                   = @width
      @style_name             = options[:style_name]
      @para_style             = NEWSPAPER_STYLE[@style_name]
      @para_style             = Hash[@para_style.map{ |k, v| [k.to_sym, v] }]
      @space_width            = @para_style[:space_width] || @para_style[:font_size]
      @text_alignment         = options[:text_alignment] || 'left'
      @body_line_height       = options[:body_line_height] || 14
      @text_height_in_lines   = @para_style[:text_height_in_lines] || 2
      @space_before_in_lines  = @para_style[:space_before_in_lines] || 0
      @top_inset              = @space_before_in_lines*@body_line_height
      @top_inset              += options[:top_inset] if options[:top_inset]
      @space_after_in_lines   = @para_style[:space_after_in_lines] || 0
      @tracking               = @para_style.fetch(:tracking, 0)
      @bottom_inset           = @space_after_in_lines*@body_line_height
      @height_in_lines        = 0
      @height_in_lines        = @space_before_in_lines + @text_height_in_lines + @space_after_in_lines
      @height                 = @height_in_lines*@body_line_height
      @line                   = NewsLineFragment.new(parent:self, width:@width, height:@height)

      create_tokens
      layout_title_toknes
      self
    end

    def create_tokens
      @tokens += @string.split(" ").collect do |token_string|
        options = {}
        options[:string]  = token_string
        options[:y]       = @top_inset
        if RUBY_ENGINE == 'rubymotion'
          options[:atts]    = ns_atts_from_style(@para_style)
        end
        # options[:stroke_width] = 1
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
        reduce_tracking_values_of_tokens
      end
      token = tokens.shift
      while token
        result = @line.place_token(token, do_not_break: true, testing:true)
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
      @line.align_tokens
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
      @space_width *= 0.8
    end

    def reduce_tracking_values_of_tokens
      @tokens = @tokens.map{|t| t.reduce_tracking_value}
    end

    def squeeze_tokens_to_fit
      # see if remaining tokesn width sum is squeezeable
      if token_width_sum/@token_width_sum < 0.8
      #code
      end
    end

    def graphics_width_sum
      @graphics.map{|t| t.width}.reduce(:+)
    end

    def graphis_pace_width_sum
      (@graphics.length - 1)*@space_width
    end

    def align_tokens
      return if @graphics.length == 0
      @total_token_width = token_width_sum
      @graphics_width_sum = (@graphics.length - 1)*@space_width if @graphics.length > 0
      room  = @width - (graphics_width_sum + graphics_width_sum)
      x     = 0
      case @text_alignment
      when 'justified'
        # in justifed paragraph, we have to treat the last line as left aligned.
        if @line_type == "last_line"
          x = @starting_position
          @graphics.each do |token|
            token.x = x
            x += token.width + @space_width
          end
        else
          @space_width = (@text_area_width - @total_token_width)/(@graphics.length - 1)
          @graphics.each do |token|
            token.x = x
            x += token.width + @space_width
          end
        end
      when 'left'
        x = 0
        @graphics.each do |token|
          token.x = x
          x += token.width + @space_width
        end
      when 'center'
        @graphics.map {|t| t.x += room/2.0}
      when 'right'
        x = room
        @graphics.each do |token|
          token.x += x
          token.y = @v_offset
          x += token.width + @space_width
        end
      else
        # do as left
        x = @starting_position
        @graphics.each do |token|
          token.x = x
          x += token.width + @space_width
        end
      end

    end


    def relayout!
      puts __method__
      # layout_title_toknes
    end
  end

end
