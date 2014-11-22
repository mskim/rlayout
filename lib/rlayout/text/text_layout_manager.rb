
# Using CoreText
# 1. layout_ct_lines: 
#       this lays out out lines with att_string and given width
#       it returns height for the layed out pargaph
# 2. Split:
#       using lines, and lines_range
#       lines keep: line_fragments that were layed out
#       lines_range: indicated the range of lines that belongs to the paragaph
#                     when paragraph is splitted, this will indicated where lines belong
# 3. Drawing:      
#       draw lines in lines_range
#
#
#   things I should implement
#   1. Dropcap, 
#   2. overlapping area with float, illegular shaped but continuous lines. 
#   3. inserting image paragraphs that flows along other paragraphs, 
#   4. drawing frames around paragraps, 
#   5. widow/orphan rule and last character sqeese options 
#   6. foot note and indexing support, I need to know colum position of the paragraph 
#   7. paragraph based editing support, where text needs to be prosented per paragraph base, and so on...

# Text Fit Mode
# Three are two text fitting mode
# one is fiiting text inside of the box, changing font size to fit
# and the other way is to layout text by give font size, expanding size or overflow
# for Pargaraph class, default fit mode is fit_font_size
# for Text class, default fit mode is fit_to_box_size


module RLayout
  class TextLayoutManager
    attr_accessor :owner_graphic, :att_string
    attr_accessor :text_direction, :text_markup, :first_half_line_count, :second_half_lines_location
    attr_accessor :frame_setter, :frame, :line_count, :text_size, :lines_array, :lines_location, :lines_length
    def initialize(owner_graphic, options={})
      @owner_graphic = owner_graphic
      return if @owner_graphic.nil?
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
      # layout_ct_lines
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
    
    # do not break paragraph that is less than 4 lines
    # apply widow/orphan rule and last_line_small_char_set rule.
    def is_breakable?
      @line_count >= 4
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
      bounds          = CGRectMake(0, 0, proposed_width, 1000)
      CGPathAddRect(proposed_path, nil, bounds)
      @frame          = CTFramesetterCreateFrame(@frame_setter,CFRangeMake(0, 0), proposed_path, nil)
      @lines_array    = CTFrameGetLines(@frame)
      @line_count     = @lines_array.count
      if @line_count == 0
        puts "++++++++++ @line_count is 0 ++++++++ "
      end
      used_size_height = @line_count*(@text_size + @text_line_spacing)
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
      # return height 
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
      @owner_graphic.tag = "front_half"
      # get the line ending before the position
      @line_count   = @lines_array.count
      line_height = @text_size + @text_line_spacing
      @first_half_line_count = (position/line_height).to_i
      #TODO i should add each line heights, I am assuming all line have same height
      truncation_position = @first_half_line_count*line_height
      owner_graphic.adjust_height_with_text_height_change(truncation_position)
      # range         = CTFrameGetVisibleStringRange(@frame)      
      # last_char_position = range.location + range.length
      # puts "last_char_position:#{last_char_position}"
      # second_half_lines = @line_count - first_half_lines
      @second_half_lines_location = @first_half_line_count
      second_half_lines_length = @line_count - @first_half_line_count
      second_half_height = second_half_lines_length*line_height
      layout_manager_copy                 = self.dup # make a copy
      layout_manager_copy.first_half_line_count = nil
      layout_manager_copy.lines_location  = @second_half_lines_location
      @second_half_lines_location = nil
      layout_manager_copy.lines_length    = second_half_lines_length
      second_paragraph = Paragraph.new(nil, layout_expand: [:width], linked_text_layout_manager: layout_manager_copy, tag:"second_half")
      second_paragraph.adjust_height_with_text_height_change(second_half_height)
      return second_paragraph
    end
    
    def text_rect
      @owner_graphic.text_rect
    end
        
    def draw_text(r) 
      return unless  @att_string
      if @text_direction == 'left_to_right'
        if @owner_graphic.tag == "front_half"
        end
        if @owner_graphic.tag == "split_second_half"
        end
        context = NSGraphicsContext.currentContext.graphicsPort
        CGContextSetTextMatrix(context, CGAffineTransformIdentity)
        CGContextSetTextMatrix(context, CGAffineTransformMakeScale(1, -1))
        # CTFrameDraw(@frame, context)
        # lines = CTFrameGetLines(@frame)
        y = @text_size
        line_height = @text_size + @text_line_spacing
        line_width  = @owner_graphic.text_rect[2]
        # line_width  = 245
        # lines.each_with_index do |line, i|
        # :lines_array, :lines_location, :lines_length
        lines_location = 0            unless @lines_location
        lines_length   = @line_count  unless @lines_length
        # @lines_array[lines_location..lines_length].each_with_index do |line, i|
        @lines_array.each_with_index do |line, i|
          if @first_half_line_count
            next if i >= @first_half_line_count
          end
          if @second_half_lines_location 
            next if  i< @second_half_lines_location
           end
        # @lines.each_with_index do |line, i|
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

end

