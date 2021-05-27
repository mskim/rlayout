
module RLayout


  class RTextToken < Graphic
    attr_accessor :string, :token_type, :has_text, :char_half_width_cushion
    attr_reader :adjust_size, :style_name, :current_style, :char_width_array
    def initialize(options={})
      options[:fill_color] = options.fetch(:token_color, 'clear')
      super
      @has_text         = true
      @string           = options[:string] || options[:text_string]
      @token_type       = options[:token_type] if options[:token_type]
      @para_style       = options[:para_style]
      @style_name       = options[:style_name]
      @char_half_width_cushion = 0
      @char_half_width_cushion  = @para_style[:font_size]/2 if @para_style[:font_size]
      if options[:width]
        @width = options[:width]
      else
        @width    = width_of_string(@string)
      end
      if options[:text_line_spacing] && options[:text_line_spacing].class != String
        @height += options[:text_line_spacing]
      end
      self
    end

    def size
      [@width, @height]
    end

    # TODO keep char_width_array
    # if we have char_width_array, get the string width from this
    def width_of_string(string, options={})
      return 0 if string.nil?
      return 0 if string == ""
      if @char_width_array 
        @char_width_array[0..(string.length - 1)].sum
      elsif @style_name
        @current_style_service = RLayout::StyleService.shared_style_service
        @current_style ||= RLayout::StyleService.shared_style_service.current_style
        @style_hash ||= current_style[@style_name]
        @style_object, @font_wrapper = @current_style_service.style_object(@style_name) 
        glyphs     = @font_wrapper.decode_utf8(string)
        width      = glyphs.map{|g| @style_object.scaled_item_width(g)}.reduce(:+)
      else
        # If we dont have @style_name, use @para_style
        @current_style_service = RLayout::StyleService.shared_style_service
        @style_object, @font_wrapper = @current_style_service.style_object_from_para_style(@para_style) 
        glyphs     = @font_wrapper.decode_utf8(string)
        width      = glyphs.map{|g| @style_object.scaled_item_width(g)}.reduce(:+)
      end
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
        second_half = RTextToken.new(string: hyphenated_result, para_style: @para_style, width: second_half_width, height: @height)
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

    def draw_text
      style = @para_style
      style[:font_size] += @adjust_size if @adjust_size
      if RUBY_ENGINE == "rubymotion"
        atts = NSUtils.ns_atts_from_style(style)
        att_string     = NSAttributedString.alloc.initWithString(string, attributes: atts)
        # att_string.drawAtPoint(NSMakePoint(@left_margin,0))
        att_string.drawAtPoint(NSMakePoint(@left_margin,-3.0))
      else
        # draw_text(canvas) is called when RUBY_ENGINE == 'ruby'
      end
    end
  end

  class VTextToken < RTextToken

  end
end
