module RLayout

  class PrintPage < Container
    attr_reader :bleeding_margin, :cutting_margin, :binding_margin
    attr_reader :page_path, :side, :first_pdf_page

    def initialize(option={})
      super
      @page_path = option[:page_path]
      @side = option[:side]
      @cutting_margin = option[:cutting_margin]
      @bleeding_margin = option[:bleeding_margin]
      @binding_margin = option[:binding_margin]
      place_pdf
      draw_cutting_line
      pdf_page
    end

    def draw_cutting_line
      line_length = @cutting_margin - @bleeding_margin
      vertical_line_position = [@cutting_margin, @width - @cutting_margin]
      vertical_line_position.each do |x_position|
        line(x:x_position,y:0, width:0.5, height: line_length)
        line(x:x_position,y: @height - @cutting_margin + @bleeding_margin, width:0.5, height: line_length)
      end
      horozontal_line_position = [@cutting_margin, @height - @cutting_margin]
      horozontal_line_position.each do |y_position|
        line(x: 0, y: y_position, width: line_length, height: 0.5)
        line(x: @width - @cutting_margin + @bleeding_margin, y:y_position, width: line_length, height: 0.5)
      end
    end

    def place_pdf
      if side == 'left'
        Image.new(parent: self, image_path:@page_path, x: @cutting_margin - @binding_margin, y: @cutting_margin, width: @width - @cutting_margin, height: @height - @cutting_margin)
      else
        Image.new(parent: self, image_path:@page_path, x: @cutting_margin + @binding_margin, y: @cutting_margin, width: @width - @cutting_margin, height: @height - @cutting_margin)
      end
    end

    def pdf_view
      to_pdf
    end

    def pdf_page
      @first_pdf_page = pdf_view.pages.first
    end

    def save_pdf(output_path)
      save_pdf_with_ruby(output_path)
    end
  end
end