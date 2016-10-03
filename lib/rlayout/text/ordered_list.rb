module RLayout
  
  # List Objects OrderedList, UnorderdList, OrderedSection, and UpperAlphList are 
  # block "unbrella" paragraphs, similar to Table 
  # They are kind of Paragraphs that wrap the actual Paragraphs.
  # When they are layed out, It is not layed out, but its graphics are.
  # Its graphics are created as OrderedListItem or UnorderdListItem.
  # OrderedListItem, UnorderdListItem is set with markup that corrensponds to the style being allyied. @list_style is applied to those listItems.
  
  # @list_style containes 
  # h[:list_font]               = h[:font]
  # h[:list_text_color]         = h[:text_color]
  # h[:list_text_size]          = h[:text_size]
  # h[:list_to_text_space]      = h[:text_size]*2 # space between num token and stating text
  # h[:list_text_indent]        = h[:text_size]*4 # x to stating text, independent of num token
  #                                               # also sets the head indent of rest of lines
  #                                               # tab effect for all lines without tab 
  # h[:list_child_indent]       = h[:list_text_size]*4
  # h[:list_first_child_top_margin]   = 0
  # h[:lsit_last_child_bottom_margin] = 0
  # 
  #
  # ordering_char_types=  %w[1 a A] #[number, lower_alphabet, upper_alphabet]
  # optional array can be passed with custom  
  # TODO this is adoc style do it for markdown as well
  
  
  class OrderedList < Container
    attr_accessor :current_order, :ordering_char_types, :text_block
    # we have @list_style from Paragraph
    
    def initialize(options={})
      super
      #TODO this fails if number goes beyond 9
      @ordering_char_types  = options.fetch(:ordering_char_types, %w[1 a A])
      @text_block           = options[:text_block]
      parse_list_items
      self
    end
    
    def parse_list_items
      #TODO this fails if items depth goes beyond 3
      @current_order  = [0,0,0]
      if @text_block.class == Array
        @list_text = @text_block
      elsif @text_block.class == String
        @list_text = @text_block.split("\n")
      end
      @list_text.each do |list|
        case list
        when /^\.\s/
          ordering_char = (@ordering_char_types[0].ord + @current_order[0]).chr
          para_string = list.sub(/^\./ , ordering_char + ".")
          OrderedListItem.new(parent: self, para_string: para_string, level: 0, order: @current_order[0])
          @current_order[0] += 1
          @current_order[1] = 0
          @current_order[2] = 0
        when /^\.\.\s/
          ordering_char = (@ordering_char_types[1].ord + @current_order[1]).chr
          ordering_char = "\t" + ordering_char + ". "
          para_string = list.sub(/^\.\.\s/ , ordering_char)
          OrderedListItem.new(parent: self, para_string: para_string, level: 1,  order: @current_order[1])
          @current_order[1] += 1
          @current_order[2] = 0
        when /^\.\.\.\s/
          ordering_char = (@ordering_char_types[2].ord + @current_order[2]).chr
          ordering_char = "\t\t" + ordering_char + ". "
          para_string = list.sub(/^\.\.\.\s/ , ordering_char)
          OrderedListItem.new(parent: self, para_string: para_string, level: 2,  order: @current_order[2])
          @current_order[2] += 1
        end
      end
    end
  end
  
  class OrderedListItem < Paragraph
    attr_accessor :order, :level, :indent
    attr_accessor :list_style
    def initialize(options={})
      super
      # set first and last line space
      if options[:is_first_item]
        @para_style[:space_before]= @para_style[:first_item_space_before] if @para_style[:first_item_space_before]
      elsif options[:is_last_item]
        @para_style[:space_after] = @para_style[:last_item_space_after] if @para_style[:last_item_space_after]
      end
      
      #TODO make @indent relative to font size
      @indent             = options.fetch(:indent, 15)
      @order              = options.fetch(:order,1)
      @level              = options.fetch(:level,0)
      @h_alignment        = "left"
      if @para_style[:first_line_indent]
        @first_line_indent  = @para_style[:first_line_indent]
      else
        @first_line_indent  = @level*@indent
      end
      @head_indent        = @first_line_indent + @indent
      # puts the list style in @list_style
      # @list_style[:font]
      # @list_style[:text_size]
      # @list_style[:text_color]
      # @list_style[:text_indent]
      
      # When we need to create list with graphical Number, 
      # number attributea are passed in @para_stye[:list_style]
      # make first token into NumberToken and insert a TabToken into tokens
      # tab_token.width = list_text_indent - number_token.width
      # and for the rest of the lines, head_indent is set same as list_text_indent
      
      # 
      @list_style = @para_style[:list_style].dup if @para_style[:list_style]
      if @list_style
        first_token           = @tokens.shift
        # text_indent is space from first_line_indent to start of text string after the number
        text_indent           = @list_style.fetch(:text_indent, 30)
        options               = @para_style.dup
        options[:string]      = first_token.string
        options.merge!(@list_style)
        number_token          = NumberToken.new(options)
        tab_token_width       = text_indent - number_token.width
        tab_token             = TabToken.new(width: tab_token_width)   
        @tokens.unshift(tab_token)
        @tokens.unshift(number_token)
        #TODO this is a quick fix, I should implement tob stop.
        @para_style[:head_indent] = para_style[:first_line_indent] + text_indent +   @para_style[:space_width]*2
      end


      self
    end
    # I should read it from StyleService      
  end
  
  
  class OrderedSection < Container
    attr_accessor :current_order, :ordering_char_types, :text_block
    
    def initialize(options={})
      super   
      # token is not created yet since the text is passed as text_block, not para_string.
      # OrderedSection acts as umbrella Paragraph, so not text layout takes place
      @ordering_char_types  = options.fetch(:ordering_char_types, %w[A 1 a])
      @text_block           = options[:text_block]
      parse_list_items
      self
    end    
    
    def parse_list_items
      #TODO this fails if items depth goes beyond 2
      @current_order  = [0,0]
      if @text_block.class == Array
        @list_text = @text_block
      elsif @text_block.class == String
        @list_text = @text_block.split("\n")
      end
      @list_text.each_with_index do |list, i|
        case list
        when /^[0-9]\.\s/
          # ordering_char = (@ordering_char_types[0].ord + @current_order[0]).chr
          para_string = list
          OrderedListItem.new(parent: self, para_string: para_string, level: 0, order: @current_order[0], markup: "ordered_section")
        else
          para_string = list
          if i == 1
            OrderedListItem.new(parent: self, para_string: para_string, level: 1,  order: @current_order[1], markup: "ordered_section_item")
          else
            if i== 2 
              OrderedListItem.new(parent: self, para_string: para_string, level: 1,  order: @current_order[1], markup: "ordered_section_item2", is_first_item: true)
            elsif list == @list_text.last
              OrderedListItem.new(parent: self, para_string: para_string, level: 1,  order: @current_order[1], markup: "ordered_section_item2", is_last_item: true)
            else
              OrderedListItem.new(parent: self, para_string: para_string, level: 1,  order: @current_order[1], markup: "ordered_section_item2")
            end
          end
        end
      end
    end    
  end
  
  class UpperAlphaList < Container
    attr_accessor :current_order, :ordering_char_types, :text_block

    def initialize(options={})
      super
      @ordering_char_types  = options.fetch(:ordering_char_types, %w[A 1 a])
      @text_block           = options[:text_block]
      parse_list_items
      self
    end
    
    def parse_list_items
      #TODO this fails if items depth goes beyond 2
      @current_order  = [0,0]
      if @text_block.class == Array
        @list_text = @text_block
      elsif @text_block.class == String
        @list_text = @text_block.split("\n")
      end
      @list_text.each do |list|
        case list
        when /^[A-Z]\s/
          # ordering_char = (@ordering_char_types[0].ord + @current_order[0]).chr
          # para_string = list.sub(/^\./ , ordering_char)
          para_string = list
          OrderedListItem.new(parent: self, para_string: para_string, level: 0, order: @current_order[0], markup: "upper_alpha_list")
        when /^\d\s/
          # ordering_char = (@ordering_char_types[1].ord + @current_order[1]).chr
          # ordering_char = "\t" + ordering_char + ". "
          # para_string = list.sub(/^\.\.\s/ , ordering_char)
          para_string = list
          OrderedListItem.new(parent: self, para_string: para_string, level: 1,  order: @current_order[1], markup: "upper_alpha_list_item")
        end
      end
    end
  end
  
  class UnorderedList < Container    
    attr_accessor :current_order, :ordering_char_types, :text_block
    
    def initialize(options={})
      super
      @ordering_char_types  = options.fetch(:ordering_char_types, %w[* + -])
      @text_block           = options[:text_block]
      parse_list_items
      self
    end
    
    def parse_list_items
      @current_order  = [0,0,0]
      if @text_block.class == Array
        @list_text = @text_block
      elsif @text_block.class == String
        @list_text = @text_block.split("\n")
      end
      @list_text.each do |list|
        case list
        when /^\*\s/
          ordering_char = @ordering_char_types[0]
          para_string = list.sub(/^\*/ , ordering_char)
          UnorderedListItem.new(parent: self, para_string: para_string, level: 0, order: @current_order[0], markup: "unordered_list_item")
          @current_order[0] += 1
          @current_order[1] = 0
          @current_order[2] = 0
        when /^\*\*\s/
          ordering_char = @ordering_char_types[1]
          ordering_char = "\t" + ordering_char
          para_string = list.sub(/^\*\*/ , ordering_char)
          UnorderedListItem.new(parent: self, para_string: para_string, level: 1,  order: @current_order[1], markup: "unordered_list_item")
          @current_order[1] += 1
          @current_order[2] = 0
        when /^\*\*\*\s/
          ordering_char = @ordering_char_types[2]
          ordering_char = "\t\t" + ordering_char
          para_string = list.sub(/^\*\*\*/ , ordering_char)
          UnorderedListItem.new(parent: self, para_string: para_string, level: 2,  order: @current_order[2], markup: "unordered_list_item")
          @current_order[2] += 1
        end
      end
    end    
  end
  
  class UnorderedListItem < Paragraph
    attr_accessor :order, :level, :indent
    attr_accessor :list_style
    
    def initialize(options={})
      super
      @list_style         = filter_list_options(@para_style)
      @indent             = options.fetch(:indent, 15)
      @order              = options[:order]
      @level              = options[:level]
      @h_alignment        = "left"
      @first_line_indent  = @level*@indent
      @head_indent        = @first_line_indent + @indent
      self
    end
    
  end
  
end