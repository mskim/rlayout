
class GraphicViewMac < NSView

  def draw_image(graphic)
    return unless graphic.image_object
      #draw dummy image
    unless File.exist?(graphic.image_path)
      r = ns_bounds_rect(graphic)
      drawLine(r, withTrap:0)
      draw_x(r)
      return
    end
    r = graphic.layout_rect
    @graphic_bounds = NSMakeRect(r[0],r[1],r[2],r[3])
    if graphic.image_fit_type == IMAGE_FIT_TYPE_IGNORE_RATIO
      graphic.image_object.drawInRect(@graphic_bounds, fromRect:NSZeroRect, operation:NSCompositeSourceOver, fraction:1.0, respectFlipped:true, hints:nil) if graphic.image_object
    else
      graphic.image_object.drawInRect(@graphic_bounds, fromRect:graphic.source_frame, operation:NSCompositeSourceOver, fraction:1.0, respectFlipped:true, hints:nil) if graphic.image_object
    end
  end

end
