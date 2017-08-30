module RLayout

    class Path < Graphic
      attr_reader :d
      def self.from_svg(options={})
        path_options = Path.parse_svg(options)
        Path.new(path_options)
      end

      def self.parse_svg(options)
        h = {}
        h[:d]  = options.delete('d')
        h[:parent] = options[:parent]
        h
      end

      def to_svg
        "<path d='#{@d}' style='#{style_to_svg}' />"
      end

      def to_nspath
        #code
      end
    end

end
