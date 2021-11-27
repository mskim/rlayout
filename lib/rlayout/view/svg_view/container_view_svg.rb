module RLayout
  class Container < Graphic
    def to_svg
      if @parent
        s = svg_element + "\n"
        if @graphics.length > 0
          s += children_graphics_svg
        end
        # s += children_graphics_svg
      else
        s = "<svg xmlns=\"http://www.w3.org/2000/svg\" xmlns:xlink=\"http://www.w3.org/1999/xlink\" width=\"#{@x + @width}px\" height=\"#{@y + @height}px\">\n"
        s += svg_element + "\n"
        # draw container stuff
        if @graphics.length > 0
          s += children_graphics_svg
        end
        s += "</svg>\n"
      end
      s
    end

    def children_graphics_svg
      # draw children
      s = "<g transform=\"translate(#{@x},#{@y})\">\n"
      @graphics.each do |graphic|
        s += graphic.to_svg
      end
      s +="</g>\n"
      s
    end

    def save_svg(path)
      File.open(path, 'w'){|f| f.write to_svg}
    end

  end

end