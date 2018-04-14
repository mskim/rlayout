# when options[:text_string] is passed, it creates TextLayoutManager
# when options[:string] is passed, it by skipping TextLayoutManager creation
# So, to call text that implements our own. pass string, not text_string

module RLayout


  # Text Using NSText System
  class NSText < Graphic
    def initialize(options={})
      super
      @transform = options[:transform]
      init_ns_text(options)
      self
    end

    def set_attributed_string(new_att_string)
      return unless @text_layout_manager
      @text_layout_manager.setAttributedString(new_att_string)
    end

    def set_text_string(text_string)
      if RUBY_ENGINE == "rubymotion"
        return unless @text_layout_manager
        @text_layout_manager.set_text_string(text_string)
      else
        @text_record.string = text_string
      end
    end

    def set_text(text_string)
      if RUBY_ENGINE == "rubymotion"
        return unless @text_layout_manager
        @text_layout_manager.set_text_string(text_string)
      else
        @text_record.string = text_string
      end
    end

    def text_string
      if @text_layout_manager
        @text_layout_manager.att_string.string
      elsif @text_record
        @text_record.string
      end
    end

    def font_size
      unless @text_layout_manager
        return 16.0
      else
        @text_layout_manager.font_size
      end
    end

    def setAttributes(atts, range)
      return unless @text_layout_manager
      @text_layout_manager.att_string.setAttributes(atts, range: range)
    end

    def to_pgscript
      if text_string && text_string.length > 0
        variables = "\"#{text_string}\", font_size: #{font_size}, x: #{@x}, y: #{@y}, width: #{@width}, height: #{@height}"
        #TODO
        # variables += ", #{@text_color}" unless @text_color == "black"
        variables += ", tag: \"#{@tag}\"" if @tag
        "   text(#{variables})\n"
      else
        " "
      end
    end

    def self.sample(options={})
      if options[:number] > 0
        Text.new(text_string: "This is a sample text string"*options[:number])
      else
        Text.new(text_string: "This is a sample text string")
      end
    end
  end

  class Graphic
    attr_accessor :text_markup, :text_direction, :text_string, :text_color, :font_size, :text_line_spacing, :font, :text_style
    attr_accessor :text_fit_type, :text_alignment, :tracking, :text_first_line_head_indent, :text_head_indent, :text_tail_indent, :text_paragraph_spacing_before, :text_paragraph_spacing
    attr_accessor :text_layout_manager, :has_text, :body_line_height, :space_before_in_lines, :text_height_in_lines,  :space_after_in_lines

    def init_ns_text(options)
      @has_text               = options[:string] ? true : false
      @body_line_height       = options.fetch(:body_line_height, 12)
      @space_before_in_lines  = 0
      @space_before_in_lines  = options[:space_before_in_lines] if options[:space_before_in_lines]
      @top_inset              = @space_before_in_lines*@body_line_height
      @top_inset              += options[:top_inset] if options[:top_inset]
      @text_height_in_lines   = 0
      @text_height_in_lines   = options[:text_height_in_lines] if options[:text_height_in_lines]
      @space_after_in_lines   = 0
      @space_after_in_lines   = options[:space_after_in_lines] if options[:space_after_in_lines]
      @tracking               = options.fetch(:tracking, 0)
      @bottom_inset           = @space_after_in_lines*@body_line_height
      if options[:layout_length_in_lines]
        @layout_length = height_in_lines
      end

      if options[:text_string] || options[:text_string_array] || options[:ns_attributed_string]
        @text_fit_type = options.fetch(:text_fit_type, 'keep_box_height')
        #TODO merge string if options[:text_string_array]
        if options[:text_string_array]
          joined_string   = options[:text_string_array].join(" ")
          @text_record    = TextStruct.new(joined_string, nil, nil)
        else
          @text_record    = TextStruct.new(options[:text_string], nil, nil)
        end
        @text_record[:color] = options[:text_color] if options[:text_color]
        @text_record[:size]  = options[:font_size] if options[:font_size]
        if RUBY_ENGINE == 'rubymotion'
          @text_layout_manager = TextLayoutManager.new(self, options)
        end
      elsif options[:text_record]
        @text_record  = options[:text_record]
        if RUBY_ENGINE == 'rubymotion'
          @text_layout_manager = TextLayoutManager.new(self, options)
        end
      elsif options[:ns_attributed_string]
        if RUBY_ENGINE == 'rubymotion'
          @text_layout_manager = TextLayoutManager.new(self, options)
        end
      end
    end

    def height_in_lines
      @space_before_in_lines  + @text_height_in_lines + @space_after_in_lines
    end

    # this is called after subtitle in body is layed out
    # we want have space between the subtitle and body, around 2 lines
    def adjust_box_height_with_changed_text_height
      #code
    end
    # this is called after top_story title is created and
    # before calling  subtitle in heading to balance the height of top_title and top_subtitle
    def adjust_height_as_height_in_lines
      @height = height_in_lines*@body_line_height
    end

    def space_before
      if @space_before_in_lines && @space_before_in_lines != 0
        return @space_before_in_lines*@body_line_height
      end
      0
    end

    def minimun_text_height
      if @text_layout_manager && @text_layout_manager.font_size
        @text_layout_manager.font_size
      else
        9
      end
    end

    def set_text(new_string)
      if @text_layout_manager.nil?
        @text_layout_manager = TextLayoutManager.new(:parent=>self, :text_string=>new_string)
      else
        @text_layout_manager.att_string.set_string(new_string)
      end
    end

    def text_string=(new_string)
      if @text_layout_manager.nil?
        @text_layout_manager = TextLayoutManager.new(:parent=>self, :text_string=>new_string)
      # eles
      #   @text_layout_manager.att_string.set_string(new_string)
      end
      self
    end
  end
end
