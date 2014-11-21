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
        
    # 
    # def atts
    #   #TODO
    #   # implement text_fit_type
    #   # atts[NSKernAttributeName] = @text_track           if @text_track
    #   # implement inline element, italic, bold, underline, sub, super, emphasis(color)
    #   atts={}
    #   atts[NSFontAttributeName]             = NSFont.fontWithName(@text_font, size:@text_size)
    #   atts[NSForegroundColorAttributeName]  = @text_color      
    # 
    #   if @guguri_width && @guguri_width < 0
    #     atts[NSStrokeWidthAttributeName] = atts_hash[:guguri_width] #0, -2,-5,-10 
    #     atts[NSStrokeColorAttributeName]=GraphicRecord.color_from_string(attributes[:guguri_color])
    #   end 
    #   
    #   right_align   = NSMutableParagraphStyle.alloc.init.setAlignment(NSRightTextAlignment)          
    #   center_align  = NSMutableParagraphStyle.alloc.init.setAlignment(NSCenterTextAlignment)          
    #   justified_align  = NSMutableParagraphStyle.alloc.init.setAlignment(NSJustifiedTextAlignment)          
    #   newParagraphStyle  = NSMutableParagraphStyle.alloc.init
    #   case @text_alignment
    #   when "right"
    #     newParagraphStyle = right_align
    #   when "center"
    #     newParagraphStyle = center_align
    #   when 'justified'
    #     newParagraphStyle = justified_align
    #   end
    #   newParagraphStyle.setLineSpacing(@text_line_spacing) if @text_line_spacing
    #   newParagraphStyle.setFirstLineHeadIndent(@text_first_line_head_indent) if @text_first_line_head_indent
    #   newParagraphStyle.setHeadIndent(@text_head_indent) if @text_head_indent
    #   newParagraphStyle.setTailIndent(@text_tail_indent) if @text_tail_indent
    #   
    #   atts[NSParagraphStyleAttributeName] = newParagraphStyle         
    #   atts
    # end
    # 
    # def att_string
    #   att_string=NSMutableAttributedString.alloc.initWithString(@text_string, attributes:atts)
    #   att_string
    # end
    # 
    # # return text height of given width and NSAttributed string atts hash
    # def self.text_height_with_atts(width, atts)
    #  
    # end
    # 
    # def atts_array_to_att_string(atts_array)
    #   text_storage = NSTextStorage.alloc.init
    #   atts_array.each do |atts|
    #     att_string.appendAttributedString(att_string(atts))
    #   end
    #   text_storage
    # end
    # 
    # def body_line_height_multiple(head_para_height)
    #   @style_service = @style_service ||= StyleService.new
    #   body_height = @style_service.body_height
    #   body_multiple = body_height
    #   while body_multiple <= head_para_height
    #     body_multiple += body_height
    #   end
    #   body_multiple
    # end
    # 
    # def layout_lines(options={})
    #   if RUBY_ENGINE =='macruby'        
    #     text_storage = nil
    #     if options[:attrs_array]
    #       text_storage = atts_array_to_att_string(options[:attrs_array])
    #     else
    #       text_storage  = NSTextStorage.alloc.initWithString(@text_string, attributes:atts)
    #     end
    #     
    #     if @text_direction == 'right_to_left'
    #       text_container = NSTextContainer.alloc.initWithContainerSize([@width,1000])
    #       layout_manager = NSLayoutManager.alloc.init
    #       layout_manager.addTextContainer(text_container)
    #       text_storage.addLayoutManager(layout_manager)
    #       text_container.setLineFragmentPadding(0.0)
    #       layout_manager.glyphRangeForTextContainer(text_container)
    #       used_size=layout_manager.usedRectForTextContainer(text_container).size
    #       @height = used_size.height + @text_line_spacing
    #       if @text_markup && @text_markup != 'p' #&& options[:aling_to_grid]
    #         # puts "Make the head paragraph height as body text multiples"
    #         # by adjusting @top_margin and @bottom_margin around it
    #         body_multiple_height = body_line_height_multiple(@height)
    #         @text_paragraph_spacing_before = (body_multiple_height - @height)/2
    #         @text_paragraph_spacing        = @text_paragraph_spacing_before
    #         # @top_margin = (body_multiple_height - @height)/2
    #         # @bottom_margin = @top_margin
    #         @height = body_multiple_height
    #       end
    #     else
    #       # for vertival text
    #       # TODO using NSASTysetter sub class
    #       #  1. rotate glyphs 90 to left, except English and numbers
    #       #  1. rotate line 90 to right
    #       
    #       # NSLineBreakByCharWrapping
    #       
    #       # issues
    #       #  1. line height control
    #       #  1. horozontal alignment for non-square English, and commas.
    #       #  1. English string that rotates
    #       #  1. Two or more digit Numbers
    #       #  1. Commas, etc....
    #        
    #       v_line_count = @width/(@text_size + @text_line_spacing)
    #       y = @top_margin + @top_inset
    #       width = @text_size*0.7
    #       x = @width - width - @right_inset - @right_margin
    #       heigth = @height  - @top_margin - @top_inset - @bottom_margin - @bottom_inset
    #       @vertical_lines = []
    #       v_line_count.to_i.times do
    #         @vertical_lines << NSMakeRect(x,y,width,height)
    #         x -= @text_size + @text_line_spacing
    #       end
    #       layout_manager = NSLayoutManager.alloc.init        
    #       text_storage.addLayoutManager(@layout_manager)
    #       @vertical_lines.each do |v_line|
    #         @text_container = NSTextContainer.alloc.initWithContainerSize(v_line.size)
    #         @text_container.setLineFragmentPadding(0.0)
    #         @layout_manager.addTextContainer(@text_container)
    #         glyphRange=@layout_manager.glyphRangeForTextContainer(@text_container) 
    #         # if layout is done  
    #         # @height = body_multiple_height
    #         # origin = v_line.origin
    #         # origin.y = origin.y
    #         # @layout_manager.drawGlyphsForGlyphRange(glyphRange, atPoint:v_line.origin)
    #       end
    #       
    #       
    #     end
    #   else
    #     # TODO
    #     # for non -macruby env
    #     # adjust height
    #     
    #   end
    #   
    # end
    # 
    
    
  end
  
end