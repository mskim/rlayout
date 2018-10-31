class GraphicViewMac < NSView
  def ns_bounds_path_for_graphic(graphic)
    shape_class = graphic.shape.class
    case shape_class.to_s
    when RLayout::RectStruct.to_s
      path = NSBezierPath.bezierPathWithRect(ns_bounds_rect(graphic))
    when RLayout::RoundRectStruct.to_s
      path = NSBezierPath.bezierPathWithRect(ns_bounds_rect(graphic))
    when RLayout::CircleStruct.to_s
      path = NSBezierPath.bezierPathWithOvalInRect(ns_bounds_rect(graphic))
    when RLayout::EllipseStruct.to_s
      path = NSBezierPath.bezierPathWithOvalInRect(ns_bounds_rect(graphic))
    when RLayout::LineStruct.to_s

    when RLayout::PoligonStruct.to_s

    when RLayout::BezierStruct.to_s

    else
      path = NSBezierPath.bezierPathWithRect(ns_bounds_rect(graphic))
    end
    path
  end

  def ns_fill_path_for_graphic(graphic)
    shape_class = graphic.shape.class
    case shape_class.to_s
    when RLayout::RectStruct.to_s
      path = NSBezierPath.bezierPathWithRect(ns_fill_rect(graphic))
    when RLayout::RoundRectStruct.to_s
      path = NSBezierPath.bezierPathWithRect(ns_bounds_rect(graphic))
    when RLayout::CircleStruct.to_s
      path = NSBezierPath.bezierPathWithOvalInRect(ns_bounds_rect(graphic))
    when RLayout::EllipseStruct.to_s
      path = NSBezierPath.bezierPathWithOvalInRect(ns_bounds_rect(graphic))
    when RLayout::LineStruct.to_s

    when RLayout::PoligonStruct.to_s

    when RLayout::BezierStruct.to_s

    else
      path = NSBezierPath.bezierPathWithRect(ns_bounds_rect(graphic))
    end
    path
  end
  
  

end
