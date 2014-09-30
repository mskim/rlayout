
# ObjectBox
# ColumnObject
# TextColumn
# Paragraph
# Line
# TextToken

# Paragraph
#  Paragraph
#  Paragraph is desinged to automate complex, design rich paragraph, layout. 
#  It has been difficult to automate design rich publiscations, 
#  which contain various boxed paragraphs, graphics based numbering, graphics based paragraph identifiers, specially designed dropcap. 
#  They are usually implemented using multiple graphics. 
#  But, that process makes it difficult to automate and keep in sync as a resuable data once thay are created.
#  Solution is to use Paragraph.
#  Paragraph uses pre-defined templates and treat them as varibale graphics.
#  Paragraph content is stored in each paragraph separate from grphiphcs, and only this part is edited and synced to representing graphics. 
#  Paragraphs are also made to flow along columns.
#  Paragraph is layed out in object_column, which belongs to object_box.
#  For case where paragraph has to be split into different columns, child text can be created to hanle overflowing text.
#  This enable us to automate design rich publication.

# Number one requsted feature for text implemetation was auto line alignment to grid line.
# Paragraph aligns lines with TextColumn line grid, making lines of adjacent column's lines align vertically.
# When head paragraph, which might have difference height than the body paragraph, is placed in the middle of the column
# causing vertical misalignment, follinging body paragraph should snap back to next grid.

# heading paragrph
# heading paragrph lines should be vertically centers within head's paragraph box. 
# change_width_and_adjust_height for heading paragrph should set height as multiples of grid_line_height

# Paragraph is initialize with para_string, it creates series of TextTokens with default size and font.
# When it is inserted into column, it generates lines(TextLine).

module RLayout
  
  class RichParagraph < Container
    attr_accessor :breakable, :part # head, body, tail
    attr_accessor :markup, :para_string, :tokens, :line_height
    def initialize(parent_graphic, options={})
      super
      @klass = "Paragraph"
      @layout_expand = []
      @para_string  = options.fetch(:para_string,"")
      @markup       = options.fetch(:markup,'p')
      @text_font    = options.fetch(:text_font,'Times')
      @text_size    = options.fetch(:text_size, 12)
      @text_color   = options.fetch(:text_color, 'black')
      @layout_space = options.fetch(:layout_space, 0)
      @left_inset   = 1
      @right_inset  = 1
      @top_margin   = 1
      @line_color   = 'red'
      @line_width   = 1
      @layout_space = 0 #  #@font_object.space_width
      create_tokens      
      self
    end
    
    def create_tokens
      font_object  = RFont.new(@text_font, @text_size)
      @token_space  = font_object.space_char_width
      @tokens = @para_string.split(" ").collect do |token_string|
        size  = font_object.string_size(token_string)
        @line_height   = @text_size*1.2 + @top_margin + @bottom_margin
        TextToken.new(nil, :text_string=>token_string, :width=>size[0], :height=>@line_height, :layout_expand=>[], :text_font=>@text_font, :text_size=>@text_size) #, :line_width=>1, :line_color=>'green'
      end
    end
    
    # create a line 
    def add_line
      t= TextLine.new(self, :x=>@left_inset, :y=>@line_y, :width=>(@width - @left_inset - @right_inset) , :height=>@line_height, :layout_space=>@token_space, :layout_expand=>[:width], :line_width=>1, :line_color=>'black' )
      @line_y += t.height
      t
    end
    
    # This is very similar to layout_items for ObjectBox
    # The difference is we are adding tokens to lines instead of adding flowing items to columns
    # TextLines get added as we need them, where as colums are not add for ObjectBox layout
    # TextLines size are change with token size,  where as colum size is fixed and flowing item size are chamged.

    def layout_lines 
      # create line as we layout tokens
      # clear lines
      @graphics = []
      @line_y = 0 #TODO @top_inset
      add_line 
      current_line = @graphics.last
      while front_most_token = @tokens.shift do
        if current_line.insert_token(front_most_token)
          # item fit into column successfully!
        else
          current_line.relayout!
          add_line 
          current_line = @graphics.last
          current_line.insert_token(front_most_token)
        end
      end
      # binding.pry
      
      # relayout!

      # now change the height of paragraph
      @sum = 0
      line_y = 0
      @graphics.each do |line| 
        line.y = line_y
        line_height = line.height
        @sum += line_height + @layout_space
        line_y += line_height + @layout_space
      end
      @height = @sum
    end
    
    def layout_para_at(column)
      
    end
    
    def change_width_and_adjust_height(new_width, options={})
      # for heading paragrph, should set height as multiples of grid_line_height
      
      @width = new_width
      if options[:line_grid_height] 
        #TODO
        
        # if @line_height != options[:line_grid_height]
        # @line_height = options[:line_grid_height]
        # update token size
      end
      layout_lines
    end

    def self.generate(number)
      list = []
      text = "M One two  three four five six seven eight nine ten eleven twelve thirteen."
      number.times do
        list << Paragraph.new(nil, :para_string=>text, :markup=>"p")
      end
      list
    end
  end
  
  class TextLine < Container
    attr_accessor 
    
    def initialize(parent_graphic, options={})
      super
      @klass = "TextLine"
      @top_margin = 2
      @top_inset  = 2
      @layout_direction = "horizontal"
      @layout_expand = []
      self
    end
    
    # def graphics_width_sum
    #   return 0 if @graphics.length == 0
    #   @sum = 0
    #   @graphics.each {|g| @sum+= g.width + @layout_space}
    #   return @sum 
    # end
    
    
    def insert_token(token)      
      if (graphics_width_sum + token.width + @layout_space) < (@width - @left_margin - @right_margin)
        # insert the token into the line
        token.parent_graphic = self
        @graphics << token
        
        #TODO
        # change line height if taller token is inserted
        # Chack the size of the token, if this new one has bigger size than the height,
        # change the height of the line.
        # if token.height > @height
        #   @height = token.height
        # end
        return true
      else
        # can not fit, reject it
        return false
      end
    end
  end
  
  class TextRun < Graphic
    attr_accessor :attrs, :space
      attr_accessor :font, :size, :rich_style, :horizontal
      attr_accessor :hide, :hypenated_head, :hypenated_middle, :hypenated_tail
    
    def initialize(parent_graphic, options={})
      super
      @attrs = options[:atts]
      
      
      self
    end
    
  end
  
  # Toke is very basic element of layout
  # in Text case it is word
  # Token can also be math element or image
  
  
  class TextToken < Text 
        
    # keep attributes that are diffrent from paragraph only
    attr_accessor :hide, :hypenated_head, :hypenated_middle, :hypenated_tail
    def initialize(parent_graphic, options={}, &block)
      super      
      @klass = "TextToken"
      @layout_expand = []
      # @text_string  = options[:text_string]      
      self
    end
    
    def layout_length
      @width
    end
        
    #TODO
    def hyphenate
      
    end    
  end
  
end