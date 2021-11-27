module RLayout

  attr_accessor :shape_type, :shape_bezier, :shape_corners

  class Graphic
    def init_shape(options)
      @shape              = options.fetch(:shape, RectStruct.new(x:@x, y:@y, width: @width, height: @height))
      @shape_corners      = options.fetch(:shape_corners, shape_defaults[:shape_corners])
      @shape_bezier       = options.fetch(:shape_bezier, shape_defaults[:shape_bezier])
    end
    
    def shape_defaults
      h = {}
      h[:shape_type]        = "rectangle" # rectangle, round_rect', circle, ellipse, bezier
      h[:shape_corners]     = nil         # [1,1,1,1], [1,0,1,0,"round" ] # round, inverse, flat, ribbon, reverse_ribbon
      h[:shape_bezier]      = nil         # path
      h
    end
  end
end
