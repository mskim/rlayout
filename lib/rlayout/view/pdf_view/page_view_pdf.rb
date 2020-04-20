

module RLayout
  class RPage < Container

    def flipped_origin
      [@left_margin + @x, @height - @y - @top_inset]
    end

    def to_pdf(canvas)
      super
    end
  end
end
