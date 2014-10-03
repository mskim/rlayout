module RLayout
  
  class Graphic
    attr_accessor :atts_array # for ns_att_string
    # There twe cases of how we keep the paragraph data.
    # 1. Entire Paragaph has uniform attrbutes
    # 2. Paragaph has mixed attrbutes in the middle of paragraph
    # for the second case, we keep changing attributes in atts_array

    # atts_array
    # atts_array is used to represent AttributtedString in Model
    # Each run is represented as hash of attributes with string
    # First hash has all the attribures and the follwing hashes string and only changed attributes. 
    # Array of atts represent mixed attributtedString.
    # [{font: 'Helvetical, size:16, style:plaine string:"this is "}, {style:italic string:"a string"}] 

    # def markup2atts_array
    #  # convert markedup string to atts_array
    #  "this is _itatic_ string" to [{string: "this is ", style: PLAIN}, {string: 'itatic', style: ITALIC}, {sting:' string', style:PLAIN}]
    # end
    # def atts_array2markup:
    #  # convert atts_array to markedup string, opposite of markup2atts_array
    # end
    
    # Apple's NSAttributtedString does this slightly diffrently,
    # They keep a whole string in one, and attributes points to range, this effienct, 
    # but it make it very difficult to edit, since you have to update the entire ranges as you change the string length of each run.
    # I am keeping attributes and string together.
    
    def init_text(options)
      if options[:attrs_array]
        @atts_array = options[:attrs_array]
        layout_lines(:attrs_array=>options[:attrs_array])
      elsif options[:text_string] && options[:text_string]!=""
        @text_string    = options.fetch(:text_string, "")
        @text_color     = options.fetch(:text_color, "black")
        @text_font      = options.fetch(:text_font, "Times")
        @text_size      = options.fetch(:text_size, 16)
        @text_line_spacing= options.fetch(:text_line_spacing, @text_size*1.5)
        @text_fit_type  = options.fetch(:text_fit_type, 0)
        @text_alignment = options.fetch(:text_alignment, "center")
        layout_lines if @parent_graphics
        
      end
      
    end
    
    def text_defaults
      {
        
      }
      
    end

    def change_width_and_adjust_height(new_width, options={})
      # for heading paragrph, should set height as multiples of grid_line_height
      @width = new_width
      if options[:line_grid_height] 
        #TODO
        # if @line_height != options[:line_grid_height]
        # @line_height = options[:line_grid_height]
        # update token size
      end
      layout_lines
    end
    
    def atts
      #TODO
      # implement text_fit_type
      # atts[NSKernAttributeName] = @text_track           if @text_track
      # implement inline element, italic, bold, underline, sub, super, emphasis(color)
      atts={}
      atts[NSFontAttributeName]             = NSFont.fontWithName(@text_font, size:@text_size)
      atts[NSForegroundColorAttributeName]  = @text_color      

      if @guguri_width && @guguri_width < 0
        atts[NSStrokeWidthAttributeName] = atts_hash[:guguri_width] #0, -2,-5,-10 
        atts[NSStrokeColorAttributeName]=GraphicRecord.color_from_string(attributes[:guguri_color])
      end 
      
      right_align   = NSMutableParagraphStyle.alloc.init.setAlignment(NSRightTextAlignment)          
      center_align  = NSMutableParagraphStyle.alloc.init.setAlignment(NSCenterTextAlignment)          
      newParagraphStyle  = NSMutableParagraphStyle.alloc.init
      case @text_alignment
      when "right"
        newParagraphStyle = right_align
      when "center"
        newParagraphStyle = center_align
      end
      puts "@text_line_spacing:#{@text_line_spacing}"
      puts "@text_markup:#{@text_markup}"
      puts "before newParagraphStyle.lineSpacing:#{newParagraphStyle.lineSpacing}"
      newParagraphStyle.setLineSpacing = @text_line_spacing
      puts "after newParagraphStyle.lineSpacing:#{newParagraphStyle.lineSpacing}"
      atts[NSParagraphStyleAttributeName] = newParagraphStyle         
      atts
    end
    
    def att_string
      att_string=NSMutableAttributedString.alloc.initWithString(@text_string, attributes:atts)
      att_string
    end
    
    # return text height of given width and NSAttributed string atts hash
    def self.text_height_with_atts(width, atts)
 
    end
    
    def atts_array_to_att_string(atts_array)
      text_storage = NSTextStorage.alloc.init
      atts_array.each do |atts|
        att_string.appendAttributedString(att_string(atts))
      end
      text_storage
    end
    

    def layout_lines(options={})
      
      if RUBY_ENGINE =='macruby'
        text_storage = nil
        if options[:attrs_array]
          text_storage = atts_array_to_att_string(options[:attrs_array])
        else
          text_storage  = NSTextStorage.alloc.initWithString(@text_string, attributes:atts)
          # puts "text_storage.string;#{text_storage.string}"
        end
        text_container = NSTextContainer.alloc.initWithContainerSize([@width,1000])
        layout_manager = NSLayoutManager.alloc.init
        layout_manager.addTextContainer(text_container)
        text_storage.addLayoutManager(layout_manager)
        text_container.setLineFragmentPadding(0.0)
        layout_manager.glyphRangeForTextContainer(text_container)
        used_size=layout_manager.usedRectForTextContainer(text_container).size
        @height = used_size.height
        # puts "+++++ in layout_lines"
        # puts "@height:#{@height}"
        # puts "@width:#{@width}"
        # puts @text_font
        # puts @text_size
        # puts @text_string
      else
        # TODO
        # adjust height
        
      end
      
    end
    
    
    
  end
  
end