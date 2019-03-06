module RLayout
  class Graphic
    def draw_image(canvas)
        image_origin = flipped_origin
        image_origin[0] += @x
        image_origin[1] -= @y
        canvas.image(@image_path, at: image_origin, width: @width, height: @height)
    end
  end
end