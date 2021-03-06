module RLayout
  class Graphic
  
    def draw_fill(canvas)
      if self.class == RDocument || self.class == RTextToken 
        return
      end
      unless  @fill 
        return
      end
      if  @fill.color == 'clear'
        return
      end
      unless @fill.color
        @fill.color = 'CMYK=0,0,0,0 '
      end
      # @fill.color = %w[red yellow blue orange white black gray].sample
      # @fill.color = RLayout.color_from_string(@fill.color)
      if @fill.color.class == String
        if @fill.color == 'clear'
          @fill.color = [0.0, 0.0, 0.0, 0.0]
        else
          @fill.color = RLayout.color_from_string(@fill.color) 
        end
      end
      canvas.save_graphics_state do
        case @shape
        when RLayout::RectStruct || 'rect'
          flipped = flipped_origin unless flipped
          canvas.fill_color(@fill.color).rectangle(flipped[0] + @left_margin,  flipped[1] - @height, @width - @left_margin - @right_margin, @height - @top_margin - @bottom_margin).fill
        when RoundRectStruct
        when RLayout::CircleStruct
          flipped = flipped_origin unless flipped
          circle = canvas.fill_color(@fill.color).circle(flipped[0] + @shape.r, flipped[1] - @shape.r, @shape.r).fill
        when EllipseStruct
        when PoligonStruct
        when PathStruct
        when LineStruct
        else
          flipped = flipped_origin unless flipped
          unless @fill.color == 'clear'
            canvas.fill_color(@fill.color).rectangle(flipped[0] + @left_margin,  flipped[1] + @left_margin, @width - @left_margin - @right_margin, @height - @top_margin - @bottom_margin).fill
          end
        end
      end
    end


  end
end