module RLayout
  class Graphic
    def draw_image(canvas)
        puts __method__
        puts "self.class:#{self.class}"
        puts "flipped_origin:#{flipped_origin}"
        puts "@y:#{@y}"
        image_origin = flipped_origin
        image_origin[0] += @x
        image_origin[1] -= @y
        puts "image_origin:#{image_origin}"
        canvas.image(@image_path, at: image_origin, width: @width, height: @height)
    end
  end
end