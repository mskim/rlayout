# Toc handles Table Of Content Layout
#

INLINE_TAB = /(\t)/

module RLayout
  
  class TocBox < Container
    attr_accessor :paragraphs, :item_rows
    def initialize(options={})
      super
      @item_rows = []
      self
    end 
    
    def layout_items(paragraphs)
      # @paragraphs =  options[:para]
      paragraphs.each do |para|
        para[:parent] = self
        para[:width] = @width
        TocRow.new(para)
      end
      relayout!
    end
    
  end
  
  class TabLineFragment < LineFragment
    
    def align_tokens
	    return if @graphics.length == 0
      
	    tab_tokens       = @graphics.select{|t| t.is_a?(TabToken)}
      tab_token_count   = tab_tokens.length
      if tab_token_count == 1
        tab_token       = tab_tokens.first
        margin          = 5
        text_tokens     = @graphics.select{|t| t.width if t.is_a?(TextToken)}
        text_token_width_sum = text_tokens.collect{|t| t.width}.reduce(:+)
        tab_token_width = @width - margin*2 - text_token_width_sum - (@graphics.length - 1)*@space_width
        tab_token.width = tab_token_width
        x = margin
        @graphics.each do |token|
          token.x = x
          x += token.width + @space_width
          puts "+++++++ in align_tokens"
          puts "token.class:#{token.class}"
          puts "token.x:#{token.x}"
          puts "token.width:#{token.width}"
          puts "token.string:#{token.string}" if token.is_a?(TextToken)
        end
        return
      else
        #TODO we have one than one token
      end
      
	    @total_token_width = token_width_sum
      @total_space_width = (@graphics.length - 1)*@space_width if @graphics.length > 0
      room = @width - (@total_token_width + @total_space_width)
      x = 0.0
      @graphics.each do |token|
        token.x = x
        x += token.width + @space_width        
      end
      
      case @para_style[:text_alignment]
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
      end
    end
    
  end
  
  class TocRow < Paragraph
    def initialize(options={})
      super      
      # layout_lines
      options = {parent:self, para_style: @para_style, tokens: @tokens, x: 0, y: 0 , width: @width, height: @height, space_width: @para_style[:space_width]}
      TabLineFragment.new(options)
      self
    end
    
    
    def create_text_tokens(para_string)
      # parse for tab first
      @tokens += para_string.split(" ").collect do |token_string|
        @para_style[:string] = token_string
        @para_style.delete(:parent) if @para_style[:parent]
        RLayout::TextToken.new(@para_style)
      end      
    end
    
    def create_tokens_with_tab(para_string)
      split_array = para_string.split(INLINE_TAB)
      # splited array contains double curl content
      split_array.each do |line|
        if line =~INLINE_TAB
          @tokens << RLayout::TabToken.new()
        else
          create_text_tokens(line)
        end
      end      
    end
    
    
    def create_tokens
      @atts = {}
      if RUBY_ENGINE == 'rubymotion'
        @atts[NSFontAttributeName]  = NSFont.fontWithName(@para_style[:font], size: @para_style[:text_size])
        if @para_style[:text_color]
          text_color    = RLayout::convert_to_nscolor(@para_style[:text_color]) unless (@para_style[:text_color]) == NSColor
          @atts[NSForegroundColorAttributeName] = text_color
        end
        atts[NSKernAttributeName]             = text_tracking if text_tracking
        @para_style[:space_width]  = NSAttributedString.alloc.initWithString(" ", attributes: @atts).size.width
        @para_style[:atts] = @atts
      end
      
      # check if we have any \t
      # if double curl is found, split para string with double curl fist
      # and do it recursively with split strings
      # do we have any tab?
      if @para_string =~INLINE_TAB
        create_tokens_with_tab(@para_string)
      # no tab found, so create_text_tokens
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
  end
end