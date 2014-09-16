
# 
# ObjectBox
# ColumnObject
# Paragraph
# Line
# TextRun
# Token
# TextToken
# MathToken

module RLayout
  
  class Paragraph < Container
    attr_accessor :breakable, :part # head, body, tail
    attr_accessor :markup, :para_string, :tokens, :line_height
    attr_accessor :font_object
    def initialize(parent_graphic, options={})
      super
      @klass = "Paragraph"
      @layout_expand = []
      @para_string  = options.fetch(:para_string,"")
      @markup       = options.fetch(:markup,'p')
      @text_font    = options.fetch(:text_font,'Times')
      @text_size    = options.fetch(:text_size,16)
      @text_color   = options.fetch(:text_color, 'black')
      @layout_space = options.fetch(:layout_space, 10)
      @left_inset  = 4
      @right_inset = 4
      @top_margin   = 3
      @line_color = 'red'
      @line_width = 1
      @font_object = Font.new(@text_font, @text_size)
      create_tokens      
      self
    end
    
    def create_tokens
      @tokens = @para_string.split(" ").collect do |token_string|
        size  = @font_object.width_with_font(token_string)
        width    = 
        @line_height   = @text_size

        TextToken.new(nil, :text_string=>token_string, :width=>size[0], :height=>size[1] + 2, :layout_expand=>[]) #, :line_width=>1, :line_color=>'green'
      end
    end
    
    # create a line 
    def add_line
      t =TextLine.new(self, :x=>@left_inset, :width=>(@width - @left_inset - @right_inset) , :height=>@line_height, :layout_space=>@text_size/4, :layout_expand=>[:width], :line_width=>1, :line_color=>'yellow' )
      puts "+++++++++++ t.x:#{t.x}"
      puts t.width
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
      add_line 
      current_line = @graphics.last
      while front_most_token = @tokens.shift do
        if current_line.insert_token(front_most_token)
          # item fit into column successfully!
        else
          add_line 
          current_line = @graphics.last
          current_line.insert_token(front_most_token)
        end
      end
      # now change the height of paragraph
      @sum = 0
      puts "@graphics.length:#{@graphics.length}"
      puts "@layout_space:#{@layout_space}"
      @graphics.each do |g| 
        puts "g.x:#{g.x}"
        puts "g.y:#{g.y}"
        puts "g.height:#{g.height}"
        @sum += g.height + @layout_space
      end
      @height = @sum
      relayout!
      # binding.pry
    end

    def change_width(new_width)
      @width = new_width
      layout_lines
      # TODO
      # change height we need to
    end

    def self.generate(number)
      list = []
      text = "One two  three four five six seven eight nine ten eleven twelve thirteen."
      number.times do
        list << Paragraph.new(nil, :para_string=>text)
      end
      list
    end
  end
  
  class TextLine < Container
    attr_accessor 
    
    def initialize(parent_graphic, options={})
      super
      puts "+++++ @width:#{width}"
      # @line_color = "gray"
      # @line_width = 1
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
      if (graphics_width_sum + token.width) < @width
        # insert the token into the line
        token.parent_graphic = self
        @graphics << token
        
        #TODO
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
  
  
  class TextToken < Graphic 
        
    # keep attributes that are diffrent from paragraph only
    attr_accessor :hide, :hypenated_head, :hypenated_middle, :hypenated_tail
    def initialize(parent_graphic, options={}, &block)
      super
      @layout_expand = []
      @text_string  = options[:text_string]      
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