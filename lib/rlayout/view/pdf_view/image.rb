module RLayout
  class Graphic

    # image without clipping rect, 
    # image is placed at clip_ready_image_rect
    # and it is clipped with image_rect
    # so that final result is clipped image with fit_type
    # fit_horizontal 
    #   clip_ready_image_rect has same width as image_rect
    # fit_vertical
    #   clip_ready_image_rect has same heigth as image_rect
    #
    # example:
    # canvas.rectangle(350, 0, 80, 80, radius: 10)
    # canvas.clip_path(:nonzero)
    # canvas.end_path
    # canvas.image(File.join(__dir__, 'machupicchu.jpg'), at: [350, 0], height: 80)
    # clipping_rect = [image_origin[0], image_origin[1], @width, @height]

    # when image is cropped if @crop_rect && @clip_rect
    # image is draw with zoom_factor at x_shift, y_shift from image origin
    # if horizontal_fit
    #   zoom_factor = image_rect[0]/crop_rect[0]
    #   x_shift
    #   y_shift
    # else 
    #   zoom_factor = image_rect[1]/crop_rect[1]
    #   x_shift
    #   y_shift
    # end
    # x_shift, 
    # y_shift 
    #
    # IMAGE_FIT_TYPE_ORIGINAL       = 0
    # IMAGE_FIT_TYPE_VERTICAL       = 1
    # IMAGE_FIT_TYPE_HORIZONTAL     = 2
    # IMAGE_FIT_TYPE_KEEP_RATIO     = 3
    # IMAGE_FIT_TYPE_IGNORE_RATIO   = 4

    def draw_image(canvas)
      # unless File.exist?(graphic.image_path)
      unless @image_path && File.exist?(@image_path)
        #draw dummy image
        # puts "image_width should be 04.442857142856:#{graphic.width}"
        # draw_line(graphic)
        return
      end
      image_origin    = flipped_origin
      # image_origin[0] += @x
      image_origin[1] -= @height #@y # + @height
      if @clip_rect_delta_x && @clip_rect_delta_y
        # drawing fit_types horizontal, vertical, keep ratio
        # IMAGE_FIT_TYPE_ORIGINAL, IMAGE_FIT_TYPE_VERTICAL, IMAGE_FIT_TYPE_HORIZONTAL IMAGE_FIT_TYPE_KEEP_RATIO
        canvas.rectangle(image_origin[0], image_origin[1], @width, @height)
        canvas.clip_path(:nonzero)
        canvas.end_path
        canvas.image(@image_path, at: [image_origin[0] + @clip_rect_delta_x,  image_origin[1] + @clip_rect_delta_y], width: @width - @clip_rect_delta_x*2, height: @height - @clip_rect_delta_y*2)
      elsif @crop_rect && @clip_rect
        # drawing with clipping rect
        canvas.rectangle(image_origin[0], image_origin[1], @width, @height)
        canvas.clip_path(:nonzero)
        canvas.end_path
        # canvas.image(@image_path, at: [image_origin[0] - @clip_rect[0], image_origin[1] - @clip_rect[1]], width: @clip_rect[2], height: @clip_rect[3])
        # to prevent slite skewing when we specify both width and height, just use height and let it keep the ratio
        # canvas.image(@image_path, at: [image_origin[0] - @clip_rect[0], image_origin[1] - @clip_rect[1]], height: @clip_rect[3])
        canvas.image(@image_path, at: [image_origin[0] - @clip_rect[0], image_origin[1] - @clip_rect[1]], width: @clip_rect[2])
      else
        # drawing IMAGE_FIT_TYPE_IGNORE_RATIO
        canvas.image(@image_path, at: image_origin, width: @width, height: @height)
      end

    end
  end
end