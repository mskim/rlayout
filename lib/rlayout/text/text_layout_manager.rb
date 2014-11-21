
# Unlike NSText System, I am using text_storage per Paragraph bases. 
# Each paragraph has own storage, lanyout_manager, and text_container,
# only when Paragraph are linked, multiple text_container are utilized.
# This is done to gain more drawing control over each Paragraph, 
# to containing text in separate views, 
# for tasks, such as 
#   1. Dropcap, 
#   2. overlapping area with float, illegular shaped but continuous lines. 
#   3. inserting image paragraphs that flows along other paragraphs, 
#   4. drawing frames around paragraps, 
#   5. widow/orphan rule and last character sqeese options 
#   6. foot note and indexing support, I need to know colum position of the paragraph 
#   7. paragraph based editing support, where text needs to be prosented per paragraph base, and so on...

# linking and spliting TextLayoutManager
# TextLayoutManager can be splitted and linked, in order to layout text continuously 
# in separated column 

# for using CoreText
# linked TextLayoutManager share CTFrameSetter, but have separate CTFrame
# And they reside in different Paragraph view

# when using NSTextSystem
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
    attr_accessor :owner_graphic, :att_string, :line_fragments, :token_list
    attr_accessor :current_token_index, :text_direction, :text_container, :is_linked
    attr_accessor :text_markup, :text_overflow, :text_underflow, :text_storage
    attr_accessor :frame_setter, :frame, :line_count, :text_size
    def initialize(owner_graphic, options={})
      @owner_graphic = owner_graphic
      return if @owner_graphic.nil?
      @is_linked = false
      @text_direction = options.fetch(:text_direction, 'left_to_right') # top_to_bottom for Japanese
      if RUBY_ENGINE =='macruby' 
        @att_string     = make_att_string_from_option(options)  
        @frame_setter= CTFramesetterCreateWithAttributedString(@att_string)
        layout_ct_lines(options) unless options[:layout_lines=>false]
      else
        
      end
      self
    end
    
    def set_frame
      # @text_container = @owner_graphic.text_rect
      layout_ct_lines
    end
    
    #TODO
    def att_string_to_hash(att_string)
      Hash.new
    end
    
    def to_hash
      h = {}
      h[:text_markup]   = @text_markup
      h[:text_string]   = @att_string.string
      #TODO
      # h = att_string_to_hash(@att_string)
      h[:line_direction] = @line_direction if @line_direction == "vertical"
      h
    end
    
    def change_width_and_adjust_height(new_width, options={})
      @text_container=setContainerSize(NSMakeSize(new_width,1000))
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
      right_align       = NSMutableParagraphStyle.alloc.init.setAlignment(NSRightTextAlignment)          
      center_align      = NSMutableParagraphStyle.alloc.init.setAlignment(NSCenterTextAlignment)          
      justified_align   = NSMutableParagraphStyle.alloc.init.setAlignment(NSJustifiedTextAlignment)          
      newParagraphStyle = NSMutableParagraphStyle.alloc.init # default is left align
      
      case @text_alignment
      when "right"
        newParagraphStyle = right_align
      when "center"
        newParagraphStyle = center_align
        # puts "newParagraphStyle.inspect:#{newParagraphStyle.inspect}"
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
    
    
    # text_overflow and any line was created 
    def partialLy_inserted?
      @text_overflow && @line_count > 0
    end
        
    # do not break paragraph that is less than 4 lines
    # apply widow/orphan rule and last_line_small_char_set rule.
    def is_breakable?
      @line_count >= 4
    end
    
    # layout text with given width
    def create_ct_lines(frame_setter, text_width)
      proposed_path = CGPathCreateMutable()
      bounds = CGRectMake(0, 0, @owner_graphic.width, proposed_height)
      CGPathAddRect(proposed_path, nil, bounds)
      proposed_frame = CTFramesetterCreateFrame(frame_setter,CFRangeMake(0, 0), proposed_path, nil)
      lines = CTFrameGetLines(proposed_frame)
      line_count = lines.count
      used_size_height = @line_count*(@text_size + @text_line_spacing)
    end
    
    # this is line layout using CoreText
    # This will allow me to do illefular shaped container layout
    def layout_ct_lines(options={})
      @text_overflow  = false
      @text_underflow = false
      proposed_height = @owner_graphic.height
      proposed_height = options[:proposed_height] if options[:proposed_height]
      proposed_width  = @owner_graphic.width
      proposed_width  = options[:proposed_width] if options[:proposed_width]
      proposed_path   = CGPathCreateMutable()
      bounds          = CGRectMake(0, 0, proposed_width, proposed_height)
      CGPathAddRect(proposed_path, nil, bounds)
      proposed_frame  = CTFramesetterCreateFrame(@frame_setter,CFRangeMake(0, 0), proposed_path, nil)
      lines           = CTFrameGetLines(proposed_frame)
      @line_count     = lines.count
      if @line_count == 0
        puts "options:#{options}"
        puts "++++++++++ @line_count is 0 ++++++++ "
        puts "@att_string.string:#{@att_string.string}"
        puts ""
      end
      used_size_height = @line_count*(@text_size + @text_line_spacing)
      
      # regeneate frame with actual height, maybe no need for this
      path = CGPathCreateMutable()
      bounds = CGRectMake(0, 0, proposed_width, used_size_height)
      CGPathAddRect(path, nil, bounds)
      @frame = CTFramesetterCreateFrame(@frame_setter,CFRangeMake(0, 0), path, nil)
      if @text_markup && (@text_markup == 'h5' || @text_markup == 'h6') #&& options[:aling_to_grid]
        # Make the head paragraphs height as body text multiples"
      end
      # set text_overflow and under flow
      owner_graphic.adjust_size_with_text_height_change(proposed_width, used_size_height)
      range = CTFrameGetVisibleStringRange(@frame)      
      last_char_position=range.location + range.length
      if @att_string.length > last_char_position 
        @text_overflow = true            
        @text_underflow = true if @line_count == 0 # no line was created
      end
      @line_count*(@text_size + @text_line_spacing)
    end
    
    def text_height
      @line_count*(@text_size + @text_line_spacing)
    end
    # 
    def can_split_at?(position)
      if position > @line_count*(@text_size + @text_line_spacing)
        return false
      elsif position < MININUM_LINES_FOR_SPLIT*(@text_size + @text_line_spacing)
        return false
      end
      true
    end
    
    # split text_layout_manager into two at position
    def split_at(position)
      first_frame_path = CGPathCreateMutable()
      bounds      = CGRectMake(0, 0, text_rect[WIDTH_VAL], position)
      CGPathAddRect(first_frame_path, nil, bounds)
      @frame        = CTFramesetterCreateFrame(@frame_setter,CFRangeMake(0, 0), first_frame_path, nil)
      lines         = CTFrameGetLines(@frame)
      @line_count   = lines.count
      used_size_height = @line_count*(@text_size + @text_line_spacing)
      owner_graphic.adjust_height_with_text_height_change(used_size_height)
      range         = CTFrameGetVisibleStringRange(@frame)      
      last_char_position=range.location + range.length
      second_size_height = text_rect[HEIGHT_VAL] - used_size_height
      second_frame_path = CGPathCreateMutable()
      bounds = CGRectMake(0, 0, @owner_graphic.width, text_rect[WIDTH_VAL],second_size_height)
      second_frame = CTFramesetterCreateFrame(@frame_setter,CFRangeMake(last_char_position, 0), second_frame_path, nil)
      layout_manager_copy = self.dup # make a copy
      layout_manager_copy.frame_setter = @frame_setter
      layout_manager_copy.frame = second_frame
      layout_manager_copy.is_linked = true
      second_paragraph = Paragraph.new(nil, linked_text_layout_manager: layout_manager_copy)
      second_paragraph.adjust_height_with_text_height_change(used_size_height)
      return second_paragraph
    end
    
    def text_rect
      @owner_graphic.text_rect
    end
        
    def draw_text(r) 
      return unless  @att_string
      if @text_direction == 'left_to_right'
        context = NSGraphicsContext.currentContext.graphicsPort
        CGContextSetTextMatrix(context, CGAffineTransformIdentity)
        CGContextSetTextMatrix(context, CGAffineTransformMakeScale(1, -1))
        # CTFrameDraw(@frame, context)
        lines = CTFrameGetLines(@frame)
        y = @text_size
        line_height = @text_size + @text_line_spacing
        line_width  = text_rect[WIDTH_VAL]
        lines.each_with_index do |line, i|
          x = 0
          # get text width
          text_width =  CTLineGetTypographicBounds(line, nil, nil,nil)
          room = line_width - text_width
          # do alignment and first line indent here
          # do center, right alignment here
          case @text_alignment
          when 'left'
          when 'center'
            x += room/2
          when 'right'
            x += room
          when 'justified'
            x += @text_first_line_head_indent if i == 0
          end
          CGContextSetTextPosition(context, x, y)
          CTLineDraw(line, context)
          y += line_height
        end        
      else

      end
    end

  end
  # 
  # class TextLine
  #   attr_accessor :text_container, :token_list, :starting_token_index, :length
  #   attr_accessor :text_direction, :line_rect
  #   
  #   def initialize(token_list, starting_token_index,  proposed_rect, text_direction)
  #     @token_list           = token_list
  #     @starting_token_index = starting_token_index
  #     @line_rect            = proposed_rect
  #     @length               = 0
  #     layout_line
  #     self
  #   end
  #   
  #   def last_token_index
  #     puts "@starting_token_index:#{@starting_token_index}"
  #     puts "@length:#{@length}"
  #     @starting_token_index + @length
  #   end
  #   
  #   def layout_line
  #     if @text_direction == 'left_to_right'
  #       current_x = 0
  #       unless (current_x + @token_list[starting_token_index + @length].width) >= line_rect[WIDTH_VAL]
  #         @length +=1
  #       end
  #     elsif @text_direction == 'top_to_bottom'
  #     
  #     end
  #     # do alignment of line
  #     
  #   end
  #   
  #   def draw_line(att_string)
  #     # @token_line[starting_token..length].each do |token|
  #     #   token.draw_token(att_string)
  #     # end
  #   end
  #   
  # end
  # 
  # class TextToken
  #   attr_accessor :start, :length, :rect
  #   attr_accessor :text_direction
  #   attr_accessor :token_type, :language, :token_type
  # 
  #   def initialize(att_string, start, length, text_direction, token_type)
  #     @text_direction = text_direction
  #     @start          = start
  #     @length         = length
  #     @token_type     = token_type
  #     layout_token(att_string)
  #     self
  #   end
  # 
  #   def layout_token(att_string)
  #     if @text_direction == 'left_to_right'
  #       token_att_string = att_string
  #       if @token_type == 'text_kind'
  #         @rect= [0,0,length*12, 12]
  #       else
  #         @rect= [0,0,6,12]
  #       end
  #     elsif @text_direction == 'top_to_bottom'
  #        puts "vertical case"
  #     end
  #     
  #   end
  #   
  #   def draw_token(att_string)
  # end
  
end

