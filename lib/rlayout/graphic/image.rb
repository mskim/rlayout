module RLayout
  
  
  class Graphic
    def init_image(options)
      @image_path       = options[:image_path]
      @image_frame      = options[:image_frame]
      @image_fit_type    = options[:image_fit_type]
      @image_caption    = options[:image_caption]      
      
    end
  end
end