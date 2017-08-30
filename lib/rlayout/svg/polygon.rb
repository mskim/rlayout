
module RLayout

    class Polygon < Graphic
      attr_reader :points
      def self.from_svg(options={})
        polygon_options = Polygon.parse_svg(options)
        puts "polygon_options:#{polygon_options}"
        Polygon.new(polygon_options)
      end

      def self.parse_svg(options)
        h = {}
        h[:points]  = options.delete('points')
        h[:parent] = options[:parent]
        h
      end

      def to_svg
        "<polygon points='#{@points}' style='#{style_to_svg}' />"
      end
    end

    class Polyline < Graphic
      attr_reader :points
      def self.from_svg(options={})
        polyline_options = Polyline.parse_svg(options)
        Polyline.new(polyline_options)
      end

      def self.parse_svg(options)
        h = {}
        h[:points]  = options.delete('points')
        h[:parent] = options[:parent]
        h
      end


      def to_svg
        "<polygon points='#{@points}' style='#{style_to_svg}' />"
      end
    end

end
