module RLayout
  
  class Graphic
    # There two of ways to save paragraph data.
    # 1. When entire Paragaph has uniform attrbutes, use atts hash.
    # 2. When paragaph has mixed attrbutes, keep them in atts_array

    # atts_array
    # atts_array is Array of attribute Hash.
    # Each run is represented as hash of attributes and string
    # First hash has all the attribures and the follwing hashes have changing attributes from the previous one. 
    # for example:
    # [{font: 'Helvetical, size:16, style:plaine string:"this is "}, {style:italic string:"a string"}] 

    # def markup2atts_array
    #  # convert markedup string to atts_array
    #  "this is _itatic_ string" to [{string: "this is ", style: PLAIN}, {string: 'itatic', style: ITALIC}, {sting:' string', style:PLAIN}]
    # end
    # def atts_array2markup:
    #  # convert atts_array to markedup string, opposite of markup2atts_array
    # end
    
    # Apple's NSAttributtedString does it diffrently,
    # Apple keep whole string in one chunk, and attributes points to range.
    # But, It makes it difficult to edit content, since you have to update the ranges of every run when you edit the text string, 
    # it forces you to use some sort of tool to reconstuct the string. Not good for editing with a text editor.
    # That is the reson why I am keeping attributes and string together in a single hash(atts).
    # Make it much easier to edit them.
    
    def init_text(options)
      if options[:text_string] || options[:text_atts_array] 
        if RUBY_ENGINE == 'macruby'
          @text_layout_manager = TextLayoutManager.new(self, options)
        else
          #TODO
        end
      end
    end
    
    def minimun_text_height
      if @text_layout_manager && @text_layout_manager.text_size
        @text_layout_manager.text_size
      else
        9 
      end
    end
    
    def text_to_hash
      unless @text_layout_manager.nil?
        @text_layout_manager.to_hash if @text_layout_manager
      else
        Hash.new
      end
      
    end
    
    def draw_text(r)
      @text_layout_manager.draw_text(r) 
    end
    
    
  end
  
end