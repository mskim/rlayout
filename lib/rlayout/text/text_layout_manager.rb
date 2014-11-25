
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

# dropcap_lines = 2-3
# dropcap_char  = 1
# for dropcap:
# get first Droped Char rect
# 1. create path with dropcap_area 
# 2. layout text with range 1, 0
# 3. Draw Droped Char 
# dropcap_area
module RLayout
  class TextLayoutManager
    attr_accessor :owner_graphic, :att_string
    attr_accessor :text_direction, :text_markup
    attr_accessor :frame_setter, :frame, :line_count, :text_size, :linked
    attr_accessor :drop_lines, :drop_char, :drop_char_width, :drop_char_height
    def initialize(owner_graphic, options={})
      @owner_graphic = owner_graphic
      # return if @owner_graphic.nil?
      @text_direction = options.fetch(:text_direction, 'left_to_right') # top_to_bottom for Japanese
      if RUBY_ENGINE =='macruby' 
        if options[:drop_lines]
          @drop_lines   = options[:drop_lines]
          @drop_char     = options[:text_string][0]
          options[:text_string] =  options[:text_string][1..-1]
          @att_string   = make_att_string_from_option(options)  
          @frame_setter = CTFramesetterCreateWithAttributedString(@att_string)
          layout_drop_cap_lines(options) unless options[:layout_lines=>false]
        else
          @att_string     = make_att_string_from_option(options)  
          @frame_setter   = CTFramesetterCreateWithAttributedString(@att_string)
          layout_ct_lines(options) unless options[:layout_lines=>false]
        end
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
      @text_line_spacing= options.fetch(:text_line_spacing, @text_size*1.2)
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
      body_height = @owner_graphic.body_height
      body_multiple = (head_para_height/body_height).to_i
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
      if @line_count == 0
        puts "++++++++++ @line_count is 0 ++++++++ "
      end
      @line_count = CTFrameGetLines(@frame).count      
      used_size_height = @line_count*(@text_size + @text_line_spacing)
      if @text_markup && (@text_markup == 'h5' || @text_markup == 'h6') #&& options[:aling_to_grid]
        # Make the head paragraphs height as body text multiples"
        used_size_height = body_line_height_multiple(used_size_height)
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
    
    # layout layout_drop_cap_lines
    # @drop_ct_line: CTLine with drop char 
    # @drop_frame:   CTFrame with side lines
    # @dropped_att_string
    # @att_string: att_string without dropped char
    # @frame:        CTFrame with rest of lines
    def layout_drop_cap_lines(options)
      @drop_char_height      = @drop_lines*(@text_size + @text_line_spacing)
      proposed_width    = @owner_graphic.width
      proposed_width    = options[:proposed_width] if options[:proposed_width]
      drop_text_font    = options.fetch(:drop_text_font, 'Helvetica')
      drop_text_color   = options.fetch(:drop_text_color, @text_color)
      drop_text_color   = Graphic.convert_to_nscolor(drop_text_color)    unless drop_text_color.class == NSColor  
      atts={}
      @drop_char_text_size                  = @drop_char_height    
      atts[NSFontAttributeName]             = NSFont.fontWithName(drop_text_font, size:@drop_char_text_size)
      atts[NSForegroundColorAttributeName]  = drop_text_color  
      drop_char_att_string                  = NSMutableAttributedString.alloc.initWithString(@drop_char, attributes:atts)
      @drop_ct_line       = CTLineCreateWithAttributedString(drop_char_att_string)
      @drop_char_width    = CTLineGetTypographicBounds(@drop_ct_line, nil, nil,nil)
      @right_side_width   = proposed_width - @drop_char_width
      proposed_path       = CGPathCreateMutable()      
      bounds              = CGRectMake(@drop_char_width, 0, @right_side_width, @drop_char_height)
      CGPathAddRect(proposed_path, nil, bounds)
      @right_size_frame   = CTFramesetterCreateFrame(@frame_setter,CFRangeMake(0, 0), proposed_path, nil)
      range = CTFrameGetVisibleStringRange(@right_size_frame)      
      last_char_position=range.location + range.length
      if last_char_position < @att_string.length
        # still left over string after right_side_frame
        proposed_path       = CGPathCreateMutable()
        bounds              = CGRectMake(0, @drop_char_height, proposed_width, 1000)
        CGPathAddRect(proposed_path, nil, bounds)
        @frame   = CTFramesetterCreateFrame(@frame_setter,CFRangeMake(0, 0), proposed_path, nil)
        @line_count = CTFrameGetLines(@frame).count      
        used_size_height = @line_count*(@text_size + @text_line_spacing) + @drop_char_height
        # set text_overflow and under flow
        owner_graphic.adjust_size_with_text_height_change(proposed_width, used_size_height)
      else
        owner_graphic.adjust_size_with_text_height_change(proposed_width, @drop_char_height)
      end
     end
    
    def text_height
      @line_count*(@text_size + @text_line_spacing)
    end
    # 
    def can_split_at?(position)
      if @drop_lines
        # do not allow split for dropcapped case
        return false
      end
      if position > @line_count*(@text_size + @text_line_spacing)
        return false
      elsif position < MININUM_LINES_FOR_SPLIT*(@text_size + @text_line_spacing)
        return false
      end
      true
    end
    
    # split text_layout_manager into two at position
    def split_at(position)
      @lines_array    = CTFrameGetLines(@frame)
      line_height             = @text_size + @text_line_spacing
      first_half_line_count   = (position/line_height).to_i
      #TODO i should add each line heights, I am assuming all line have same height
      truncation_position     = first_half_line_count*line_height
      last_line_of_first_half = @lines_array[first_half_line_count-1]
      last_line_range         = CTLineGetStringRange(last_line_of_first_half)    
      second_half_position    = last_line_range.location + last_line_range.length
      first_half_range = NSMakeRange(0, second_half_position)
      current_rect            = @owner_graphic.text_rect
      proposed_path           = CGPathCreateMutable()
      bounds                  = CGRectMake(0, 0, current_rect[2], current_rect[3])
      CGPathAddRect(proposed_path, nil, bounds)
      # re-generate first half with first string only 
      @frame                  = CTFramesetterCreateFrame(@frame_setter,CFRangeMake(0,second_half_position), proposed_path, nil)
      @lines_array            = CTFrameGetLines(@frame)
      @owner_graphic.tag = "first half"
      # puts " first half @lines_array.length:#{@lines_array.length}"
      owner_graphic.adjust_height_with_text_height_change(truncation_position)
      # create second half frame
      proposed_path           = CGPathCreateMutable()
      bounds                  = CGRectMake(0, 0, current_rect[2], 1000)
      CGPathAddRect(proposed_path, nil, bounds)
      second_half_frame       = CTFramesetterCreateFrame(@frame_setter,CFRangeMake(second_half_position, 0), proposed_path, nil)
      second_half_lines_length= CTFrameGetLines(second_half_frame).count
      second_half_height      = second_half_lines_length*line_height
      layout_manager_copy     = self.dup # make a copy
      layout_manager_copy.frame =second_half_frame
      layout_manager_copy.linked= true
      second_paragraph        = Paragraph.new(nil, layout_expand: [:width], linked_text_layout_manager: layout_manager_copy)
      second_paragraph.adjust_size_with_text_height_change(current_rect[2], second_half_height)
      return second_paragraph
    end
    
    def text_rect
      @owner_graphic.text_rect
    end
        
    def draw_text(r) 
      if @text_direction == 'left_to_right'
        context = NSGraphicsContext.currentContext.graphicsPort
        CGContextSetTextMatrix(context, CGAffineTransformIdentity)
        CGContextSetTextMatrix(context, CGAffineTransformMakeScale(1, -1))
        y = @text_size
        if @drop_lines
          # draw drop char
          CGContextSetTextPosition(context, 1, @drop_char_text_size - 10)
          
          CTLineDraw(@drop_ct_line, context)
          # draw right_size_frame
          @lines_array    = CTFrameGetLines(@right_size_frame)
          @line_count     = @lines_array.count      
          line_height = @text_size + @text_line_spacing
          #TODO I shuld get the width from @frame
          line_width  = @right_side_width
          @lines_array.each_with_index do |line, i|
            x_offset = @drop_char_width + 2
            text_width =  CTLineGetTypographicBounds(line, nil, nil,nil)
            room = line_width - text_width
            # alignment and first line indent done here
            # center, right alignment done here
            case @text_alignment
            when 'left'
            when 'center'
              x_offset += room/2
            when 'right'
              x_offset += room
            when 'justified'
              #first line head indent, but not for linked part first line
              x_offset += @text_first_line_head_indent if i == 0 && @linked != true
            end

            CGContextSetTextPosition(context, x_offset, y)
            CTLineDraw(line, context)
            y += line_height
          end
          
        end
        return unless @frame
        @lines_array    = CTFrameGetLines(@frame)
        @line_count     = @lines_array.count      
        # y = @text_size
        line_height = @text_size + @text_line_spacing
        #TODO I shuld get the width from @frame
        line_width  = @owner_graphic.text_rect[2]
        @lines_array.each_with_index do |line, i|
          x_offset = 0
          text_width =  CTLineGetTypographicBounds(line, nil, nil,nil)
          room = line_width - text_width
          # alignment and first line indent done here
          # center, right alignment done here
          case @text_alignment
          when 'left'
          when 'center'
            x_offset += room/2
          when 'right'
            x_offset += room
          when 'justified'
            #first line head indent, but not for linked part first line
            x_offset += @text_first_line_head_indent if i == 0 && @linked != true
          end
          
          CGContextSetTextPosition(context, x_offset, y)
          CTLineDraw(line, context)
          y += line_height
        end        
      else

      end
    end

  end

end

