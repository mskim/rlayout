#


FIT_FONT_SIZE   = 0   # keep given font size
FIT_TO_BOX      = 1   # change font size to fit text into box
FIT_EACH_LINE   = 2   # adjust font size for each line to fit text into lines.
                      # So, fewer the text, larger the font size becomes in for each line
                      # And reduce the size of the lines propotionally to fit the entire lines in text box.
FIT_BOX_TO_TEXT = 3    

# anchor_type 
# 'left', 'center', 'right'
# v_anchor_type 
# 'top', 'center', bottom'
# 
           
module RLayout
  # uniform styled text
  # used for title, subject_head
  # It can squeeze text
  class Text < Container
    attr_accessor :tokens, :string, :para_style, :room, :height_in_lines
    attr_accessor :current_line, :current_line_y, :starting_x, :line_width, :space_width
    attr_accessor :single_line_title, :force_fit_title,  :text_fit_type
    attr_accessor :anchor_type, :v_anchor_type
    attr_accessor :from_right, :from_bottom, :line_after, :font, :font_size
    def initialize(options={})
      super
      @string                   = options.delete(:text_string)
      @font                     = options.fetch(:font, 'KoPubBatangPM')
      @font_size                = options.fetch(:font_size, 16)

      if options[:para_style]
        @para_style             = options[:para_style]
      elsif options[:style_name]
        @para_style           = RLayout::StyleService.shared_style_service.current_style[options[:style_name]]
        @para_style           = Hash[@para_style.map{ |k, v| [k.to_sym, v] }]
      else
        @para_style             = {}
        @para_style[:font]      = options[:font] || 'KoPubBatangPM'
        @para_style[:font_size] = options[:font_size] || 16
        @para_style[:text_color]= options[:text_color] if options[:text_color]
        @para_style[:tracking]  = options.fetch(:tracking, 0)
        @para_style[:scale]     = options.fetch(:scale, 100)
        @para_style[:alignment] =  'left'
      end
      @para_style[:alignment] = options[:text_alignment] if options[:text_alignment]
      @anchor_type            = options[:anchor_type]
      @v_anchor_type          = options[:v_anchor_type]
      @font_size              = @para_style[:font_size]
      @space_width            = @font_size/3
      @line_after             = options[:line_after]
      @line_space             = options[:line_apace] || @font_size/2
      @line_height            = @font_size + @line_space
      @text_fit_type          = options[:text_fit_type]
      @bottom_margin          = options.fetch(:from_bottom, 0)
      @body_line_height       = options.fetch(:body_line_height, 12)
      @space_before_in_lines  = 0
      @space_before_in_lines  = options[:space_before_in_lines] if options[:space_before_in_lines]
      @top_inset              = 0
      @top_inset              = @space_before_in_lines*@body_line_height
      @top_inset              += options[:top_inset] if options[:top_inset]
      @text_height_in_lines   = 0
      @text_height_in_lines   = options[:text_height_in_lines] if options[:text_height_in_lines]
      @space_after_in_lines   = 0
      @space_after_in_lines   = options[:space_after_in_lines] if options[:space_after_in_lines]
      @top_inset              += options[:top_inset] if options[:top_inset]
      @bottom_inset           = @space_after_in_lines*@body_line_height
      @height_in_lines        = @space_before_in_lines + @text_height_in_lines + @space_after_in_lines
      @height                 = @height_in_lines*@body_line_height 
      @tokens                 = []
      @room                   = @width
      @single_line_title      = options[:single_line_title]
      @current_line_y         = @top_inset + @space_before_in_lines*@body_line_height
      @starting_x             = @left_margin + @left_inset
      @line_width             = @width - @starting_x - @right_margin - @right_inset
      @current_line           = RLineFragment.new(parent:self, x: @starting_x, y:@current_line_y,  width:@line_width, height:@line_height, space_width: @space_width, para_style: @para_style, debug: true, top_margin: @top_margin)
      @current_line_y         += @current_line.height
      @height                 = @current_line_y
      create_tokens
      layout_tokens
      ajust_height_as_body_height_multiples
      if options[:from_right]
        puts "++++++++ from_right"
        @right_margin         = options[:from_right]
        @anchor_type          = 'right'
      end
      if options[:from_bottom]
        @bottom_margin         = options[:from_bottom]
        @anchor_type          = 'bottom'
      end
      adjust_box_width if @text_fit_type == 'fit_box_to_text'
      adjust_box_x if @parent && (@anchor_type == 'right' || @anchor_type == 'center')
      adjust_box_y if @parent && (@v_anchor_type == 'bottom' || @v_anchor_type == 'center')
      self
    end

    ## called when text_fit_type == 'fix_box_to_text' 
    def adjust_box_width
      return if @graphics.length == 0
      longest_line = @graphics.sort_by{|line| line.width}.last
      @width = longest_line.width_of_token_union
    end

    def adjust_box_x
      if @anchor_type == 'right'
        @x = @parent.width - @right_margin - @width        
      elsif @anchor_type == 'center'
        center = @parent.width/2.0
        @x = center - @width/2.0
      end
    end

    def adjust_box_y
      if @v_anchor_type == 'bottom'
        @y = @parent.height- @bottom_margin - @height
      elsif @v_anchor_type == 'center'
        center = @parent.height/2.0
        @y = center - @height/2.0
      end
    end

    def create_tokens
      return unless @string
      @tokens += @string.split(" ").collect do |token_string|
        options                 = {}
        options[:string]        = token_string
        options[:layout_expand] = nil
        options[:y]             = 0
        options[:para_style]    = @para_style
        options[:para_style][:fill_color]  = nil
        options[:height]        = @para_style[:font_size]
        RLayout::RTextToken.new(options)
      end

    end

    def add_new_line
      @current_line       = RLineFragment.new(parent:self, x: @starting_x, y:@current_line_y,  width:@line_width, height:@line_height, space_width: @space_width, para_style: @para_style, debug: true, top_margin: @top_margin)
      @current_line_y    += @current_line.height + @line_space
    end

    def line_height_sum
      @graphics.map{|line| line.height}.reduce(:+)
    end

    def ajust_height_as_body_height_multiples
      # We want to keeep it as multple of body_line_height
      if @graphics.length == 1
        # to avoid edge case overloap adding 2 pixels would do it
        @height = @height_in_lines*@body_line_height - 2 if @height_in_lines > 0
        return
      end
      natural_height          =  @top_inset + line_height_sum
      body_height_multiples   = natural_height/@body_line_height
      @height_in_lines        = body_height_multiples.to_i
      float_delta             = body_height_multiples - body_height_multiples.to_i
      if float_delta > 0.7
        @height_in_lines += (@space_after_in_lines + 1)
      else
        @height_in_lines += @space_after_in_lines
      end
      @height = @height_in_lines*@body_line_height - 1
      @height += @line_after*@body_line_height if @line_after
      @height -= 3
    end

    def layout_tokens
      token = tokens.shift
      while token
        result = @current_line.place_token(token, do_not_break: @single_line_title)
        # result = @current_line.place_token(token)
        # forcing not to break the token
        # result can be one of two
        # case 1. entire token placed succefully, returned result is true
        # case 2. entire token is rejected from the line
        if result.class == TrueClass
          # entire token placed succefully, returned result is true
          token = tokens.shift
        else  # case 2
          if @single_line_title
            # insert left over tokens to @current_line for fitting
            @current_line.graphics << token if result.class == FalseClass
            @current_line.graphics += @tokens
            @current_line.reduce_to_fit(force_fit: @force_fit_title)
            return
          else
            # if result.class == TextToken
            if result.class == RTextToken
              token = result
            end
            @current_line.align_tokens
            add_new_line
            @current_line.place_token(token)
            token = tokens.shift
          end
        end
      end
      @current_line.align_tokens
    end

    # place tokens in the line, given tokens array
    # return loft over tokens array if not all tokens are layed out
    # return false if no leftvver tokens
    #CharHalfWidthCushion = 5.0
    def place_token(token)
      if @room  >= token.width
        # place token in line.
        token.parent = self
        @graphics << token
        @room -= token.width
        @room -= @space_width
        return true
      else
        return false
      end
      return false
    end

    def mark_overflow
      # return unless @tokens.length > 0
      @current_line.mark_overflow
    end

    def graphics_width_sum
      @graphics.map{|t| t.width}.reduce(:+)
    end

    def space_width_sum
      (@graphics.length - 1)*@space_width
    end

    def to_pgscript
      if text_string && text_string.length > 0
        variables = "\"#{@string}\", font_size: #{@font_size}, x: #{@x}, y: #{@y}, width: #{@width}, height: #{@height}"
        # variables += ", #{@text_color}" unless @text_color == "CMYK=0,0,0,100"
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
    def relayout!
      @graphics.each do |line|
        line.width = @width
        line.align_tokens
      end
    end

  end

  # class Quote < Text
  #   def initialize(options={})
  #     options[:text_string] = "“ #{options[:text_string]} ”" if options[:text_string]
  #     options[:font_size]   = 24 unless options[:font_size]
  #     super
  #     self
  #   end
  # end

end
