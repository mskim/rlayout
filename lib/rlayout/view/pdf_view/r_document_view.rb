module RLayout

  class RDocument
    def save_pdf_with_ruby(canvas, output_path, options={})
      @pages.each do |p|
        p.draw_pdf(canvas)
      end

    end
  end

end