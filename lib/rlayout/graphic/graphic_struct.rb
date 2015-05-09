
KLASS_NAMES =%w[Rectangle Circle RoundRect Ellipse Line Text Image]
TEXT_STRING_SAMPLES =["This is a text", "Good Morning", "Nice", "Cool", "RLayout", "PageScript"]
IMAGE_TYPES = %w[pdf jpg tiff png PDF JPG TIFF]

# NAMED_COLORS        = %w[black white blue yellow lightGray darkGray gray brown green orange clear cyan magenta].sample
STROKE_TYPES        = %w[single double double1 double2 tripple tripple1 tripple2 tripple3 tripple4 tripple5]
CORNER_SHAPE_TYPES  = %w[inverted_rect round inverted_round slash]
SIDE_SHAPE_TYPES    = %w[round inverted_round ribbon roman_knife]

module RLayout
  
  ColorStruct     = Struct.new(:name) do    
    def sample
      COLOR_NAMES.sample
    end
  end
  CMYKStruct      = Struct.new(:c, :m, :y, :k, :a)
  RGBStruct       = Struct.new(:r, :g, :b, :a)
  FillStruct      = Struct.new(:color) do
    def to_svg
      color
    end
    def to_hash
      to_h.delete_if{|k,v| v.nil?}
    end
  end
  
  LinearGradient= Struct.new(:starting_color, :ending_color, :angle, :steps)
  RadialGradient= Struct.new(:starting_color, :ending_color, :center, :steps)
  StrokeStruct    = Struct.new(:color, :thickness, :dash, :line_cap, :line_join, :type) do
    def to_svg
      s = "stroke:#{color};"
      s += "stroke-width:#{thickness}" if thickness > 0
      s += "dash:#{dash}" if dash
      s
    end
    def to_hash
      to_h.delete_if{|k,v| v.nil?}
    end
  end
  CornersStruct   = Struct.new(:top_left, :top_right, :bottom_right, :bottom_left, :type)
  SidesStruct     = Struct.new(:left, :top, :right, :bottom, :type)
  RectStruct      = Struct.new(:x, :y, :width, :height) do
    def to_svg
      "<rect x=\"#{x}\" y=\"#{y}\" width=\"#{width}\" height=\"#{height}\" replace_this_with_style></rect>"
    end
    def to_hash
      to_h.delete_if{|k,v| v.nil?}
    end
  end
  
  RoundRectStruct = Struct.new(:x, :y, :width, :height, :rx, :ry, :corners) do
    def to_svg
      "<rect x=\"#{x}\" y=\"#{y}\" width=\"#{width}\" height=\"#{height}\" rx=\"#{rx}\" ry=\"#{ry}\" replace_this_with_style />"
    end
    def to_hash
      to_h.delete_if{|k,v| v.nil?}
    end
  end
  
  CircleStruct    = Struct.new(:cx, :cy, :r) do
    def to_svg
      "<circle cx=\"#{cx}\" cy=\"#{cy}\" r=\"#{r}\" replace_this_with_style />"
    end
    def to_hash
      to_h.delete_if{|k,v| v.nil?}
    end
  end
  
  EllipseStruct   = Struct.new(:cx, :cy, :rx, :ry) do
    def to_svg
      "<ellipse cx=\"#{cx}\" cy=\"#{cy}\" rx=\"#{rx}\" ry=\"#{ry}\" replace_this_with_style />"
    end
    def to_hash
      to_h.delete_if{|k,v| v.nil?}
    end
    
  end
  
  LineStruct      = Struct.new(:x1, :y1, :x2, :y2, :h_direction, :v_direction) do
    def to_svg
      mid_y = y1 + (y2 - y1)/2
      "<line x1=\"#{x1}\" y1=\"#{mid_y}\" x2=\"#{x2}\" y2=\"#{mid_y}\" replace_this_with_style />"
    end
    def to_hash
      to_h.delete_if{|k,v| v.nil?}
    end
  end
  
  PoligonStruct   = Struct.new(:points, :style) do
    def to_svg
      #TODO
    end
    def to_hash
      to_h.delete_if{|k,v| v.nil?}
    end
  end
  BezierStruct = Struct.new(:points, :style) do
    def to_svg
      #TODO
    end
    def to_hash
      to_h.delete_if{|k,v| v.nil?}
    end
  end
  
  TextStruct= Struct.new(:string, :size, :color, :font, :style, :alignment) do
    def to_hash
      to_h.delete_if {|key,value| value==nil}
    end
    
    def to_svg
      #TODO
      # "<text string= #{string}></text>"
      # "<text font-size=\"#{size}\" x=\"#{@x}\" y=\"#{@y + size*1.2}\" fill=\"#{color}\">#{string}</text>\n"
      "<text font-size=\"#{size}\" replace_this_with_text_origin fill=\"#{color}\">#{string}</text>\n"
    end
    
  end
  
  ImageStruct = Struct.new(:image_path, :fit_type, :rotation) do
    def to_hash
      to_h.delete_if {|key,value| value==nil}
    end
    
    def to_svg
      "<image replace_this_with_rect xlink:href=\"#{image_path}\"></image>"
    end
  end
end

