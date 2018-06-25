module RLayout


  class RTextToken < Graphic
    attr_accessor :string, :token_type, :style_name, :has_text, :style, :char_half_width_cushion

    def initialize(options={})
      #code
      options[:fill_color] = options.fetch(:token_color, 'clear')
      super
      @has_text         = true
      @string           = options[:string]
      @style_name       = options[:style_name]
      @style_name       = 'body' unless @style_name
      @style            = RLayout::StyleService.shared_style_service
      @char_half_width_cushion = @style.space_width(@style_name)/2
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

    def space_width
      @style.space_width(@style_name)
    end

    def width_of_string(string)
      return 0 if string.nil?
      return 0 if string == ""
      @style.width_of_string(@style_name, string)
    end

    def height_of_token
      style = RLayout::StyleService.shared_style_service
      style.height_of_token(@style_name)
    end

    FORBIDDEN_FIRST_CHARS = /[\.|\,|!|\?|\)|}|\]|>|\u8217|\u8221]$/
    FORBIDDEN_LAST_CHARS  = /[\(|{|\[|<|\u8216|\u8220]/

    # return false if break_position < MinimunLineRoom
    # split string into two and return splited_second_half_attsting
    def break_attstring_at(break_position)
      # give a char_half_c""
      return false if break_position < MinimunLineRoom
      string_length = @string.length
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
        elsif width_of_string(sub_string_incremented) > (break_position + @char_half_width_cushion)
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
        @width = width_of_string(@string)
        second_half_width = width_of_string(hyphenated_result) + @left_margin + @right_margin
        second_half = RTextToken.new(string: hyphenated_result, style_name: @style_name, width: second_half_width, height: @height)
        return second_half
        # return TextToken.new(att_string: result, atts: @atts)
      else
        return false
      end
      false
    end

    def draw_text
      style = RLayout::StyleService.shared_style_service
      style = style.current_style[@style_name]
      style = Hash[style.map{ |k, v| [k.to_sym, v] }]
      if RUBY_ENGINE == "rubymotion"
        atts = NSUtils.ns_atts_from_style(style)
        att_string     = NSAttributedString.alloc.initWithString(string, attributes: atts)
        att_string.drawAtPoint(NSMakePoint(@left_margin,0))
      else
        #TODO
      #code
      end
    end



  end

end
