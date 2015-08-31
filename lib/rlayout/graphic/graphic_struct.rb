
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
      h = {}
      h[:color]     = color if color
      h
    end
  end
  
  LinearGradient= Struct.new(:starting_color, :ending_color, :angle, :steps)
  RadialGradient= Struct.new(:starting_color, :ending_color, :center, :steps)
  StrokeStruct    = Struct.new(:color, :thickness, :dash, :line_cap, :line_join, :type, :sides) do
    def to_svg
      s = "stroke:#{color};"
      s += "stroke-width:#{thickness}" if thickness > 0
      s += "dash:#{dash}" if dash
      s
    end
    def to_hash
      h = {}
      h[:color]     = color if color
      h[:thickness] = thickness if thickness
      h[:dash]      = dash if dash
      h[:line_cap]  = line_cap if line_cap
      h[:line_join] = line_join if line_join
      h[:type]      = type if type
      h[:sides]     = sides if sides
      h
    end
  end
  # CornersStruct   = Struct.new(:top_left, :top_right, :bottom_right, :bottom_left, :type)
  # SidesStruct     = Struct.new(:left, :top, :right, :bottom, :type)
  RectStruct      = Struct.new(:x, :y, :width, :height) do
    def to_svg
      "<rect x=\"#{x}\" y=\"#{y}\" width=\"#{width}\" height=\"#{height}\" replace_this_with_style></rect>"
    end
    def to_hash
      h = {}
      h[:x]       = x if x
      h[:y]       = y if y
      h[:width]   = width if width
      h[:height]  = height if height
      h    
    end
  end
  
  RoundRectStruct = Struct.new(:x, :y, :width, :height, :rx, :ry, :corners) do
    def to_svg
      "<rect x=\"#{x}\" y=\"#{y}\" width=\"#{width}\" height=\"#{height}\" rx=\"#{rx}\" ry=\"#{ry}\" replace_this_with_style />"
    end
    def to_hash
      h = {}
      h[:x]       = x if x
      h[:y]       = y if y
      h[:width]   = width if width
      h[:height]  = height if height
      h[:rx]      = rx if rx
      h[:ry]      = ry if ry
      h[:corners] = corners if corners
      h    
    end
  end
  
  CircleStruct    = Struct.new(:cx, :cy, :r) do
    def to_svg
      "<circle cx=\"#{cx}\" cy=\"#{cy}\" r=\"#{r}\" replace_this_with_style />"
    end
    def to_hash
      h = {}
      h[:cx]  = cx if cx
      h[:cy]   = cy if cy
      h[:r]   = r if r
      h    
    end
  end
  
  EllipseStruct   = Struct.new(:cx, :cy, :rx, :ry) do
    def to_svg
      "<ellipse cx=\"#{cx}\" cy=\"#{cy}\" rx=\"#{rx}\" ry=\"#{ry}\" replace_this_with_style />"
    end
    def to_hash
      h = {}
      h[:cx]  = cx if cx
      h[:cy]  = cy if cy
      h[:rx]  = rx if rx
      h[:ry]  = ry if ry
      h    
    end
    
  end
  
  LineStruct      = Struct.new(:x1, :y1, :x2, :y2, :h_direction, :v_direction) do
    def to_svg
      mid_y = y1 + (y2 - y1)/2
      "<line x1=\"#{x1}\" y1=\"#{mid_y}\" x2=\"#{x2}\" y2=\"#{mid_y}\" replace_this_with_style />"
    end
    def to_hash
      h = {}
      # self.to_h.delete_if{|k,v| v.nil?}
      h
    end
  end
  
  PoligonStruct   = Struct.new(:points, :style) do
    def to_svg
      #TODO
    end
    def to_hash
      h = {}
      # self.to_h.delete_if{|k,v| v.nil?}
      h
    end
  end
  BezierStruct = Struct.new(:points, :style) do
    def to_svg
      #TODO
    end
    def to_hash
      to_h
      # self.to_h.delete_if{|k,v| v.nil?}
    end
  end
  
  GridStruct = Struct.new(:grid_base, :grid_width, :grid_height, :gutter, :v_gutter) do
    def to_hash
      h = {}
      # self.to_h.delete_if{|k,v| v.nil?}
      h
    end    
  end
  
  AttsRunStruct = Struct.new(:position, :length, :size, :color, :font, :style) do
    def to_hash
      h = {}
      # self.to_h.delete_if{|k,v| v.nil?}
      h
    end
  end
  
  TextStruct = Struct.new(:string, :size, :color, :font, :style) do
    def to_hash
      h = {}
      h[:string]  = string if string
      h[:size]    = size if size
      h[:color]   = color if color
      h[:font]    = font if font
      h[:style]   = style if style
      h    
    end
    
    def to_svg
      "<text font-size=\"#{size}\" replace_this_with_text_origin fill=\"#{color}\">#{string}</text>\n"
    end
  end
  
  ImageStruct = Struct.new(:image_path, :fit_type, :rotation) do
    def to_hash
      to_h
      # self.to_h.delete_if{|k,v| v.nil?}
    end
    
    def to_svg
      "<image replace_this_with_rect xlink:href=\"#{image_path}\"></image>"
    end
  end
  
  ParagraphStruct = Struct.new(:string, :markup, :footnote, :index) do
    def to_hash
      to_h
      # self.to_h.delete_if{|k,v| v.nil?}
    end
  end
  
end

