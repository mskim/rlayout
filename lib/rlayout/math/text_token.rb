
module RLayout
  

  TextToken   = Struct.new(:string, :x, :y, :width, :height) do
    def svg
      # TODO <text font-size=\"#{text_size}\"
      s = ""
      if string !=nil && string != ""
        s += "<text font-size=\"#{@text_size}\" x=\"#{x}\" y=\"#{y + height*0.8}\">#{string}</text>\n"
      end
      s
    end
  end
  StyleToken  = Struct.new(:font, :size, :color, :style, :h_alignment, :v_alignment)
  
  class RTextLayoutManager
    attr_accessor :owner_graphic, :text_container, :tokens
    attr_accessor :text_string, :para_style, :font_object, :token_space_width
    def initialize(owner_graphic, options={})
      @owner_graphic  = owner_graphic
      @text_container = RTextContainer.new(self, options)
      @tokens         = []
      @text_string    = options.fetch(:text_string, "")
      @para_style     = default_para_style
      @para_style[:font] = options[:font] if options[:font]
      @para_style[:size] = options[:size] if options[:size]
      @para_style[:color] = options[:color] if options[:color]
      @para_style[:style] = options[:style] if options[:style]
      @para_style[:h_alignment] = options[:h_alignment] if options[:h_alignment]
      @para_style[:v_alignment] = options[:v_alignment] if options[:v_alignment]
      create_tokens
      layout_text_lines unless options[:no_layout]
      self
    end    
            
    def default_para_style
        StyleToken.new("Times", 12, "black", "plain", "left", "center")
    end
      
    def create_tokens
      @font_object        = RFont.new(@para_style[:font],@para_style[:size])
      @token_space_width  = font_object.space_char_width
      @tokens = @text_string.split(" ").collect do |token_string|
        #TODO multile token case
        if token_string =~/^_(.*)+_|^\*(.*)+\*/
          #TODO
        else
          @size  = font_object.string_size(token_string)
          TextToken.new(token_string, 0, 0, @size[0], @size[1])
        end
      end
    end
    
    def layout_text_lines
      @text_container.layout_text_lines
    end 
    
    def line_count
      @text_container.lines.length
    end
  end
  
  class RTextContainer
    attr_accessor :text_layout_manager, :complex_container
    attr_accessor :lines
    attr_accessor :width, :height
    def initialize(text_layout_manager, options={})
      @text_layout_manager = text_layout_manager
      if @text_layout_manager.owner_graphic
        @width              = @text_layout_manager.owner_graphic.width
        @height             = @text_layout_manager.owner_graphic.height
      else
        @width              = options.fetch(:width, 300)
        @height             = options.fetch(:height, 500)
      end
      @lines              = []
      @tokens             = @text_layout_manager.tokens
      self
    end
    
    def size
      [@width, @height]
    end
    
    def set_container_size(size)
      @width = size[0]
      @heigh = size[1]
    end
    
    def layout_text_lines
      while @text_layout_manager.tokens.length > 0
        line = LineFragment.new(@text_layout_manager, width: @width)
        @lines << line
      end
    end    
  end
  
  class	LineFragment 
    attr_accessor :text_layout_manager, :tokens
    attr_accessor :line_tokens
    attr_accessor :left_indent, :right_indent
    attr_accessor :x, :y, :width, :height, :total_token_width
  	def	initialize(text_layout_manager, options={})
  	  @text_layout_manager = text_layout_manager
  	  @tokens           = @text_layout_manager.tokens
  	  @space_width      = @text_layout_manager.token_space_width
  	  @width            = options[:width]
  	  @left_indent      = options.fetch(:left_indernt, 0)
  	  @right_indent     = options.fetch(:right_indent, 0)
  	  @line_tokens      = []
  	  layout_tokens
  		self
  	end
	  	  
	  def layout_tokens 
	    @total_token_width = 0
	    x = @total_token_width
      while token = @tokens.shift
        if  (@total_token_width + token.width) < @width
          @total_token_width += token.width
          token[:x] = x
          @line_tokens << token
          x += @total_token_width + @space_width
        else
          @tokens.unshift(token)
          align_tokens
          return self
        end
      end

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
  end



end

