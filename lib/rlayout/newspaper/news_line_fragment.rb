

CharHalfWidthCushion  = 5.0
MinimunLineRoom       = 4.0



module RLayout

  # LineFragments
  # LineFragments are made up of TextTokens, ImageToken, MathToken etc....
  # When paragraph is created, TextTokenAtts is created for default att value for all TextTokena and they are all created using it as default.
  # Whenever there is differnce TextTokenAtts in the paragraph, new TextTokenAtts is created and different TextToken ponts to that one.

  # line fill_color is set by optins[:line_color] or it is set to clear
  class	NewsLineFragment < Container
    attr_accessor :line_type #first_line, last_line, drop_cap, drop_cap_side
    attr_accessor :left_indent, :right_indent, :para_style, :text_alignment
    attr_accessor :x, :y, :width, :height, :total_token_width, :room
    attr_accessor :text_area, :has_text, :space_width
    def	initialize(options={})
      # options[:stroke_color]      = 'red'
      # options[:stroke_width]      = 1
      options[:layout_direction]  = 'horizontal'
      options[:fill_color]        = options.fetch(:line_color, 'clear')
      # options[:fill_color]        = options.fetch(:line_color, 'lightGray')
      # options[:stroke_width]      = 0.5
      super
      @graphics         = options[:tokens] || []
      @space_width      = options.fetch(:space_width, 5.0)
      @stroke_width     = 1
      @text_area        = [@x, @y, @width, @height]
      @room             = @text_area[2]

      self
    end

    def adjust_text_area_away_from(overlapping_float_rect)
      #first adjust cordinate offset from pararent graphic
      translated_rect = frame_rect.dup
      translated_rect[0] += @parent_graphic.x
      translated_rect[1] += @parent_graphic.y
      # puts "overlapping_float_rect:#{overlapping_float_rect}"
      # puts "translated_rect:#{translated_rect}"
      if intersects_rect(overlapping_float_rect, translated_rect)
        # puts "++++++++ overlapping_float_rect:#{overlapping_float_rect}"
        # puts "translated_rect:#{translated_rect}"
        @text_area[2] = 0
        @room         = @text_area[2]
      end
    end

    def has_text_room?
      @room > 10
    end

    def text_line?
      @room > 10 || @graphics.length > 0
    end

    def char_count
      line_string.length
    end
    # set line type, and paragraph information for line
    def set_paragraph_info(paragraph, line_type)
      para_style        = paragraph.para_style
      @space_width      = para_style[:space_width]
      @text_alignment   = para_style[:h_alignment]
      @v_offset         = para_style[:v_offset] || 0
      if @text_alignment == "left" || @text_alignment == "justified"
        @first_line_width   = @width - para_style[:first_line_indent] - para_style[:tail_indent]
        @middle_line_width  = @width - para_style[:head_indent] - para_style[:tail_indent]
      else
        #TODO fix this
        @first_line_width   = @width - para_style[:head_indent] - para_style[:tail_indent]
        @middle_line_width  = @width - para_style[:head_indent] - para_style[:tail_indent]
      end

      @line_type = line_type
      # puts "@first_line_width:#{@first_line_width}"
      # puts "@middle_line_width:#{@middle_line_width}"
      if @line_type == 'first_line'
        @starting_position  = para_style[:first_line_indent]
        @text_area_width    = @first_line_width
      else
        @starting_position  = para_style[:head_indent]
        @text_area_width    = @middle_line_width
      end
      @room  = @text_area_width
      #code
    end

    # place tokens in the line, given tokens array
    # return loft over tokens array if not all tokens are layed out
    # return false if no leftvver tokens

    #CharHalfWidthCushion = 5.0


    def place_token(token)
      if @room + CharHalfWidthCushion >= token.width
        # token is place into line.
        token.parent_graphic = self
        @graphics << token
        @room -= token.width
        @room -= @space_width
        return true
      else
        # no more room, try hyphenating token
        result = token.hyphenate_token(@room)
        if result == "period at the end of token"
          # this ss when the last char is "." and we can sqeezed it into the line.
          # token is not broken
          @graphics << token
          @room = 0
          return true
        elsif result.class == TextToken
          # token is broken into two
          @graphics << token  # insert front part to line_count
          return result       # return second part
        end
        # cound not break the token,
        return false
      end
      return false
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
      room  = @text_area_width - (@total_token_width + @total_space_width)
      x     = @starting_position
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
        x = @starting_position
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
