module RLayout

  class Graphic

    def init_text(options)
      @text_fit_type = options.fetch(:text_fit_type,1)
      if options[:text_string] || options[:text_atts_array]
        @text_layout_manager = TextLayoutManager.new(self, options)
      end
    end

    def minimun_text_height
      if @text_layout_manager && @text_layout_manager.text_size
        @text_layout_manager.text_size
      else
        9
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

    def text_to_hash
      unless @text_layout_manager.nil?
        @text_layout_manager.to_hash if @text_layout_manager
      else
        Hash.new
      end

    end

  end

end
