
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

    def color2hex(name)
      return name.sub("#", "") if name =~/^#/
      unless COLOR_LIST[upcase_first_letter(name)]
        return COLOR_LIST['Black']
      end
      COLOR_LIST[upcase_first_letter(name)].sub("#", "")
    end

    def to_pdf(canvas)
      canvas.fill_color= color2hex(color)
    end
  end

  LinearGradient = Struct.new(:starting_color, :ending_color, :angle, :steps) do
    def to_pdf(canvas)

    end
  end

  RadialGradient = Struct.new(:starting_color, :ending_color, :center, :steps) do
    def to_pdf(canvas)

    end
  end
  StrokeStruct   = Struct.new(:color, :thickness, :dash, :line_cap, :line_join, :type, :sides, :rule) do
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

    def to_pdf(canvas)
      canvas.stroke
    end

  end

  ShadowStruct      = Struct.new(:color, :x_offset, :y_offset, :blur_radius)

  GutterStrokeStruct = Struct.new(:color, :thickness, :dash, :type)
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

    def to_key_value
      [:rectangle, to_hash]
    end

    def to_pdf(canvas)
      canvas.rectangle(x, y, width, height)
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

    def to_key_value
      [:rectangel, to_hash]
    end

    def to_pdf(canvas)
      canvas.rectangle(@x, @y, @width, @height, radius: @round)
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

    def to_key_value
      [:circle, to_hash]
    end

    def to_pdf(canvas)
      # center_x = @x + @width/2.0
      # center_y = @y + @height/2.0
      # r = (@width <= @height)?  @width/2 :  @height/2
      canvas.circle(cx, cy, r)
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

    def to_key_value
      [:ellipse, to_hash]
    end

    def to_pdf(canvas)

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

    def to_key_value
      [:line, to_hash]
    end

    def to_pdf(canvas)

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

    def to_key_value
      [:polygon, to_hash]
    end

    def to_pdf(canvas)

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

    def to_pdf(canvas)
      font = 'Times' unless font
      size = 16 unless size
      canvas.font(font, size: size)
      canvas.text(string, at:[100,100])
    end

  end

  ImageStruct = Struct.new(:image_path, :fit_type, :rotation) do
    def to_hash
      # self.to_h.delete_if{|k,v| v.nil?}
    end

    def to_svg
      "<image replace_this_with_rect xlink:href=\"#{image_path}\"></image>"
    end

    def to_pdf(canvas)

    end

  end

  ParagraphStruct = Struct.new(:string, :markup, :footnote, :index) do
    def to_hash
      to_h
      # self.to_h.delete_if{|k,v| v.nil?}
    end

    def to_pdf(canvas)

    end

  end

end
