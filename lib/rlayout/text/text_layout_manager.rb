# There two of ways to save Text data.
# 1. When entire Text has uniform attrbutes, use atts hash.
# 2. When Text has mixed attrbutes, keep them in atts_array

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

# Apple implemetation of  NSAttributtedString,
# Apple Text implemetation keeps whole string in one chunk, and attributes points to range.
# But, It makes it difficult to edit content, since you have to update the ranges of every following runs when you edit the text string, 
# it forces you to use additional tool to reconstuct the string. Not ideal for editing with a text editor.
# That is the reson why I am keeping attributes and string together in a single hash(atts).
# Make it much easier to edit them by Paragraph level.

# Using CoreText
# I am using CoreText functions rather than NSText, 
# CTFrame, CTLine, CTRun, CTToken,
# For vertical text, and finer controll
#
# 1. layout_ct_lines: 
#       lays out out lines with att_string and given width
#       it returns height for the layed out pargaph
#
# 2. Split:
#       using lines, and lines_range
#       lines keep: line_fragments that were layed out
#       lines_range: indicated the range of lines that belongs to the paragaph
#                     when paragraph is splitted, this will indicated where lines belong
# 3. Drawing:      
#       draw lines in lines_range
#       line cordinate are reversed in CoreText, so I have to draw from the top to bottom.
#
#   things I should implement
#   1. Dropcap, 
#   2. overlapping area with float, illegular shaped but continuous lines. 
#   3. inserting image paragraphs that flows along other paragraphs, 
#   4. drawing frames around paragraps, 
#   5. widow/orphan rule and last character sqeese options 
#   6. foot note and indexing support, I need to know colum position of the paragraph 
#   7. paragraph based editing support, where text needs to be prosented per paragraph base, and so on...
#   8. Squeeze text to fit

# Text Fit Mode
# Three are two text fitting mode
# one is fiiting text inside of the box, changing font size to fit
# and the other way is to layout text by give font size, expanding size or overflow
# for Text class, default fit mode is TEXT_FIT_TO_BOX = 0
# for Pargaraph class, default fit mode is TEXT_FIT_TO_FONT =1

# dropcap_lines = 2-3
# dropcap_char  = 1
# for dropcap:
# get first Droped Char rect
# 1. create path with dropcap_area 
# 2. layout text with range 1, 0
# 3. Draw Droped Char 
# dropcap_area


FIT_FONT_SIZE   = 0   # keep given font size
FIT_TO_BOX      = 1   # change font size to fit text into box 

# TODO
FIT_EACH_LINE   = 2   # adjust font size for each line to fit text into lines.
                      # So, fewer the text, larger the font size becomes in for each line
                      # And reduce the size of the lines propotionally to fit the entire lines in text box.

module RLayout
  class TextLayoutManager
    attr_accessor :owner_graphic, :att_string
    attr_accessor :text_direction, :text_markup
    attr_accessor :frame_setter, :frame, :line_count, :text_size, :linked
    attr_accessor :drop_lines, :drop_char, :drop_char_width, :drop_char_height
    attr_accessor :text_fit_type, :text_overflow, :text_underflow
    attr_accessor :proposed_path, :proposed_line_count
    def initialize(owner_graphic, options={})
      @owner_graphic = owner_graphic
      @text_fit_type = @owner_graphic.text_fit_type if @owner_graphic
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
      # puts "body_height:#{body_height}"
      body_multiple = ((head_para_height/body_height).to_i + 1)*body_height
    end
    
    # do not break paragraph that is less than 4 lines
    # apply widow/orphan rule and last_line_small_char_set rule.
    def is_breakable?
      @line_count >= 4
    end
    
    # this is line layout using CoreText
    # This allows me to do illefular shaped container layout easier than using NSTextContainer
    def layout_ct_lines(options={})
      @text_overflow  = false
      @text_underflow = false
      proposed_height = @owner_graphic.height
      proposed_height = options[:proposed_height] if options[:proposed_height]
      proposed_width  = @owner_graphic.width      
      proposed_width  = options[:proposed_width] if options[:proposed_width]
      @proposed_path   = CGPathCreateMutable()
      bounds          = CGRectMake(0, 0, proposed_width, 1000)
      CGPathAddRect(@proposed_path, nil, bounds)
      @frame          = CTFramesetterCreateFrame(@frame_setter,CFRangeMake(0, 0), @proposed_path, nil)
      @line_count = CTFrameGetLines(@frame).count  
      if @line_count == 0
        puts "++++++++++ @line_count is 0 ++++++++ "
      end
      line_height = @text_size + @text_line_spacing
      used_size_height = @line_count*line_height
      # if @text_markup && (@text_markup == 'h5' || @text_markup == 'h6') #&& options[:aling_to_grid]
      if @text_markup && (@text_markup != 'p') #&& options[:aling_to_grid]
        # puts "markup is :#{@text_markup}"
        # Make the head paragraphs height as body text multiples"
        used_size_height = body_line_height_multiple(used_size_height)
        # puts  "used_size_height:#{used_size_height}"
      end
      @proposed_line_count = (proposed_height/line_height).to_i
      proposed_line_height = @proposed_line_count*line_height
      # set text_overflow and under flow
      if used_size_height > proposed_line_height
        @text_overflow = true            
        @text_underflow = true if @proposed_line_count == 0 # no line was created
      end
      # return height 
      if @text_fit_type != FIT_TO_BOX 
        @owner_graphic.adjust_size_with_text_height_change(proposed_width, used_size_height)
        @proposed_line_count = @line_count
      end
      @line_count*(@text_size + @text_line_spacing)
      
    end
    
    ############ text fitting #######
    # fit text to box by reducing font size
    # 1. calculate box of current att_string
    # 2. compare it with current text_rect to  box ratio
    # 3. take the min value of w,h
    # 3. reduce font by the ratio
    # 4. See if they fit, and adjust font size for best fit
    def new_font_size_for_fit
      text_size             = @att_string.size   
      proposed_total_width  = @proposed_line_count*@owner_graphic.text_rect[2]
      # puts "proposed_total_width:#{proposed_total_width}"
      # puts "text_size.width:#{text_size.width}"
      height                = @owner_graphic.text_rect[3]
      w                     = proposed_total_width/text_size.width
      h                     = height/text_size.height 
      # if heightis less than the full font height
      # puts "@proposed_line_count:#{@proposed_line_count}"
      if  @proposed_line_count <= 1
        h= 0.8
      end    
      scale                 = [w,h].min
      # puts "w:#{w}"
      # puts "h:#{h}"
      # puts "scale:#{scale}"
      @text_size*scale
    end
    
    def fit_text_to_box
      puts "@att_string.string:#{@att_string.string}"
      puts "@text_overflow :#{@text_overflow }"
      # return unless @text_fit_type == FIT_TO_BOX      
      return unless @text_overflow    
      new_size = new_font_size_for_fit
      @text_size = new_size
      # change @att_string with new font size
      range=NSMakeRange(0,0)
      atts=@att_string.attributesAtIndex(0, effectiveRange:range)
      current_font = atts[NSFontAttributeName].fontName
      new_font_atts = {}
      new_font_atts[NSFontAttributeName] = NSFont.fontWithName(current_font, size:new_size)
      range=NSMakeRange(0,@att_string.length)
      # add new attribute to @att_string
      @att_string.addAttributes(new_font_atts, range:range)
      # relayout lines 
      @frame_setter = CTFramesetterCreateWithAttributedString(@att_string)
      @frame        = CTFramesetterCreateFrame(@frame_setter,CFRangeMake(0, 0), @proposed_path, nil)
      @line_count   = CTFrameGetLines(@frame).count  
      @proposed_line_count = @line_count
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
      @proposed_path       = CGPathCreateMutable()      
      bounds              = CGRectMake(@drop_char_width, 0, @right_side_width, @drop_char_height)
      CGPathAddRect(@proposed_path, nil, bounds)
      @right_size_frame   = CTFramesetterCreateFrame(@frame_setter,CFRangeMake(0, 0), @proposed_path, nil)
      range               = CTFrameGetVisibleStringRange(@right_size_frame)      
      last_char_position=range.location + range.length
      if last_char_position < @att_string.length
        # still left over string after right_side_frame
        @proposed_path     = CGPathCreateMutable()
        bounds            = CGRectMake(0, @drop_char_height, proposed_width, 1000)
        CGPathAddRect(@proposed_path, nil, bounds)
        @frame            = CTFramesetterCreateFrame(@frame_setter,CFRangeMake(0, 0), @proposed_path, nil)
        @line_count       = CTFrameGetLines(@frame).count      
        used_size_height  = @line_count*(@text_size + @text_line_spacing) + @drop_char_height
        # set text_overflow and under flow
        @owner_graphic.adjust_size_with_text_height_change(proposed_width, used_size_height)
      else
        @owner_graphic.adjust_size_with_text_height_change(proposed_width, @drop_char_height)
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
      @proposed_path           = CGPathCreateMutable()
      bounds                  = CGRectMake(0, 0, current_rect[2], current_rect[3])
      CGPathAddRect(@proposed_path, nil, bounds)
      # re-generate first half with first string only 
      @frame                  = CTFramesetterCreateFrame(@frame_setter,CFRangeMake(0,second_half_position), @proposed_path, nil)
      @lines_array            = CTFrameGetLines(@frame)
      @owner_graphic.tag = "first half"
      # puts " first half @lines_array.length:#{@lines_array.length}"
      owner_graphic.adjust_height_with_text_height_change(truncation_position)
      # create second half frame
      @proposed_path           = CGPathCreateMutable()
      bounds                  = CGRectMake(0, 0, current_rect[2], 1000)
      CGPathAddRect(@proposed_path, nil, bounds)
      second_half_frame       = CTFramesetterCreateFrame(@frame_setter,CFRangeMake(second_half_position, 0), @proposed_path, nil)
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
    
    # draw only proposed_line
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
        line_height     = @text_size + @text_line_spacing
        line_width      = @owner_graphic.text_rect[2]
        # @lines_array.each_with_index do |line, i|
        # draw only the lines that fit in proposed area, proposed_line_count
        @lines_array[0..(@proposed_line_count - 1)].each_with_index do |line, i|
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

