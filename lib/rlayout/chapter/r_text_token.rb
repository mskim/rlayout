module RLayout


  class RTextToken < Graphic
    attr_accessor :string, :token_type, :has_text, :para_style, :char_half_width_cushion
    attr_reader :adjust_size
    def initialize(options={})
      options[:fill_color] = options.fetch(:token_color, 'clear')
      super
      @has_text         = true
      @string           = options[:string]
      @para_style       = options[:para_style]
      # @para_style[:font_size] += options[:adjust_size] if options[:adjust_size]
      @char_half_width_cushion = 0
      @char_half_width_cushion  = @para_style[:font_size]/2 if @para_style[:font_size]
      @width            = width_of_string(@string)
      @height_of_token  = height_of_token
      if options[:text_line_spacing] && options[:text_line_spacing].class != String
        @height += options[:text_line_spacing]
      end
      self
    end

    def size
      [@width, @height]
    end

    def width_of_string(string)
      return 0 if string.nil?
      return 0 if string == ""
      if RUBY_ENGINE == "rubymotion"
        atts = NSUtils.ns_atts_from_style(@para_style)
        att_string     = NSAttributedString.alloc.initWithString(string, attributes: atts)
        return att_string.size.width
      end
      font_size = @para_style[:font_size] || 10
      font      = @para_style[:font] || 'shinmoon'
      size      = RFont.string_size(@string, font, font_size)
      size[0]
    end

    def height_of_token
      font_size = @para_style[:font_size] || 10
      # font      = @para_style[:font] || 'shinmoon'
      # size      = RFont.string_size(@string, font, font_size)
      # size[1]
      font_size*0.8
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


    # return false if break_position < MinimunLineRoom
    # split string into two and return splited_second_half_attsting
    def break_attstring_at(break_position)
      # give a char_half_c""
      return false if break_position < MinimunLineRoom
      string_length = @string.length
      (1..string_length).to_a.each do |i|
        front_range = [0,i]
        sub_string_incremented = @string[0..i]
        if i == (string_length - 1) && sub_string_incremented =~ FORBIDDEN_FIRST_CHARS_AT_END
          # puts "FORBIDDEN_FIRST_CHARS_AT_END"
          # we have front forbidden character . ? , !
          return "front forbidden character"
        elsif i == (string_length - 1) && sub_string_incremented =~ FORBIDDEN_LAST_CHARS_AT_END
          puts "forbidden last char at the end"
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
            puts "FORBIDDEN_LAST_CHARS at cut_off_string[-2] move it to right"
            cut_index = i  # move one before FORBIDDEN_LAST_CHAR
          elsif i > 2 && cut_off_string[-2] =~ FORBIDDEN_LAST_CHARS
            puts "FORBIDDEN_LAST_CHARS at cut_off_string[-2]"
            cut_index = i - 2 # move one before FORBIDDEN_LAST_CHAR
          end
          sub_string_incremented = @string[0..cut_index]
          original_string        = @string
          @string                = sub_string_incremented
          @width                 = width_of_string(@string) + @left_margin + @right_margin
          second_half_string     = original_string[(cut_index + 1)..(string_length - 1)]
          if second_half_string =~ FORBIDDEN_FIRST_CHARS_AT_FRONT
            puts "FORBIDDEN_FIRST_CHARS at front of second string"
            #TODO
            puts "original_string:#{original_string}"
            puts "before cut_index:#{cut_index}"
            if cut_index >= 2
              cut_index -= 1
            elsif second_half_string.length >=2
              cut_index += 1
            end
            puts "after cut_index:#{cut_index}"
            sub_string_incremented  = original_string[0..cut_index]
            @string                 = sub_string_incremented
            @width                  = width_of_string(@string) + @left_margin + @right_margin
            second_half_string      = original_string[(cut_index + 1)..(string_length - 1)]
            puts "second_half_string:#{second_half_string}"
          elsif sub_string_incremented =~ FORBIDDEN_FIRST_CHARS_AT_END
            #TODO
            puts "FORBIDDEN_FIRST_CHARS_AT_END of first string"

          end


          return second_half_string
        end
      end
      return false
    end

    # divide token at position
    def hyphenate_token(break_position)
      # break_attstring_at breaks original att_string into two
      # adjust first token width and result is second haldf att_string
      # or false is return if not abtle to brake the token
      hyphenated_result = break_attstring_at(break_position)
      if hyphenated_result == "front forbidden character"
        return "front forbidden character"
      elsif hyphenated_result.class == String
        @width = width_of_string(@string)
        second_half_width = width_of_string(hyphenated_result) + @left_margin + @right_margin
        second_half = RTextToken.new(string: hyphenated_result, para_style: @para_style, width: second_half_width, height: @height)
        return second_half
      else
        return false
      end
      false
    end

    def draw_text
      style = @para_style
      style[:font_size] += @adjust_size if @adjust_size
      # puts "@string:#{@string}"
      # puts "style[:font]:#{style[:font]}"
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
