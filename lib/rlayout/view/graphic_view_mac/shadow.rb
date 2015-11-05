
class GraphicViewMac < NSView
  attr_accessor :shadow
  def draw_shadow(graphic)
    return unless graphic.shadow
    @shadow = NSShadow.alloc.init
    shadow_nscolor = convert_to_nscolor(graphic.shadow.color)    unless graphic.shadow.color.class == NSColor  
    @shadow.setShadowColor(shadow_nscolor) 
    @shadow.setShadowOffset(NSSize.new(graphic.shadow.x_offset, graphic.shadow.y_offset)) 
    @shadow.setShadowBlurRadius(graphic.shadow.blur_radius)
    @shadow.set
  end
end