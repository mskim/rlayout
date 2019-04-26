class NewsBoxViewMac < GraphicViewMac

  def draw_graphic_in_nsview(graphic)
    @context  = NSGraphicsContext.currentContext
    transform = NSAffineTransform.transform
    @context.saveGraphicsState
    graphic.y = 0 if graphic.y == nil
    transform.translateXBy(graphic.x, yBy: graphic.y)
    transform.concat
    # draw_fill(graphic)            if graphic.fill
    # draw_grid_rects(graphic)      if graphic.class == RLayout::TextColumn
    draw_graphics
    draw_floats
    draw_stroke(graphic)               if graphic.stroke
    @context.restoreGraphicsState
  end

  def draw_graphics
    puts "draw_graphics"
  end

  def draw_floats
    puts "draw_floats"
  end
end