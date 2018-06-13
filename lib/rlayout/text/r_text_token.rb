module RLayout


  class RTextToken < Graphic
    attr_accessor :string, :style_name

    def initialize(options={})
      #code
      super
      @string       = options[:string]
      @style_name   = options[:style_name]
      @width        = width_of_string(@string)
      self
    end

    def size
      [@width, @height]
    end

    def width_of_string(string)
      style = RLayout::StyleService.shared_style_service
      style.width_of_string(@style_name, string)
    end

    FORBIDDEN_FIRST_CHARS = /[\.|\,|!|\?|\)|}|\]|>|\u8217|\u8221]$/
    FORBIDDEN_LAST_CHARS  = /[\(|{|\[|<|\u8216|\u8220]/

    # return false if break_position < MinimunLineRoom
    # split string into two and return splited_second_half_attsting
    def break_attstring_at(break_position)
      # give a char_half_c""
      return false if break_position < MinimunLineRoom
      string_length = @string.length
      #TODO use ruby only not NS
      # puts "@att_string.string:#{@att_string.string}"
      (1..string_length).to_a.each do |i|
        front_range = [0,i]
        sub_string_incremented = @string[0..i]
        if i == string_length && sub_string_incremented =~ FORBIDDEN_FIRST_CHARS
          # we have front forbidden character . ? , !
          return "front forbidden character"
        elsif i == string_length && sub_string_incremented =~ FORBIDDEN_LAST_CHARS
          cut_index = i - 1 # pne before i
          sub_string_incremented = @string[0..cut_index]
          original_string = @string
          @string     = sub_string_incremented
          @width      = width_of_string(@string) + @left_margin + @right_margin
          new_string  = original_string[cut_index..(string_length - cut_index)]
          return new_string
        elsif width_of_string(sub_string_incremented) > (break_position + CharHalfWidthCushion)
          cut_index = i - 1 # pne before i
          #handle line ending rule. chars that should not be at the end of line.
          front_string = sub_string_incremented
          if i > 2 && front_string[-2] =~ FORBIDDEN_LAST_CHARS
            # puts "we have on end-line char case at -2 position"
            cut_index = i - 2 # pne before i
          end
          sub_string_incremented = @string[0..cut_index]
          original_string = @string
          @string         = sub_string_incremented
          @width          = width_of_string(@string) + @left_margin + @right_margin
          new_string      = original_string[(cut_index + 1)..(string_length - cut_index + 1)]
          return new_string
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
        second_half = self.dup
        second_half.string = hyphenated_result
        second_half.width = width_of_string(hyphenated_result) + @left_margin + @right_margin
        return second_half
        # return TextToken.new(att_string: result, atts: @atts)
      else
        return false
      end
      false
    end



  end

end
