
# ObjectBox
# ColumnObject
# Paragraph
# Line
# TextToken

module RLayout
  
  class Paragraph < Container
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
        t= TextToken.new(nil, :text_string=>token_string, :width=>size[0], :height=>@line_height, :layout_expand=>[], :text_font=>@text_font, :text_size=>@text_size) #, :line_width=>1, :line_color=>'green'
        t
      end
    end
    
    # create a line 
    def add_line
      puts __method__
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
        puts "line.class:#{line.class}"
        line.y = line_y
        puts "++++++++++ line.y:#{line.y}"
        line_height = line.height
        @sum += line_height + @layout_space
        line_y += line_height + @layout_space
      end
      @height = @sum
      puts "@layout_space:#{@layout_space}"
      puts "@height:#{@height}"
    end

    def change_width_and_adjust_height(new_width)
      @width = new_width
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
      puts "in TextLine init"
      puts "@y:#{@y}"
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