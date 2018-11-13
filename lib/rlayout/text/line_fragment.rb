
module RLayout

  # LineFragments
  # LineFragments are made up of TextTokens, ImageToken, MathToken etc....
  # When paragraph is created, TextTokenAtts is created for default att value for all TextTokena and they are all created using it as default.
  # Whenever there is differnce TextTokenAtts in the paragraph, new TextTokenAtts is created and different TextToken ponts to that one.
  # line fill_color is set by optins[:line_color] or it is set to clear
  class	LineFragment < Container
    attr_accessor :line_type #first_line, last_line, drop_cap, drop_cap_side
    attr_accessor :left_indent, :right_indent, :para_style, :text_alignment, :starting_position
    attr_accessor :x, :y, :width, :height, :total_token_width, :room
    attr_accessor :text_area, :text_area_width, :has_text, :space_width, :debug
    def	initialize(options={})
      # options[:stroke_color]      = 'red'
      options[:layout_direction]  = 'horizontal'
      options[:fill_color]        = options.fetch(:line_color, 'clear')
      # options[:stroke_width]      = 0.5
      super
      @debug            = options[:debug]
      @graphics         = options[:tokens] || []
      @space_width      = @parent.space_width
      @text_alignment   = @parent.para_style[:text_alignment]
      @starting_position = @left_inset || 0
      @stroke_width     = 1
      @text_area        = [@x, @y, @width, @height]
      @text_area_width  = @width
      @room             = @text_area[2]
      self
    end

    def column
      @parent
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
      translated_rect[0] += @parent.x
      translated_rect[1] += @parent.y
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
      self == @parent.graphics.first
    end

    def first_text_line_in_column?
      self == @parent.first_text_line_in_column
    end

    # is it the last line of the column
    def last_line_in_column?
      self == @parent.graphics.last
    end

    def line_index
      @parent.graphics.index(self)
    end

    def text_line?
      @room > 10 || @graphics.length > 0
    end

    def char_count
      line_string.length
    end

    # place tokens in the line, given tokens array
    # return loft over tokens array if not all tokens are layed out
    # return false if no leftvver tokens
    #CharHalfWidthCushion = 5.0
    def place_token(token, options={})
      if @room + CharHalfWidthCushion >= token.width
        # place token in line.
        token.parent = self
        @graphics << token
        @room -= token.width
        @room -= @space_width
        return true
      else
        return false if options[:do_not_break]
        # no more room, try hyphenating token
        result = token.hyphenate_token(@room)
        if result == "front forbidden character"
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
      room  = @width - (@total_token_width + @total_space_width)
      x = @starting_position
      @graphics.each do |token|
        token.x = x
        x += token.width + @space_width
      end

      case @text_alignment
      when 'justified'
        # in justifed paragraph, we have to treat the last line as left aligned.
        if @line_type == "last_line" && room > 0
          x = @starting_position
          @graphics.each do |token|
            token.x = x
            x += token.width + @space_width
          end
        else
          x = 0
          @space_width = (@width - @total_token_width)/(@graphics.length - 1)
          @graphics.each do |token|
            token.x = x
            x += token.width + @space_width
          end
        end

      when 'center'
        @graphics.map {|t| t.x += room/2.0}
      when 'right'
        @graphics.each do |token|
          token.x += room
          token.y = @v_offset
          # x += token.width + @space_width
        end
      else
        # do as left

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

    def relayout!
      puts "in relayout! of LineFragment"
      align_tokens
    end

  end

  class OverFlowMarker < Graphic
    def initialize(options)
      puts "in OverFlowMarker"
      options[:is_float] = true
      super
      @x                = @parent.width - 8
      @y                = @parent.height - 8
      @width            = 8
      @hwight           = 8
      @stroke_color     = 'red'
      @stroke_width     = 1
      @stroke_sides     = [1,1,1,1,1,1]
      self
    end

  end

end
