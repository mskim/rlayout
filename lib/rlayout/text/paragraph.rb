
# For text handling, Text and Paragraph are used
# Text Object is used for simple text, usually for single page document or Ads.
# Text uses NSTextSystem,
# Text is also used in Heading, HeadingContainer, where several short texts are used.
# Paragraph Object is used in middle to long document.
# Paragraph uses our own text system.

# How Paragraoh is layed out?
# 1. Tokens are created with given para_style.
# 2. Paragraphs can be layed out the initail time if we know the width of the column to be,
#    but most of the we do not know where the paragraph will be layed out. So, layout_lines(width)
#    is called at the time of layout.
# 3. We can encounter simple column or complex column
#    complex column are those who have overlapping floats of various shapes.
#    so the text lines could be shorter than the ones in simple column.
# 3. We can also encounter tokens that are not uniform in heights, math tokens for example


# LineFragments
# LineFragments are made up of TextTokens, ImageToken, MathToken etc....
# When paragraph is created, TextTokenAtts is created for default att value for all TextTokena and they are all created using it as default.
# Whenever there is differnce TextTokenAtts in the paragraph, new TextTokenAtts is created and different TextToken ponts to that one.

# Emphasis Handling
# inline emphasis are handled using double curl {{content}}, or single curl {content}
# We want the emphasis mark to be simple as possible for writers. This is work in process, it might change as we go!!!!
# So, we limit the emphasis markup to those two only, and how it is implement is left to designer, not to the writer. It means designer need to provide custom style at the run time for effected para styles.
# There are two types of emphasis,  "text effect" and "special layout".
# For text effect, such as italic, bold, boxed, underline, hidden_text, emphasis we can modify the @token_style to get the effect. So designer need to provide paragraph_styles paragraph style as hash.
# For special layout tokens, such as ruby, reverse ruby,  we have to do some layout modification. In this case, desinger needs to proved the function name of the emphasis, such as ruby, reverse_ruby, icon: name . in custom paragraph style. as para_style[:double_emphasis]  = "reverse_ruby"

#
# {{base text}{top text}}
# {{base text}{top text}}
#
DefRegex = /(def_.*?\(.*?\))/

INLINE_SINGLE_CURL = /(\{.*?\})/
INLINE_DOUBLE_CURL = /(\{\{.*?\}\})/m
RUBY_ARGUMENT_DIVIDER   = /\}(\s)*?\{/

# String#split
# if we use String#split with match, we get the match as an Array eleemnt. I find it very useful.
# I am using it to parse the inline style empasis and inline special empasis.

# {{ruby sting, uppper}}

# I am still toying with differnce syntexes to make it easy to work
# candidate 1
#   def_box('boxed_text')
#   def_ruby('base_text', 'top_text')
#   def_undertag('base_text', 'under_text')

# candidate 2
#   {style empases}
#   {{boxed_text}}
#   {{base_text}{top_text}}
#   for each document meaning of {{}} and {} are specified by designer
#   to make writers not to be concered with design aspect
#   writers should not be memprizing many many markups, just two or three.

module RLayout

  #TODO
  # tab stop
  # implementing paragraph with tab
  # if para_string.include?("\t")
  # tab_group = para_string.split("\t")
  # tokens = []
  # tab_group.each do |sub_string|
  #    tokens << create_tokens(sub_string)
  #    tokens << TabToken.new
  # end
  # tokens.pop #pop the last TabToken

  # tab Token

  # we use three different string types in opions
  # text_string for NSText
  # string          Token
  # para_string     For Paragraph, para_string is passed to Tokens as string
  # so the text drawing take place only when option is text_string and string

  # list_styles option items are used in list type paragraphs, such as
  # OrderedList, UnordersList, OrderedSection, UpperAlpaList
  # they all have prefix of ":list_*" ,
  # it is filtered using "filter_list_options(options)" and saved in @list_style
  # @list_style is passed into Tokens as Graphic options.

  # I will be using this "prefix filtering" convension through out rlayout.
  # text_color => color of Text
  # fill_color => color of Fill
  # line_color => color of Line
  # list_fill_color => fill_color of NumberToken
  # list_line_color => line_color of NumberToken

  class Paragraph < Container
    attr_reader :markup
    attr_accessor :tokens, :token_heights_are_eqaul
    attr_accessor :para_string, :para_style, :list_style
    attr_accessor :text_column, :grid_height
    attr_accessor :overflow, :underflow, :linked, :line_y_offset, :body_line_height
    attr_accessor :linked
    def initialize(options={})
      super
      #simple, drop_cap, drop_cap_image, math, with_image, with_math
      @markup         = options.fetch(:markup, 'p')
      @para_string    = options.fetch(:para_string, "")
      make_para_style
      # super doen't set @para_style values
      @fill.color     = @para_style[:fill_color]
      @space_width    = @para_style[:space_width]
      @grid_height    = options.fetch(:grid_height, 2)
      @linked         = options.fetch(:linked, false)
      if options[:tokens]
        # this is when Paragraph has been splited into two
        # left over tokens are passed in options[:tokens]
        # so, no need to re-create tokens.
        @tokens         = options[:tokens]
        @token_strings  = @tokens.map { |t| t.string}
        @para_string    = @token_strings.join(" ")
        # @tokens.each do |t|
        #   puts t.string
        #   puts t.width
        #   puts t.height
        # end
      else
        @tokens       = []
        create_tokens
      end
      # layout_lines is called when Paragraph is actually placed in the column
      # do not call layout_lines at initialization stage, unless requested.
      if options[:layout_lines]
        @body_line_height = 30
        layout_lines(self)
      end
      self
    end

    def box(text, options={})
      para_style = @para_style.dup
      # para_style[:text_string] = text
      para_style[:string] = text
      para_style[:stroke_width] = 0.5
      @tokens << TextToken.new(para_style)
    end

    def round(text, options={})
      para_style = @para_style.dup
      para_style[:string] = text
      para_style[:stroke_width] = 0.5
      para_style[:shape]        = "round"
      @tokens << TextToken.new(para_style)
    end

    def create_tokens_with_double_curl(para_string)
      split_array = para_string.split(INLINE_DOUBLE_CURL)
      # splited array contains double curl content
      split_array.each do |line|
        if line =~INLINE_DOUBLE_CURL
          line.sub!("{{", "").sub!("}}", "")
          if line=~RUBY_ARGUMENT_DIVIDER
            # when no custm style is defined, just use normal style
            # when no custm style is defined, just use normal style
            # @para_style[:string] = line.sub("{{", "").sub("}}", "")
            # create_special_token(@para_style[:double_emphasis], line)
            create_special_token('reverse_ruby', line)
          elsif line=~/^@/
            line.sub!(/^@/, "")
            create_special_token('image', line)
          elsif @para_style[:double_emphasis].is_a?(Hash)
            emp = @para_style[:double_emphasis]
            emphasized_style = @para_style.dup.merge emp
            emphasized_style.delete(:double_emphasis)
            emphasized_style[:string]        = line
            emphasized_style.delete(:parent) if emphasized_style[:parent]
            emphasized_style[:left_margin]   = 3 # box left side margin
            emphasized_style[:right_margin]  = 3 # box right side margin
            @tokens << RLayout::TextToken.new(emphasized_style)
          else
            @para_style[:string] = line
            @para_style.delete(:parent) if emphasized_style[:parent]
            @tokens << RLayout::TextToken.new(@para_style)
          end
          # elsif @para_style[:double_emphasis].is_a?(String)
            # create_special_token(@para_style[:double_emphasis], line)
        elsif  line =~INLINE_SINGLE_CURL
          # some of the split line contains single curl
          create_tokens_with_single_curl(line)
        else
          # line text with just noral text tokens
          create_text_tokens(line)
        end
      end
    end

    def create_tokens_with_single_curl(para_string)
      para_string.chomp!
      para_string.sub!(/^\s*/, "")
      split_array = para_string.split(INLINE_SINGLE_CURL)
      split_array.each do |line|
        if line =~INLINE_SINGLE_CURL
          line.sub!("{", "").sub!("}", "")
          if @para_style[:single_emphasis].is_a?(Hash)
            # single emphasis style is specified
            emp = @para_style[:single_emphasis]
            emphasized_style = @para_style.dup.merge emp
            emphasized_style[:string] = line
            emphasized_style.delete(:single_emphasis)
            @tokens << RLayout::TextToken.new(emphasized_style)
          else
            # when no style is defined, just use normal style
            @para_style[:string] = line
            @tokens << RLayout::TextToken.new(@para_style)
          end
        else
          # line text with just noral text tokens
          if line.empty? || line == " " or line == "\n"
            # puts "line is emptuy"
          else
            create_text_tokens(line)
          end
        end
      end
    end

    def create_special_token(token_type, line_text)
      case token_type
      when "ruby"
        arg = line_text.split(RUBY_ARGUMENT_DIVIDER)
        options = {}
        options[:base]  = arg[1]
        options[:top]   = arg[2]
        options[:para_style] = @para_style
        @tokens << RLayout::RubyToken.new(options)
      when "reverse_ruby"
        arg = line_text.split(RUBY_ARGUMENT_DIVIDER)
        options = {}
        options[:base]  = arg[0]
        options[:bottom]= arg[1]
        options[:para_style] = @para_style
        @tokens << RLayout::ReverseRubyToken.new(options)
      when "image"
        options = {}
        options[:image_name]  = line_text
        @tokens << RLayout::ImageToken.new(options)
      else
        #TODO supply more special tokens
        options = {}
        options[:string]  = arg[9]
        @tokens << RLayout::TextToken.new(options)
      end
    end

    def create_text_tokens(para_string)
      # parse for tab first
      @tokens += para_string.split(" ").collect do |token_string|
        @para_style[:string] = token_string
        @para_style.delete(:parent) if @para_style[:parent]
        RLayout::TextToken.new(@para_style)
      end
    end

    # before we create any text_tokens,
    # check if we have any special token mark {{something}} or {something}
    # first check for double curl, single curl
    # if double curl is found, split para string with double curl fist
    # and do it recursively with split strings
    # and call create_text_tokens for regular string segmnet
    def create_tokens
      @atts = {}
      if RUBY_ENGINE == 'rubymotion'
        @atts[NSFontAttributeName]  = NSFont.fontWithName(@para_style[:font], size: @para_style[:text_size])
        if @para_style[:text_color]
          text_color    = RLayout::convert_to_nscolor(@para_style[:text_color]) unless (@para_style[:text_color]) == NSColor
          @atts[NSForegroundColorAttributeName] = text_color
        end
        atts[NSKernAttributeName]             = text_tracking if text_tracking
        @para_style[:space_width]  = NSAttributedString.alloc.initWithString(" ", attributes: @atts).size.width
        @para_style[:atts] = @atts
      end

      # do we have any doulbe curl?
      if @para_string =~INLINE_DOUBLE_CURL
        create_tokens_with_double_curl(@para_string)
      # no doulbe curl, do we have any single curl?
      elsif @para_string =~INLINE_SINGLE_CURL
        create_tokens_with_single_curl(@para_string)
      # no curls found, so create_text_tokens
      else
        create_text_tokens(@para_string)
      end
      token_heights_are_eqaul = true
      return unless  @tokens.length > 0
      tallest_token_height = @tokens.first.height
      @tokens.each do |token|
        if token.height > tallest_token_height
          token_heights_are_eqaul = false
          return
        end
      end
    end

    def line_count
      @graphics.length
    end

    # algorithm for laying out paragraph in simple and complex container
    # loop until we run out of tokens
	  # 1. start with line rect with width of column and height of para_style
	  # 2. keep filling up the line_tokens until the width total exceed the width of column
    #    for complex column
    #    call "text_column.sugest_me_a_rect_at" to get line rect at the current grid_rects
    #    if lien rect is [0,0,0,0] we have no room at that grid_rect area of column
    #    elsif we get the rect, fill in the tokens in that rect.
    #
	  # 3. Each time with new token, check the height change, tallest_token and adjust line height.
    # 4. Once we run out of the line space,
	  # 5. create LineFragment with width and height
	  # 6. clear the line_tokens buffer and set new positions
	  # all tokens are layed out even fo underflow, or overflow.
	  # underflow is when there is no room even for a single line.
	  # overflow is when there is not enough room to fit all the lines.

    def layout_lines(text_column)
      @text_column      = text_column
      @overflow         = false
      @underflow        = false
      @column_width     = @text_column.width
      @width            = @column_width
      @first_line_width = @column_width
      @text_line_width  = @column_width
      if @para_style[:h_alignment] == "left" || @para_style[:h_alignment] == "justified"
        @first_line_width = @column_width - @para_style[:first_line_indent] - @para_style[:tail_indent]
        @text_line_width  = @column_width - @para_style[:head_indent] - @para_style[:tail_indent]

      else
        @first_line_width = @column_width - @para_style[:head_indent] - @para_style[:tail_indent]
        @text_line_width  = @column_width - @para_style[:head_indent] - @para_style[:tail_indent]
      end
      @body_line_height = @text_column.body_line_height
      @line_y_offset    = 0
      if @para_style[:space_before]
        @line_y_offset  = @para_style[:space_before]
      end
      @total_token_width= 0
      @line_tokens      = []
      @line_index       = 0
      @line_x           = 0
      @line_width       = @first_line_width
      if @tokens.length > 0
        token = @tokens.first
        @tallest_token_height = token.height
      end
      while @tokens.length > 0
        token = @tokens.first
        if @line_index == 0 && !@linked
          @line_x     = @para_style[:first_line_indent]
          @line_width = @first_line_width
        else
          @line_x     = @para_style[:head_indent]
          @line_width = @text_line_width
        end
        # make @line_rectangle for LineFragment
        if text_column.is_simple_column? || text_column.is_rest_of_area_simple?
          # simple column
          @line_rectangle = [@line_x, @line_y_offset, @line_width, @tallest_token_height]
          if @line_y_offset + @line_rectangle[3] > @text_column.room
            if @graphics.length <= 1
              @underflow  = true
              if @graphics.length == 1
                line = @graphics.first
                commited_tokens = line.graphics.dup
                @tokens.unshift(commited_tokens).flatten!
                @graphics = [] #clear LineFragment created for this column
              else
                @tokens.unshift(@line_tokens).flatten!
              end
            else
              @overflow   = true
            end
            # @height     = @line_y_offset
            @height     = @line_y_offset + @line_rectangle[3]
            return
          end
        else
          # complex column
          @line_rectangle = @text_column.sugest_me_a_rect_at(@line_y_offset, @tallest_token_height)
          if @line_y_offset + @line_rectangle[3] > @text_column.room
            if @graphics.length <= 1
              @underflow  = true
            else
              @overflow = true
            end
            puts "text_column.column_index:#{text_column.column_index}"
            puts "reached bottom of column"
            return
          elsif @line_rectangle[2] == 0
            # move move_current_position_by token_heigh
            @text_column.move_current_position_by(@tallest_token_height)
            @line_y_offset += @tallest_token_height
            next
          else
            if @line_rectangle[0] > @para_style[:head_indent]
              #TODO tail_indent
              @line_x     = @line_rectangle[0]
            else
              # @para_style[:head_indent] is right of line origin
              # use head_indent, adjust width as @line_rectangle[2] - (@para_style[:head_indent] - @line_rectangle[0])
              @line_x     = @para_style[:head_indent]
              @line_width = @line_rectangle[2] - (@para_style[:head_indent] - @line_rectangle[0])
            end
          end
        end
        # check for space for more tokens
        if  (@total_token_width + @para_style[:space_width] + token.width) < @line_width
          @total_token_width += (@para_style[:space_width] + token.width)
          @line_tokens << @tokens.shift
        else
          options = {parent:self, para_style: @para_style, tokens: @line_tokens, x: @line_x, y: @line_y_offset , width: @line_width, height: @line_rectangle[3], space_width: @para_style[:space_width]}
          line = LineFragment.new(options)
          @line_y_offset += line.height
          @line_tokens = []
          @total_token_width = 0
          @line_index += 1
          @height = @line_y_offset
        end
      end

      # make LineFragment for last line
      if @line_tokens.length > 0
        options = {parent:self, para_style: @para_style, tokens: @line_tokens, x: @line_x, y: @line_y_offset , width: @line_width, height: @line_rectangle[3], space_width: @para_style[:space_width]}
        line    = LineFragment.new(options)
        @line_y_offset += line.height
        @height = @line_y_offset
      end
      if @para_style[:space_after]
        @height = @line_y_offset + @para_style[:space_after]
      end

    end

	  # this is called when paragraph is splitted or moved to next column and have to be
	  # relayed out at the carried over column
	  # lines are already created, it might have to be layed out for complex column
	  # or different column width,
    # def re_layout_lines(text_column)
    #   @overflow         = false
    #       @underflow        = false
    #   @height           = @graphics.map{|line| line.height}.inject(:+)
    # end

    def is_breakable?
      return true  if @graphics.length > 2
      false
    end

    def to_hash
      h = {}
      h[:width]           = @width
      h[:markup]          = @markup
      h[:para_style]      = @para_style
      h[:linked]          = true
      h
    end

    # split current paragraph into two at overflowing line
    # return newly created second half Paragraph
    # steps
    # 1. create second_half paragraph with options saved from to_hash
    # 1. move left over tokens to second_half_options[:tokens]
    # 1. clear tokens from first_half
    def split_overflowing_lines
      second_half_options           = to_hash
      second_half_options[:tokens]  = @tokens.dup
      @tokens                       = []
      second_half                   = Paragraph.new(second_half_options)
      second_half.linked            = true
      second_half
    end

    # overflow is when we have breakable paragraph
    # and partial lines are layout at current column.
	  def overflow?
	    @overflow == true
	  end

	  # underflow is when none of the lines can fit into a given column at the position
	  # We move it to the item to the next column
	  def underflow?
	    @underflow == true
	  end

	  # I should read it from StyleService
	  # list_* are for list item order token attributes
    def make_para_style
      h                           = {}
      h[:font]                    = "smSSMyungjoP-W30"
      h[:text_size]               = 10
      h[:space_width]             = 4
      h[:text_color]              = "black"
      h[:fill_color]              = "white"
      h[:text_style]              = "plain"
      h[:h_alignment]             = "left"
      h[:v_alignment]             = "center"
      h[:first_line_indent]       = 20
      h[:head_indent]             = 3
      h[:tail_indent]             = 3
      h[:space_before]            = 0
      h[:space_after]             = 0
      h[:tab_stops]               = [['left', 20], ['left', 40], ['left', 60],['left', 80]]
      h[:double_emphasis]         = {stroke_sides: [1,1,1,1], stroke_thickness: 0.5}
      h[:single_emphasis]         = {stroke_sides: [0,1,0,1], stroke_thickness: 0.5}

      style = RLayout::StyleService.shared_style_service.current_style[@markup]
      if style.class == String
        # this is when a style is refering to other style by name
        style = RLayout::StyleService.shared_style_service.current_style[style]
      end
      if style
        h.merge! style
      end
      @para_style = h
    end

    def filter_list_options(h)
      list_only = Hash[h.select{|k,v| [k, v] if k=~/^list_/}]
      Hash[list_only.collect{|k,v| [k.to_s.sub("list_","").to_sym, v]}]
    end

    def attributes_of_attributed_string(att_str)
      att_run_array=[]
      range = Pointer.new(NSRange.type)
      i=0
      string = att_str.string
      puts "att_str.string:#{att_str.string}"
      while i < att_str.string.length do
        attrDict = att_str.attributesAtIndex  i, effectiveRange:range
        length=range[0].length
        i += length
        att_hash={}
        starting_index = range[0].location
        ending_index = starting_index + (range[0].length - 1)
        puts "[starting_index..ending_index]:#{[starting_index..ending_index]}"
        puts att_hash[:string] = string[starting_index..ending_index]
        att_hash[:paragraph_style]=attrDict[NSParagraphStyleAttributeName]  if attrDict[NSParagraphStyleAttributeName]
        if attrDict[NSFontAttributeName]
          att_hash[:font]=attrDict[NSFontAttributeName].fontName
          att_hash[:size]= attrDict[NSFontAttributeName].pointSize.round(2)
          # att_hash[:color]= attrDict[NSForegroundColorAttributeName].color
        end
        att_hash[:tracking]       = attrDict[NSKernAttributeName]            if attrDict[NSKernAttributeName]
        att_hash[:strike]         = attrDict[NSStrikethroughStyleAttributeName] if attrDict[NSStrikethroughStyleAttributeName]
        att_hash[:baseline_offset]= attrDict[NSBaselineOffsetAttributeName]       if attrDict[NSBaselineOffsetAttributeName]
        att_hash[:styles]= []
        att_hash[:styles]<<:italic                                    if attrDict[NSObliquenessAttributeName]
        att_hash[:styles]<<:bold                                      if attrDict[NSObliquenessAttributeName]
        att_hash[:styles]<< :underline                                if attrDict[NSUnderlineStyleAttributeName]
        att_hash[:styles]<< :superscript                              if attrDict[NSSuperscriptAttributeName]

        # is there no subscript?
        # att_hash[:styles]<< :suberscript  if attrDict[NSSubscriptAttributeName]
        att_run_array <<  att_hash
      end
      att_run_array
    end
    # NSString *NSFontAttributeName;
    # NSString *NSParagraphStyleAttributeName;
    # NSString *NSForegroundColorAttributeName;
    # NSString *NSUnderlineStyleAttributeName;
    # NSString *NSSuperscriptAttributeName;
    # NSString *NSBackgroundColorAttributeName;
    # NSString *NSAttachmentAttributeName;
    # NSString *NSLigatureAttributeName;
    # NSString *NSBaselineOffsetAttributeName;
    # NSString *NSKernAttributeName;
    # NSString *NSLinkAttributeName;
    # NSString *NSStrokeWidthAttributeName;
    # NSString *NSStrokeColorAttributeName;
    # NSString *NSUnderlineColorAttributeName;
    # NSString *NSStrikethroughStyleAttributeName;
    # NSString *NSStrikethroughColorAttributeName;
    # NSString *NSShadowAttributeName;
    # NSString *NSObliquenessAttributeName;
    # NSString *NSExpansionAttributeName;
    # NSString *NSCursorAttributeName;
    # NSString *NSToolTipAttributeName;
    # NSString *NSMarkedClauseSegmentAttributeName;

  end

  # line fill_color is set by optins[:line_color] or it is set to clear
  class	LineFragment < Container
    attr_accessor :line_type #first_line, last_line, drop_cap, drop_cap_side
    attr_accessor :left_indent, :right_indent, :para_style
    attr_accessor :x, :y, :width, :height, :total_token_width

  	def	initialize(options={})
      # options[:stroke_color]    = 'red'
      options[:layout_direction]  = 'horizontal'
      options[:fill_color]        = options.fetch(:line_color, 'clear')
      # options[:stroke_width]      = 1
      #TODO
      # line frame are drawn with offset value, they don't align with tokens
  	  super
      # @tokens         = @text_layout_manager.tokens
  	  @graphics         = options[:tokens]
  	  @space_width      = options.fetch(:space_width, 5.0)
  	  @stroke_width     = 1
  	  @width            = options.fetch(:width, 300)
      # @left_indent      = options.fetch(:width, 10)
      # @right_indent     = options.fetch(:right_indent, 0)
  	  @para_style       = options[:para_style]
  	  @graphics.each do |token|
        token.parent_graphic = self
      end
  		align_tokens
  		self
  	end

    def token_width_sum
      @graphics.map{|t| t.width}.reduce(0, :+)
    end

    def rect
      [@x, @y, @width, @height]
    end

	  def align_tokens
	    return if @graphics.length == 0
	    @total_token_width = token_width_sum
      @total_space_width = (@graphics.length - 1)*@space_width if @graphics.length > 0
      room = @width - (@total_token_width + @total_space_width)
      x = 0.0
      @graphics.each do |token|
        token.x = x
        x += token.width + @space_width
      end

      case @para_style[:text_alignment]
      when 'left'
      when 'center'
        @graphics.map {|t| t.x += room/2.0}
      when 'right'
        @graphics.map do |t|
          t.x += room
        end
      #TODO
      # when 'justified'
      #   if is_last_line?
      #   else
      #     just_space = room/(@graphics.length - 1)
      #     x = 0
      #     @graphics.each_with_index do |token, i|
      #       token.x = x
      #       x += token.width + just_space
      #     end
      #   end
      else

      end

	  end

    def line_string
      string = ""
      @graphics.each do |token|
        string += token.string
      end
      string
    end

    # def tallest_token
    #
    # end

    # def room
    #       @width - @left_indent - @right_indent
    # end

  end


  class DropParagraph < Paragraph
    attr_accessor :image_object, :cap_object, :title, :subtitle, :body
    def initialize(options={}, &block)
      super

      self
    end

    def layout_lines

    end
  end

  # ComboParagraph can have DropCap, DropImage, head, body
  class ComboParagraph < Paragraph
    attr_accessor :image_object, :cap_object, :title, :subtitle, :body

    def initialize(options={}, &block)
      super
      add_title_tokens
      self
    end

  end

  def add_title_tokens

  end

end
