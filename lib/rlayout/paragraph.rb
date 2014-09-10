
module RLayout
  
  class Paragraph < Container
    attr_accessor :breakable, :part # head, body, tail
    attr_accessor :markup, :text_string, :tokens
    def initialize(parent_graphic, options={})
      super
      @layout_expand = []
      @text_string  = options.fetch(:text_string,"")
      @markup       = options.fetch(:markup,'p')
      @text_font    = options.fetch(:text_font,'Times')
      @text_size    = options.fetch(:text_size,16)
      @text_color   = options.fetch(:text_color, 'black')
      create_tokens      
      self
    end
    
    def create_tokens
      @tokens = @text_string.split(" ").collect do |token_string|
        width    = token_string.length*@text_size/2
        height   = @text_size
        if RUBY_ENGINE == "macruby"
          atts = {}
          atts[NSFontAttributeName] = NSFont.fontWithName(@text_font, size:@text_size)
          att_string=NSMutableAttributedString.alloc.initWithString(token_string, attributes:atts)
          width    = att_string.size.width
          height   = att_string.size.height
        end
        Text.new(nil, :text_string=>token_string, :width=>width, :height=>height, :layout_expand=>[])
      end
    end
    
    # create a line 
    def add_line
      TextLine.new(self, :width=>@width, :height=>@text_size, :layout_space=>@text_size/4, :layout_expand=>[])
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
          puts "current_line.graphics.length:#{current_line.graphics.length}"
          puts "current_line.graphics.last.text_string:#{current_line.graphics.last.text_string}"
          add_line 
          current_line = @graphics.last
          current_line.insert_token(front_most_token)
        end
      end
      # now change the height of paragraph
      @sum = 0
      @graphics.each {|g| @sum += g.height + 5}
      @height = @sum
      relayout!
    end

    def change_width(new_width)
      @width = new_width
      layout_lines
      # TODO
      # change height we need to
    end
        
    def to_svg
      if @parent_graphic
        return svg
      else
        svg_string = "<svg xmlns=\"http://www.w3.org/2000/svg\" xmlns:xlink=\"http://www.w3.org/1999/xlink\">\n"
        svg_string += svg
        svg_string += "</svg>\n"
        return svg_string
      end
    end
    
    def svg
        s = "<rect x=\"#{@x}\" y=\"#{@y}\" width=\"#{@width}\" height=\"#{@height}\""
        if @fill_color!=nil && @fill_color != ""
          s+= " fill=\"#{@fill_color}\""
        end
        if @line_width!=nil && @line_width > 0
          s+= " stroke=\"#{@line_color}\""
          s+= " stroke-width=\"#{@line_width}\""
        end
        s+= "></rect>\n"
        
        if @text_string !=nil && @text_string != ""
          s += "<text font-size=\"#{@text_size}\" x=\"#{@x}\" y=\"#{@y}\" fill=\"#{@text_color}\">#{@text_string}</text>\n"
        end
        s
    end
    
    def self.generate(number)
      list = []
      text = "This is some string and I like it. "*2
      number.times do
        list << Paragraph.new(nil, :text_string=>text)
      end
      list
    end
  end
  
  class TextLine < Container
    attr_accessor 
    
    def initialize(parent_graphic, options={})
      super
      @layout_direction = "horizontal"
      @layout_expand = []
      self
    end
        
    
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
  # 
  # class TextToken < Graphic
  #       
  #   # keep attributes that are diffrent from paragraph only
  #   attr_accessor :font, :size, :rich_style, :horizontal
  #   attr_accessor :hide, :hypenated_head, :hypenated_middle, :hypenated_tail
  #   attr_accessor :token_width, :markup
  #   def initialize(parent_graphic, options={}, &block)
  #     super
  #     @layout_expand = []
  #     @paragraph    = options[:paragraph]
  #     @text_string  = options[:text_string]
  #     @markup       = options.fetch(:markup,'p')
  #     @text_font    = options.fetch(:text_font,'Times')
  #     @text_size    = options.fetch(:text_size,16)
  #     calculate_token_size
  #     
  #     self
  #   end
  #   
  #   def layout_length
  #     @width
  #   end
  #   
  #   
  #   
  #   def attr_string
  #     if RURY_ENGINE == "macruby"
  #       # TODO
  #     end
  #   end
  #   
  #   #TODO
  #   def hyphenate
  #     
  #   end
  #   
  #   
  # end
  # 
end