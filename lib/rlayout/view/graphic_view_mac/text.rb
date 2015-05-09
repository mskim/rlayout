
class GraphicViewMac < NSView
  
  # draw only proposed_line
  def draw_text(graphic)
    text_layout_manager = graphic.text_layout_manager
    glyphRange=text_layout_manager.layout_manager.glyphRangeForTextContainer(text_layout_manager.text_container)
    origin = NSMakePoint(graphic.left_margin + graphic.left_inset, graphic.top_margin + graphic.top_inset) #graphic.y
    text_layout_manager.layout_manager.drawGlyphsForGlyphRange(glyphRange, atPoint:origin)
  end

end