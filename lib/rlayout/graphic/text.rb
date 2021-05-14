# text('2021년 3월 19일 금요일 (3호)', x: 828.00, y: 107.25, fill_color:'clear', width: 200, font: 'KoPubDotumPL', font_size: 9.5, font_color: "CMYK=0,0,0,100", text_alignment: 'right')

module RLayout
  class Text < Graphic
    attr_reader :text_string, :font, :font_size, :font_color, :tracking
    attr_reader :text_style, :string_width
    attr_accessor :text_alignment, :v_alignment, :text_fit_type

    def init_text(options={})
      # @stroke[:thickness] = 1
      # @stroke[:color] = 'black'
      # @fill[:color] = 'yellow'
      @has_text       = true
      @text_fit_type  = options[:text_fit_type]   || 'normal' # fit_box_to_text
      @tracking       = options[:tracking]        || 0
      @scale          = options[:scale]           || 100
      @font           = options[:font]            || 'KoPubDotumPL'
      @font_color     = options[:font_color]      || 'black'
      @fill_color     = options[:fill_color]      || 'clear'
      @font_size      = options[:font_size]       || 16
      @text_string    = options[:text_string]     || options[:string]
      @text_style     = options[:style]           || 'normal'
      if options[:position] 
        @options = options[:position]
        set_position
      else
        @text_alignment = options[:text_alignment] || options[:alignment] || 'left'
        @v_alignment    = options[:v_alignment]     || 'top'
      end
      set_string_width
      if @text_fit_type == "fit_box_to_text"
        adjust_width_to_string_width
      end
      self
    end

    def set_string_width
      @current_style_service = RLayout::StyleService.shared_style_service
      @style_object, @font_wrapper = @current_style_service.style_object_from_para_style(para_style) 
      glyphs        = @font_wrapper.decode_utf8(@text_string)
      @string_width = glyphs.map{|g| @style_object.scaled_item_width(g)}.reduce(:+)
    end

    # TODO: it only applies to center alignment
    def adjust_width_to_string_width
      diff = @width - @string_width
      @width = @string_width
      if @text_fit_type == 'fit_box_to_text'
        case @text_alignment
        when 'center'
          @x += diff/2
        when 'right'
          # @x += diff
        end
      end
    end

    def draw_text(canvas)
      if @text_string.length > 0
        # canvas.fill_color(@fill_color)
        if canvas.font
          canvase_font_name = canvas.font.wrapped_font.font_name
          canvas_font_size  = canvas.font_size
          canvas_fill_color = canvas.fill_color
          if @font == canvase_font_name && @font_size == canvas_font_size
          elsif @font != canvase_font_name
            font_foleder  = "/Users/Shared/SoftwareLab/font_width"
            font_file     = font_foleder + "/#{@font}.ttf"
            doc           = canvas.context.document
            font_wapper   = doc.fonts.add(font_file)
            canvas.font(font_wapper, size: @font_size)
          elsif @font_size != canvas_font_size
            canvas.font(canvas.font, size: @font_size)
          else
            font_foleder  = "/Users/Shared/SoftwareLab/font_width"
            font_file     = font_foleder + "/#{@font}.ttf"
            doc           = canvas.context.document
            font_wapper   = doc.fonts.add(font_file)
            canvas.font(font_wapper, size: @font_size)
          end
        else
          font_foleder  = "/Users/Shared/SoftwareLab/font_width"
          font_file     = font_foleder + "/Shinmoon.ttf"
          font_file     = font_foleder + "/#{@font}.ttf" if @font
          doc           = canvas.context.document
          font_wapper   = doc.fonts.add(font_file)
          canvas.font(font_wapper, size: @font_size)
        end

        f = flipped_origin
        @x_offset = f[0].dup
        @y_offset = f[1].dup
        case @text_alignment
        when 'left'
          @x_offset += @left_margin + @left_inset
        when 'center'
          @x_offset += (@width - @string_width)/2
        when 'right'
          @x_offset += @width - @string_width
        else
          @x_offset += @left_margin + @left_inset
        end

        case @v_alignment
        when 'top'
        when 'center'
          @y_offset -= (@height - @font_size)/2
        when 'bottom'
          @y_offset -= @height - @font_size
        else
        end
        canvas.text(@text_string, at: [@x_offset, @y_offset - @font_size])
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