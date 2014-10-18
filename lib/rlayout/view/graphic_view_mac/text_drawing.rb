
# Thre are coupe of different types of text

# Text
# StyledText
# Paragaraph
# DropBoxParagraph < Container
# Header < Container
# TextBar < Container

# NSLeftTextAlignment
# NSRightTextAlignment
# NSCenterTextAlignment
# NSJustifiedTextAlignment
# NSNaturalTextAlignment


# CTFrame
# CTLIne
# CTRun
# CGGlyph
framework 'ApplicationServices'

class GraphicViewMac < NSView
  
  attr_accessor :att_string
  
  def init_text
    @text_direction = @data.fetch(:text_direction, 'left_to_right')
    @text_string    = @data.fetch(:text_string, "")
    @text_fit_type  = @data.fetch(:text_fit_type, text_defaults[:text_fit_type])
    @text_font      = @data.fetch(:text_font, text_defaults[:text_font])
    @text_size      = @data.fetch(:text_size, text_defaults[:text_size])
    @text_line_spacing = @data.fetch(:text_line_spacing, nil)
    @text_style     = @data.fetch(:text_style, text_defaults[:text_style])
    @text_color     = @data.fetch(:text_color, text_defaults[:text_color])
    @text_alignment = @data.fetch(:text_alignment, text_defaults[:text_alignment])
    @text_first_line_head_indent    = @data.fetch(:text_first_line_head_indent, nil)
    @text_paragraph_spacing_before  = @data[:text_paragraph_spacing_before] if @data[:text_paragraph_spacing_before]
    @text_paragraph_spacing         = @data[:text_paragraph_spacing] if @data[:text_paragraph_spacing]
    @text_color                     = convert_to_nscolor(@text_color)    unless @text_color.class == NSColor  
    
    case @text_alignment 
    when "left"
      @text_alignment = NSLeftTextAlignment
    when "right"
      @text_alignment = NSRightTextAlignment
    when "center"
      @text_alignment = NSCenterTextAlignment
    when "justified"
      @text_alignment = NSJustifiedTextAlignment
    when "natural"
      @text_alignment = NSNaturalTextAlignment
    else
      @text_alignment = NSLeftTextAlignment
    end
    @att_string = make_att_string_from(@data)
    # convert to NSRect
  end
  
  def text_defaults
    h={}
    h[:text_fit_type] = 0
    h[:text_color] = 0
    h[:text_font] = "Times"
    h[:text_size] = 14
    h[:text_style] = 0
    h[:text_alignment] = "left" #0
    h
  end
  
  def draw_text(r)  
    return if @att_string.string == ""
    # @att_string.drawInRect(r)
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
    if @text_direction == 'left_to_right'
      @text_storage=NSTextStorage.alloc.init
      @text_storage.setAttributedString @att_string
      @layout_manager = NSLayoutManager.alloc.init        
      @text_storage.addLayoutManager(@layout_manager)
      @text_container = NSTextContainer.alloc.initWithContainerSize(r.size)
      @text_container.setLineFragmentPadding(0.0)
      @layout_manager.addTextContainer(@text_container)
      glyphRange=@layout_manager.glyphRangeForTextContainer(@text_container) 
      origin = r.origin
      origin.y = origin.y + @data[:text_paragraph_spacing_before] if @data[:text_paragraph_spacing_before]
      @layout_manager.drawGlyphsForGlyphRange(glyphRange, atPoint:r.origin)
    else
      v_line_count = @data[:width]/(@text_size + @text_line_spacing)            
      y = @data[:top_margin] + @data[:top_inset]
      width = @text_size*0.7
      x = @data[:width] - width - @data[:right_inset] - @data[:right_margin]
      height = @data[:height]  - @data[:top_margin] - @data[:top_inset] - @data[:bottom_margin] - @data[:bottom_inset]
      @vertical_lines = []
             
      v_line_count.to_i.times do
        @vertical_lines << NSMakeRect(x,y,width,height)
        x -= @text_size + @text_line_spacing
      end
      
      @text_storage=NSTextStorage.alloc.init
      @text_storage.setAttributedString @att_string
      @layout_manager = NSLayoutManager.alloc.init        
      @text_storage.addLayoutManager(@layout_manager)
      @vertical_lines.each do |v_line|
        @text_container = NSTextContainer.alloc.initWithContainerSize(v_line.size)
        @text_container.setLineFragmentPadding(0.0)
        @layout_manager.addTextContainer(@text_container)
        glyphRange=@layout_manager.glyphRangeForTextContainer(@text_container) 
        origin = v_line.origin
        origin.y = origin.y
        @layout_manager.drawGlyphsForGlyphRange(glyphRange, atPoint:v_line.origin)
      end
      
      
      
      
    end
  end
  
  def isFlipped
    true
  end
  
  def make_att_string_from(data={})
    if data[:atts_array]
      return atts_array_to_att_string(data[:atts_array])
    else
      return att_string
    end
  end
  
  def atts_array_to_att_string(atts_array)
    text_storage = NSTextStorage.alloc.init
    atts_array.each do |atts|
      att_string.appendAttributedString(att_string(atts))
    end
    text_storage
  end
    
  def att_string
    #TODO
    # implement text_fit_type
    # atts[NSKernAttributeName] = @text_track           if @text_track
    # implement inline element, italic, bold, underline, sub, super, emphasis(color)
    atts={}
    atts[NSFontAttributeName]     = NSFont.fontWithName(@text_font, size:@text_size)
    if atts[NSFontAttributeName].nil?
      puts "font nameed #{@text_font} not found!!"
      @text_font = "Times"
      atts[NSFontAttributeName]   = NSFont.fontWithName(@text_font, size:@text_size)
    end
    
    atts[NSForegroundColorAttributeName]  = @text_color      
    atts["kCTVerticalFormsAttributeName"]  = true # for vertical      

    if @guguri_width && @guguri_width < 0
      atts[NSStrokeWidthAttributeName] = atts_hash[:guguri_width] #0, -2,-5,-10 
      atts[NSStrokeColorAttributeName]=GraphicRecord.color_from_string(attributes[:guguri_color])
    end 
    
    newParagraphStyle  = NSMutableParagraphStyle.alloc.init
    newParagraphStyle.setAlignment(@text_alignment)
    newParagraphStyle.setLineSpacing(@text_line_spacing) if @text_line_spacing
    newParagraphStyle.setFirstLineHeadIndent(@text_first_line_head_indent) if @text_first_line_head_indent
    newParagraphStyle.setHeadIndent(@text_head_indent) if @text_head_indent
    newParagraphStyle.setTailIndent(@text_tail_indent) if @text_tail_indent
    newParagraphStyle.setParagraphSpacingBefore(@text_paragraph_spacing_before) if @text_paragraph_spacing_before
    newParagraphStyle.setParagraphSpacing(@text_paragraph_spacing) if @text_paragraph_spacing    
    atts[NSParagraphStyleAttributeName] = newParagraphStyle         
    # end     
    att_string=NSMutableAttributedString.alloc.initWithString(@text_string, attributes:atts)
    att_string
  end
  
  def make_att_string(string, font, size, options={})
    atts={}
    atts[NSFontAttributeName] = NSFont.fontWithName(font, size:size)
    att_string=NSMutableAttributedString.alloc.initWithString(string, attributes:atts)
  end
end