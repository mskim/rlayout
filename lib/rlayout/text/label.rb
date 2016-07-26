
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
  

end