module RLayout

    class Text < Graphic
      attr_reader :x, :y, :transform
      def self.from_svg(options={})
        text_options = Text.parse_svg(options)
        Text.new(text_options)
      end

      def self.parse_svg(options)
        h = {}
        h[:x]         = options.delete('x')
        h[:y]         = options.delete('y')
        h[:transform] = options.delete('transform')
        if h[:transform]
          # matrix = matrix(1 0 0 1 0.479 115.1865)
          s = h[:transform]
          s = s.gsub('matrix(', "")
          s = s.gsub(')', "")
          s = s.split(" ")
          h[:x] = s[4].to_f
          h[:y] = s[5].to_f
        end
        h[:text_string] = options.delete('content')
        h[:parent] = options[:parent]
        h
      end

      def to_svg
        "<text transform='#{@transform}' style='#{style_to_svg}'>#{@text_content}</text>"
      end
    end

end
