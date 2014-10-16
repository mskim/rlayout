module RLayout
  
  class Graphic
    attr_accessor :atts_array # for ns_att_string
    # There twe cases of how we keep the paragraph data.
    # 1. When entire Paragaph has uniform attrbutes
    # 2. Paragaph has mixed attrbutes, for this case, we keep changing attributes in atts_array

    # atts_array
    # atts_array is used to represent AttributtedString in Model
    # Each run is represented as hash of attributes with string
    # First hash has all the attribures and the follwing hashes have string and changed attributes from the previous one. 
    # for example:
    # [{font: 'Helvetical, size:16, style:plaine string:"this is "}, {style:italic string:"a string"}] 

    # def markup2atts_array
    #  # convert markedup string to atts_array
    #  "this is _itatic_ string" to [{string: "this is ", style: PLAIN}, {string: 'itatic', style: ITALIC}, {sting:' string', style:PLAIN}]
    # end
    # def atts_array2markup:
    #  # convert atts_array to markedup string, opposite of markup2atts_array
    # end
    
    # Apple's NSAttributtedString does this slightly diffrently,
    # They keep a whole string in one, and attributes points to range, 
    # but it make it very difficult to edit, since you have to update the entire ranges as you change the string length of each run.
    # I am keeping attributes and string together in a single hash.
    
    def init_text(options)
      if options[:attrs_array]
        @atts_array = options[:attrs_array]
        layout_lines(:attrs_array=>options[:attrs_array])
      elsif options[:text_string] || options[:text_size] #&& options[:text_string]!=""
        @text_markup    = options.fetch(:text_markup, @text_markup)
        @text_markup    = options.fetch(:markup, "p")
        @text_string    = options.fetch(:text_string, "")
        @text_color     = options.fetch(:text_color, "black")
        @text_font      = options.fetch(:text_font, "Times")
        @text_size      = options.fetch(:text_size, 16)
        @text_line_spacing= options.fetch(:text_line_spacing, @text_size*1.5)
        @text_fit_type  = options.fetch(:text_fit_type, 0)
        @text_alignment = options.fetch(:text_alignment, "center")
        @text_first_line_head_indent    = options.fetch(:text_first_line_head_indent, nil)
        @text_head_indent               = options.fetch(:text_head_indent, nil)
        @text_tail_indent               = options.fetch(:text_tail_indent, nil)
        
        @text_paragraph_spacing_before  = options[:text_paragraph_spacing_before] if options[:text_paragraph_spacing_before]
        @text_paragraph_spacing         = options[:text_paragraph_spacing]        if options[:text_paragraph_spacing]
        @fill_color                     = options[:fill_color]                    if options[:fill_color]
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
      justified_align  = NSMutableParagraphStyle.alloc.init.setAlignment(NSJustifiedTextAlignment)          
      newParagraphStyle  = NSMutableParagraphStyle.alloc.init
      case @text_alignment
      when "right"
        newParagraphStyle = right_align
      when "center"
        newParagraphStyle = center_align
      when 'justified'
        newParagraphStyle = justified_align
      end
      newParagraphStyle.setLineSpacing(@text_line_spacing) if @text_line_spacing
      newParagraphStyle.setFirstLineHeadIndent(@text_first_line_head_indent) if @text_first_line_head_indent
      newParagraphStyle.setHeadIndent(@text_head_indent) if @text_head_indent
      newParagraphStyle.setTailIndent(@text_tail_indent) if @text_tail_indent
      
      
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
    
    def body_line_height_multiple(head_para_height)
      @style_service = @style_service ||= StyleService.new
      body_height = @style_service.body_height
      body_multiple = body_height
      while body_multiple <= head_para_height
        body_multiple += body_height
      end
      body_multiple
    end
    
    def layout_lines(options={})
      if RUBY_ENGINE =='macruby'        
        text_storage = nil
        if options[:attrs_array]
          text_storage = atts_array_to_att_string(options[:attrs_array])
        else
          text_storage  = NSTextStorage.alloc.initWithString(@text_string, attributes:atts)
        end
        text_container = NSTextContainer.alloc.initWithContainerSize([@width,1000])
        layout_manager = NSLayoutManager.alloc.init
        layout_manager.addTextContainer(text_container)
        text_storage.addLayoutManager(layout_manager)
        text_container.setLineFragmentPadding(0.0)
        layout_manager.glyphRangeForTextContainer(text_container)
        used_size=layout_manager.usedRectForTextContainer(text_container).size
        @height = used_size.height + @text_line_spacing
        if @text_markup && @text_markup != 'p' #&& options[:aling_to_grid]
          # puts "Make the head paragraph height as body text multiples"
          # by adjusting @top_margin and @bottom_margin around it
          body_multiple_height = body_line_height_multiple(@height)
          @text_paragraph_spacing_before = (body_multiple_height - @height)/2
          @text_paragraph_spacing        = @text_paragraph_spacing_before
          # @top_margin = (body_multiple_height - @height)/2
          # @bottom_margin = @top_margin
          @height = body_multiple_height
        end
      else
        # TODO
        # adjust height
        
      end
      
    end
    
    
    
  end
  
end