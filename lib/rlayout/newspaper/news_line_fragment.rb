

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
    attr_accessor :left_indent, :right_indent, :para_style, :text_alignment, :starting_position
    attr_accessor :x, :y, :width, :height, :total_token_width, :room
    attr_accessor :text_area, :text_area_width, :has_text, :space_width, :debug
    def	initialize(options={})
      # options[:stroke_color]      = 'red'
      # options[:stroke_width]      = 1
      options[:layout_direction]  = 'horizontal'
      options[:fill_color]        = options.fetch(:line_color, 'clear')
      # options[:fill_color]        = options.fetch(:line_color, 'lightGray')
      # options[:stroke_width]      = 0.5
      super
      @debug            = options[:debug]
      @graphics         = options[:tokens] || []
      @space_width      = options.fetch(:space_width, 3.0)
      @text_alignment   = options.fetch(:text_alignment, 'left')
      @starting_position = @left_inset || 0
      @stroke_width     = 1
      @text_area        = [@x, @y, @width, @height]
      @text_area_width  = @width
      @room             = @text_area[2]
      self
    end

    def column
      @parent_graphic
    end

    def mark_overflow
      return if @floats.length > 0
      @stroke.color = 'red'
      @stroke.thickness = 1
      @stroke.sides = [1,1,1,1,1,1]
    end

    def adjust_text_area_away_from(overlapping_float_rect)
      #first adjust cordinate offset from pararent graphic
      translated_rect = frame_rect.dup
      translated_rect[0] += @parent_graphic.x
      translated_rect[1] += @parent_graphic.y
      if intersects_rect(overlapping_float_rect, translated_rect)
        @text_area[2] = 0
        @room         = @text_area[2]
      end
    end

    def has_text_room?
      @room > 10
    end

    # is it the first line of the column
    def first_line_in_column?
      self == @parent_graphic.graphics.first
    end

    def first_text_line_in_column?
      self == @parent_graphic.first_text_line_in_column
    end

    # is it the last line of the column
    def last_line_in_column?
      self == @parent_graphic.graphics.last
    end

    def line_index
      @parent_graphic.graphics.index(self)
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
        @first_line_width   = @width
        @middle_line_width  = @width
        if para_style[:head_indent] && para_style[:tail_indent]
          @first_line_width   = @width - para_style[:head_indent] - para_style[:tail_indent]
          @middle_line_width  = @width - para_style[:head_indent] - para_style[:tail_indent]
        end
      end

      @line_type = line_type
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
    # CharHalfWidthCushion = 5.0
    def place_token(token, options={})
      if @room + CharHalfWidthCushion >= token.width
        # place token in line.
        token.parent_graphic = self
        @graphics << token
        @room -= token.width
        @room -= @space_width
        return true
      else
        return false if options[:do_not_break]
        # no more room, try hyphenating token
        @result = token.hyphenate_token(@room)
        if @result == "period at the end of token"
          # this ss when the last char is "." and we can sqeezed it into the line.
          # token is not broken
          @graphics << token
          @room = 0
          return true
        elsif @result.class == TextToken
          @graphics << token  # insert front part to line_count
          return @result       # return second part
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
        # do as left
        x = @starting_position
        @graphics.each do |token|
          token.x = x
          x += token.width + @space_width
        end
      end

    end

    def line_string
      return "" if @graphics.length == 0
      strings = []
      @graphics.each do |token|
        strings << token.string
      end
      string = strings.join(" ")
    end

    def force_fit
      puts "in force fit!!!"
    end

    def tracking_positions_count
      @graphics.map{|t| t.tracking_count}.reduce(:+)
    end

    def reduce_tracking_values_of_tokens_by(width_in_points)
      # we have divide tracking evenly throughout all tokens
      # tracking_positions_count: number of tracking applied positions
      per_tracking_value = width_in_points/tracking_positions_count
      @graphics.map!{|t| t.reduce_tracking_value(per_tracking_value)}
    end

    def space_width_sum
      (@graphics.length - 1)*@space_width
    end

    def reduce_to_fit(options={})
      content_width = token_width_sum + space_width_sum
      over_width = content_width - @width
      if content_width < @width
      elsif over_width > space_width_sum
        if options[:force_fit]
          force_fit
          return
        end
        align_tokens
        mark_overflow
        return
      elsif over_width < space_width_sum/2
        @text_alignment = 'justified'
      else
        @text_alignment = 'justified'
        reduce_amount = over_width/2
        reduce_tracking_values_of_tokens_by(reduce_amount)
      end
      align_tokens

    end

  end

  class OverFlowMarker < Graphic
    def initialize(options)
      puts "in OverFlowMarker"
      options[:is_float] = true
      super
      @x                = @parent_graphic.width - 8
      @y                = @parent_graphic.height - 8
      @width            = 8
      @hwight           = 8
      @stroke_color     = 'red'
      @stroke_width     = 1
      @stroke_sides     = [1,1,1,1,1,1]
      self
    end

  end

end
