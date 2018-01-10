module RLayout

    LabelTextRegex = /^[\s|\w]:/
    # Label is a text with label in front of it
    # label is separated from text by ":"
    # label uses bold text, we can specifie the label font with
    # label_font, label_text_size, label_text_color
    # label uses small_captalized letters, *0.8 of font_size as default
    class Label < Text
      attr_accessor :label_text, :label_font, :label_text_color, :label_length
      def initialize(options={})
        @text_string = options[:text_string]
        @font_size = options[:font_size]
        super
        @label_text   = @text_string.match(LabelTextRegex).to_s
        @label_length = @label_text.length
        @label_font   = options.fetch(:label_font, "Helvetica")
        @label_text_size    = options.fetch(:label_text_size, @font_size*0.8)
        @label_text_color   = options[:label_text_color] if options[:label_text_color]
        atts          = {}
        if RUBY_ENGINE == 'rubymotion'
          @label_text_size= options.fetch(:label_text_size, @text_layout_manager.font_size*0.8)

          range                                 = NSMakeRange(0, @label_length)
          atts[NSFontAttributeName]             = NSFont.fontWithName(@label_font, size: @label_text_size)
          if @label_text_color
            @label_text_color = RLayout.convert_to_nscolor(@label_text_color)    unless @text_color.class == NSColor
            atts[NSForegroundColorAttributeName]  = @label_text_color
          end
          setAttributes(atts, range)
        else
          @label_text_size    = options.fetch(:label_text_size, @font_size*0.8)
        end
        self
      end

    end

  #code
end
