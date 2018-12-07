#
#
CharHalfWidthCushion  = 2.0
MinimunLineRoom       = 4.0

module RLayout
  # RLineFragment
  # RLineFragment are made up of TextTokens, ImageToken, MathToken etc....
  # When paragraph is created, TextTokenAtts is created for default att value for all TextTokena and they are all created using it as default.
  # Whenever there is differnce TextTokenAtts in the paragraph, new TextTokenAtts is created and different TextToken ponts to that one.

  class	RLineFragment < Container
    attr_accessor :next_line, :layed_out_line
    attr_accessor :total_token_width, :room, :overlap
    attr_accessor :text_area, :text_area_width, :space_width, :debug, :char_half_width_cushion
    attr_accessor :line_type #first_line, last_line, drop_cap, drop_cap_side
    attr_accessor :left_indent, :right_indent,  :text_alignment, :starting_position, :first_line_indent
    attr_accessor :token_union_rect, :token_union_style
    attr_accessor :font, :font_size, :para_style

    def	initialize(options={})
      options[:layout_direction]  = 'horizontal'
      options[:fill_color]        = options.fetch(:line_color, 'clear')
      @space_width                = options[:space_width] || 3
      @char_half_width_cushion    = @space_width/3
      options[:right_margin]      = 2
      super

      if options[:para_style]
        @para_style       = options[:para_style]
      elsif options[:parent] && options[:parent].respond_to?(:para_style)
        @para_style       = options[:parent].para_style
      end

      if @para_style
        @font             = @para_style[:font]
        @font_size        = @para_style[:font_size]
        @text_alignment   = @para_style[:alignment]
      end
      @text_alignment   = options[:text_alignment] if options[:text_alignment]
      @debug            = options[:debug]
      @graphics         = options[:tokens] || []
      @starting_position = @left_inset || 0
      @stroke_width     = 1
      @text_area        = [@x, @y, @width, @height]
      @text_area_width  = @width
      @room             = @width
      @overlap          = false
      @layed_out_line   = false
      @token_union_style = @parent.token_union_style if @parent.respond_to?(:token_union_style)
      self
    end

    def clear_tokens
      @graphics = []
    end

    def next_text_line
      l_next = next_line
      return nil if l_next.nil?
      return l_next if l_next.has_text_room?
      next_text_line = l_next.next_text_line
      return next_text_line if next_text_line
      nil
    end

    def width_of_token_union
      return 0 if @graphics.length == 0
      max_x = @graphics.last.x + @graphics.last.width #TODO
      max_x - @graphics.first.x
    end

    def create_token_union_rect
      return unless @graphics
      return if @graphics.length == 0
      return unless @token_union_style
      tokens = @graphics.dup
      token_union_options               = {}
      token_union_options               = @token_union_style.dup if @token_union_style
      token_union_options[:fill_color]  = 'clear'
      token_union_options[:x]           = tokens.first.x - 0.85 #TODO
      token_union_options[:y]           = tokens.first.y
      token_union_options[:y]           = tokens.first.y - token_union_options[:top_line_space] if token_union_options[:top_line_space]
      max_x                             = tokens.last.x + tokens.last.width + 1.5 #TODO
      token_union_options[:width]       = max_x - token_union_options[:x]
      token_union_options[:height]      = tokens.first.height
      token_union_options[:parent]      = self
      @token_union_rect                 = Rectangle.new(token_union_options)
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
        @room         = 0
        @overlap      = true
      end
    end

    def has_text_room?
      @overlap == false && @room > 10
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
    # set line type, and paragraph information for line
    def set_paragraph_info(paragraph, line_type)
      @para_style       = paragraph.para_style
      @font             = @para_style[:font]
      @font_size        = @para_style[:font_size]
      @space_width      = @para_style[:space_width] || 3.0
      @text_alignment   = @para_style[:alignment] || "left"
      @v_offset         = @para_style[:v_offset] || 0
      @first_line_indent = @para_style[:first_line_indent] || para_style[:font_size] || para_style[:text_size]
      @right_indent      = @para_style[:right_indent] || 0
      @left_indent      = @para_style[:left_indent] || 0
      if @text_alignment == "left" || @text_alignment == "justified"
        @first_line_width   = @width - @first_line_indent - @right_indent
        @middle_line_width  = @width - @left_indent - @right_indent
      else
        @first_line_width   = @width
        @middle_line_width  = @width
        if para_style[:left_indent] && para_style[:right_indent]
          @first_line_width   = @width - para_style[:left_indent] - para_style[:right_indent]
          @middle_line_width  = @width - para_style[:left_indent] - para_style[:right_indent]
        end
      end

      @line_type = line_type
      if @line_type == 'first_line'
        @starting_position  = @first_line_indent
        @text_area_width    = @first_line_width
      else
        @starting_position  = para_style[:left_indent] || 0
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
      return if token.nil?
      if @room + CharHalfWidthCushion >= token.width
      # if @room + @char_half_width_cushion >= token.width
        # place token in line.
        token.parent = self
        @graphics << token
        @room -= token.width
          @room -= @space_width
        @layed_out_line = true
        return true
      else
        return false if options[:do_not_break]
        # no more room, try hyphenating token
        @result = token.hyphenate_token(@room)
        if @result == "front forbidden character"
          # this ss when the last char is "." and we can sqeezed it into the line.
          # token is not broken
          token.parent = self
          @graphics << token
          @room = 0
          return true
        elsif @result.class == RTextToken || @result.class == TextToken
          token.parent = self
          @graphics << token  # insert front part to line_count
          return @result       # return second part
        end
        # cound not break the token,
        return false
      end
      return false
    end

    def layed_out_line?
      @layed_out_line == true
    end

    def token_width_sum
      @graphics.map{|t| t.width}.reduce(0, :+)
    end

    def rect
      [@x, @y, @width, @height]
    end

    def align_tokens
      return if @graphics.length <= 0
      @total_token_width = token_width_sum
      @total_space_width = (@graphics.length - 1)*@space_width
      room  = @text_area_width - (@total_token_width + @total_space_width)
      x     = @starting_positions
      case @text_alignment
      when 'justified'
        # in justifed paragraph, we have to treat the last line as left aligned.
        x = @starting_position
        if @line_type == "last_line" && room > 0
          @graphics.each do |token|
            token.x = x
            x += token.width + @space_width
          end
        else
          @space_width = (@text_area_width - 1  - @total_token_width)/(@graphics.length - 1)
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
        shift = room/2.0
        x = @starting_position + shift
        @graphics.each do |token|
          token.x = x
          x += token.width + @space_width
        end
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
      create_token_union_rect
    end

    def line_string
      return "" if @graphics.length == 0
      strings = []
      @graphics.each do |token|
        strings << token.string if token.class != Rectangle
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
      #TODO ruduce space width also
      # divide tracking evenly throughout all tokens
      # tracking_positions_count: number of tracking applied positions
      per_tracking_value = width_in_points/tracking_positions_count
      @graphics.map!{|t| t.reduce_token_width_with_new_tracking_value(per_tracking_value)}
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
