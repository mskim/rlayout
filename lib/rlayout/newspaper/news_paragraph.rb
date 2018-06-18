
# For text handling, Text and Paragraph are used
# Text Object is used for simple text, usually for single page document or Ads.
# Text is also used in Heading, HeadingContainer, where several short texts are used.

# Paragraph Object is used in middle to long document.
# Paragraph is not a Graphic subclass.
# Paragraph holds data tokens and resposible for laying out them out in lines.

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

  # list_styles option items are used in list type paragraphs, such as
  # OrderedList, UnordersList, OrderedSection, UpperAlpaList
  # they all have prefix of ":list_*" ,
  # it is filtered using "filter_list_options(options)" and saved in @list_style
  # @list_style is passed into Tokens as Graphic options.

  EMPASIS_STRONG = /(\*\*.*?\*\*)/
  EMPASIS_DIAMOND = /(\*.*?\*)/

  class NewsParagraph
    attr_reader :markup
    attr_accessor :tokens, :token_heights_are_eqaul
    attr_accessor :para_string, :para_style, :style_name
    attr_accessor :grid_height, :article_type
    attr_accessor :body_line_height, :split, :line_count, :token_union_style

    def initialize(options={})
      @tokens = []
      #simple, drop_cap, drop_cap_image, math, with_image, with_math
      @markup         = options.fetch(:markup, 'p')
      @para_string    = options.fetch(:para_string, "")
      @line_count     = 0
      @article_type   = options[:article_type]
      make_para_style
      # super doen't set @para_style values
      @space_width    = @para_style[:space_width]
      @grid_height    = options.fetch(:grid_height, 2)
      @linked         = options.fetch(:linked, false)
      if @markup == 'br'

      elsif options[:tokens]
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

    def create_plain_tokens(para_string)
      # parse for tab first
      return unless para_string
      tokens_strings = para_string.split(" ")
      tokens_strings.each do |token_string|
        next unless token_string
        @para_style[:string] = token_string
        @para_style.delete(:parent) if @para_style[:parent]
        @tokens << RLayout::TextToken.new(@para_style)
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
    # and call create_plain_tokens for regular string segmnet
    def create_tokens
      @atts = {}
      if RUBY_ENGINE == 'rubymotion'
        @atts = NSUtils.ns_atts_from_style(@para_style)
        @space_width = @atts[:@space_width]
        @para_style[:atts] = @atts
      else
        unless @para_style[:space_width]
          @space_width = @para_style[:space_width]  = @para_style[:font_size]/2
        end
      end
      if @markup == "h3"
        unless @para_string =~/■/
          @para_string = "■" + @para_string
        end
      end
      if @para_string =~EMPASIS_STRONG
        create_tokens_with_emphasis_strong(@para_string)
      elsif @para_string =~EMPASIS_DIAMOND
        create_tokens_with_emphasis_diamond(@para_string)
      else
        create_plain_tokens(@para_string)
      end
      # create_plain_tokens(@para_string)
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

    def create_tokens_with_emphasis_strong(para_string)
      para_string.chomp!
      para_string.sub!(/^\s*/, "")
      split_array = para_string.split(EMPASIS_STRONG)
      # splited array contains strong content
      split_array.each do |token_group|
        if token_group =~EMPASIS_DIAMOND
          token_group.gsub!("**", "")
          current_style             = RLayout::StyleService.shared_style_service.current_style
          style_hash                = current_style['body_gothic']
          style_hash                = Hash[style_hash.map{ |k, v| [k.to_sym, v] }] if style_hash
          emphasis_style              = @para_style.dup
          emphasis_style[:font]       = style_hash[:font] if style_hash[:font]
          emphasis_style[:font_size]  = style_hash[:font_size] if style_hash[:font_size]
          emphasis_style[:text_color] = style_hash[:text_color] if style_hash[:text_color]
          atts = {}
          if RUBY_ENGINE == 'rubymotion'
            atts = NSUtils.ns_atts_from_style(emphasis_style)
            @space_width = atts[:@space_width]
            emphasis_style[:atts] = atts
          else
            unless @para_style[:space_width]
              @space_width = @para_style[:space_width]  = @para_style[:font_size]/2
            end
          end
          # get font and size
          tokens_array = token_group.split(" ")
          tokens_array.each do |token_string|
            emphasis_style[:string] = token_string
            @tokens << RLayout::TextToken.new(emphasis_style)
          end
        else
          # line text with just noral text tokens
          create_plain_tokens(token_group)
        end
      end
    end


    def create_tokens_with_emphasis_diamond(para_string)

      para_string.chomp!
      para_string.sub!(/^\s*/, "")
      split_array = para_string.split(EMPASIS_DIAMOND)
      # splited array contains strong content
      split_array.each do |token_group|
        if token_group =~EMPASIS_DIAMOND
          token_group.gsub!("*", "")
          current_style             = RLayout::StyleService.shared_style_service.current_style
          style_hash                = current_style['running_head']
          style_hash                = Hash[style_hash.map{ |k, v| [k.to_sym, v] }] if style_hash
          emphasis_style              = @para_style.dup
          emphasis_style[:font]       = style_hash[:font] if style_hash[:font]
          emphasis_style[:font_size]  = style_hash[:font_size] if style_hash[:font_size]
          emphasis_style[:text_color] = style_hash[:text_color] if style_hash[:text_color]
          atts = {}
          if RUBY_ENGINE == 'rubymotion'
            atts = NSUtils.ns_atts_from_style(emphasis_style)
            @space_width = atts[:@space_width]
            emphasis_style[:atts] = atts
          else
            unless @para_style[:space_width]
              @space_width = @para_style[:space_width]  = @para_style[:font_size]/2
            end
          end
          # get font and size
          unless token_group =~ /◆/
            token_group.strip!
            token_group = "◆" + token_group
          end
          unless token_group =~ /\=/
            token_group.strip!
            token_group += " ="
          end

          tokens_array = token_group.split(" ")
          tokens_array.each do |token_string|
            emphasis_style[:string] = token_string
            emphasis_style[:token_type] = 'diamond_emphasis'
            @tokens << RLayout::TextToken.new(emphasis_style)
          end
        else
          # line text with just noral text tokens
          # puts "token_group for plain: #{token_group}"
          create_plain_tokens(token_group)
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

    def layout_lines(current_line, options={})
      @current_line = current_line
      @current_line.set_paragraph_info(self, "first_line")
      token = tokens.shift
      if token && token.token_type == 'diamond_emphasis'
        # puts "first token is diamond_emphasis"
        # if first token is diamond emphasis, no head indent
        @current_line.set_paragraph_info(self, "middle_line")
      elsif @markup == 'h2' || @markup == 'h3' ||  @markup == 'h1'
        unless @current_line.first_text_line_in_column?
          @current_line = @current_line.next_text_line
          @current_line.layed_out_line = true
          @current_line.token_union_style = @token_union_style if @token_union_style
        end
        # @current_line = @current_line.next_text_line
        # return true unless @current_line
        @current_line.set_paragraph_info(self, "middle_line")
      end

      while token
        result = @current_line.place_token(token)
        # token is broken into two, second part is returned
        if result.class == TextToken
          @current_line.align_tokens
          @current_line.room = 0
          new_line = @current_line.next_text_line

          if new_line
            @current_line = new_line
            @current_line.set_paragraph_info(self, "middle_line")
            @line_count += 1
            token = result
          else
            @current_line = @current_line.parent.add_new_line
            tokens.unshift(result) #stick the unplace token back to the tokens
            token = result
            # break #reached end of column
          end
        # entire token placed succefully, returned result is true
        elsif result
          token = tokens.shift
        # entire token was rejected,
        else
          @current_line.align_tokens
          @current_line.room = 0
          new_line = @current_line.next_text_line
          if new_line
            @current_line = new_line
            @current_line.set_paragraph_info(self, "middle_line")
            @line_count += 1
          else
            @current_line = @current_line.parent.add_new_line
            tokens.unshift(token) #stick the unplace token back to the tokens
            # break #reached end of column
          end
        end
      end
      @current_line.set_paragraph_info(self, "last_line")
      @current_line.align_tokens
      # move cursor to new line
      @current_line.next_text_line
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
      h[:text_color]              = "CMYK=0,0,0,100"
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

      current_style = RLayout::StyleService.shared_style_service.current_style
      if @markup =='p'
        @style_name  = 'body'
        style_hash = current_style['body']
        style = Hash[style_hash.map{ |k, v| [k.to_sym, v] }]
      end
      # h1 $ is  assigned as reporrter
      if @markup =='h1'
        if @article_type == '사설' || @article_type == 'editorial' || @article_type == '기고'
          style_hash = current_style['reporter_editorial']
          @style_name  = 'reporter_editorial'
          @graphic_attributes = style_hash['graphic_attributes']
          if @graphic_attributes == {}
          elsif @graphic_attributes == ""
          elsif @graphic_attributes.class == String
            @graphic_attributes = eval(@graphic_attributes)
          end
          if @graphic_attributes.class == Hash
            @token_union_style = @graphic_attributes['token_union_style']
          end
        else
          style_hash = current_style['reporter']
          @style_name  = 'reporter_editorial'
        end
        style = Hash[style_hash.map{ |k, v| [k.to_sym, v] }]
      end

      if @markup =='h2'
        style_hash = current_style['running_head']
        @style_name  = 'running_head'
        # style_hash = current_style['body_gothic']
        style = Hash[style_hash.map{ |k, v| [k.to_sym, v] }]
      end

      if @markup =='h3'
        style_hash = current_style['body_gothic']
        @style_name  = 'body_gothic'

        # style_hash = current_style['body_gothic']
        style = Hash[style_hash.map{ |k, v| [k.to_sym, v] }]
      end

      # if @markup =='h3'
      #   style_hash = current_style['running_head']
      #   style = Hash[style_hash.map{ |k, v| [k.to_sym, v] }]
      # end

      style[:h_alignment]   = style[:alignment]   if style && style[:alignment]
      if style
        h.merge! style
      end
      @para_style = h
    end

    def filter_list_options(h)
      list_only = Hash[h.select{|k,v| [k, v] if k=~/^list_/}]
      Hash[list_only.collect{|k,v| [k.to_s.sub("list_","").to_sym, v]}]
    end

    def self.sample
      tokens = []
      100.times do
        tokens << TextToken.sample
      end
      NewsParagraph.new(token_array: tokens)
    end

    def self.sample_para_list(options={})
      list = []
      options[:count].times do
        list << NewsParagraph.sample
      end
      list
    end

  end

end
