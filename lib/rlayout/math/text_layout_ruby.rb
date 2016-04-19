module RLayout
  
  # RTextLayoutManager
  # TextLayoutManager in Ruby
  # 1. Parse marked up inline paragraph text into attributted string.
  # 2. Create Tokens for line layout
  # 3. layout line for the Paragraph.
  # RTextLayoutManager
  # TextLayoutManager in Ruby
  # RTextLayoutManager is replaecement of NSText System with Ruby Objects preparation for non-Cocoa enviroment
  # RFont for NSFont
  # RAttributedString for NSAttributedString
  # RLineFragment for NSLineFragment
  # 1. Parse marked up inline paragraph text into attributted string.
  # 2. Create Tokens for line layout
  # 3. layout line for the Paragraph.
  # TextToken is uniform runs of text
  
  class RTextLayoutManager
    attr_accessor :owner_graphic, :att_string, :tokens, :lines
    attr_accessor :text_container
    def initialize(owner_graphic, options={})
      @owner_graphic  = owner_graphic
      @att_string     = att_string_from_string(options[:text_string])
      create_tokens
      # we might not need to layout lines at creation time
      layout_text_lines(options={}) unless options[:layout_lines] == false
      self
    end
    
    # this can be called when relayout takes place after creation
    def layout_text_lines(options={})
      
    end
  end
  
  class TextRun
    attr_accessor :string, :atts, :type
    def initialize(string, atts, options={})
      @string             = string
      @atts              = atts
      calculate_size
      self
    end
        
    def calculate_size
      
    end
  end

  class Token < Graphic
    attr_accessor :type
    attr_accessor :position, :length, :x, :y, :width, :height, :string, :style
    attr_accessor :scale, :advancement, :origin # 
    def initialize(options={})
      @line_framgment     = parent_graphic
      @position           = options.fetch(:position, 0)
      @length             = options.fetch(:position, 0.0)
      self
    end
    
    
  end
  

  class ImageToken < Graphic
    def initialize(line_framgment, options={})
      super
      @type               = options.fetch(:type, "image")
      self   
    end 
  end
  

end
