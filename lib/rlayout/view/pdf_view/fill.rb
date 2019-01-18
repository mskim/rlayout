module RLayout
  class Graphic
    def draw_fill(canvas)
      if !@fill.color
        @fill.color = 'CMYK=0,0,0,0 '
      end
      # @fill.color = %w[red yellow blue orange white black gray].sample
      @fill.color = RLayout.color_from_string(@fill.color)
      if @fill.color.class == String
        if @fill.color == 'clear'
          #TODO set opacity
          # @fill.color = [0.0, 0.0, 0.0, 0.0]
        else
          @fill.color = RLayout.color_from_string(@fill.color) 
        end
      end

      case @shape
      when RLayout::RectStruct
        unless @fill.color == 'clear'
          canvas.fill_color(@fill.color).rectangle(flipped[0],  flipped[1] , @width - @left_margin - @right_margin, @height - @top_margin - @bottom_margin).fill
        end
          # canvas.fill_color(@fill.color).rectangle(@x - @left_margin, @y - @top_margin, @width - @left_margin - @right_margin, @height - @top_margin - @bottom_margin).fill
      when RoundRectStruct
      when RLayout::CircleStruct
        circle = canvas.fill_color(@fill.color).stroke_color(@stroke.color).line_width(@stroke.thickness).circle(flipped[0] + @shape.r, flipped[1] + @shape.r, @shape.r).fill_stroke
      when EllipseStruct
      when PoligonStruct
      when PathStruct
      when LineStruct
      else
        unless @fill.color == 'clear'
          canvas.fill_color(@fill.color).rectangle(flipped[0],  flipped[1] , @width - @left_margin - @right_margin, @height - @top_margin - @bottom_margin).fill
        end
          # canvas.fill_color(@fill.color).rectangle(@x - @left_margin, @y - @top_margin, @width - @left_margin - @right_margin, @height - @top_margin - @bottom_margin).fill
      end
    end


  end
end