
class GraphicViewMac < NSView
  
  # image_frame: original image size
  # @graphic_rect: graphic rect in CGRect
  # @graphic_rect: graphic rect in CGRect
  attr_accessor :graphic_rect
  def draw_image(graphic)      
    return unless graphic.image_object
    @graphic_bounds = NSMakeRect(0, 0, graphic.width, graphic.height) 
    # If I want to displace image with reduced % , I have to make the source_frame larger
    if graphic.image_fit_type == IMAGE_FIT_TYPE_IGNORE_RATIO 
      graphic.image_object.drawInRect(@graphic_bounds, fromRect:NSZeroRect, operation:NSCompositeSourceOver, fraction:1.0, respectFlipped:true, hints:nil) if graphic.image_object
    else
      graphic.image_object.drawInRect(@graphic_bounds, fromRect:graphic.source_frame, operation:NSCompositeSourceOver, fraction:1.0, respectFlipped:true, hints:nil) if graphic.image_object
    end
  end 
end