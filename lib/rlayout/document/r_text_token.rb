
module RLayout


  class NewLineToken < Graphic
    attr_accessor :string
    def initialize(options={})
      super
      @string = ""
      @width  = 0
      self
    end
  end

  class RTextToken < Graphic
    attr_accessor :string, :font_size
    attr_accessor  :token_type, :has_text, :char_half_width_cushion
    attr_reader :adjust_size
    attr_reader :style_name, :current_style
    attr_reader :font_wrapper, :glyphs, :style_object, :has_missing_glyph
    attr_reader  :has_footnote_marker, :footnote_item_number
    attr_reader :base_width, :superscript_text, :superscript_width, :post_superscript_text, :post_superscript_width

    def initialize(options={})
      options[:fill_color] = options.fetch(:token_color, 'clear')
      options[:stroke_width] = 1
      super
      @style_object  = options[:style_object]
      @font_wrapper  = @style_object.font
      @font_size = @style_object.scaled_font_size
      @string = options[:string] || options[:text_string]
      @token_type = options[:token_type] if options[:token_type]

      if @string =~FOOTNOTE_TEXT_ITEM
        # TODO change front string other than [^\d]:
        # do nothing if /^\[\^(\d*?)\]:/
        # this is 
        @string = "(#{$1})"
        @glyphs = filter_glyph(@string) 
        @width= @glyphs.map {|g| @style_object.scaled_item_width(g)}.reduce(:+)
      elsif @string =~FOOTNOTE_MARKER
        @footnote_item_number = $1
        @has_footnote_marker = true
        footnote_marker_to_superscript
        @glyphs = filter_glyph(@string) 
        @base_width= @glyphs.map {|g| @style_object.scaled_item_width(g)}.reduce(:+)
        # create footnote marker token
        #TODO set  @style_object superscript: true
        superscrupt_glyphs = @font_wrapper.decode_utf8(@superscript_text)
        # TODO 
        @superscript_width= superscrupt_glyphs.map {|g| @style_object.scaled_item_width(g)}.reduce(:+)
        @post_superscript_width =  0
        if @post_superscript_text
          #  단어[^1]로  로 is @post_superscript_text
          post_superscrupt_glyphs  = @font_wrapper.decode_utf8(@superscript_text)
          @post_superscript_width= post_superscrupt_glyphs.map {|g| @style_object.scaled_item_width(g)}.reduce(:+)
        end
        @width = @base_width + @superscript_width + @post_superscript_width
      else
        #filter unsupported glyph!!!! replace it with ???
        @glyphs = filter_glyph(@string) 
        @width= @glyphs.map {|g| @style_object.scaled_item_width(g)}.reduce(:+)
      end

      @has_text         = true
      @char_half_width_cushion = 0
      @char_half_width_cushion  = @font_size/2

      if options[:text_line_spacing] && options[:text_line_spacing].class != String
        @height += options[:text_line_spacing]
      end
      self
    end

    # split @string into @string, and @superscript_text
    # original @string = myword[^1] 
    # @string = myword , @superscript_text = (1)
    def footnote_marker_to_superscript
      array = @string.split("[^")
      @string = array[0]
      # super_number = array[1].sub(/]$/, "") can't hanle post_superscript_text
      # handle case for 단어[^1]의
      post_super_array = array[1].split("]")
      super_number = post_super_array[0]
      @superscript_text = "(#{super_number})"
      @post_superscript_text =  post_super_array[1] if post_super_array.length > 1
    end

    def size
      [@width, @height]
    end

    #####  checking for missing glyphs and replace it with  ???
    def filter_glyph(token_string)
      glyphs = @font_wrapper.decode_utf8(token_string)
      glyph_class_list = glyphs.map{|g| g.class}
      if glyph_class_list.include?(HexaPDF::Font::InvalidGlyph)
        @has_missing_glyph = true
        missing_chars = []
        missing_chars_indexes = []
        glyph_class_list.each_with_index do |g, i|
          if g == HexaPDF::Font::InvalidGlyph
            missing_chars << token_string[i]
            missing_chars_indexes << i
          end
        end
        missing_chars.each do |char|
          token_string.sub!(char, "???")
        end
        glyphs = @font_wrapper.decode_utf8(token_string)
      end
      glyphs
    end

    # def draw_text(canvas)
    #   if @string.length > 0 
    #     # TODO replace it with set_
    #     @style_service = RLayout::StyleService.shared_style_service
    #     @style_service.set_canvas_text_style_with_para_styl(canvas, @para_style)
    #     f = flipped_origin
    #     x_offset = f[0]
    #     y_offset = f[1]
    #     canvas.text(@string, at: [x_offset, y_offset - size])
    #   end
    # end
  
    def width_of_string(string, options={})
      return 0 if string.nil?
      return 0 if string == ""
      glyphs     = @font_wrapper.decode_utf8(string)
      glyphs.map{|g| @style_object.scaled_item_width(g)}.reduce(:+)
    end

    def tracking_count
      return 0 unless @string
      @string.length - 1
    end

    # reduce the tracking value of token by 10%
    def reduce_token_width_with_new_tracking_value(tracking_value)
      @width -= tracking_value*(@string.length - 1)
      self
    end

    FORBIDDEN_FIRST_CHARS_AT_END = /[\.|\,|!|\?|\)|}|\]|>|’|”]$/
    FORBIDDEN_FIRST_CHARS_AT_FRONT = /^[\.|\,|!|\?|\)|}|\]|>|’|”]/
    FORBIDDEN_FIRST_CHARS = /[\.|\,|!|\?|\)|}|\]|>|’|”]/

    FORBIDDEN_LAST_CHARS  = /[\(|{|\[|<|‘|“]/
    FORBIDDEN_LAST_CHARS_AT_END  = /[\(|{|\[|<|‘|“]$/

    NUMBERS_RUN_RE     = /^\d+\,?\d+/
    NUMBERS_RUN_WITH_PERCENT_P_RE     = /^\d+\,?\d+%p/
    RANDD_RE           = /^R&D/


    # return false if break_position < MinimunLineRoom
    # split string into two and return splited_second_half_attsting
    def break_attstring_at(break_position, options={})
      # give a char_half_c""
      return false if break_position < MinimunLineRoom
      return false if @string =~ NUMBERS_RUN_RE || @string =~ RANDD_RE || @string =~ NUMBERS_RUN_WITH_PERCENT_P_RE

      @char_half_width_cushion = options[:char_half_width_cushion] if options[:char_half_width_cushion]
      string_length = @string.length
      (1..string_length).to_a.each do |i|
        front_range = [0,i]
        sub_string_incremented = @string[0..i]
        if i == (string_length - 1) && sub_string_incremented =~ FORBIDDEN_FIRST_CHARS_AT_END
          # puts "FORBIDDEN_FIRST_CHARS_AT_END"
          # we have front forbidden character . ? , !
          return "front forbidden character"
        elsif i == (string_length - 1) && sub_string_incremented =~ FORBIDDEN_LAST_CHARS_AT_END
          cut_index = i - 1 # pne before i
          sub_string_incremented = @string[0..cut_index]
          original_string = @string
          @string     = sub_string_incremented
          @width      = width_of_string(@string) + @left_margin + @right_margin
          second_half_string  = original_string[(cut_index + 1)..(string_length - 1)]
          return second_half_string
        elsif width_of_string(sub_string_incremented) > (break_position + @char_half_width_cushion)
          cut_off_string = sub_string_incremented
          cut_index = i - 1 # use one before cut_off_string
          #handle line ending rule. chars that should not be at the end of line.
          if i <= 2 && cut_off_string[-2] =~ FORBIDDEN_LAST_CHARS
            # puts "FORBIDDEN_LAST_CHARS at cut_off_string[-2] move it to right"
            cut_index = i  # move one before FORBIDDEN_LAST_CHAR
          elsif i > 2 && cut_off_string[-2] =~ FORBIDDEN_LAST_CHARS
            # puts "FORBIDDEN_LAST_CHARS at cut_off_string[-2]"
            cut_index = i - 2 # move one before FORBIDDEN_LAST_CHAR
          end
          sub_string_incremented = @string[0..cut_index]
          original_string        = @string
          @string                = sub_string_incremented
          @width                 = width_of_string(@string) + @left_margin + @right_margin
          second_half_string     = original_string[(cut_index + 1)..(string_length - 1)]
          if second_half_string =~ FORBIDDEN_FIRST_CHARS_AT_FRONT
            # puts "FORBIDDEN_FIRST_CHARS at front of second string"
            #TODO
            # puts "original_string:#{original_string}"
            # puts "before cut_index:#{cut_index}"
            if cut_index >= 2
              cut_index -= 1
            elsif second_half_string.length >=2
              cut_index += 1
            end
            # puts "after cut_index:#{cut_index}"
            sub_string_incremented  = original_string[0..cut_index]
            @string                 = sub_string_incremented
            @width                  = width_of_string(@string) + @left_margin + @right_margin
            second_half_string      = original_string[(cut_index + 1)..(string_length - 1)]
            # puts "second_half_string:#{second_half_string}"
          elsif sub_string_incremented =~ FORBIDDEN_FIRST_CHARS_AT_END
            #TODO
            # puts "FORBIDDEN_FIRST_CHARS_AT_END of first string"
          end
          return second_half_string
        end
      end
      return false
    end

    # divide token at position
    def hyphenate_token(break_position, options={})
      if is_number_token?
          hyphenated_result = break_number_token_at(break_position)
      elsif is_english_token?
        hyphenated_result = break_english_token_at(break_position)
      else
        hyphenated_result = break_attstring_at(break_position, options={})
      end
      # break_attstring_at breaks original att_string into two
      # adjust first token width and result is second haldf att_string
      # or false is return if not abtle to brake the token
      if hyphenated_result == "front forbidden character"
        return "front forbidden character"
      elsif hyphenated_result.class == String
        @width = width_of_string(@string)
        # "‘회"  10.372000000000002
        second_half_width = width_of_string(hyphenated_result) + @left_margin + @right_margin
        second_half = RTextToken.new(string: hyphenated_result, style_object: @style_object, width: second_half_width, height: @height)
        return second_half
      else
        return false
      end
      false
    end

    def is_english_token?
      @string.each_char do |ch|
        if ch =~/[a-zA-Z]/
        else
          return false
        end
      end
      return true    
    end

    def break_english_token_at(break_position)
      require 'text/hyphen'
      hh = ::Text::Hyphen.new
      r = hh.visualize(@string)
      captures = r.split("-")
      return false if captures.length == 1
      return false if captures == []
      current_front_string = ""
      captures.each_with_index do |partial, i|
        temp_front_string = current_front_string + partial
        temp_string_width = width_of_string(temp_front_string)
        if temp_string_width <= break_position 
          current_front_string = temp_front_string
        else
          # current_front_string exceeded break_position
          if current_front_string == ""
            return false 
          else
            @string = current_front_string + "-"
            @width = width_of_string(current_front_string)
            second_string = captures[i..-1].join("")
            return second_string
          end
        end
      end
      false    
    end

    def is_number_token?
      @string=~(/^(\d+)/)
    end
    
    # this breaks at a number token at break_position
    # updates @string with front and return second_part of the broken token string
    def break_number_token_at(break_position)
      match = @string.match(/(\d+)(\D*)(\d*)(\D*)(\d*)(\D*)/)
      current_front_string = ""
      return false unless match
      match.captures.each_with_index do |partial, i|
        temp_front_string = current_front_string + partial
        temp_string_width = width_of_string(temp_front_string)
        if temp_string_width <= break_position 
          current_front_string = temp_front_string
        else
          # current_front_string exceeded break_position
          if current_front_string == ""
            return false 
          else
            @string = current_front_string
            @width = width_of_string(current_front_string)
            second_string = match.captures[i..-1].join("")
            return second_string
          end
        end
      end
      false
    end
  end
end
