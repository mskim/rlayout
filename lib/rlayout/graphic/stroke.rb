
# LINE_TYPE_PLAIN           = 0
# LINE_TYPE_DOUBLE_LINES_1  = 1
# LINE_TYPE_DOUBLE_LINES_2  = 2
# LINE_TYPE_DOUBLE_LINES_3  = 3
# LINE_TYPE_TRIPPLE_LINES_1 = 4
# LINE_TYPE_TRIPPLE_LINES_2 = 5
# LINE_TYPE_TRIPPLE_LINES_3 = 6

module RLayout
  class Graphic
    def init_stroke(options)
      @stroke             = options.fetch(:stroke, StrokeStruct.new('black', 0))
      @stroke[:color]     = options[:line_color] if options[:line_color] # supporting commomly used name
      @stroke[:color]     = options[:stroke_color] if options[:stroke_color]
      @stroke[:thickness] = options[:line_width] if options[:line_width] # supporting commomly used name
      @stroke[:thickness] = options[:stroke_thickness] if options[:stroke_thickness]
      @stroke[:thickness] = options[:stroke_width] if options[:stroke_width]
      @stroke[:thickness] = options[:thickness] if options[:thickness]
      @stroke[:dash]      = options[:dash] if options[:dash]
      @stroke[:line_cap]  = options[:line_cap] if options[:line_cap]
      @stroke[:line_join] = options[:line_join] if options[:line_join]
      @stroke[:type]      = options[:line_type] if options[:line_type]
      @stroke[:sides]     = options[:stroke_sides] || [1,1,1,1]   # [1,1,1,1], [1,0,1,0]
      @stroke[:rule]      = options[:stroke_rule] if options[:stroke_rule]   # [1,1,1,1], [1,0,1,0]

    end

  end
end
