
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

class GraphicViewMac < NSView
  
  attr_accessor :att_string
  
  def init_text
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
    # 
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
    atts[NSFontAttributeName]             = NSFont.fontWithName(@text_font, size:@text_size)
    atts[NSForegroundColorAttributeName]  = @text_color      

    if @guguri_width && @guguri_width < 0
      atts[NSStrokeWidthAttributeName] = atts_hash[:guguri_width] #0, -2,-5,-10 
      atts[NSStrokeColorAttributeName]=GraphicRecord.color_from_string(attributes[:guguri_color])
    end 
    
    newParagraphStyle  = NSMutableParagraphStyle.alloc.init
    newParagraphStyle.setAlignment(@text_alignment)
    newParagraphStyle.setLineSpacing(@text_line_spacing) if @text_line_spacing
    newParagraphStyle.setFirstLineHeadIndent(@text_first_line_head_indent) if @text_first_line_head_indent
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