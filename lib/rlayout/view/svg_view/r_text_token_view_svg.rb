
module RLayout
  class RTextToken < Graphic
    
    def to_svg
      s = "<Text>#{string}</Text>"
    end

    def to_svg_with_style
      s = "<Text>#{string}</Text>"
    end

  end
end