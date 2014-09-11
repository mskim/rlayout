
# Thre are coupe of different types of text

# Text
# StyledText
# Paragaraph
# DropBoxParagraph < Container
# Header < Container
# TextBar < Container

# TEXT_ALIGNMENT_LEFT       = NSLeftTextAlignment
# TEXT_ALIGNMENT_RIGHT      = NSRightTextAlignment
# TEXT_ALIGNMENT_CENTER     = NSCenterTextAlignment
# TEXT_ALIGNMENT_JUSTIFIED  = NSJustifiedTextAlignment
# TEXT_ALIGNMENT_NATURAL    = NSJustifiedTextAlignment

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
    @text_style     = @data.fetch(:text_style, text_defaults[:text_style])
    @text_color     = @data.fetch(:text_color, text_defaults[:text_color])
    @text_alignment = @data.fetch(:text_alignment, text_defaults[:text_alignment])
    # convert to NSColor
    
    @text_color  = convert_to_nscolor(@text_color)    unless @text_color.class == NSColor  
    case @text_alignment 
    when "left"
      @text_alignment = NSLeftTextAlignment
    when "right"
      @text_alignment = NSRightTextAlignment
    when "center"
      @text_alignment = NSCenterTextAlignment
    when "justified"
      @text_alignment = NSJustifiedTextAlignment
    else
      @text_alignment = NSLeftTextAlignment
    end
    
    @att_string = att_string
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
    # puts "+++++++"  
    # puts @data[:klass]
    # puts r.origin.x
    # puts r.origin.y
    return if @att_string.string == ""
    puts @att_string.string
    @att_string.drawInRect(r)
  end

  def att_string
    
    #TODO
    # implement text_fit_type
    # atts[NSKernAttributeName] = @text_track           if @text_track
    right_align   = NSMutableParagraphStyle.alloc.init.setAlignment(NSRightTextAlignment)          
    center_align  = NSMutableParagraphStyle.alloc.init.setAlignment(NSCenterTextAlignment)          
    
    
    atts={}
    atts[NSFontAttributeName]             = NSFont.fontWithName(@text_font, size:@text_size)
    atts[NSForegroundColorAttributeName]  = @text_color      

    if @guguri_width && @guguri_width < 0
      atts[NSStrokeWidthAttributeName] = atts_hash[:guguri_width] #0, -2,-5,-10 
      atts[NSStrokeColorAttributeName]=GraphicRecord.color_from_string(attributes[:guguri_color])
    end 
    
    if @text_alignment != 0
      newParagraphStyle  = NSMutableParagraphStyle.alloc.init
      newParagraphStyle.setAlignment(@text_alignment)
      atts[NSParagraphStyleAttributeName] = newParagraphStyle         
    end     
    att_string=NSMutableAttributedString.alloc.initWithString(@text_string, attributes:atts)
    att_string
  end
  
  
end