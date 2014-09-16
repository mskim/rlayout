module RLayout
  class Document
    def to_svg
      # TODO
      # SVG 1.1 does not support multipe page svg, SVG 1.2 has <pageSet> for multiple page support
      # but it does not work in Safari
      # So, save each pages as separate files
      # layout_page

      # s = "<svg xmlns=\"http://www.w3.org/2000/svg\" xmlns:xlink=\"http://www.w3.org/1999/xlink\" x=\"0\" y=\"0\" width=\"#{@document_width}\" height=\"#{@document_height}\">\n"
      # @pages.each do |page|
      #   s += page.save_svg(page)
      # end
      # s += "</svg>"      
    end

    def save_svg(path)
      dir = File.dirname(path)
      ext = File.extname(path)
      base = File.basename(path, ".svg")
      @pages.each_with_index do |page, i|
        path = dir + "/#{base}" + i.to_s + "#{ext}"
        page.save_svg(path)
      end
    end
  end
  
end