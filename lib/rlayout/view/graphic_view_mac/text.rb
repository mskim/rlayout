
class GraphicViewMac < NSView
  
  # draw only proposed_line
  def draw_text(graphic)
    text_layout_manager = graphic.text_layout_manager  
    # if text_layout_manager.is_a?(RLayout::RTextLayoutManager)
    #   text_layout_manager.draw_text 
    #   return
    # end
    glyphRange=text_layout_manager.layout_manager.glyphRangeForTextContainer(text_layout_manager.text_container)
    text_vertical_offset = 0
    text_vertical_offset = text_layout_manager.text_vertical_offset if text_layout_manager.text_vertical_offset
    origin = NSMakePoint(graphic.left_margin + graphic.left_inset, text_vertical_offset) #graphic.y
    text_layout_manager.layout_manager.drawGlyphsForGlyphRange(glyphRange, atPoint:origin)
  end

end