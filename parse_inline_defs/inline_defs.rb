InlineDefRx = /(def_.*?\(.*?\))/


module RLayout

  class ImageToken 
    attr_accessor :image_path, :x,:y, :width, :height, :image_path
    def initialize(image_path, options={})
      @image_path = image_path
      self   
    end 
  end
  class Paragraph
    attr_accessor :para_string
    
    def initialize(options={})
      # binding.pry
      
      @para_string    = options.fetch(:para_string, "")
      create_tokens
      self
    end
    
    def ruby(base, top, options={})
      options[:base] = base
      options[:top] = top
      @tokens << RubyToken.new(options={})
    end

    def undertag(root, under, options={})
      options[:base] = base
      options[:top] = top
      @tokens << RubyToken.new(options={})
    end
    
    def choice(number,choice_text, options={})
      options[:choice_number] = base
      options[:choice_text] = top
      @tokens << ChoiceToken.new(options={})
    end
    
    def process_special_tokens(def_string)
      def_string.sub!("def_", "")
      eval(def_string)
    end
    
    def process_text_tokens(text_string)
      @tokens += text_string.split(" ").collect do |token_string|
        @para_style[:string] = token_string
        @para_style.delete(:parent) if @para_style[:parent]
        @para_style[:atts] = @atts
        RLayout::TextToken.new(@para_style)
      end
    end
    
    def create_tokens
      @atts = {}
      if RUBY_ENGINE == 'rubymotion'
        @atts[NSFontAttributeName]  = NSFont.fontWithName(@para_style[:font], size: @para_style[:size])
        @space_width  = NSAttributedString.alloc.initWithString(" ", attributes: @atts).size.width
      end
      if token_string =~/def_.*?\(.*?\)/
        # token_string contains special token
        #TODO create special tokens
        puts "token_string matches:#{token_string}"
        split_array = string.split(InlineDefRx)
        split_array.each do |line|
          process_special_tokens(line) if line =~/def_/
        end
      else
        @tokens = @para_string.split(" ").collect do |token_string|
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

p = RLayout::Paragraph.new(para_string: "this is a def_sub(one, two) and some more")