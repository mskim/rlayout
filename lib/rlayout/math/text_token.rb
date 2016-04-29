
# How text is layed out?
# 1. Tokens are created
# 2. For simple container
#    Tokens are divided into lines, by separating it with width of text_container
#    We can have simple container or complex one.
#     Tokens are uniform Height?
#       align them
#     different height
#       ask for proosed rect to RLineFragment
#
# 3. For complex container

# TextToken
# TextToken consists of text string with uniform attributes, a same text run.
# TextToken does not contain space character. Space charcter is implemented as gap between tokens.
# RLineFragments is made up of TextTokens, ImageToken, MathToken etc....
# When paragraph is created, TextTokenAtts is created for default att value for all TextTokena and they all point ot it.
# Whenever there is differnce TextTokenAtts in the paragraph, new TextTokenAtts is created and different TextToken ponts to that one.

module RLayout
    
  class TextToken
    attr_accessor :att_string, :x,:y, :width, :height, :tracking, :scale
    def initialize(string, atts, options={})
      @att_string = NSAttributedString.alloc.initWithString(string, attributes: atts)
      @x      = 0
      @y      = 0
      self
    end
    
    def size
      @att_string.size
    end
    
    def origin
      NSMakePoint(@x,@y)
    end
            
    def svg
      # TODO <text font-size=\"#{text_size}\"
      s = ""
      if string !=nil && string != ""
        s += "<text font-size=\"#{@text_size}\" x=\"#{x}\" y=\"#{y + height*0.8}\">#{string}</text>\n"
      end
      s
    end
    
    def draw
      @att_string.drawAtPoint(origin)
    end
    
  end

  class ImageToken 
    attr_accessor :image_path, :x,:y, :width, :height, :image_path
    
    def initialize(image_path, options={})
      @image_path = image_path
      self   
    end 
  end

  
  class	RLineFragment < Container
    attr_accessor :text_layout_manager, :tokens
    attr_accessor :line_tokens
    attr_accessor :left_indent, :right_indent
    attr_accessor :x, :y, :width, :height, :total_token_width
  	def	initialize(text_layout_manager, tokens, options={})
  	  @text_layout_manager = text_layout_manager
  	  @text_container = @text_layout_manager.text_container
      # @tokens           = @text_layout_manager.tokens
  	  @tokens           = tokens
  	  @space_width      = @text_layout_manager.token_space_width
  	  @width            = options[:width]
  	  @left_indent      = options.fetch(:left_indernt, 0)
  	  @right_indent     = options.fetch(:right_indent, 0)
  	  layout_tokens
  		self
  	end

    def layout_tokens

      align_tokens
    end
    
	  def align_tokens
      @total_token_width -= @space_width if @line_tokens.length > 0
      room = @width - @total_token_width      
      case @text_layout_manager.para_style.h_alignment
      when 'left'
      when 'center'
        @line_tokens.map {|t| t.x += room/2.0}
      when 'right'
        @line_tokens.map do |t| 
          t.x += room
        end
      when 'justified'
        just_space = room/(@line_tokens.length - 1)
        x = 0
        @line_tokens.each_with_index do |token, i|
          token[:x] = x
          x += token[:width] + just_space
        end
      else
        
      end

	  end

    # def tallest_token
    #  
    # end
	  
    def room
	    @width - @left_indent - @right_indent
    end
    
    def draw_line
      
    end
  end

  
  # RichText Layout Mangager
  # This is custom TextLayoutManager similar to NSTextLayoutManager
  # It has single textContainer, 
  # it is doing the line layout.

  # Ii is called from Text Object when options rich_text: true  
  # I am using it when when doing Math equations and other special effects.
  
  class RTextLayoutManager
    attr_accessor :owner_graphic, :text_container, :lines, :tokens
    attr_accessor :text_string, :para_style, :font_object, :token_space_width
    def initialize(owner_graphic, options={})
      @owner_graphic  = owner_graphic
      @text_container = RTextContainer.new(self, options)
      @tokens         = []
      @lines          = []
      @text_string    = options.fetch(:text_string, "")
      @para_style     = default_para_style
      @para_style     = options[:para_style] if options[:para_style]
      create_tokens
      if @simple_container
        layout_simple_container
      else
        layout_complex_container
      end
      self
    end    
        
    def create_tokens
      @atts = {}
      @atts[NSFontAttributeName]  = NSFont.fontWithName(@para_style[:font], size:@para_style[:size])
      @token_space_width  = NSAttributedString.alloc.initWithString(" ", attributes: @atts).size.width
      @tokens = @text_string.split(" ").collect do |token_string|
        puts "token_string:#{token_string}"
        #TODO special tokens created with functions
        if token_string =~/^_(.*)+_|^\*(.*)+\*/
          #TODO
        else
          TextToken.new(token_string, @para_style)
        end
      end
    end
    
    def line_count
      @text_container.lines.length
    end
    
    
    def layout_simple_container
      @total_token_width = 0
      @line_tokens = []
      x = @total_token_width
      while token = @tokens.shift
        if  (@total_token_width + token.width) < @width
          @total_token_width += token.width
          token[:x] = x
          @line_tokens << token
          x += @total_token_width + @space_width
        else
          @tokens.unshift(token)
          @line_tokens = []
          @lines << RLineFragment.new(self, @line_tokens , width: @width)
        end
      end
      # handle the left over last line
      if @line_tokens.length > 0
        @lines << RLineFragment.new(self, @line_tokens , width: @width)
      end
    end
	      
	  def layout_complex_container
	   
	  end
	  
    def draw_text
      puts "in draw_text of  RTextLayoutManager"
      puts "line_count:#{line_count}"
      @lines.each do |line|
        lines.draw_line
      end
    end
    
    def default_para_style
      default = {}
      default[:font] = "Times"
      default[:size] = 10
      default[:color] = "black"
      default[:style] = "plain"
      default[:h_alignment] = "left"
      default[:v_alignment] = "center"
      default
    end

  end
  
  class RTextContainer
    attr_accessor :text_layout_manager, :simple_rect, :snap_to_grid
    attr_accessor :lines
    attr_accessor :width, :height, :inset
    def initialize(text_layout_manager, options={})
      @text_layout_manager = text_layout_manager
      @simple_rect  = true
      @snap_to_grid = true
      if @text_layout_manager.owner_graphic
        @width          = @text_layout_manager.owner_graphic.width
        @height         = @text_layout_manager.owner_graphic.height
      else
        @width          = options.fetch(:width, 300)
        @height         = options.fetch(:height, 500)
        @inset          = options.fetch(:inset, 3)
      end
      @lines            = []
      @tokens           = @text_layout_manager.tokens
      self
    end
    
    def size
      [@width, @height]
    end
    
    def set_container_size(size)
      @width = size[0]
      @heigh = size[1]
    end
    
    # def lineFragmentRectForProposedRect(sweepDirection, movementDirection, remainingRect)
    #   
    # end
    def line_fragment_rect_for_proposed_rect(proposed_rect, options={})
      
    end
    
    def is_simple_rect?
      @simple_rect
    end
    
  end

end

SMAMPLE_PARA =<<EOF

\drop(T)his \color("black","is black") colored text in the middle of para.
\bold(This is :) bold text at the \italic(begining) of line.
\cmyk([30,30,0,0], colored) text $\frac({x+2}{y\sup2 + xy})$

EOF
