module RLayout
  # x, y, widht, height
  # pillar_path, images

  class PillarImage < Container
    attr_reader :images, :pillar_path
    attr_reader :status # underflow, overflow, fit

    def initialize(options={})
      super
      @pillar_path  = options[:pillar_path]
      @images       = options[:images]
      create_images
      self
    end

    def create_images
      currnt_y = 0
      @images.each do |image|
        image_h                   = {}
        image_h[:parent]          = self
        image_h[:image_path]      = @pillar_path + "/#{image}"
        image_h[:y]               = currnt_y
        image_h[:width]           = @width
        image_h[:image_fit_type]  = IMAGE_CHANGE_BOX_SIZE
        img = Image.new(image_h)
        currnt_y += img.height
      end
    end

  end
end