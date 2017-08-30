module RLayout
    class Circle < Graphic
      attr_accessor :cx, :cy, :r
      def self.from_svg(options={})
        circle_options = Circle.parse_svg(options)
        puts "initialize of SVG::Circle"
        Circle.new(circle_options)
      end

      def self.parse_svg(options)
        h = {}
        cx = options['cx'] || 0
        cy = options['cy'] || 0
        r = options['r'] || 100
        h[:x] = cx - r
        h[:y] = cy + r
        h[:width] = cx + r
        h[:heigth] = cy - r
        h[:cx] = cx
        h[:cy] = cy
        h[:r]  = r
        h[:parent] = options[:parent]
        h
      end

      def to_ns_path
        #code
      end

      def to_svg
        "<circle cx='#{@cx} y='#{@cy} width='#{@r}' style=#{style_to_svg}/>"
      end
    end

    class Ellipse < Graphic
      attr_reader :cx, :cy, :rx, :ry
      def self.from_svg(options={})
        ellipse_options = Circle.parse_svg(options)
        puts "initialize of Ellipse"
        Ellipse.new(ellipse_options)
      end

      def self.parse_svg(options)
        h = {}
        cx = options['cx'] || 0
        cy = options['cy'] || 0
        rx = options['rx'] || 100
        ry = options['ry'] || 100
        h[:x] = cx - r
        h[:y] = cy + r
        h[:width] = cx + rx
        h[:heigth] = cy - ry
        h[:cx] = cx
        h[:cy] = cy
        h[:rx]  = rx
        h[:ry]  = ry
        h
      end

      def to_svg
        "<ellipse cx='#{@cx}' cy='#{@cy}' rx='#{@rx}' ry='#{@ry}' style='#{style_to_svg}' />"
      end
    end
end
