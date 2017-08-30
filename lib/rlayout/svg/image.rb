module RLayout

    class Image < Graphic
      attr_reader :preserveAspectRatio
      def self.from_svg(options={})
        image_options = image_logo.parse_svg(options)
        puts "initialize of SVG::Circle"
        Circle.new(image_options)
      end

      def self.parse_svg(options)
        h = {}
        h[:image_path]          = options.delete('xlink:href') || 0
        h[:width]               = options.delete('width') || 100
        h[:height]              = options.delete('height') || 100
        h[:preserveAspectRatio] = options.delete('preserveAspectRatio')
        h[:parent] = options[:parent]
        h
      end

      def to_svg
        "<image xlink:href='#{@image_path}' width='#{@width}' height='#{height}' />"
      end

    end

  #code
end
