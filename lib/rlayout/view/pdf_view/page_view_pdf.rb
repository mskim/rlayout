

module RLayout
  class RPage < Container

    def flipped_origin
      [@left_margin + @x, @height - @y - @top_inset]
    end

    def draw_pdf(canvas)
      @pdf_doc = parent.pdf_doc if parent

      # main_box
      # heder
      # footer
      
      @graphics.each do |g|
        g.draw_pdf(canvas)
      end
      @floats.each do |g|
        g.draw_pdf(canvas)
      end
      # end
    end
  end
end
