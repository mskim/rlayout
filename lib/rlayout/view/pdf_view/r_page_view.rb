module RLayout

  class RPage < Container
    def draw_pdf(canvas, options={})
      @main_box.draw_pdf(canvas) if @main_box
      @header.draw_pdf(canvas) if @header
      @footer.draw_pdf(canvas) if @footer
    end
  end

end