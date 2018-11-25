
class GraphicViewMac < NSView
  # draw only proposed_line
  def draw_text(graphic)
    if graphic.is_a?(RLayout::TextToken) || graphic.is_a?(RLayout::RTextToken) || graphic.is_a?(RLayout::LeaderToken)
      graphic.draw_text
      return
    else
      text_layout_manager = graphic.text_layout_manager
      glyphRange=text_layout_manager.layout_manager.glyphRangeForTextContainer(text_layout_manager.text_container)
      text_vertical_offset = graphic.top_margin + graphic.top_inset
      # text_vertical_offset = text_layout_manager.text_vertical_offset if text_layout_manager.text_vertical_offset
      origin = NSMakePoint(graphic.left_margin + graphic.left_inset, text_vertical_offset) #graphic.y
      text_layout_manager.layout_manager.drawGlyphsForGlyphRange(glyphRange, atPoint:origin)
    end
  end

end
