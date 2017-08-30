
# For text handling, Text and Paragraph are used
# Text Object is used for simple text, usually for single page document or Ads.
# Text uses NSTextSystem,
# Text is also used in Heading, HeadingContainer, where several short texts are used.
# Paragraph Object is used in middle to long document.

# Paragraph uses our own text system.
# Paragraph is not a Graphic eleemnt, it just holds data and tokens.
# line layout is done in TextColumn


# Emphasis Handling(2016_11)
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
    attr_accessor :body_line_height, :split, :line_count
    def initialize(options={})
      @tokens = []
      #simple, drop_cap, drop_cap_image, math, with_image, with_math
      @markup         = options.fetch(:markup, 'p')
      @para_string    = options.fetch(:para_string, "")
      @line_count = 0
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

    def create_text_tokens(para_string)
      # parse for tab first
      @tokens += para_string.split(" ").collect do |token_string|
        @para_style[:string] = token_string
        @para_style.delete(:parent) if @para_style[:parent]
        RLayout::TextToken.new(@para_style)
      end
    end

    # this is use in calculating left ocer text after layout
    def left_over_token_text
      string = ""
      @tokens.each do |token|
        string += token.string
        string += " "
      end
      string
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
        @atts[NSFontAttributeName]  = NSFont.fontWithName(@para_style[:font], size: @para_style[:font_size])
        if @para_style[:text_color]
          text_color    = RLayout.convert_to_nscolor(@para_style[:text_color]) unless (@para_style[:text_color]) == NSColor
          @atts[NSForegroundColorAttributeName] = text_color
        end
        if @para_style[:text_tracking] != 0
          # atts[NSKernAttributeName]  = text_tracking if text_tracking
          @atts[NSKernAttributeName] = @para_style[:text_tracking]
        end
        # #TODO
        # atts[NSKernAttributeName]  = text_tracking if text_tracking
        unless @para_style[:space_width]
          @space_width = @para_style[:space_width]  = NSAttributedString.alloc.initWithString(" ", attributes: @atts).size.width
        end
        @para_style[:atts] = @atts
      else
        unless @para_style[:space_width]
          @space_width = @para_style[:space_width]  = @para_style[:font_size]/2
        end
        # puts "@para_style:#{@para_style}"
      end

      # do we have any doulbe curl?, for special token
      # if @para_string =~INLINE_DOUBLE_CURL
      #   create_tokens_with_double_curl(@para_string)
      # # no doulbe curl, do we have any single curl?
      # elsif @para_string =~INLINE_SINGLE_CURL
      #   create_tokens_with_single_curl(@para_string)
      # # no curls found, so create_text_tokens
      # else
      #   create_text_tokens(@para_string)
      # end
      create_text_tokens(@para_string)
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
    def layout_lines(text_box)
      # @current_line = text_column.current_line
      @current_line = text_box.next_text_line
      return true unless @current_line  # this mean overflow
      if @line_count == 0
        @current_line.set_paragraph_info(self, "first_line")
      end
      token = tokens.shift
      while token
        result = @current_line.place_token(token)
        # token is broken into two, second part is returned
        if result.class == TextToken
          @current_line.align_tokens
          @current_line.room = 0
          @current_line = text_box.next_text_line
          if @current_line
            @current_line.set_paragraph_info(self, "middle_line")
            @line_count += 1
            token = result
          else
            tokens.unshift(result) #stick the unplace token back to the tokens
            return true # overflow
            # break #reached end of column
          end
        # entire token placed succefully, returned result is true
        elsif result
          token = tokens.shift
        # entire token was rejected,
        else
          @current_line.align_tokens
          @current_line.room = 0
          @current_line = text_box.next_text_line
          if @current_line
            @current_line.set_paragraph_info(self, "middle_line")
            @line_count += 1
          else
            tokens.unshift(token) #stick the unplace token back to the tokens
            return true # overflow id true
            # break #reached end of column
          end
        end
      end
      @current_line.set_paragraph_info(self, "last_line")
      @current_line.align_tokens
      # move cursor to new line
      text_box.current_column.go_to_next_line
      text_box.next_text_line
      false # no  overflow
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
      h[:font_size]               = 9.2
      h[:text_color]              = "black"
      h[:fill_color]              = "white"
      h[:text_style]              = "plain"
      h[:h_alignment]             = "justified"
      h[:v_alignment]             = "center"
      h[:first_line_indent]       = 10
      h[:head_indent]             = 1
      h[:tail_indent]             = 1
      h[:space_before]            = 0
      h[:space_after]             = 0
      h[:tab_stops]               = [['left', 20], ['left', 40], ['left', 60],['left', 80]]
      h[:double_emphasis]         = {stroke_sides: [1,1,1,1], stroke_thickness: 0.5}
      h[:single_emphasis]         = {stroke_sides: [0,1,0,1], stroke_thickness: 0.5}

      style = RLayout::StyleService.shared_style_service.current_style[@markup]
      if custom_styles = RLayout::StyleService.shared_style_service.custom_style
        if @markup =='p'
          style_hash = custom_styles['body']
          style = Hash[style_hash.map{ |k, v| [k.to_sym, v] }]

        elsif style.class == String
          # this is when a style is refering to other style by name
          style = RLayout::StyleService.shared_style_service.current_style[style]
        end

        if @markup =='h1'
          style_hash = custom_styles['reporter']
          style = Hash[style_hash.map{ |k, v| [k.to_sym, v] }]
        elsif style.class == String
          # this is when a style is refering to other style by name
          style = RLayout::StyleService.shared_style_service.current_style[style]
        end
      else
        if @markup =='p'
          style = NEWSPAPER_STYLE['body']
          style = Hash[style.map{ |k, v| [k.to_sym, v] }]

        elsif style.class == String
          # this is when a style is refering to other style by name
          style = RLayout::StyleService.shared_style_service.current_style[style]
        end

        if @markup =='h1'
          style = NEWSPAPER_STYLE['reporter']
          style = Hash[style.map{ |k, v| [k.to_sym, v] }]

        elsif style.class == String
          # this is when a style is refering to other style by name
          style = RLayout::StyleService.shared_style_service.current_style[style]
        end
      end
      # puts "before style[:space_width]:#{style[:space_width]}"
      style[:space_width]    = style[:space_width]  if style[:space_width]
      style[:text_tracking] = style[:tracking]    if style[:tracking]
      style[:h_alignment]   = style[:alignment]   if style[:alignment]
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
        att_hash[:tracking]         = attrDict[NSKernAttributeName]               if attrDict[NSKernAttributeName]
        att_hash[:strike]           = attrDict[NSStrikethroughStyleAttributeName] if attrDict[NSStrikethroughStyleAttributeName]
        att_hash[:baseline_offset]  = attrDict[NSBaselineOffsetAttributeName]     if attrDict[NSBaselineOffsetAttributeName]
        att_hash[:styles]= []
        att_hash[:styles]<<:italic                                                if attrDict[NSObliquenessAttributeName]
        att_hash[:styles]<<:bold                                                  if attrDict[NSObliquenessAttributeName]
        att_hash[:styles]<< :underline                                            if attrDict[NSUnderlineStyleAttributeName]
        att_hash[:styles]<< :superscript                                          if attrDict[NSSuperscriptAttributeName]
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
