module RLayout
  
  
  # OrderedList is created with given block of ordered list item text block
  # TODO
  # Indenting, tab, first_line_indent, head_indent
  # set head_indent = num + space
  # next level_1_indent = first_line head_indent
  # next level_2_indent = level_1_indent
  
  # ordering_char_types=  %w[1 a A] #[number, lower_alphabet, upper_alphabet]
  # optional array can be passed with custom  
  class OrderedList < Container
    attr_accessor :current_order, :ordering_char_types, :text_block
    def initialize(options={})
      super
      @ordering_char_types  = options.fetch(:ordering_char_types, %w[1 a A])
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
    def initialize(options={})
      super
      #TODO make @indent relative to font size
      @indent             = options.fetch(:indent, 15)
      @order              = options[:order]
      @level              = options[:level]
      @h_alignment        = "left"
      @first_line_indent  = @level*@indent
      @head_indent        = @first_line_indent + @indent
      self
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
          UnorderedListItem.new(parent: self, para_string: para_string, level: 0, order: @current_order[0])
          @current_order[0] += 1
          @current_order[1] = 0
          @current_order[2] = 0
        when /^\*\*\s/
          ordering_char = @ordering_char_types[1]
          ordering_char = "\t" + ordering_char
          para_string = list.sub(/^\*\*/ , ordering_char)
          UnorderedListItem.new(parent: self, para_string: para_string, level: 1,  order: @current_order[1])
          @current_order[1] += 1
          @current_order[2] = 0
        when /^\*\*\*\s/
          ordering_char = @ordering_char_types[2]
          ordering_char = "\t\t" + ordering_char
          para_string = list.sub(/^\*\*\*/ , ordering_char)
          UnorderedListItem.new(parent: self, para_string: para_string, level: 2,  order: @current_order[2])
          @current_order[2] += 1
        end
      end
    end    
  end
  
  class UnorderedListItem < Paragraph
    attr_accessor :order, :level, :indent
    def initialize(options={})
      super
      @order = options[:order]
      @level = options[:level]
      @head_indent = @level*20
      self
    end
    
  end
  
end