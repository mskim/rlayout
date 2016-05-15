
# How text is layed out?
# 1. Tokens are created
# 2. For simple container
#    Tokens are divided into lines, by separating it with width of text_column
#    We can have simple container or complex one.
#     Tokens are uniform Height?
#       align them
#     different height
#       ask text_column for proosed rect for LineFragment
#
# 3. For complex container

# TextToken
# TextToken consists of text string with uniform attributes, a same text run.
# TextToken does not contain space character. Space charcter is implemented as gap between tokens.
# LineFragments is made up of TextTokens, ImageToken, MathToken etc....
# When paragraph is created, TextTokenAtts is created for default att value for all TextTokena and they all point ot it.
# Whenever there is differnce TextTokenAtts in the paragraph, new TextTokenAtts is created and different TextToken ponts to that one.

module RLayout
    
  class TextToken
    attr_accessor :att_string, :x,:y, :width, :height, :tracking, :scale
    attr_accessor :string
    def initialize(string, options={})
      if RUBY_ENGINE == "rubymotion"
        @att_string = NSAttributedString.alloc.initWithString(string, attributes: options[:atts])
      end
      @string = string
      @x      = 0
      @y      = 0
      @width  = 30
      @height = 20
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

  
  class	LineFragment < Container
    attr_accessor :tokens, :line_type #first_line, drop_cap, drop_cap_side
    attr_accessor :left_indent, :right_indent
    attr_accessor :x, :y, :width, :height, :total_token_width
  	def	initialize(options={})
  	  super
      # @tokens           = @text_layout_manager.tokens
  	  @tokens           = options[:tokens]
  	  @space_width      = options.fetch(:space_width, 5)
  	  @width            = options.fetch(:width, 300)
  	  @left_indent      = options.fetch(:width, 10)
  	  @right_indent     = options.fetch(:right_indent, 0)
  		align_tokens
  		self
  	end
    
    def token_width_sum
      @tokens.map{|t| t.width}.reduce(0, :+)
    end
    
	  def align_tokens
	    @total_token_width = token_width_sum
      @total_token_width -= @space_width if @tokens.length > 0
      room = @width - @total_token_width      
      case @parent_graphic.para_style[:h_alignment]
      when 'left'
      when 'center'
        @tokens.map {|t| t.x += room/2.0}
      when 'right'
        @tokens.map do |t| 
          t.x += room
        end
      when 'justified'
        just_space = room/(@tokens.length - 1)
        x = 0
        @tokens.each_with_index do |token, i|
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

  
  # ParagraphNew
  # This is the new paragraph
  # This is for long document and Math equations and other special effects.
  
  class ParagraphNew < Container
    attr_accessor :paragraph_type
    attr_accessor :lines, :tokens, :token_heights_are_eqaul
    attr_accessor :para_string, :para_style, :font_object, :space_width
    attr_accessor :starting_grid_index, :grid_count, :space_before_in_grid, :space_after_in_grid
    attr_accessor :text_column
    
    def initialize(options={})
      super
      @paragraph_type = 'simple' #drop_cap, drop_cap_image, math, with_image, with_math
      @tokens         = []
      @lines          = []
      @starting_grid_index = 0
      @grid_count     = 2
      @space_before_in_grid = 0
      @space_after_in_grid = 0
      @para_string    = options.fetch(:para_string, "")
      @para_style     = default_para_style
      @para_style     = options[:para_style] if options[:para_style]
      @space_width    = 3
      create_tokens
      self
    end    
        
    def create_tokens
      @atts = {}
      if RUBY_ENGINE == 'rubymotion'
        @atts[NSFontAttributeName]  = NSFont.fontWithName(@para_style[:font], size:@para_style[:size])
        @space_width  = NSAttributedString.alloc.initWithString(" ", attributes: @atts).size.width
      end
      @tokens = @para_string.split(" ").collect do |token_string|
        #TODO special tokens created with functions
        if token_string =~/^_(.*)+_|^\*(.*)+\*/
          #TODO
        else
          RLayout::TextToken.new(token_string, @para_style)
        end
      end
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
        
    def line_count
      @lines.length
    end
    
    def layout_paragraph(text_column)
      @text_column = text_column
      if text_column.is_simple_column?
        layout_simple_container
      else
        layout_complex_container
      end
    end
    
    # algorithm for laying out paragraph in simple container
	  # 1. start with rect with width of column and height of para_style
	  # 2. keep filling up the line_tokens until the width total exceed the width of column
	  # 3. Each time with new token, check the height change, tallest_token and adjust line height.
    # 4. Once we run out of the line space,
	  # 5. create LineFragment with with and height
	  # 6. clear the line_tokens buffer and set new positions
    def layout_simple_container
      @column_width     = @text_column.width
      @body_line_height = @text_column.body_line_height
      @current_y        = 0
      @total_token_width= 0
      @line_tokens = []
      while @tokens.length > 0
        token = @tokens.first 
        if  (@total_token_width + @space_width + token.width) < @column_width
          @total_token_width += (@space_width + token.width)
          token = @tokens.shift
          @line_tokens << token
        else
          options = {parent: self, tokens: @line_tokens, y: @current_y , width: @column_width, height: @body_line_height}
          line = LineFragment.new(options)
          @lines << line
          @current_y += line.height
          @line_tokens = []
          @total_token_width = 0
        end
      end
      # left over tokens for last line.
      if @line_tokens.length > 0
        options = {parent: self, tokens: @line_tokens, y: @current_y , width: @column_width, height: @body_line_height}
        line = LineFragment.new(options)
        @lines << line
        @current_y += line.height
      end
      # set_new_column_y_position and current_grid_index
      @text_column.advance_y_position(@current_y)
      puts "after @text_column.current_grid_index:#{@text_column.current_grid_index}"
      # set y LineFragment y posiions
    end
	  
	  # algorithm for laying out paragraph in complex container
	  # 1. start with line rect with width of column and height of para_style
	  # 2. keep filling up the line_tokens until the width total exceed the sugested width
	  # 3. Each time with new token, check the height change, tallest_token and adjust proposing line height.
    # 4. call "text_column.sugest_me_a_rect_at" to get line rect
    # 5. Once we run out of the line space, create LineFragment with sugessted with and height
	  # 6. clear the line_tokens buffer and set new positions and do it for onthoer line.
	  def layout_complex_container
      @column_width       = @text_column.width
      @current_grid_index = @text_column.current_grid_index
      #TODO this should be determined from parastyle
      @body_line_height = @text_column.body_line_height
      @current_y        = 0 # local y position, not text_column y position
      @total_token_width= 0
      @line_tokens = []
      while @tokens.length > 0
        token = @tokens.first 
        #TODO ingnore token height unless token heihgt is taller that line height
        tallest_token_height = token.height
        sugested_rect = @text_column.sugest_me_a_rect_at(@current_grid_index, tallest_token_height)
        if  (@total_token_width + @space_width + token.width) < sugested_rect.width
          token = @tokens.shift
          @line_tokens << token
          @total_token_width += (@space_width + token.width )
          tallest_token_height = token.height if token.height > tallest_token_height
          sugested_rect = @text_column.sugest_me_a_rect_at(@current_y, @total_token_width, tallest_token_height)
        else
          options = {parent: self, tokens: @line_tokens, x: sugested_rect[0], y: sugested_rect[1] , width: sugested_rect[2], height: sugested_rect[3]}
          line = LineFragment.new(options)
          @lines << line
          @current_y = max_y(line)
          @line_tokens = []
          @total_token_width = 0
        end
      end
      # left over tokens for last line.
      if @line_tokens.length > 0
        options = {parent: self, tokens: @line_tokens, x: sugested_rect[0], y: sugested_rect[1] , width: sugested_rect[2], height: sugested_rect[3]}
        # options = {parent: self, tokens: @line_tokens, y: @current_y , width: @column_width, height: @body_line_height}
        line = LineFragment.new(options)
        @lines << line
        @current_y = max_y(line)
      end
      # set_new_column_y_position and current_grid_index
      @text_column.advance_y_position(@current_y)
      puts "after @text_column.current_grid_index:#{@text_column.current_grid_index}"      
	  end
	  
    def draw_text
      puts "in draw_text of  ParagraphNew"
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
