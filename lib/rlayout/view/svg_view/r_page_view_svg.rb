module RLayout
  class RPage < Container

    def to_svg
      s = "<svg xmlns=\"http://www.w3.org/2000/svg\" xmlns:xlink=\"http://www.w3.org/1999/xlink\" width=\"#{@x + @width}px\" height=\"#{@y + @height}px\">\n"
      s += svg_element + "\n"
      # draw container stuff
      if @graphics.length > 0
        s += children_graphics_svg
      end
      s += "</svg>\n"
    end

    def save_svg(svg_path)
      page_folder = File.dirname(svg_path)
      FileUtils.mkdir_p(page_folder) unless File.exist?(page_folder)
      File.open(svg_path, 'w'){|f| f.write to_svg}
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

  end
end