module RLayout

  class TitleText < Container
    def draw_pdf(canvas, options={})
      # canvas.save_graphics_state do
        # canvas.font(font_wapper, size: size)
        @graphics.each do |line|
          line.draw_pdf(canvas)
        end
    end
  end

end