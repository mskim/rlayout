

module RLayout
  class RPage < Container

    def flipped_origin
      [@x, @height]
    end

    def draw_pdf(canvas)
      @graphics.each_with_index do |g, i|
        g.draw_body_line(canvas)
      end
      @floats.each do |g|
        g.draw_pdf(canvas)
      end
      # end
    end
  end
end
