
# View is flipped by
# canvas.translate(0.0, page.box.height)
# canvas.scale(1.0, -1.0)

module RLayout
  class Page < Container
    attr_accessor :pdf_page
    def to_pdf(pdf_page)
      @pdf_page = pdf_page
      page    = pdf_page
      canvas  = @pdf_page.canvas
      # flip virtically canvas
      canvas.translate(0.0, page.box.height)
      canvas.scale(1.0, -1.0)

      radius  = 75

      # Left pie chart
      center = [page.box.width * 0.25, page.box.height * 0.85]
      pie = canvas.graphic_object(:solid_arc, cx: center[0], cy: center[1],
                                  outer_a: radius, outer_b: radius)
      canvas.fill_color('ddddff')
      canvas.draw(pie, start_angle: 30, end_angle: 110).fill
      canvas.fill_color('ffdddd')
      canvas.draw(pie, start_angle: 110, end_angle: 130).fill
      canvas.fill_color('ddffdd')
      canvas.draw(pie, start_angle: 130, end_angle: 30).fill

      @graphics.each do |graphic|
        graphic.draw.pdf(canvans)
      end
    end
  end

end
