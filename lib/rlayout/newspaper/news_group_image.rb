module RLayout

  # layout_direction horizontal, vertical, nxn(2x2 or 3x3)

  class NewsGroupImage < NewsImage
    attr_accessor :image_count, :member_images

    def initialize(options={}, &block)
      super
      @width              = options[:width] if options[:@width]
      @height             = options[:width] if options[:@height]
      @layout_direction   = options[:direction] || 'horizontal'
      @member_images      = options[:member_images]
      @member_count       = @member_images.length
      create_group_image
      if block
        instance_eval(&block)
      end
      relayout!
      self
    end
  end

  def create_group_image
    if @layout_direction == 'horizontal'
      @member_width   = @width/@member_count
      @member_height  = @height
    else
      @member_width   = @width
      @member_height  = @height/@member_count
    end
    @member_images.each do |image_path|
      i = Image.new(parent:self, image_path:image_path, width:@member_width, height: @member_height, layout_expand: [:width, :height])
    end
  end
end
