module RLayout

  class PrintPage < Container
    attr_reader :bleed_margin, :gripper_margin, :binding_margin
    attr_reader :page_path, :side, :first_pdf_page

    def initialize(option={})
      super
      @page_path = option[:page_path]
      @side = option[:side]
      @gripper_margin = option[:gripper_margin]
      @bleed_margin = option[:bleed_margin]
      @binding_margin = option[:binding_margin]
      place_pdf
      draw_cutting_line
      pdf_page
    end

    def draw_cutting_line
      line_length = @gripper_margin - @bleed_margin
      vertical_line_position = [@gripper_margin, @width - @gripper_margin]
      vertical_line_position.each do |x_position|
        # line(x:x_position,y:0, width:0.5, height: line_length)
        # line(x:x_position,y: @height - @gripper_margin + @bleed_margin, width:0.5, height: line_length)
        
        line(x1: x_position, y1: 0, x2: x_position, y2: line_length)
        line(x1: x_position, y1: @height - @gripper_margin + @bleed_margin, x2: x_position, y2: @height)
      end
      horozontal_line_position = [@gripper_margin, @height - @gripper_margin]
      horozontal_line_position.each do |y_position|
        line(x1: 0, y1: y_position, x2: line_length, y2: y_position)
        line(x1: @width - @gripper_margin + @bleed_margin, y1: y_position, x2: @width, y2: y_position)
      end
    end

    def place_pdf
      if side == 'left'
        Image.new(parent: self, image_path:@page_path, x: @gripper_margin - @binding_margin, y: @gripper_margin, width: @width - @gripper_margin*2, height: @height - @gripper_margin*2)
      else
        Image.new(parent: self, image_path:@page_path, x: @gripper_margin + @binding_margin, y: @gripper_margin, width: @width - @gripper_margin*2, height: @height - @gripper_margin*2)
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