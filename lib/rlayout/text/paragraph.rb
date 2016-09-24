
# For text handling, Text and Paragraph are used 
# Text Object is used for simple text, usually for single page document or Ads.
# Text uses NSTextSystem
# Paragraph Object is used in middle to long document.
# Paragraph uses our own text system.

# How Paragraoh is layed out?
# 1. Tokens are created
# 2. We can encounter simple column or complex column
#    complex column are those who have overlapping floats of various shapes. 
#    so the text lines could be shorter than the ones in simple column. 
# 3. We can also encounter tokens are not uniform in heights, math tokens for example

 
# LineFragments
# LineFragments are made up of TextTokens, ImageToken, MathToken etc....
# When paragraph is created, TextTokenAtts is created for default att value for all TextTokena and they all point ot it.
# Whenever there is differnce TextTokenAtts in the paragraph, new TextTokenAtts is created and different TextToken ponts to that one.
DefRegex = /(def_.*?\(.*?\))/
# example 
#   def_box('boxed_text')
#   def_ruby('base_text', 'top_text')
#   def_undertag('base_text', 'under_text')


module RLayout

  #TODO
  # tab stop
  # implementing paragraph with tab
  # if para_string.include?("\t")
  # tab_group = para_string.split("\t")
  # tokens = []
  # tab_group.each do |sub_string|
  #    tokens << create_tokens(sub_string)
  #    tokens << TabToken.new
  # end
  # tokens.pop #pop the last TabToken
  
  # tab Token
  
  #TODO add markup, read styles from StyleService
  class Paragraph < Container
    attr_reader :markup
    attr_accessor :tokens, :token_heights_are_eqaul
    attr_accessor :para_string, :para_style
    attr_accessor :text_column, :grid_height 
    attr_accessor :overflow, :underflow, :overflowing_line_index, :linked, :line_y_offset

    def initialize(options={})
      super      
      #simple, drop_cap, drop_cap_image, math, with_image, with_math
      @markup         = options.fetch(:markup, 'p') 
      @para_string    = options.fetch(:para_string, "")
      @para_style     = default_para_style
      @space_width    = @para_style[:space_width]
      @grid_height    = options.fetch(:grid_height, 2)
      @linked         = options.fetch(:linked, false) 
      if options[:tokens]
        @tokens       = options[:tokens]
      else
        @tokens       = []
        create_tokens   
      end
      self
    end    
    
    def box(text, options={})
      para_style = @para_style.dup
      # para_style[:text_string] = text
      para_style[:string] = text
      para_style[:stroke_width] = 0.5
      @tokens << TextToken.new(para_style)
    end
    
    def round(text, options={})
      para_style = @para_style.dup
      para_style[:string] = text
      para_style[:stroke_width] = 0.5
      para_style[:shape]        = "round"
      @tokens << TextToken.new(para_style)
    end
    
    def create_special_tokens
      # split paragraph with def_name(ar)
      split_array = @para_string.split(DefRegex)
      split_array.each do |line|
        if line =~/def_/
          # line with special tokens
          line.sub!("def_", "")
          eval(line)
        else
          # line text with just nonal text tokens
          create_text_tokens(line)
        end
      end      
    end
    
    def create_text_tokens(para_string)
      # parse for tab first
      @tokens += para_string.split(" ").collect do |token_string|
        @para_style[:string] = token_string
        @para_style.delete(:parent) if @para_style[:parent]
        RLayout::TextToken.new(@para_style)
      end
    end
    
    def create_tokens
      @atts = {}
      if RUBY_ENGINE == 'rubymotion'
        @atts[NSFontAttributeName]  = NSFont.fontWithName(@para_style[:font], size: @para_style[:text_size])
        @para_style[:space_width]  = NSAttributedString.alloc.initWithString(" ", attributes: @atts).size.width
        @para_style[:atts] = @atts
      end
      if @para_string =~DefRegex
        #TODO special tokens created with functions
        create_special_tokens
      else
        create_text_tokens(@para_string)
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
    
    # algorithm for laying out paragraph in simple and complex container
    # loop until we run out of tokens
	  # 1. start with line rect with width of column and height of para_style
	  # 2. keep filling up the line_tokens until the width total exceed the width of column
    #    for complex column
    #    call "text_column.sugest_me_a_rect_at" to get line rect at the current grid_rects
    #    if lien rect is [0,0,0,0] we have no room at that grid_rect area of column
    #    elsif we get the rect, fill in the tokens in that rect.
    #
	  # 3. Each time with new token, check the height change, tallest_token and adjust line height.
    # 4. Once we run out of the line space,
	  # 5. create LineFragment with width and height
	  # 6. clear the line_tokens buffer and set new positions
	  # all tokens are layed out even fo underflow, or overflow.
	  # underflow is when there is no room even for a single line.
	  # overflow is when there is not enough room to fit all the lines.
    
    def layout_lines(text_column)
      @text_column      = text_column
      @overflow         = false
      @underflow        = false
      @column_width     = @text_column.width
      @width            = @column_width
      @first_line_width = @column_width
      @text_line_width  = @column_width
      if @para_style[:h_alignment] == "left" || @para_style[:h_alignment] == "justified"
        @first_line_width = @column_width - @para_style[:first_line_indent] - @para_style[:tail_indent]
      else
        @first_line_width = @column_width - @para_style[:head_indent] - @para_style[:tail_indent]
        @text_line_width  = @column_width - @para_style[:head_indent] - @para_style[:tail_indent] 
      end
      @body_line_height = @text_column.body_line_height
      @line_y_offset    = 0
      if @para_style[:space_before]
        @line_y_offset  = @para_style[:space_before]
      end
      @total_token_width= 0
      @line_tokens      = []
      @line_index       = 0
      @line_x           = 0
      @line_width       = @first_line_width
      if @tokens.length > 0
        token = @tokens.first 
        @tallest_token_height = token.height
      end
      while @tokens.length > 0
        token = @tokens.first 
        if @line_index == 0 && !@linked
          @line_x     = @para_style[:first_line_indent]
          @line_width = @first_line_width
        else
          @line_width = @text_line_width
          @line_x     = @para_style[:head_indent]
        end
        
        if text_column.is_simple_column? || text_column.is_rest_of_area_simple?
          @line_rectangle = [@line_x, @line_y_offset, @line_width, @tallest_token_height]
          if @line_y_offset + @line_rectangle[3] > @text_column.room
            if @graphics.length <= 1
              @underflow  = true
            else
              @overflow = true 
            end
            return
          end
        else
          @line_rectangle = @text_column.sugest_me_a_rect_at(@line_y_offset, @tallest_token_height)
          if @line_y_offset + @line_rectangle[3] > @text_column.room
            if @graphics.length <= 1
              @underflow  = true
            else
              @overflow = true 
            end
            puts "text_column.column_index:#{text_column.column_index}"
            puts "reached bottom of column"
            return
          elsif @line_rectangle[2] == 0
            # move move_current_position_by token_heigh
            @text_column.move_current_position_by(@tallest_token_height)
            @line_y_offset += @tallest_token_height
            next
          else            
            if @line_rectangle[0] > @para_style[:head_indent]
              #TODO tail_indent
              @line_x     = @line_rectangle[0]              
            else
              # @para_style[:head_indent] is right of line origin
              # use head_indent, adjust width as @line_rectangle[2] - (@para_style[:head_indent] - @line_rectangle[0])
              @line_x     = @para_style[:head_indent]              
              @line_width = @line_rectangle[2] - (@para_style[:head_indent] - @line_rectangle[0])
            end
          end
        end
        
        # check for space for more tokens
        if  (@total_token_width + @para_style[:space_width] + token.width) < @line_width
          @total_token_width += (@para_style[:space_width] + token.width)
          token = @tokens.shift
          @line_tokens << token
        else 
          options = {parent:self, para_style: @para_style, tokens: @line_tokens, x: @line_x, y: @line_y_offset , width: @line_width, height: @line_rectangle[3], space_width: @para_style[:space_width]}
          line = LineFragment.new(options)
          @line_y_offset += line.height
          @line_tokens = []
          @total_token_width = 0
          @line_index += 1
        end
        @height = @line_y_offset
      end
      if @line_tokens.length > 0
        options = {parent:self, para_style: @para_style, tokens: @line_tokens, x: @line_x, y: @line_y_offset , width: @line_width, height: @line_rectangle[3], space_width: @para_style[:space_width]}
        # options = {parent: self, tokens: @line_tokens, x: @line_x, y: @line_y_offset , width: @column_width, height: @body_line_height, space_width: @para_style[:space_width]}
        line    = LineFragment.new(options)
        @line_y_offset += line.height
        if @para_style[:space_after]
          @height = @line_y_offset + @para_style[:space_after]
        else
          @height = @line_y_offset
        end
      end
    end
	  
	  # this is called when paragraph is splitted or moved to next column and have to be
	  # relayed out at the carried over column
	  # lines are already created, it might have to be layed out for complex column
	  # or different column width, 
    # def re_layout_lines(text_column)
    #   @overflow         = false
    #       @underflow        = false
    #   @height           = @graphics.map{|line| line.height}.inject(:+)
    # end

    def is_breakable?
      return true  if @graphics.length > 2
      false
    end

    def to_hash
      h = {}
      h[:width]  = @width
      h[:markup]  = @markup
      h[:para_style]      = @para_style
      h[:linked]          = true
      h
    end
    
    # split current paragraph into two at overflowing line
    # return newly created second half Paragraph
    def split_overflowing_lines
      second_half_options = to_hash
      second_half         = Paragraph.new(second_half_options)
      second_half.tokens = @tokens.map{|x| x}
      @tokens = []
      second_half
    end
    
    # overflow is when we have breakable paragraph and partial lines are layout at current column. 
	  def overflow?
	    @overflow == true
	  end
	  
	  # underflow is when none of the lines can fit into a given column at the position
	  # We move it to the item to the next column 
	  def underflow?
	    @underflow == true
	  end
	  
	  # I should read it from StyleService
    def default_para_style      
      default               = {}
      default[:font]        = "smSSMyungjoP-W30"
      default[:text_size]   = 10
      default[:space_width] = 4
      default[:color]       = "black"
      default[:style]       = "plain"
      default[:h_alignment] = "left"
      default[:v_alignment] = "center"
      default[:first_line_indent] = 20
      default[:head_indent] = 3
      default[:tail_indent] = 3
      default[:space_before]= 0
      default[:space_after] = 0
      default[:tab_stops]   = [['left', 20], ['left', 40], ['left', 60],['left', 80]]
      style = RLayout::StyleService.shared_style_service.current_style[@markup]
      if style.class == String
        # this is when a style is refering to other style
        style = RLayout::StyleService.shared_style_service.current_style[style]
      end
      
      if style
        default.merge! style 
      else
      end      
      # if @markup == "ordered_section_item2"
      #   puts "ordered_section_item2"
      #   puts "style:#{style}"
      # end
      default
    end
  end

  # line fill_color is set by optins[:line_color] or it is set to clear
  class	LineFragment < Container
    attr_accessor :line_type #first_line, drop_cap, drop_cap_side
    attr_accessor :left_indent, :right_indent, :para_style
    attr_accessor :x, :y, :width, :height, :total_token_width
  	def	initialize(options={})
      # options[:stroke_color]    = 'red'
      options[:layout_direction]  = 'horizontal'
      options[:fill_color]        = options.fetch(:line_color, 'clear')
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
	    return if @graphics.length == 0
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

  
  class DropParagraph < Paragraph
    attr_accessor :image_object, :cap_object, :title, :subtitle, :body
    def initialize(options={}, &block)
      super
      
      self
    end
    
    def layout_lines
      
    end
  end
  
  # ComboParagraph can have DropCap, DropImage, head, body
  class ComboParagraph < Paragraph
    attr_accessor :image_object, :cap_object, :title, :subtitle, :body
    
    def initialize(options={}, &block)
      super
      add_title_tokens
      self
    end
    
  end
  
  def add_title_tokens
    
  end
  
  def layout_lines
    
  end
  
end


SMAMPLE_PARA =<<EOF

\drop(T)his \color("black","is black") colored text in the middle of para.
\bold(This is :) bold text at the \italic(begining) of line.
\cmyk([30,30,0,0], colored) text $\frac({x+2}{y\sup2 + xy})$

EOF
