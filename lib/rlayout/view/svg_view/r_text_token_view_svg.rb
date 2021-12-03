
module RLayout
  class RTextToken < Graphic
    
    def to_svg
      s = "<text x=\"#{@x}\"  y=\"#{@y}\">#{string}</text>"
    end

    def to_svg_with_style
      s = "<text x=\"#{@x}\"  y=\"#{@y}\">#{string}</text>"
    end

  end
end