module RLayout

  class Container < Graphic
    def to_svg
      if @parent_graphic
        s = svg + "\n"
        s += children_graphics_svg
      else
        s = "<svg xmlns='http://www.w3.org/2000/svg' xmlns:xlink='http://www.w3.org/1999/xlink' width='#{@x + @width}px' height='#{@y + @height}px'>\n"
        s += svg + "\n"
        s += children_graphics_svg if @graphics.length > 0
        s += "</svg>\n"
      end
      s
    end

    def children_graphics_svg
      # draw container stuff
      # draw children stuff
      s= "<g transform='translate(#{@x},#{@y})'>\n"
      @graphics.each do |graphic|
        s += graphic.to_svg + "\n"
      end
      s +="</g>\n"
      s
    end
  end

end
