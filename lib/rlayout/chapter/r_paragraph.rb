
# Paragraph Object is used in middle to long document.
# Paragraph is not a Graphic subclass.
# Paragraph holds data tokens and resposible for laying out them out in lines.

# announcement paragragraph
# line takes up 2 or multples of body_line_height
# it has line space of 1 before

module RLayout
  #TODO
  # tab stop
  EMPASIS_STRONG = /(\*\*.*?\*\*)/
  EMPASIS_DIAMOND = /(\*.*?\*)/

  class RParagraph
    attr_reader :markup, :move_up_if_room
    attr_accessor :tokens, :token_heights_are_equal
    attr_accessor :para_string, :style_name, :para_style, :space_width
    attr_accessor :article_type
    attr_accessor :body_line_height, :line_count, :token_union_style

    def initialize(options={})
      @tokens = []
      @markup         = options.fetch(:markup, 'p')
      @para_string    = options.fetch(:para_string, "")
      @line_count     = 0
      @article_type   = options[:article_type]
      parse_style_name
      # super doen't set @para_style values
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
        token_options = {}
        token_options[:string] = token_string
        token_options[:para_style] = @para_style
        token_options[:height] = @para_style[:font_size]
        @tokens << RLayout::RTextToken.new(token_options)
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
      if @markup == "h4" || @markup == "h1"
        if  @para_string =~/\^$/
          @para_string = @para_string.sub(/\^$/, "")
          @move_up_if_room = true
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
      token_heights_are_equal = true
      return unless  @tokens.length > 0
      tallest_token_height = @tokens.first.height
      @tokens.each do |token|
        if token.height > tallest_token_height
          token_heights_are_equal = false
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
        if token_group =~EMPASIS_STRONG
          token_group.gsub!("**", "")
          # get font and size
          current_style = RLayout::StyleService.shared_style_service.current_style
          style_hash = current_style['body_gothic'] #'strong_emphasis'
          @emphasis_para_style = Hash[style_hash.map{ |k, v| [k.to_sym, v] }]
          tokens_array = token_group.split(" ")
          tokens_array.each do |token_string|
            emphasis_style              = {}
            emphasis_style[:string]     = token_string
            emphasis_style[:para_style] = @emphasis_para_style
            emphasis_style[:height]     = @emphasis_para_style[:font_size]
            @tokens << RLayout::RTextToken.new(emphasis_style)
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
          # get font and size
          unless token_group =~ /◆/
            token_group.strip!
            token_group = "◆" + token_group
          end
          unless token_group =~ /\=/
            token_group.strip!
            token_group += " ="
          end
          current_style = RLayout::StyleService.shared_style_service.current_style
          style_hash = current_style['body_gothic'] #'diamond_emphasis'
          @diamond_para_style = Hash[style_hash.map{ |k, v| [k.to_sym, v] }]
          tokens_array = token_group.split(" ")
          tokens_array.each do |token_string|
            emphasis_style              = {}
            emphasis_style[:string]     = token_string
            emphasis_style[:para_style] = @diamond_para_style
            emphasis_style[:height]     = @diamond_para_style[:font_size]
            emphasis_style[:token_type] = 'diamond_emphasis'
            @tokens << RLayout::RTextToken.new(emphasis_style)
          end
        else
          # line text with just noral text tokens
          # puts "token_group for plain: #{token_group}"
          create_plain_tokens(token_group)
        end
      end
    end

    def layout_lines(current_line, options={})
      return unless current_line
      @current_line = current_line
      @line_count = 1
      @current_line.set_paragraph_info(self, "first_line")
      token = tokens.shift
      if token && token.token_type == 'diamond_emphasis'
        # if first token is diamond emphasis, no head indent
        unless @current_line.first_text_line_in_column?
          @current_line = @current_line.next_text_line
        end
        @current_line.layed_out_line = true
        @current_line.set_paragraph_info(self, "middle_line")
      elsif @markup == 'h1' || @markup == 'h2' || @markup == 'h3' ||  @markup == 'h4'
        
        unless @current_line.first_text_line_in_column?
          if @para_style[:space_before_in_lines] == 1
            @current_line.layed_out_line = true
            @current_line = @current_line.next_text_line
          end
          @current_line.layed_out_line = true
          @current_line.token_union_style = @token_union_style if @token_union_style
        end
        # @current_line = @current_line.next_text_line
        # return true unless @current_line
        @current_line.set_paragraph_info(self, "middle_line")
      end

      while token
        return unless @current_line
        result = @current_line.place_token(token)
        # token is broken into two, second part is returned
        if result.class == RTextToken
          @current_line.align_tokens
          @current_line.room = 0
          new_line = @current_line.next_text_line
          if new_line
            @current_line = new_line
            @current_line.set_paragraph_info(self, "middle_line")
            @line_count += 1
            token = result
          else
            # break #reached end of last column
            @current_line = @current_line.parent.add_new_page
            # tokens.unshift(result) #stick the unplace token back to the tokens
            token = result
          end
        elsif result
          # puts "entire token placed succefully, returned result is true"
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
            @current_line = @current_line.parent.add_new_page
            # tokens.unshift(token) #stick the unplace token back to the tokens
            # break #reached end of column
          end
        end
      end
      if @line_count == 1 && @current_line.line_type == 'first_line'
        @current_line.text_alignment = 'left'
      else
        @current_line.set_paragraph_info(self, "last_line")
      end
      @current_line.align_tokens
      if @move_up_if_room 
        if found_previous_line = previous_line_has_room(@current_line)
          move_tokens_to_previous_line(@current_line, found_previous_line)
          @current_line
        else
          @current_line.next_text_line
        end
      else
        @current_line.next_text_line
      end
    end

    def previous_line_has_room(current_line)
      previous_line = current_line.previous_text_line
      return previous_line if previous_line.room > current_line.text_length
      false
    end

    def move_tokens_to_previous_line(line, p_line)
      line.graphics.each do |token|
        token.parent = p_line
        p_line.graphics << token
      end
      line.graphics = []
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

    def parse_style_name
      current_style = RLayout::StyleService.shared_style_service.current_style
      if @markup =='p' || @markup =='br'
        @style_name  = 'body'
        style_hash = current_style['body']
        @para_style = Hash[style_hash.map{ |k, v| [k.to_sym, v] }]
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
            @token_union_style = Hash[@token_union_style.map{ |k, v| [k.to_sym, v] }]
          end
        else
          style_hash = current_style['reporter']
          @style_name  = 'reporter'
        end
        @para_style = Hash[style_hash.map{ |k, v| [k.to_sym, v] }]
      end

      if @markup =='h2'
        style_hash = current_style['running_head']
        @style_name  = 'running_head'
        @para_style = Hash[style_hash.map{ |k, v| [k.to_sym, v] }]
      end

      if @markup =='h3'
        style_hash = current_style['body_gothic']
        @style_name  = 'body_gothic'
        @para_style = Hash[style_hash.map{ |k, v| [k.to_sym, v] }]
      end

      if @markup =='h4'
        style_hash = current_style['linked_story']
        @style_name  = 'linked_story'
        @para_style  = Hash[style_hash.map{ |k, v| [k.to_sym, v] }]
        @para_string = "▸▸" + @para_string
      end

      @space_width  = @para_style[:space_width]
      if @space_width.nil?
        font_size   = @para_style[:font_size]
        @space_width = font_size/2
      end
    end

    def filter_list_options(h)
      list_only = Hash[h.select{|k,v| [k, v] if k=~/^list_/}]
      Hash[list_only.collect{|k,v| [k.to_s.sub("list_","").to_sym, v]}]
    end

    def self.sample
      tokens = []
      100.times do
        tokens << RTextToken.sample
      end
      RParagraph.new(token_array: tokens)
    end

    def self.sample_para_list(options={})
      list = []
      options[:count].times do
        list << RParagraph.sample
      end
      list
    end

  end

end
