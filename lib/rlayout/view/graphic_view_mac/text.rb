
class GraphicViewMac < NSView
  
  # draw only proposed_line
  def draw_text(graphic)
    puts __method__
    text_layout_manager = graphic.text_layout_manager
    puts "text_layout_manager:#{text_layout_manager}"
    puts "text_layout_manager.att_string.string:#{text_layout_manager.att_string.string}"
    
    glyphRange=text_layout_manager.layout_manager.glyphRangeForTextContainer(text_layout_manager.text_container)
    origin = NSMakePoint(graphic.left_margin + graphic.left_inset, graphic.top_margin + graphic.top_inset) #graphic.y
    text_layout_manager.layout_manager.drawGlyphsForGlyphRange(glyphRange, atPoint:origin)
  end

end