module RLayout
  class RPage < Container

    def to_svg
      s = "<svg xmlns=\"http://www.w3.org/2000/svg\" xmlns:xlink=\"http://www.w3.org/1999/xlink\" width=\"#{@width}px\" height=\"#{@height}px\">\n"
      s += svg_element + "\n"
      # draw container stuff
      if @graphics.length > 0
        s += children_graphics_svg
      end
      s += "</svg>\n"
    end

    def save_svg(page_folder)
      FileUtils.mkdir_p(page_folder) unless File.exist?(page_folder)
      svg_path = page_folder + "/page.svg"
      File.open(svg_path, 'w'){|f| f.write to_svg}
    end

    def children_graphics_svg
      # draw children
      s = "<g transform=\"translate(#{@x + @left_margin},#{@y + @top_margin})\">\n"
      @graphics.each do |graphic|
        s += graphic.to_svg
        s += "\n"
      end
      s +="</g>\n"
      s
    end

  end
end