
# For text handling, Text and Paragraph are used
# Text Object is used for simple text, usually for single page document or Ads.
# Text uses NSTextSystem,
# Text is also used in Heading, HeadingContainer, where several short texts are used.
# Paragraph Object is used in middle to long document.

# Paragraph uses our own text system.
# Paragraph is not a Graphic eleemnt, it just holds data and tokens.
# line layout is done in TextColumn


# Emphasis Handling
# inline emphasis are handled using double curl {{content}}, or single curl {content}
# We want the emphasis mark to be simple as possible for writers.
# This is work in process, it might change as we go!!!!
# So, we limit the emphasis markup to those two only,
# and how it is implement is left to designer, not to the writer.
# It means designer need to provide custom style at run time for effected para styles.
# There are two types of emphasis,  "text effect" and "special layout".
# For text effect, such as italic, bold, boxed, underline, hidden_text, emphasis we can modify the @token_style to get the effect. So designer need to provide paragraph_styles paragraph style as hash.
# For special layout tokens, such as ruby, reverse ruby,  we have to do some layout modification. In this case, desinger needs to proved the function name of the emphasis, such as ruby, reverse_ruby, icon: name . in custom paragraph style. as para_style[:double_emphasis]  = "reverse_ruby"
#
# {{base text}{top text}}
# {{base text}{top text}}
#

# String#split
# if we use String#split with match, we get the match as an Array eleemnt. I find it very useful.
# I am using it to parse the inline style empasis and inline special empasis.

# {{ruby sting, uppper}}

# I am still toying with differnce syntexes to make it easy to write.
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

  class NewsParagraph
    attr_reader :markup
    attr_accessor :tokens, :token_heights_are_eqaul
    attr_accessor :para_string, :para_style, :list_style
    attr_accessor :text_column, :grid_height
    attr_accessor :body_line_height, :split
    def initialize(options={})
      puts "++++++++++++ NewsParagraph"
      @tokens = []
      #simple, drop_cap, drop_cap_image, math, with_image, with_math
      @markup         = options.fetch(:markup, 'p')
      @para_string    = options.fetch(:para_string, "")
      make_para_style
      # super doen't set @para_style values
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
      else
        @tokens       = []
        create_tokens
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
      else
        # puts "@para_style:#{@para_style}"
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

    def room
      @height
    end

    def number_of_tokens
      number_of_tokens = 0
      @graphics.each do |line|
        number_of_tokens +=  line.graphics.count
      end
      number_of_tokens
    end

    # it makes sense to reduce space by the paragraph, since return key blocks the rippling effect.
    # we reduce the paragraphs from the alst to first untill we have reduced desired number of lines.
    def para_space_info
      number_of_spaces = 0
      number_of_tokens = 0
      @graphics.each do |line|
        number_of_spaces +=  line.graphics.count - 1
        number_of_tokens +=  line.graphics.count
      end
      number_of_lines = @graphics.count
      # number_of_spaces
      # number_of_tokens
      last_line_tokens = @graphics.last.graphics.count
      if @tokens.length > 0
        last_line_tokens = @tokens.lengt
      end
      {number_of_lines: number_of_lines, number_of_spaces: number_of_spaces, number_of_tokens: number_of_tokens, last_line_tokens: last_line_tokens}
    end


    # algorithm for laying out paragraph in TextColumn
    # loop until we run out of tokens
	  # 1. start at current_line
	  # 2. keep filling up the line_tokens until the width total exceed the width of line.
    # For fix line height layout
    #
    # else
       # this is for variable line height
	     # 3. Each time with new token, check the height change, tallest_token and adjust line height.
    # end
    def layout_lines(text_column)
      @current_line = text_column.current_line
      @current_line.set_paragraph(self)
      @current_line.set_line_type("first_line")
      while @current_line.place_tokens(tokens) && text_column.has_room?
        @current_line.align_tokens
        @current_line = text_column.go_to_next_line
        if @current_line
          @current_line.set_paragraph(self)
          @current_line.set_line_type("middle_line")
        else
          exit
        end
      end
      if text_column.is_last_line?
        split = true
        return true # left over is true
      else
        @current_line.align_tokens
      end
      false # no left over
    end



    # try reducing lines by using reducded space width
    # the result would either succeed in reducing the number of lines
    # or we just can't reduce the line numbers without going over the limit
    # goal is given, so stop the process, if we have reached a goal
    # return number of reduced lines
    def try_reducing_line_numbers_by_changing_space_width(our_goal)
      reduced_lines = 0
      #TODO
      reduced_lines
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
      #  "att_str.string:#{att_str.string}"
      while i < att_str.string.length do
        attrDict = att_str.attributesAtIndex  i, effectiveRange:range
        length=range[0].length
        i += length
        att_hash={}
        starting_index = range[0].location
        ending_index = starting_index + (range[0].length - 1)
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

end
