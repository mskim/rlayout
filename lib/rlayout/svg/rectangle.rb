module RLayout

    class Rectangle < Graphic
      attr_reader :rx, :ry
      def self.from_svg(options={})
        rect_options = Rectangle.parse_svg(options)
        RLayout::Rectangle.new(rect_options)
      end

      def self.parse_svg(options)
        h = {}
        h[:x]      = options.delete('x') || 0
        h[:y]      = options.delete('y') || 0
        h[:width]  = options.delete('width') || 0
        h[:eight]  = options.delete('height') || 0
        h[:rx]     = options.delete('rx')
        h[:ry]     = options.delete('ry')
        h[:parent] = options[:parent]
        h
      end

      def round_coner?
        @rx || @ry
      end

      def round_string
        s = ""
        s += " '#{@rx}'" if @rx
        s += "' #{@ry}'" if @rx
        s
      end

      def to_svg
        if round_coner?
          "<rect x='#{@x}' y='#{@y}' width='#{@width}' height='#{@height}' #{round_string} #{style_to_svg}/>"
        else
          "<rect x='#{@x}' y='#{@y}' width='#{@width}' height='#{@height}' #{style_to_svg}/>"
        end
      end

      def to_ns_path
        #code
      end
    end
end
