
#TODO
# label_text_color

module RLayout
  
  LabelTextRegex = /^[\s|\w]:/
  # TextLabel is a text with label in front of it 
  # label is separated from text by ":"
  # label uses bold text, we can specifie the label font with 
  # label_font, label_text_size, label_text_color
  class Label < Text
    attr_accessor :label_text, :label_font, :label_text_color, :label_length
    def initialize(options={})
      @text_string = options[:text_string]
      super
      @label_text   = @text_string.match(LabelTextRegex).to_s
      @label_length = @label_text.length
      @label_font   = options.fetch(:label_font, "Helvetica")
      @label_text_size    = options.fetch(:label_text_size, @text_size*0.8)
      @label_text_color   = options[:label_text_color] if options[:label_text_color]
      atts          = {}
      if RUBY_ENGINE == 'rubymotion'
        range                                 = NSMakeRange(0, @label_length)
        atts[NSFontAttributeName]             = NSFont.fontWithName(@label_font, size: @label_text_size)
        if @label_text_color
          @label_text_color = RLayout::convert_to_nscolor(@label_text_color)    unless @text_color.class == NSColor
          atts[NSForegroundColorAttributeName]  = @label_text_color 
        end
        setAttributes(atts, range)
      end
      self      
    end
    
  end
  
  
  # TextTrain is a series of text runs with differnt attributes.
  # They are separated by \t .
  # It is used to handle mixed text attributes.
  class TextTrain < Container
    attr_accessor :text_run, :atts_run, :v_align
    def initialize(options={})
      super
      @text_run = options[:text_string].split("\t")
      @v_align  = options.fetch(:v_align, "center")
      
      
      self
    end
    
    
  end
  
  # TextStack is a series of paragrph text with differnt attributes.
  # They are virtically stacked.
  # They are separated by \n.
  # Simolary to TextTrain but they are stacked paragrpha.
  class TextStack < Container
    attr_accessor :text_run, :atts_run, :h_align
    def initialize(options={})
      super
      @text_run = options[:text_string].split("\n")
      @v_align  = options.fetch(:h_align, "left")
      
      self
    end
    
  end
  
	# EShape, E Shaped Object
	# It refers to shapes that looks like "E".
	# On the left size with images and on the right side list of texts.
	# Admonition, 
	# Itmes text with Image, 
	# Logo with image, companly name, and web site url
	# EShape
	# stem refers to image box on the left.
	# brances refers to list of text on the right side.
	class EShape < Container
		attr_accessor :stem, :branches, :stem_length, :stem_alignment, :comb_length, :reverse
		def initialize(options={}, &block)
		  @reverse = options.fetch(:reverse, false)
		  create_stem(options)
		  create_branches(options)
		  relayout!
		  self
		end
		
		def create_stem(options={})
		  @stem_length    = options.fetch(:stem_length, 1)
		  @stem_alignment = options.fetch(:stem_alignment, 'top')
		  # creating code here
		end
		
		def create_branches(options)
		  @branches_length = options.fetch(:branches_length, 4)
		  # creating code here
		  
		end
		
	end


end