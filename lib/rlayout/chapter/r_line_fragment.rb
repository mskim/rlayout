#
#
# CharHalfWidthCushion  = 5.0
CharHalfWidthCushion  = 4.0
MinimunLineRoom       = 4.0

module RLayout
  # RLineFragment
  # RLineFragment are made up of TextTokens, ImageToken, MathToken etc....
  # When paragraph is created, TextTokenAtts is created for default att value for all TextTokena and they are all created using it as default.
  # Whenever there is differnce TextTokenAtts in the paragraph, new TextTokenAtts is created and different TextToken ponts to that one.

  class	RLineFragment < Container
    attr_accessor :next_line, :layed_out_line
    attr_accessor :total_token_width, :room, :overlap
    attr_accessor :text_area, :space_width, :debug, :char_half_width_cushion
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
      @room             = @width
      @overlap          = false
      @layed_out_line   = false
      @token_union_style = @parent.token_union_style if @parent.respond_to?(:token_union_style)
      self
    end

    def clear_tokens
      @graphics = []
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

    # give a line_rect and float_rect, return un-cover rect
    def un_covered_rect(line_rect, covering_rect)
      if line_rect[0] >= covering_rect[0] && (line_rect[0] + line_rect[2]) <= (covering_rect[0] + covering_rect[2])
        # puts "covered all"
        [line_rect[0], line_rect[1] , 0, line_rect[3] ]
      elsif line_rect[0] < covering_rect[0]
        # puts "covered right side"
        [line_rect[0], line_rect[1] , covering_rect[0] - line_rect[0], line_rect[3] ]
      elsif covering_rect[0] + covering_rect[0] <= (line_rect[0] + line_rect[2])
        # puts "covered left side"
        [covering_rect[0] + covering_rect[2], line_rect[1] , line_rect[0] + line_rect[2] - (covering_rect[0] + covering_rect[2]), line_rect[3] ]
      else
        line_rect
      end
    end

    def adjust_text_area_away_from(overlapping_float_rect)
      translated_line_rect = frame_rect.dup
      translated_line_rect[0] += @parent.x
      translated_line_rect[1] += @parent.y
      if intersects_rect(overlapping_float_rect, translated_line_rect)
        un_covered    = un_covered_rect(translated_line_rect, overlapping_float_rect)
        un_covered[0] -= @parent.x # offset relative x back to local coordinate 
        @text_area    = un_covered
        @room         = @text_area[2]
        @overlap      = true
      end
    end

    def has_text_room?
      # @overlap == false && @room > 10
      @room > 20
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

    def previous_line
      i = line_index
      i -= 1
      unless i < 0
        return @parent.graphics[i]
      end
      p_column = @parent.previous_column
      return p_column.graphics.last if p_column
      nil
    end

    def next_text_line
      l_next = next_line
      return nil if l_next.nil?
      return l_next if l_next.has_text_room?
      next_text_line = l_next.next_text_line
      return next_text_line if next_text_line
      nil
    end

    def previous_text_line
      l_prev = previous_line
      return nil if l_prev.nil?
      return l_prev if l_prev.graphics.length > 0
      p_text_line = l_prev.previous_text_line
      return p_text_line if p_text_line
      nil
    end

    # sum of text length + extra space
    def text_length
      @graphics.map{|t| t.width + @space_width}.reduce(:+) + @space_width
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
        @first_line_width   = @text_area[2] - @first_line_indent - @right_indent
        @middle_line_width  = @text_area[2] - @left_indent - @right_indent
      else
        @first_line_width   = @text_area[2]
        @middle_line_width  = @text_area[2]
        if para_style[:left_indent] && para_style[:right_indent]
          @first_line_width   = @text_area[2] - para_style[:left_indent] - para_style[:right_indent]
          @middle_line_width  = @text_area[2] - para_style[:left_indent] - para_style[:right_indent]
        end
      end

      @line_type = line_type
      if @line_type == 'first_line'
        @starting_position  = @first_line_indent
        @text_area[2]    = @first_line_width
      else
        @starting_position  = para_style[:left_indent] || 0
        @text_area[2]    = @middle_line_width
      end
      @room  = @text_area[2]
      #code
    end

    # place tokens in the line, given tokens array
    # return left over tokens array if not all tokens are layed out
    # return false if no leftvver tokens
    # CharHalfWidthCushion = 5.0
    def place_token(token, options={})
      return if token.nil?
      # binding.pry if token.string == '111111'
      if (@room + CharHalfWidthCushion >= token.width)
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
        # give custion only when there are more than 4 tokens
        # puts "++++++++ token.string:#{token.string}"
        # puts "@graphics.length:#{@graphics.length}"
        # puts "@room:#{@room}"
        # puts "token.width:#{token.width}"
        if @graphics.length < 4
          options[:char_half_width_cushion] = @graphics.length
        elsif @graphics.length <= 5
          # puts "in @graphics.length <= 5"
          options[:char_half_width_cushion] = @graphics.length
        else
          options[:char_half_width_cushion] = @graphics.length + 3
        end
        
        # options[:char_half_width_cushion] = @graphics.length
        # puts "options[:char_half_width_cushion]:#{options[:char_half_width_cushion]}"
        #Todo fix this so that only body has cushion
        # puts "@room + options[:char_half_width_cushion]:#{@room + options[:char_half_width_cushion]}"
        if @room + options[:char_half_width_cushion] >= token.width
          # puts "+++++++++ stuffing token into line"
          token.parent = self
          @graphics << token
          @room -= token.width
          @room -= @space_width
          @layed_out_line = true
          return true
        end
        options[:char_half_width_cushion] = 0 # if  @font_size && @font_size > 10
        over_line = @room + options[:char_half_width_cushion] - token.width
        if over_line < @space_width && token.width > @space_width*4
          # this is case where token width slightly exceeds room, make sure that this token is cut
          @result = token.hyphenate_token(@room - @space_width, options)
        elsif @graphics.length < 4
          @result = token.hyphenate_token(@room - 2, options)
        else
          @result = token.hyphenate_token(@room, options)
        end

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
      x  = @starting_position
      @total_token_width = token_width_sum
      @total_space_width = (@graphics.length - 1)*@space_width
      leftover_room  = @text_area[2] - (@total_token_width + @total_space_width)
      @starting_position += @text_area[0] if @text_area[0] != 0
      x  = @starting_position
      case @text_alignment
      when 'justified'
        # in justifed paragraph, we have to treat the last line as left aligned.
        x = @starting_position
        if @line_type == "last_line" && leftover_room > 0
          @graphics.each do |token|
            token.x = x
            x += token.width + @space_width
          end
        else
          @space_width = (@text_area[2] - 1  - @total_token_width)/(@graphics.length - 1)
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
        shift = leftover_room/2.0
        x = @starting_position + shift
        @graphics.each do |token|
          token.x = x
          x += token.width + @space_width
        end
      when 'right'
        x = leftover_room
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
