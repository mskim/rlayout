
class GraphicViewMac < NSView

  def draw_image(graphic)      
    return unless graphic.image_object
    @graphic_bounds = NSMakeRect(0, 0, graphic.width, graphic.height) 
    if graphic.image_fit_type == IMAGE_FIT_TYPE_IGNORE_RATIO 
      graphic.image_object.drawInRect(@graphic_bounds, fromRect:NSZeroRect, operation:NSCompositeSourceOver, fraction:1.0, respectFlipped:true, hints:nil) if graphic.image_object
    else
      graphic.image_object.drawInRect(@graphic_bounds, fromRect:graphic.source_frame, operation:NSCompositeSourceOver, fraction:1.0, respectFlipped:true, hints:nil) if graphic.image_object
    end
  end 
end