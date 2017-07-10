
class GraphicViewMac < NSView

  def draw_fill(graphic)
    return if graphic.nil?

    if graphic.fill.class == RLayout::FillStruct
      path       = ns_bounds_path_for_graphic(graphic)
      fill_color = graphic.fill.color
      unless fill_color.class == NSColor
        fill_color = RLayout.convert_to_nscolor(fill_color)
      end

      fill_color.set if fill_color
      path.fill

    elsif  graphic.fill.class == RLayout::LinearGradient
      #TO Linea Fill
      strating_color  = graphic.fill.starting_color
      strating_color  = RLayout.convert_to_nscolor(strating_color)    unless strating_color.class == NSColor
      ending_color    = graphic.fill.ending_color
      ending_color    = RLayout.convert_to_nscolor(ending_color)    unless ending_color.class == NSColor
      myGradient      = NSGradient.alloc.initWithStartingColor(strating_color, endingColor:ending_color)
      path            = ns_bounds_path_for_graphic(graphic)
      myGradient.drawInBezierPath(path, angle:graphic.fill.angle)

    elsif graphic.fill.class == RLayout::RadialGradient
      #TO Radial Fill
      strating_color  = graphic.fill.starting_color
      strating_color  = RLayout.convert_to_nscolor(strating_color)    unless strating_color.class == NSColor
      ending_color    = graphic.fill.ending_color
      ending_color    = RLayout.convert_to_nscolor(ending_color)    unless ending_color.class == NSColor
      myGradient      = NSGradient.alloc.initWithStartingColor(strating_color, endingColor:ending_color)
      path            = NSBezierPath.bezierPathWithRect(r)
      myGradient.drawInBezierPath(path, relativeCenterPosition:graphic.fill.center)
    end
  end
end
