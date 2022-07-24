
module RLayout


  class	RLineFragment < Container

    def has_hyphenated_token_with_char(char_count)
      last_token = @graphics.last
      if last_token && last_token.hyphenated && last_token.string.length == char_count
        return true
      end
      false
    end
    
    def take_token_from_prev_line(prev_line)
      return false if line_space_width < 20 # font_size * 2
      prev_line_last_token = prev_line.graphics.pop
      first_token = @graphics.first
      if prev_line_last_token
        if prev_line_last_token.hyphenated 
          first_token.prepend_token(prev_line_last_token)
        end
        relayout_line{options={}}
      end
    end

    def move_hyphenated_token_to_next_line(min_hyphen_char, next_line)
      last_token = @graphics.last
      if last_token && last_token.hyphenated && last_token.string.length < min_hyphen_char
        hyphenated_token = @graphics.pop 
        next_line.prepend_token(hyphenated_token)
      end
    end

    def prepend_hyphenated_token(hyphenated_token)
      first_token = @graphics.first
      first_token.prepend_token(hyphenated_token)
    end

    # def total_content_width
    #   token_width_sum +  total_space_width
    # end
    def relayout_line_to_fit(target_extra_space)
      # TODO
      @line_type = 'middle_line'
      align_tokens      
    end

  end


end