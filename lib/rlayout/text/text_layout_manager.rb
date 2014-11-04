
# Unlike NSText System, I am using text_storage per Paragraph bases. 
# Each paragraph has own storage, lanyout_manager, and text_container,
# only when Paragraph are linked, multiple text_container are utilized.
# This is done to gain more drawing control over each Paragraph, to containing text in separate views, 
# for tasks, such as drawing line frames around paragraps, 
# widow/orphan rule last character sqeese options 
# foot note and indexing support 
# paragraph based editing support, where text needs to be prosented per paragraph base, and so on...

# linking and spliting TextLayoutManager
# TextLayoutManager can be splitted and linked, in order to layout text continuously 
# in separated column 
# linked TextLayoutManager share text_storage, layout_manager, but have separate text_container
# And they reside in different Paragraph view

# Text Fit Mode
# Three are two text fitting mode
# one is fiiting text inside of the box, changing font size to fit
# and the other way is to layout text by give font size, expanding size or overflow
# for Pargaraph class, default fit mode is fit_font_size
# for Text class, default fit mode is fit_to_box_size

# Paragaph layout_lines
# TextLayoutManager is designed to make it easy for column layout of Paragraphs.
# I usually set text_container height to inserting column room. 
# after layout_lines, it will adjust Paragaph height to the used_rect + text_line_spaceing, if used rect is less than the given rect height
# but for the case when used rect height is larger, it sets text_overflow and I can retrive linked paragaph. 
# It will take care of Paragraph height setting and creating overflowing link.

# Thre are two main operation for TextLayoutManager
# first is layout_lines
#   it construct attributedSting and text_storage, ns_layouit_manager, and ns_text_storage
#   it creates ns_text_storage with owner_graphic height, it lays out lines.
#   if overflow occurs, text_overflow flag is set to true
#   if paragraph is linked, no line layout process is needed since it was done by the previous head link
#   it only need to draw lines
# and second is draw_text
#   it draws for corresponding text_container
#   for linked , draw_last_container(r) is called

module RLayout
  class TextLayoutManager
    attr_accessor :owner_graphic, :att_string, :text_container, :line_fragments, :token_list
    attr_accessor :current_token_index, :text_direction, :previous_link
    attr_accessor :text_markup, :text_overflow, :text_underflow, :text_storage, :ns_layout_manager, :ns_text_container
    def initialize(owner_graphic, options={})
      @owner_graphic = owner_graphic
      @att_string     = make_att_string_from_option(options)  
      if RUBY_ENGINE =='macruby'        
        @text_container = @owner_graphic.text_rect
        if options[:linked_text_layout_manager]
          @previous_link  = options[:linked_text_layout_manager]
          # linked TextLayoutManager
          # @ns_text_layout     = options[:ns_text_container]
          # @ns_text_container  = options[:ns_text_container]
          @text_direction = options.fetch(:text_direction, 'left_to_right') # top_to_bottom for Japanese
        else
          @att_string     = make_att_string_from_option(options)  
          @text_direction = options.fetch(:text_direction, 'left_to_right') # top_to_bottom for Japanese
          @width          = @text_container[2]
          @height         = @text_container[3]
          # line_fragments  = []
          # make_tokens
          # layout_lines_custom
          layout_lines(options) unless options[:layout_lines=>false]
        end
      else
        
      end
      self
    end
    
    def set_frame
      @text_container = @owner_graphic.text_rect
      layout_lines
    end
    
    #TODO
    def att_string_to_hash(att_string)
      Hash.new
    end
    
    def to_hash
      h = {}
      h[:previous_link] = @previous_link
      h[:text_markup]   = @text_markup
      h[:text_string]   = @att_string.string
      #TODO
      # h = att_string_to_hash(@att_string)
      h[:line_direction] = @line_direction if @line_direction == "vertical"
      h
    end
    
    def change_width_and_adjust_height(new_width, options={})
      if @text_container.nil?
        @text_container=[0,0,new_width,1000]
      else
        @text_container[2] = new_width
      end
      layout_lines
      # TODO change owner_graphic height
    end
    
    def make_atts
      @text_color = Graphic.convert_to_nscolor(@text_color)    unless @text_color.class == NSColor  
      atts={}
      atts[NSFontAttributeName]             = NSFont.fontWithName(@text_font, size:@text_size)
      atts[NSForegroundColorAttributeName]  = @text_color      
      if @guguri_width && @guguri_width < 0
        atts[NSStrokeWidthAttributeName] = atts_hash[:guguri_width] #0, -2,-5,-10 
        atts[NSStrokeColorAttributeName]=GraphicRecord.color_from_string(attributes[:guguri_color])
      end 
      
      if @text_tracking
        atts[NSKernAttributeName] = @text_tracking
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
    
    def make_att_string_from_option(options)
      if options[:atts_array]
        make_att_string_from_atts_array(options[:atts_array])
      else
        make_att_string(options)
      end
    end
    
    def make_att_string_from_atts_array(atts_array)
      att_string = NSMutableAttributedString.alloc.init
      atts_array.each do |atts|
        att_string.appendAttributedString(att_string(atts))
      end
      att_string
    end
    
    
    def make_att_string(options={})
      #TODO
      # implement text_fit_type
      # atts[NSKernAttributeName] = @text_track           if @text_track
      # implement inline element, italic, bold, underline, sub, super, emphasis(color)        
      if options[:text_markup]
        @text_markup = options[:text_markup]
      elsif options[:markup]
        @text_markup = options[:markup]
      else
        @text_markup = 'p'
      end
      # @text_markup    = options.fetch(:text_markup, 'p')
      # @text_markup    = options.fetch(:markup, "p")
      @text_string      = options.fetch(:text_string, "")
      @text_color       = options.fetch(:text_color, "black")
      @text_font        = options.fetch(:text_font, "Times")
      @text_size        = options.fetch(:text_size, 16)
      @text_line_spacing= options.fetch(:text_line_spacing, @text_size*1.5)
      @text_fit_type    = options.fetch(:text_fit_type, 0)
      @text_alignment   = options.fetch(:text_alignment, "center")
      @text_tracking    = options.fetch(:text_tracking, 0)  if options[:text_tracking ]      
      @text_first_line_head_indent    = options.fetch(:text_first_line_head_indent, 0)
      @text_head_indent               = options.fetch(:text_head_indent, 0)
      @text_tail_indent               = options.fetch(:text_tail_indent, 0)
      @text_paragraph_spacing_before  = options[:text_paragraph_spacing_before] if options[:text_paragraph_spacing_before]
      @text_paragraph_spacing         = options[:text_paragraph_spacing]        if options[:text_paragraph_spacing]
      att_string        =NSMutableAttributedString.alloc.initWithString(@text_string, attributes:make_atts)
      att_string
    end
    
    
    def make_tokens
      starting = 0
      # def initialize(att_string, start, length, text_direction)
      @token_list = []
      @text_storage.string.split(" ").collect do |token_string|
        @token_list << TextToken.new(@text_storage, starting, token_string.length, @text_direction, 'text_kind')
        starting += token_string.length
        @token_list << TextToken.new(@text_storage, starting, 1, @text_direction, 'space_kind')
        starting += 1
      end
      @token_list.last.token_type = 'end_of_para'
    end
    
    def body_line_height_multiple(head_para_height)
      # TODO
      # @style_service = @style_service ||= StyleService.new
      # body_height = @style_service.body_height
      body_height = 12
      body_multiple = body_height
      while body_multiple <= head_para_height
        body_multiple += body_height
      end
      body_multiple
    end
    
    def self.generate(owner_graphic, options={})
      RLayput::TextLayoutManager.new(owner_graphic, options)
    end
    
    # text_overflow and any line was created 
    def partialLy_inserted?
      @text_overflow && @ns_layout_manager.textContainers.count > 0
    end
    
    def line_count
      #TODO
      #used_rect/@text_size ???
      used_size=@ns_layout_manager.usedRectForTextContainer(@ns_text_container).size
      used_size.height/(@text_size + @text_line_spacing)
    end
    
    # do not break paragraph that is less than 4 lines
    # apply widow/orphan rule and last_line_small_char_set rule.
    def is_breakable?
      line_count >= 4
    end
    
    # text_layout_manager layout_lines
    # layout_lines lays out lines att_string into text_container
    #
    # it behaves differently, depending on fit_mode,
    # in fit_mode == fit_to_box mode
    #    text_size is reduced to fit into text_container
    #    proposed_height = @text_container[3]
    # in fit_mode == fit_font_size
    # there are two cases 
    # 1. when it's width has changed, before inserted into column, no parent_graphic
    #    proposed_height is set to 1000, meaning make height as long as it goes. 
    # 2. when it is layedout into column, 
    #    proposed_height is set to room of column, if it fits without overflow, we have successfully inserted paragraph into column
    #    if it doesn't fit it, overflow, ns_text_container should be split into two
    #    splited ns_layout_manager should be set as linked paragraphs ns_layout_manager
    
    def layout_lines(options={})
      # this is a link, so no need to layout lines
      # is is done by the head link
      return if !@previous_link.nil?
      if RUBY_ENGINE =='macruby' 
        # if @text_direction == 'left_to_right'
          @text_overflow = false
          @text_container = @owner_graphic.text_rect
          @text_storage = NSTextStorage.alloc.init
          @text_storage.setAttributedString @att_string
          proposed_height = @text_container[3]
          proposed_height = options[:proposed_height] if options[:proposed_height]
          @ns_text_container = NSTextContainer.alloc.initWithContainerSize(NSMakeSize(@text_container[2],proposed_height)) #[@width,1000]
          @ns_layout_manager = NSLayoutManager.alloc.init        
          @ns_layout_manager.addTextContainer(ns_text_container)
          @text_storage.addLayoutManager(@ns_layout_manager)
          range = @ns_layout_manager.glyphRangeForTextContainer(@ns_text_container)
          used_size=@ns_layout_manager.usedRectForTextContainer(@ns_text_container).size
          # adjust owner_graphics size
          # TODO if fit_mode is fit_box, reduce text_size to fit the text
          # split ns_text_container into two at given hight
          # this is usually the room of the column
          
          # owner_graphic.set_text_rect(used_size.height + @text_line_spacing)
          used_size.height += @text_line_spacing
          owner_graphic.adjust_height_with_text_height_change(used_size.height)
          @text_container[3] = used_size.height 
          if @text_markup && (@text_markup == 'h5' || @text_markup == 'h6') #&& options[:aling_to_grid]
            puts "we have running head ...."
            # Make the head paragraph height as body text multiples"
            # by adjusting @top_margin and @bottom_margin around it
            # body_multiple_height = body_line_height_multiple(@height)
            # @text_paragraph_spacing_before = (body_multiple_height - @height)/2
            # @text_paragraph_spacing        = @text_paragraph_spacing_before
            # @top_margin = (body_multiple_height - @height)/2
            # @bottom_margin = @top_margin
            # puts "body_multiple_height:#{body_multiple_height}"
            # @text_container[3] = body_multiple_height
            # @height = body_multiple_height
          end
          
          # set text_overflow
          # returns true, if the text overflows the text box
          # and also check if the overflow is text_undeflow
          # text_undeflow is when overflowing container doen's have any lines, no line fit into container area.
          firstContainer=@ns_layout_manager.textContainers.first
          @textStorage_length=@text_storage.string.length
          range=@ns_layout_manager.glyphRangeForTextContainer(firstContainer)
          last_char_index=range.location+range.length
          if @textStorage_length > last_char_index 
            @text_overflow = true
            if proposed_height < used_size.height
              @text_underflow = true
            end
            
          end
        # end
        # else
        #   # for vertival text
        #   # TODO using NSASTysetter sub class
        #   #  1. rotate glyphs 90 to left, except English and numbers
        #   #  1. rotate line 90 to right
        #   
        #   # NSLineBreakByCharWrapping
        #   
        #   # issues
        #   #  1. line height control
        #   #  1. horozontal alignment for non-square English, and commas.
        #   #  1. English string that rotates
        #   #  1. Two or more digit Numbers
        #   #  1. Commas, etc....
        #    
        #   v_line_count = @width/(@text_size + @text_line_spacing)
        #   y = @top_margin + @top_inset
        #   width = @text_size*0.7
        #   x = @width - width
        #   heigth = @height
        #   @vertical_lines = []
        #   v_line_count.to_i.times do
        #     @vertical_lines << NSMakeRect(x,y,width,height)
        #     x -= @text_size + @text_line_spacing
        #   end
        #   layout_manager = NSLayoutManager.alloc.init        
        #   text_storage.addLayoutManager(@ns_layout_manager)
        #   @vertical_lines.each do |v_line|
        #     @@ns_text_container = NSTextContainer.alloc.initWithContainerSize(v_line.size)
        #     @@ns_text_container.setLineFragmentPadding(0.0)
        #     @ns_layout_manager.addTextContainer(@ns_text_container)
        #     glyphRange=@ns_layout_manager.glyphRangeForTextContainer(@ns_text_container) 
        #     # if layout is done  
        #     # @height = body_multiple_height
        #     # origin = v_line.origin
        #     # origin.y = origin.y
        #     # @layout_manager.drawGlyphsForGlyphRange(glyphRange, atPoint:v_line.origin)
        #   end
        #   
          
        # end
      else
        # TODO
        # for non -macruby env
        # adjust height
        
      end
      
    end
    
    
    def layout_lines_custom
      current_token_index = 0
      y = 0
      height = @token_list[current_token_index].rect[3]
      # def initialize(token_list, starting_token_index,  proposed_rect, text_direction)
      proposed_rect = [0, y, @text_container[2], height]
      line = TextLine.new(@token_list, current_token_index, proposed_rect, @text_direction)
      puts "line:#{line}"
      current_token_index += line.length
      puts "line.last_token_index:#{line.last_token_index}"
      unless line.last_token_index == @token_list.length
        line = TextLine.new(current_token_index, current_token_index, proposed_rect, @text_direction)
        current_token_index += line.length
        y+= line[3]
      end
    end
    
    def shown_text_index
    
    end
    
    def line_height_sum
      
    end
    
    def text_rect
      @owner_graphic.text_rect
    end
    
    # This is used for laying out paragraphs into column
    # and we have to split the paragraph into two to fit,
    # but needing to keep text_storage linked as one.
    # create new paragraph with overflowing text to go to the next column.
    # They share same text_storage, ns_layout_manager, 
    # but new text_layout_manager with new ns_text_container for overflowing text
    def split_overflowing_paragraph
      if @text_overflow
        linked_container = NSTextContainer.alloc.initWithContainerSize(NSMakeSize(@text_container[2],500))
        @ns_layout_manager.addTextContainer(linked_container)
        range = @ns_layout_manager.glyphRangeForTextContainer(linked_container)
        used_size=@ns_layout_manager.usedRectForTextContainer(linked_container).size
        used_size.height += @text_line_spacing
        linked_container.setContainerSize(used_size)
        p = Paragraph.new(nil, linked_text_layout_manager: self)
        p.adjust_height_with_text_height_change(used_size.height)
        return p
      end
      nil
    end
    
    # called from linked paragraph to draw lineked container lines
    def draw_last_container(r)
      last_text_container = @ns_layout_manager.textContainers.last
      glyphRange=@ns_layout_manager.glyphRangeForTextContainer(last_text_container) 
      origin = r.origin
      origin.y = origin.y + @text_paragraph_spacing_before if @text_paragraph_spacing_before
      if @text_markup == 'h6'
        range=NSMakeRange(0,0)
        # puts atts = text_storage.attributesAtIndex(0, effectiveRange:range) 
      end
      @ns_layout_manager.drawGlyphsForGlyphRange(glyphRange, atPoint:origin)
    end
    
    def draw_text(r) 
      # is is done by the head link
      if @previous_link
        @previous_link.draw_last_container(r)
        return
      end
      
      if @text_direction == 'left_to_right'
        @text_storage = NSTextStorage.alloc.init
        @text_storage.setAttributedString @att_string
        @ns_text_container = NSTextContainer.alloc.initWithContainerSize(NSMakeSize(@text_container[2],@text_container[3])) #[@width,1000]
        @ns_layout_manager = NSLayoutManager.alloc.init        
        @ns_layout_manager.addTextContainer(ns_text_container)
        @text_storage.addLayoutManager(@ns_layout_manager)
        glyphRange=@ns_layout_manager.glyphRangeForTextContainer(@ns_text_container) 
        origin = r.origin
        origin.y = origin.y + @text_paragraph_spacing_before if @text_paragraph_spacing_before
        if @text_markup == 'h6'
          range=NSMakeRange(0,0)
          # puts atts = text_storage.attributesAtIndex(0, effectiveRange:range) 
        end
        @ns_layout_manager.drawGlyphsForGlyphRange(glyphRange, atPoint:origin)
        
        # atts1 = {
        #   NSFontAttributeName => NSFont.fontWithName('Helvetica', size:36.0),
        # }
        # str = "This is plane text for attstring"
        # attString1 = NSAttributedString.alloc.initWithString str, attributes:atts1
        # # attString1.drawAtPoint .origin
        # attString1.drawInRect(r)
        # context =NSGraphicsContext.currentContext.graphicsPort
        # CGContextSetTextMatrix(context, CGAffineTransformIdentity);
        # # CGContextSetTextMatrix(context, CGAffineTransformMakeScale(1, -1));
        # CGContextSetAllowsFontSmoothing(context, true);
        # CGContextSetShouldSmoothFonts(context, true);
        # framesetter = CTFramesetterCreateWithAttributedString(att_string);
        # path = CGPathCreateMutable()
        # bounds = CGRectMake(r.origin.x, r.origin.y, r.size.width, r.size.height)
        # CGPathAddRect(path, nil, bounds)
        # frame_attributes = {}
        # frame_attributes = NSDictionary.dictionaryWithObject(NSNumber.numberWithInt(1), forKey:"kCTFrameProgressionAttributeName")
        # # frame_attributes[kCTFrameProgressionAttributeName] = 1
        # frame = CTFramesetterCreateFrame(framesetter, CFRangeMake(0, 0), path, nil)

        # lines = CTFrameGetLines(frame)
        # y = @text_size
        # line_height = @text_size + @text_line_spacing
        # puts "r.size.height:#{bounds.size.height}"
        # lines.each do |line|
        #   CGContextSetTextPosition(context, 0, y)
        #   CTLineDraw(line, context)
        #   y += line_height
        # end
        # origins = Pointer.new('f')
        # 
        # CTFrameGetLineOrigins(frame, CFRangeMake(0,total), origins)
        # lines.each do |line|
        #   puts line
        # end

        # CTFrameDraw(frame, context)
        #     
        #
      
      
      else
        puts "vertival"
        v_line_count = @graphic.width/(@text_size + @text_line_spacing)            
        y = @graphic.top_margin + @graphic.top_inset
        width = @text_size*0.7
        x = @graphic.width - width - @graphic.right_inset - @graphic.right_margin
        height = @graphic.height  - @graphic.top_margin - @graphic.top_inset - @graphic.bottom_margin - @graphic.bottom_inset
        @vertical_lines = []

        v_line_count.to_i.times do
          @vertical_lines << NSMakeRect(x,y,width,height)
          x -= @text_size + @text_line_spacing
        end

        @vertical_lines.each do |v_line|
          @ns_text_container = NSTextContainer.alloc.initWithContainerSize(v_line.size)
          @ns_text_container.setLineFragmentPadding(0.0)
          @ns_layout_manager.addTextContainer(@ns_text_container)
          glyphRange=@ns_layout_manager.glyphRangeForTextContainer(@ns_text_container) 
          origin = v_line.origin
          origin.y = origin.y
          @ns_layout_manager.drawGlyphsForGlyphRange(glyphRange, atPoint:v_line.origin)
        end
      end
    end


  end
  
  class TextLine
    attr_accessor :text_container, :token_list, :starting_token_index, :length
    attr_accessor :text_direction, :line_rect
    
    def initialize(token_list, starting_token_index,  proposed_rect, text_direction)
      @token_list           = token_list
      @starting_token_index = starting_token_index
      @line_rect            = proposed_rect
      @length               = 0
      layout_line
      self
    end
    
    def last_token_index
      puts "@starting_token_index:#{@starting_token_index}"
      puts "@length:#{@length}"
      @starting_token_index + @length
    end
    
    def layout_line
      if @text_direction == 'left_to_right'
        current_x = 0
        unless (current_x + @token_list[starting_token_index + @length].width) >= line_rect[2]
          @length +=1
        end
      elsif @text_direction == 'top_to_bottom'
      
      end
      # do alignment of line
      
    end
    
    def draw_line(att_string)
      # @token_line[starting_token..length].each do |token|
      #   token.draw_token(att_string)
      # end
    end
    
  end
  
  class TextToken
    attr_accessor :start, :length, :rect
    attr_accessor :text_direction
    attr_accessor :token_type, :language, :token_type
  
    def initialize(att_string, start, length, text_direction, token_type)
      @text_direction = text_direction
      @start          = start
      @length         = length
      @token_type     = token_type
      layout_token(att_string)
      self
    end
  
    def layout_token(att_string)
      if @text_direction == 'left_to_right'
        token_att_string = att_string
        if @token_type == 'text_kind'
          @rect= [0,0,length*12, 12]
        else
          @rect= [0,0,6,12]
        end
      elsif @text_direction == 'top_to_bottom'
         puts "vertical case"
      end
      
    end
    
    def draw_token(att_string)
      
    end
  end
  
end

