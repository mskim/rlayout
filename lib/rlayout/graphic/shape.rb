module RLayout

  attr_accessor :shape_type, :shape_bezier, :shape_corners, :shape_corner_type, :shape_sides, :shape_side_type

  class Graphic
    def init_shape(options)
      shorter = @width < @height ? @width : @height
      r= shorter/10      
      @shape              = options.fetch(:shape, RoundRectStruct.new(@x, @y, @width, @height, r, r))
      @shape_corners      = options.fetch(:shape_corners, shape_defaults[:shape_corners])
      @shape_corner_type  = options.fetch(:shape_corner_type, shape_defaults[:shape_corner_type])
      @shape_sides        = options.fetch(:shape_sides, shape_defaults[:shape_sides])
      @shape_side_type    = options.fetch(:shape_side_type, shape_defaults[:shape_side_type])
      @shape_bezier       = options.fetch(:shape_bezier, shape_defaults[:shape_bezier])
    end
    
    def shape_defaults
      h = {}
      h[:shape_type]        = "rectangle" # rectangle, round_rect', circle, ellipse, bezier
      h[:shape_corners]     = nil         # [1,1,1,1], [1,0,1,0]
      h[:shape_corner_type] = nil   # round, inverse, flat
      h[:shape_sides]       = nil         # [1,1,1,1], [1,0,1,0]
      h[:shape_side_type]   = nil   # round, inverse, flat, ribbon, reverse_ribbon
      h[:shape_bezier]      = nil     # path
    end
  end
end
