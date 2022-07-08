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
    attr_accessor :total_token_width, :overlap
    attr_accessor :text_area, :room, :space_width, :char_half_width_cushion
    attr_accessor :line_type #first_line, last_line, drop_cap, drop_cap_side
    attr_accessor :left_indent, :right_indent,  :text_alignment, :starting_position, :first_line_indent
    attr_accessor :token_union_rect, :token_union_style
    attr_accessor :font, :font_size, :para_style, :content_cleared
    attr_accessor :style_name, :has_mixed_token, :adjust_size
    attr_accessor :content_source # r_paragraph, title_text, text

    # set content_source and use style_object from content_source

    def	initialize(options={})
      options[:layout_direction]  = 'horizontal'
      options[:fill_color]        = options.fetch(:line_color, 'clear')
      options[:stroke_width]      = 1
      options[:stroke_color]      = 'black'
      options[:fill_color]        = 'gray'
      options[:fill_color]        = 'yellow'
      @space_width                = options[:space_width] || 7
      @char_half_width_cushion    = @space_width/3
      options[:right_margin]      = 2 
      options[:stroke_width] = 1.0

      super
      @content_source = options[:content_source]
      if options[:style_name]
        @style_name = options[:style_name]
      elsif options[:para_style]
        @para_style       = options[:para_style]
        @font             = @para_style[:font]
        @font_size        = @para_style[:font_size]
        @text_alignment   = @para_style[:text_alignment] || 'left'
      elsif options[:parent] && options[:parent].respond_to?(:para_style)
        @para_style       = options[:parent].para_style
      else
        @style_name = 'body'
      end
      @adjust_size      = options[:adjust_size] if options[:adjust_size]
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
    
    def log
      "#{page_number}_#{line_index}:#{line_string}\n"
    end

    def page_number
      return 1 unless @parent
      @parent.page_number
    end

    def collect_line_content
      line_info = {}
      tokens = []
      while graphic = @graphics.shift do
        tokens << graphic
      end 
      @content_cleared = true  
      tokens  
      line_info[:tokens] = tokens
      line_info[:para_style] = @para_style if @para_style
      line_info[:style_name] = @style_name if @style_name
      line_info
    end

    def place_line_content_from(line_data)
      tokens = []
      if line_data.class == Hash
        tokens = line_data[:tokens]
        @para_style = line_data[:para_style] if line_data[:para_style]
        @style_name = line_data[:style_name] if line_data[:style_name]
      elsif line_data.class == Array
        tokens = line_data
      end
      while token = tokens.shift do
        token.parent = self
        @graphics << token
      end
      @layed_out_line = true
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

    def page
      if @parent
        @parent.parent
      else
        nil
      end
    end

    def document
      if page
        @page.parent
      end
    end

    def mark_overflow
      return if @floats.length > 0
      @stroke.color = 'red'
      @stroke.thickness = 1
      @stroke[:sides] = [1,1,1,1,1,1]
    end

    # given a line_rect and float_rect, return un-cover rect
    def un_covered_rect(line_rect, covering_rect)
      gap = 8
      if line_rect[0] >= covering_rect[0] && (line_rect[0] + line_rect[2]) <= (covering_rect[0] + covering_rect[2])
        # puts "covered all"
        [line_rect[0], line_rect[1] , 0, line_rect[3] ]
      elsif line_rect[0] < covering_rect[0]
        # puts "covered right side"
        [line_rect[0], line_rect[1] , covering_rect[0] - line_rect[0] - gap, line_rect[3] ]
      elsif covering_rect[0] + covering_rect[2] <= (line_rect[0] + line_rect[2])
        # puts "covered left side
        [covering_rect[0] + covering_rect[2] + gap, line_rect[1] , line_rect[0] + line_rect[2] - (covering_rect[0] + covering_rect[2] + gap), line_rect[3] ]
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
        @room = @text_area[2]
        @overlap      = true
      end
    end

    def has_text_room?
      @text_area[2] > 20
    end

    # is it the first line of the column
    def first_line_in_column?
      self == @parent.graphics.first
    end

    def line_index
      @parent.graphics.index(self)
    end
    
    def first_text_line?
      self == @parent.first_text_line
    end

    # is it the last line of the column
    def last_line_in_column?
      self == @parent.graphics.last
    end

    def line_index
      @parent.graphics.index(self)
    end

    def text_line?
      @text_area[2] > 20
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
      # next_text_line = @parent.next_text_line(self)
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
      @style_name       = paragraph.style_name
      @para_style       = paragraph.para_style
      if @para_style
        @font             = @para_style[:font]
        @font_size        = @para_style[:font_size]
        @space_width      = @para_style[:space_width] || 3.0
        @text_alignment   = @para_style[:text_alignment] || "left"
        @v_offset         = @para_style[:v_offset] || 0
        @first_line_indent = @para_style[:first_line_indent] || 0
        @right_indent      = @para_style[:right_indent] || 0
        @left_indent       = @para_style[:left_indent] || 0
      else
        binding.pry
      end

      @line_type = line_type
      if @line_type == 'first_line'
        @starting_position  = @first_line_indent
        @first_line_width   = @text_area[2] - @first_line_indent - @right_indent
        @text_area[2] = @first_line_width
        @room = @text_area[2]
      else
        @starting_position  = para_style[:left_indent] || 0
        @middle_line_width  = @text_area[2] - @left_indent - @right_indent
        @text_area[2]    = @middle_line_width
        @room = @text_area[2]
      end

      if @text_alignment == "left" || @text_alignment == "justify"        
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
    end

    def add_footnote_description_to_column(token)
      column.add_footnote_description_item(token.footnote_item_number.to_i - 1)
    end

    # place tokens in the line, given tokens array
    # return left over tokens array if not all tokens are layed out
    # return false if no leftvver tokens
    # CharHalfWidthCushion = 5.0

    # TODO reduce room by first_line_indent
    # if line is first_line 
    def place_token(token, options={})
      return if token.nil?
      return true if token.string == ""
      return false if @room <= 0
      
      if (@room + CharHalfWidthCushion >= token.width)
        token.parent = self
        @graphics << token
        @room -= token.width
        #TODO fix this
        @space_width = 7 if @space_width.nil?
        @room -= @space_width
        @layed_out_line = true
        return true
      else
        return false if @text_alignment != 'justify'
        return false if options[:do_not_break]
        return false if token.has_footnote_marker
        if @graphics.length < 4
          options[:char_half_width_cushion] = @graphics.length
        elsif @graphics.length <= 5
          # puts "in @graphics.length <= 5"
          options[:char_half_width_cushion] = @graphics.length
        else
          options[:char_half_width_cushion] = @graphics.length + 3
        end
        if @room + options[:char_half_width_cushion] >= token.width
          token.parent = self
          @graphics << token
          @room -= token.width
          @room -= @space_width
          @layed_out_line = true
          return true
        end
        options[:char_half_width_cushion] = 0 unless options[:char_half_width_cushion]
        over_line = @room + options[:char_half_width_cushion] - token.width
        if over_line < @space_width && token.width > @space_width*4
          # this is case where token width slightly exceeds @room@room, make sure that this token is cut
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
          @room  = 0
          return true
        elsif @result.class == RTextToken
          token.parent = self
          @graphics << token  # insert front part to line_count
          return @result       # return second part
        end
        # cound not break the token,
        return false
      end
      return false
    end

    def unoccupied_line?
      layed_out_line == false && @text_area[2] > 20
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
      # when column @inset > 0,  @text_area[0] is not 0
      # so handle it by @text_area[0] - @x
      @starting_position += @text_area[0] - @x if @text_area[0] - @x != 0
      x  = @starting_position
      case @text_alignment
      when 'justify'
        # in justifed paragraph, we have to treat the last line as left aligned.
        x_position = @starting_position
        if @line_type == "last_line" && leftover_room > 0
          @graphics.each do |token|
            token.x = x_position
            x_position += token.width + @space_width
          end
        else
          @space_width = (@text_area[2] - 1  - @total_token_width)/(@graphics.length - 1)
          @graphics.each do |token|
            token.x = x_position
            x_position += token.width + @space_width
          end
        end
      when 'left'
        x_position = @starting_position
        @graphics.each do |token|
          token.x = x_position
          x_position += token.width + @space_width
        end
      when 'center'
        shift = leftover_room/2.0
        x_position = @starting_position + shift
        @graphics.each do |token|
          token.x = x_position
          x_position += token.width + @space_width
        end
      when 'right'
        x_position = leftover_room
        @graphics.each do |token|
          token.x += x_position
          token.y = @v_offset
          x_position += token.width + @space_width
        end
      else
        # do as left
        x_position = @starting_position
        @graphics.each do |token|
          token.x = x_position
          x_position += token.width + @space_width
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

    def text_string
      line_string
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
        @text_alignment = 'justify'
      else
        @text_alignment = 'justify'
        reduce_amount = over_width/2
        reduce_tracking_values_of_tokens_by(reduce_amount)
      end
      align_tokens
    end

    def first_token
      @graphics.first
    end

    def last_token
      @graphics.last
    end

    def svg_rect_string
      h = @height - 3
      if @graphics.length == 0
        "x='#{x}' y='#{y}' width='#{0}' height='#{h}'"
      else
        if @parent
          x = @parent.x + first_token.x
          y = @parent.y + @y
        else
          x = first_token.x
          y = @y
        end
        w = last_token.x_max - first_token.x
        "x='#{x}' y='#{y}' width='#{w}' height='#{h}'"
      end
    end
    

    # def to_svg
    #   s = "<rect fill='gray' #{svg_rect_string} />"
    #   return s if @graphics.length > 0 && @layed_out_line
    #   "" 
    # end
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
