module RLayout

    class Line < Graphic
      def self.from_svg(options={})
        line_options = Line.parse_svg(options)
        l = Line.new(line_options)
        l
      end

      def self.parse_svg(options)
        h = {}
        h[:x] = h[:x1]  = options.delete('x1').to_f || 0
        h[:y] = h[:y1]  = options.delete('y1').to_f || 0
        h[:x2]          = options.delete('x2').to_f || 100
        h[:y2]          = options.delete('y2').to_f || 100
        h[:width]       = h[:x2] - h[:x1]
        h[:height]      = h[:y2] - h[:y1]
        h[:parent] = options[:parent]
        h
      end

      def to_svg
        "<line x1='#{@x1}' y1='#{@y1}' x2='#{@x2}' y2='#{@y2}' #{style_to_svg}' />"
      end

      def stroke_width
        @attributes['stroke-width'] || 0
      end

      def draw
        nsview_draw if RUBY_ENGINE != 'rubymotion'
        puts "line draw a line"
      end

      def nsview_draw
        NSBezierPath.new
        starting  = NSPoint.new(@x1, @y1)
        ending    = NSPoint.new(@x2, @y2)
        path      = NSBezierPath.bezierPath
        path.setLineWidth(stroke_width)
        path.moveToPoint(starting)
        path.lineToPoint(ending)
        path.stroke
      end
    end

end
