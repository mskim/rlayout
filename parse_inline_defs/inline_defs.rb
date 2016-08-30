module RLayout
  class Paragraph
    attr_accessor :para_string
    
    def initialize(options={})
      @para_string    = options.fetch(:para_string, "")
      create_tokens
      self
    end
    
    def create_tokens
      @atts = {}
      if RUBY_ENGINE == 'rubymotion'
        @atts[NSFontAttributeName]  = NSFont.fontWithName(@para_style[:font], size: @para_style[:size])
        @space_width  = NSAttributedString.alloc.initWithString(" ", attributes: @atts).size.width
      end
      @tokens = @para_string.split(" ").collect do |token_string|
        #TODO special tokens created with functions
        if token_string =~/^def_\((.*)+\)/
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
  end  
end