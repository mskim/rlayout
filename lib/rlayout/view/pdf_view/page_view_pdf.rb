

module RLayout
  class RPage < Container

    def flipped_origin
      [@left_margin + @x, - @top_margin - @top_inset - @y]
    end

    def to_pdf(canvas)
      super
    end
  end
end
