module RLayout
  class LineFragment < Container
    def to_pdf(canvas)
      binding.pry
      canvas.text(line_string, at: flipped_origin)
    end
  end
end