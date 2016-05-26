
# We have Text, and Paragraph.
# Text is for simple text, usually for single page document or Ads.
# Paragraph is for text that is used in middle to long document.
# Paragraph has grid_height value, which is multiple of body text grid_height.
# We want to align them accross the columns.

# How Paragraoh is layed out?
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
    
  class TextToken < Graphic
    attr_accessor :att_string, :x,:y, :width, :height, :tracking, :scale
    attr_accessor :string, :atts
    def initialize(options={})
      options[:layout_expand]  = nil
      if RUBY_ENGINE == "rubymotion"
        @atts           = default_atts
        @atts           = @atts.merge(options[:atts]) if options[:atts]
        @att_string     = NSAttributedString.alloc.initWithString(options[:text_string], attributes: options[:atts])
        options[:width] = @att_string.size.width
      else
        @width  = 30
      end
      super
      @string = options[:text_string]
      @x      = 0
      @y      = 0
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
    
    def default_atts
      {
        NSFontAttributeName => NSFont.fontWithName("Times", size:10.0),
      }
    end
    
    def draw
      @att_string.drawAtPoint(NSMakePoint(0,0))
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
    attr_accessor :line_type #first_line, drop_cap, drop_cap_side
    attr_accessor :left_indent, :right_indent, :para_style
    attr_accessor :x, :y, :width, :height, :total_token_width
  	def	initialize(options={})
      # options[:stroke_color]     = 'red'
      options[:layout_direction] = 'horizontal'
  	  super
      # @tokens         = @text_layout_manager.tokens
  	  @graphics         = options[:tokens]
  	  @space_width      = options.fetch(:space_width, 5.0)
  	  @stroke_width     = 1
  	  @width            = options.fetch(:width, 300)
      # @left_indent      = options.fetch(:width, 10)
      # @right_indent     = options.fetch(:right_indent, 0)
  	  @para_style       = options[:para_style]
  	  @graphics.each do |token|
        token.parent_graphic = self
      end   
  		align_tokens
  		self
  	end
    
    def token_width_sum
      @graphics.map{|t| t.width}.reduce(0, :+)
    end
    
    def rect
      [@x, @y, @width, @height]
    end
    
	  def align_tokens
	    @total_token_width = token_width_sum
      @total_space_width = (@graphics.length - 1)*@space_width if @graphics.length > 0
      room = @width - (@total_token_width + @total_space_width)
      x = 0
      @graphics.each do |token|
        token.x = x
        x += token.width + @space_width
      end
      
      case @para_style
      when 'left'
      when 'center'
        @graphics.map {|t| t.x += room/2.0}
      when 'right'
        @graphics.map do |t| 
          t.x += room
        end
      when 'justified'
        just_space = room/(@graphics.length - 1)
        x = 0
        @graphics.each_with_index do |token, i|
          token[:x] = x
          x += token[:width] + just_space
        end
      else
        
      end
      
	  end
    
    def line_string
      string = ""
      @graphics.each do |token|
        string += token.string
      end
      string
    end
    
    # def tallest_token
    #  
    # end
	  
    # def room
    #       @width - @left_indent - @right_indent
    # end
  
  end

  
  # ParagraphLongDoc
  # This is the new paragraph
  # This is for long document and Math equations and other special effects.
  
  class ParagraphLongDoc < Container
    attr_accessor :paragraph_type
    attr_accessor :tokens, :token_heights_are_eqaul, :left_over_tokens
    attr_accessor :para_string, :para_style, :font_object, :space_width
    attr_accessor :text_column, :grid_height
    attr_accessor :h_alignment, :first_line_indent, :overflow, :underflow
    
    def initialize(options={})
      # options[:fill_color]   = 'green'
      # options[:stroke_width]   = 5
      # options[:stroke_color]   = "red"
      super
      @paragraph_type = options.fetch(:paragraph_type, 'simple') #drop_cap, drop_cap_image, math, with_image, with_math
      @para_string    = options.fetch(:para_string, "")
      puts @para_string
      @para_style     = default_para_style
      @para_style     = @para_style.merge(options[:para_style]) if options[:para_style]
      @h_alignment    = @para_style[:h_alignment]
      @first_line_indent = @para_style[:first_line_indent]
      @head_indent    = @para_style[:head_indent]
      @tail_indent    = @para_style[:tail_indent]
      @space_width    = 3
      @grid_height    = options.fetch(:grid_height, 2)
      if options[:tokens]
        @tokens       = options[:tokens]
      else
        @tokens       = []
        create_tokens   
      end
      self
    end    
        
    def create_tokens
      @atts = {}
      if RUBY_ENGINE == 'rubymotion'
        puts "@para_style[:font]:#{@para_style[:font]}"
        @atts[NSFontAttributeName]  = NSFont.fontWithName(@para_style[:font], size: @para_style[:size])
        @space_width  = NSAttributedString.alloc.initWithString(" ", attributes: @atts).size.width
      end
      @tokens = @para_string.split(" ").collect do |token_string|
        #TODO special tokens created with functions
        if token_string =~/^_(.*)+_|^\*(.*)+\*/
          #TODO
        else
          @para_style[:text_string] = token_string
          @para_style.delete(:parent) if @para_style[:parent]
          @para_style[:atts] = @atts
          RLayout::TextToken.new(@para_style)
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
      @graphics.length
    end

    
    # algorithm for laying out paragraph in simple container
	  # 1. start with line rect with width of column and height of para_style
	  # 2. keep filling up the line_tokens until the width total exceed the width of column
	  # 3. Each time with new token, check the height change, tallest_token and adjust line height.
    # 4. Once we run out of the line space,
	  # 5. create LineFragment with width and height
	  # 6. clear the line_tokens buffer and set new positions
	  
	  # algorithm for laying out paragraph in complex container
	  # 1. start with line rect with width of column and height of para_style
    # 4. call "text_column.sugest_me_a_rect_at" to get line rect
    #    if lien rect is [0,0,0,0] we have no room at this column
    #    elsif we get the rect, fill in the tokens in that rect.
    # 5. Once we run out of the line space, create LineFragment with sugessted with and height
	  # 6. clear the line_tokens buffer and set new positions and do it for onthoer line.
    def layout_lines(text_column)
      @text_column      = text_column
      @overflow         = false
      @underflow        = false
      @column_width     = @text_column.width
      @width            = @column_width
      @first_line_width = @column_width
      @text_line_width  = @column_width
      if @h_alignment == "left" || @h_alignment == "justified"
        @first_line_width = @column_width - @first_line_indent - @tail_indent
      else
        @first_line_width = @column_width - @head_indent - @tail_indent
        @text_line_width  = @column_width - @head_indent - @tail_indent 
      end
      @body_line_height = @text_column.body_line_height
      @current_y        = 0
      @total_token_width= 0
      @line_tokens      = []
      @line_index       = 0
      @line_x           = 0
      @line_width       = @first_line_width
      if @tokens.length > 0
        token = @tokens.first 
      #TODO ingnore token height unless token heihgt is taller that line height
        @tallest_token_height = token.height
      end
      while @tokens.length > 0
        token = @tokens.first 
        if @line_index == 0
          @line_x     = @first_line_indent
          @line_width = @first_line_width
        else
          @line_width = @text_line_width
          @line_x     = @head_indent
        end
        
        if text_column.is_simple_column? || text_column.is_rest_of_area_simple?
        else
          puts "we are at complex part of column"
          @line_width = sugest_me_a_rect_at(@current_y, @tallest_token_height)
        end
        
        if  (@total_token_width + @space_width + token.width) < @line_width
          @total_token_width += (@space_width + token.width)
          token = @tokens.shift
          @line_tokens << token
        else 
          options = {para_style: @para_style, tokens: @line_tokens, x: @line_x, y: @current_y , width: @line_width, height: @body_line_height, space_width: @space_width}
          line = LineFragment.new(options)
          if @text_column.room < @current_y
            # not enough room
            @overflow = true
            #add uncommitted line tokens and left over tokens. 
            @left_over_tokens = line.graphics.select {|t| t}
            @left_over_tokens += @tokens 
            return
          end
          # add line to paragraph 
          line.parent_graphic = self
          @graphics << line
          @line_tokens = []
          @current_y += line.height
          @total_token_width = 0
          @line_index += 1
        end
      end
      # left over tokens for last line.
      if @line_tokens.length > 0
        options = {parent: self, tokens: @line_tokens, x: @line_x, y: @current_y , width: @column_width, height: @body_line_height, space_width: @space_width}
        line = LineFragment.new(options)
        @current_y += line.height
      end
      # set y LineFragment y posiions
      
      if @text_column.room >= @current_y && @graphics.length > 0
        @height = @current_y
      else
        @underflow = true
        return "none"
      end
    end
	  

    def is_breakable?
      return true  if @graphics.length > 2
      false
    end

    def get_leftover_tokens

    end

    def to_hash
      h = {}
      h[:paragraph_type]  = @paragraph_type
      h[:para_string]     = overflowing_string
      h[:para_style]      = @para_style
      h
    end

    def split_overflowing_lines
      puts __method__
      second_half_options           = to_hash
      second_half_options[:tokens]  = @left_over_tokens
      @left_over_tokens.each do |token|
        puts token.string
      end
      second_half_options[:linked]  = true
      ParagraphLongDoc.new(second_half_options)
    end
    
	  def overflow?
	    @overflow == true
	  end
	  
	  def underflow?
	    @underflow == true
	  end
	  
	  
    def default_para_style
      default               = {}
      default[:font]        = "smSSMyungjoP-W30"
      default[:size]        = 10
      default[:color]       = "black"
      default[:style]       = "plain"
      default[:h_alignment] = "left"
      default[:v_alignment] = "center"
      default[:first_line_indent] = 20
      default[:head_indent] = 3
      default[:tail_indent] = 3
      default
    end
  end
end

SMAMPLE_PARA =<<EOF

\drop(T)his \color("black","is black") colored text in the middle of para.
\bold(This is :) bold text at the \italic(begining) of line.
\cmyk([30,30,0,0], colored) text $\frac({x+2}{y\sup2 + xy})$

EOF
