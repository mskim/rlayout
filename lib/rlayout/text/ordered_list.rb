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
  
  
  class OrderedList < Paragraph
    attr_accessor :current_order, :ordering_char_types, :text_block
    attr_accessor :list_style
    # we have @list_style from Paragraph
    
    def initialize(options={})
      super
      @list_style = filter_list_options(@para_style)
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
    # we have @list_style from Paragraph
    def initialize(options={})
      super
      @list_style = filter_list_options(@para_style)
      #TODO make @indent relative to font size
      @indent             = options.fetch(:indent, 15)
      @order              = options[:order]
      @level              = options[:level]
      @h_alignment        = "left"
      @first_line_indent  = @level*@indent
      @head_indent        = @first_line_indent + @indent
      self
    end
    # I should read it from StyleService      
  end
  
  
  class OrderedSection < Paragraph
    attr_accessor :current_order, :ordering_char_types, :text_block
    attr_accessor :list_style
    
    def initialize(options={})
      super   
      # token is not created yet since the text is passed as text_block, not para_string.
      # OrderedSection acts as umbrella Paragraph, so not text layout takes place
      @list_style = filter_list_options(@para_style)
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
            OrderedListItem.new(parent: self, para_string: para_string, level: 1,  order: @current_order[1], markup: "ordered_section_item2")
          end
        end
      end
    end    
  end
  
  class UpperAlphaList < Paragraph
    attr_accessor :current_order, :ordering_char_types, :text_block
    attr_accessor :list_style 

    def initialize(options={})
      super
      @list_style = filter_list_options(@para_style)
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
  
  class UnorderedList < Paragraph    
    attr_accessor :current_order, :ordering_char_types, :text_block
    attr_accessor :list_style 
    
    def initialize(options={})
      super
      @list_style = filter_list_options(@para_style)
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