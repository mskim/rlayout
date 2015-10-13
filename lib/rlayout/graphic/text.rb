module RLayout

  class Graphic
    attr_accessor :text_markup, :text_direction, :text_string, :text_color, :text_size, :text_line_spacing, :font
    attr_accessor :text_fit_type, :text_alignment, :text_tracking, :text_first_line_head_indent, :text_head_indent, :text_tail_indent, :text_paragraph_spacing_before, :text_paragraph_spacing
    attr_accessor :text_layout_manager

    def init_text(options)
      @text_fit_type = options.fetch(:text_fit_type,'keep_box_height')
      if options[:text_string] #|| options[:text_atts_array]
        @text_record  = TextStruct.new(options[:text_string], nil, nil)
        @text_record[:color] = options[:text_color] if options[:text_color]
        @text_record[:size] = options[:text_size] if options[:text_size]
        if RUBY_ENGINE == 'rubymotion'
          @text_layout_manager = TextLayoutManager.new(self, options)
        end
      elsif options[:text_record]
        @text_record  = options[:text_record]
        if RUBY_ENGINE == 'rubymotion'
          @text_layout_manager = TextLayoutManager.new(self, options)
        end
      end
    end

    def minimun_text_height
      if @text_layout_manager && @text_layout_manager.text_size
        @text_layout_manager.text_size
      else
        9
      end
    end
    
    # TODO
    def set_text(new_string)
      if @text_layout_manager.nil?
        @text_layout_manager = TextLayoutManager.new(self, :text_string=>new_string)
      else
        @text_layout_manager.att_string.set_string(new_string)
      end      
    end
    
    def text_string=(new_string)
      if @text_layout_manager.nil?
        @text_layout_manager = TextLayoutManager.new(self, :text_string=>new_string)
      # eles
      #   @text_layout_manager.att_string.set_string(new_string)
      end
      self
    end

  end

end
