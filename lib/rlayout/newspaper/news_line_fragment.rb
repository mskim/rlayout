




module RLayout

  # LineFragments
  # LineFragments are made up of TextTokens, ImageToken, MathToken etc....
  # When paragraph is created, TextTokenAtts is created for default att value for all TextTokena and they are all created using it as default.
  # Whenever there is differnce TextTokenAtts in the paragraph, new TextTokenAtts is created and different TextToken ponts to that one.

  # line fill_color is set by optins[:line_color] or it is set to clear
  class	NewsLineFragment < Container
    attr_accessor :line_type #first_line, last_line, drop_cap, drop_cap_side
    attr_accessor :left_indent, :right_indent, :para_style
    attr_accessor :x, :y, :width, :height, :total_token_width, :room
    attr_accessor :paragraph, :font_size
    def	initialize(options={})
      # options[:stroke_color]    = 'red'
      options[:layout_direction]  = 'horizontal'
      options[:fill_color]        = options.fetch(:line_color, 'clear')

      super
      @room             = @width
      @graphics         = options[:tokens] || []
      @space_width      = options.fetch(:space_width, 5.0)
      @stroke_width     = 1
      self
    end

    def set_paragraph(paragraph)
      @paragraph = paragraph
      @font_size = paragraph.para_style[:text_size]
    end

    def set_line_type(line_type)
      @para_style = paragraph.para_style
      if @para_style[:h_alignment] == "left" || @para_style[:h_alignment] == "justified"
        @first_line_width = @width - @para_style[:first_line_indent] - @para_style[:tail_indent]
        @text_line_width  = @width - @para_style[:head_indent] - @para_style[:tail_indent]
      else
        @first_line_width = @width - @para_style[:head_indent] - @para_style[:tail_indent]
        @text_line_width  = @width - @para_style[:head_indent] - @para_style[:tail_indent]
      end

      @line_type = line_type
      if @line_type == 'first_line'
        @x     = @paragraph.para_style[:first_line_indent]
        @width = @first_line_width
      else
        @x     = @paragraph.para_style[:head_indent]
        @width = @text_line_width
      end
      #code
    end

    # place tokens in the line, given tokens array
    # return loft over tokens array if not all tokens are layed out
    # return false if no leftvver tokens
    def place_tokens(tokens)
      while token = tokens.shift
        if token.width <= @room
          token.parent_graphic = self
          @graphics << token
          @room -= token.width
          @room -= @paragraph.para_style[:space_width]
        else
          tokens.unshift(token)
          return tokens
        end
      end
      false # this mean no more tokens are left
    end

    def token_width_sum
      @graphics.map{|t| t.width}.reduce(0, :+)
    end

    def rect
      [@x, @y, @width, @height]
    end

    def align_tokens
      return if @graphics.length == 0
      @total_token_width = token_width_sum
      @total_space_width = (@graphics.length - 1)*@space_width if @graphics.length > 0
      room = @width - (@total_token_width + @total_space_width)
      x = 0.0
      @graphics.each do |token|
        token.x = x
        x += token.width + @space_width
      end

      case @para_style[:text_alignment]
      when 'left'
      when 'center'
        @graphics.map {|t| t.x += room/2.0}
      when 'right'
        @graphics.map do |t|
          t.x += room
        end
      #TODO
      # when 'justified'
      #   if is_last_line?
      #   else
      #     just_space = room/(@graphics.length - 1)
      #     x = 0
      #     @graphics.each_with_index do |token, i|
      #       token.x = x
      #       x += token.width + just_space
      #     end
      #   end
      else

      end

    end

    def line_string
      strings = []
      @graphics.each do |token|
        strings << token.string
      end
      string = strings.join(" ")
    end
  end

end
