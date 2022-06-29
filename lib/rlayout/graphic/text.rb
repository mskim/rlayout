# text('2021년 3월 19일 금요일 (3호)', x: 828.00, y: 107.25, fill_color:'clear', width: 200, font: 'KoPubBatangPM', font_size: 9.5, font_color: "CMYK=0,0,0,100", text_alignment: 'right')

module RLayout
  
  # single line uniform attributes text.
  class Text < Graphic
    attr_reader :text_string, :font_name, :font_size, :font_color, :tracking
    attr_reader :style_name, :string_width
    attr_accessor :text_alignment, :v_alignment, :text_fit_type

    def init_text(options={})
      # @stroke[:thickness] = 1
      # @stroke[:color] = 'black'
      # @fill[:color] = 'yellow'
      @text_string    = options[:text_string] ||  options[:string]
      @has_text       = true
      @text_fit_type  = options[:text_fit_type]   || 'normal' # fit_box_to_text
      @tracking       = options[:tracking]        || 0
      @scale          = options[:scale]           || 10
      @current_style_service = RLayout::StyleService.shared_style_service
      @style_name = options[:style_name]
      if @style_name
        unless @current_style_service.current_style[@style_name]
          @style_name = 'body'
        end
        @style_object = @current_style_service.style_object(@style_name, adjust_size: @adjust_size)
        para_hash = @current_style_service.current_style[@style_name]

      elsif options[:para_style]
        if @adjust_size
          @para_style[:font_size] += @adjust_size
        end
        @style_object = @current_style_service.style_object_from_para_style(options[:para_style])
      else
        @para_style             = {}
        @para_style[:font]      = options.fetch(:font, 'KoPubBatangPM')
        @para_style[:font_size] = options.fetch(:font_size, 16)
        if @adjust_size
          @para_style[:font_size] += @adjust_size
        end
        @style_object = @current_style_service.style_object_from_para_style(@para_style)
        @text_alignment = 'left'
      end
      @starting_x             = @left_margin + @left_inset
      @line_width             = @width - @starting_x - @right_margin - @right_inset
      @font_wrapper           = @style_object.font
      space_glyph             = @font_wrapper.decode_utf8(" ").first
      @space_width            = @style_object.scaled_item_width(space_glyph)
      @font_size = @style_object.font_size
      if @text_fit_type == 'fit_box_to_text'
        @height = @font_size*0.8
      end
      @line_height            = @style_object.font_size
      if options[:position] 
        @options = options[:position]
        set_position
      else
        @text_alignment = options[:text_alignment] || 'left'
        @v_alignment    = options[:v_alignment]     || 'center'
      end
      set_string_width
      if @text_fit_type == "fit_box_to_text"
        adjust_width_to_string_width
      end
      self
    end

    def set_string_width
      @font_wrapper =  @style_object.font
      @font_size = @style_object.font_size
      glyphs        = @font_wrapper.decode_utf8(@text_string)
      @string_width = glyphs.map{|g| @style_object.scaled_item_width(g)}.reduce(:+)
    end

    # TODO: it only applies to center alignment
    def adjust_width_to_string_width
      diff = @width - @string_width
      @width = @string_width.dup
      if @text_fit_type == 'fit_box_to_text'
        case @text_alignment
        when 'center'
          @x += diff/2
        when 'right'
          @x += diff
        end
      end
    end

    def draw_text(canvas)
      if @text_string.length > 0
        # canvas.fill_color(@fill_color)
        if canvas.font
          canvas_font_name = canvas.font.wrapped_font.font_name
          canvas_font_size  = canvas.font_size
          canvas_fill_color = canvas.fill_color
          # TODO fix this
          unless @style_name
            @style_name = 'body'
          end
          @style_object = @current_style_service.style_object(@style_name, adjust_size: @adjust_size)
          @font_wrapper           = @style_object.font
          @font_name              = @font_wrapper.wrapped_font.font_name
          @font_size              = @style_object.font_size
          space_glyph             = @font_wrapper.decode_utf8(" ").first

          if @font_name == canvas_font_name && @font_size == canvas_font_size            
          elsif @font_name != canvas_font_name
            canvas.font(@font_wrapper, size: @font_size)
          elsif @font_size != canvas_font_size
            canvas.font(canvas.font, size: @font_size)
          end
        else
          @style_object = @current_style_service.style_object('body')
          @font_wrapper           = @style_object.font
          @font_size              = @style_object.font_size
          canvas.font(@font_wrapper, size: @font_size)
        end
        f = flipped_origin
        @x_offset = f[0].dup
        @y_offset = f[1].dup
        # binding.pry if self.class == RLayout::LeaderCell
        case @text_alignment
        when 'left'
          @x_offset += @left_margin + @left_inset
        when 'center'
          # TODO: this is hack fix this
          if self.class == RLayout::LeaderCell
            @x_offset += (@width - @string_width)/2.0 - 50
          else
            @x_offset = (@width - @string_width)/2
          end
        when 'right'
          # TODO fix this 
          # why is @string_width different from initial set_string_width
          # may style_object is diffent?
          set_string_width
          @x_offset += @width - @string_width
          # @x_offset = @left_margin + @width - @string_width
        else
          @x_offset += @left_margin + @left_inset
        end

        # case @v_alignment
        # when 'top'
        # when 'center'
        #   @y_offset -= (@height - @font_size)/3
        # when 'bottom'
        #   @y_offset -= @height - @font_size
        # else
        # end
        # TODO do font_color
        if @font_color.class == String
          canvas.fill_color(RLayout::color_from_string(@font_color))
        end
        # canvas.text(@text_string, at: [@x_offset, @y_offset + @font_size/2])
        canvas.text(@text_string, at: [@x_offset, @y_offset])
      end
    end

    def set_position
      case @position
      when 1
        @text_alignment = 'left'
        @v_alignment    = 'top'
      when 2
        @text_alignment = 'center'
        @v_alignment    = 'top'      
      when 3
        @text_alignment = 'right'
        @v_alignment    = 'top'      
      when 4
        @text_alignment = 'left'
        @v_alignment    = 'center'   
      when 5
        @text_alignment = 'center'
        @v_alignment    = 'center'     
      when 6
        @text_alignment = 'right'
        @v_alignment    = 'center'           
      when 7
        @text_alignment = 'left'
        @v_alignment    = 'bottom'      
      when 8
        @text_alignment = 'center'
        @v_alignment    = 'bottom'   
      when 9
        @text_alignment = 'right'
        @v_alignment    = 'bottom'        
      end
    end

    def para_style
      h = {}
      h[:font]                = @font
      h[:font_size]           = @font_size
      h[:tracking]            = @tracking        if @tracking != 0
      h[:scale]               = @scale           if @scale != 100
      h
    end

  end

end