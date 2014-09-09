
IMAGE_FIT_TYPE_ORIGINAL       = 0
IMAGE_FIT_TYPE_VIRTICAL       = 1
IMAGE_FIT_TYPE_HORIZONTAL     = 2
IMAGE_FIT_TYPE_KEEP_RATIO     = 3
IMAGE_FIT_TYPE_IGNORE_RATIO   = 4

class GraphicViewMac < NSView
  attr_accessor :image_object, :source_frame, :image_frame
  
  def init_image
    @image_fit_type = @data.fetch(:image_fit_type, image_defaults[:image_fit_type])
    @image_path     = @data.fetch(:image_path, nil)
    @image_frame    = NSZeroRect
    # frame   = NSMakeRect(@data[:x], @data[:y], @data[:width], @data[:height])
    if @image_path
      @image_object=NSImage.alloc.initByReferencingFile(@image_path)
    end
    apply_fit_type
  end

  def image_defaults
    {
      image_path: nil,
      local_image: nil,
      image_frame: NSZeroRect,
      image_fit_type: IMAGE_FIT_TYPE_VIRTICAL, 
      source_frame: NSZeroRect,
      clip_path: nil,
      rotation: 0
    }

  end
  	
  def draw_image(rect)      
    return unless @image_object
    
    case @image_fit_type
    when  IMAGE_FIT_TYPE_ORIGINAL
      @image_object.drawInRect(rect, fromRect:@source_frame, operation:NSCompositeSourceOver, fraction:1.0, respectFlipped:true, hints:nil) if @image_object
      # This is really confusing. If I want to make smaller image , I have to make the source_frame larger
    when  IMAGE_FIT_TYPE_VIRTICAL
      @image_object.drawInRect(rect, fromRect:@source_frame, operation:NSCompositeSourceOver, fraction:1.0, respectFlipped:true, hints:nil) if @image_object
    when  IMAGE_FIT_TYPE_HORIZONTAL
      @image_object.drawInRect(rect, fromRect:@source_frame, operation:NSCompositeSourceOver, fraction:1.0, respectFlipped:true, hints:nil) if @image_object
    when  IMAGE_FIT_TYPE_KEEP_RATIO 
      @image_object.drawInRect(rect, fromRect:NSZeroRect, operation:NSCompositeSourceOver, fraction:1.0, respectFlipped:true, hints:nil) if @image_object
    when   IMAGE_FIT_TYPE_IGNORE_RATIO
      @image_object.drawInRect(rect, fromRect:@source_frame, operation:NSCompositeSourceOver, fraction:1.0, respectFlipped:true, hints:nil) if @image_object
    else
      @image_object.drawInRect(rect, fromRect:NSZeroRect, operation:NSCompositeSourceOver, fraction:1.0, respectFlipped:true, hints:nil) if @image_object
    end
    
  end


  def apply_fit_type
    case @image_fit_type
    when  IMAGE_FIT_TYPE_ORIGINAL
      fit_original
    when  IMAGE_FIT_TYPE_VIRTICAL
      fit_virtical
    when  IMAGE_FIT_TYPE_HORIZONTAL
      fit_horizontal
    when  IMAGE_FIT_TYPE_KEEP_RATIO
      fit_keep_ratio 
    when  IMAGE_FIT_TYPE_IGNORE_RATIO
      fit_ignore_ratio
    end
  end
  
  def fit_original
    @image_frame.size = @image_object.size
    mid_x = NSMidX(@image_frame)
    mid_y = NSMidY(@image_frame)
    if frame
      @source_frame = graphic_rect.dup
    else
      @source_frame = NSZeroRect
      return
    end
    @source_frame.origin.x = @image_frame.size.width/2.0 - graphic_rect.size.width/2.0
    @source_frame.origin.y = @image_frame.size.height/2.0 - graphic_rect.size.height/2.0
       
  end
  
  
  def fit_virtical
    return unless @image_object
    @image_frame.size = @image_object.size
    if frame
      @source_frame = frame.dup
    else
      @source_frame = NSZeroRect
      return
    end
    # @image_object.drawInRect(rect, fromRect:@source_frame, operation:NSCompositeSourceOver, fraction:1.0, respectFlipped:true, hints:nil) if @image_object
    # This is really confusing. If I want to make smaller image , I have to make the source_frame larger
    source_width = frame.size.width / (frame.size.height/@image_frame.size.height)
    @source_frame.origin.x = (@image_frame.size.width - source_width)/2.0
    @source_frame.origin.y = 0
    @source_frame.size.width = source_width
    @source_frame.size.height = @image_frame.size.height
    
  end
  
  def fit_horizontal
    return unless @image_object
    @image_frame.size = @image_object.size
    if frame
      @source_frame = frame.dup
    else
      @source_frame = NSZeroRect
      return
    end
    # @image_object.drawInRect(rect, fromRect:@source_frame, operation:NSCompositeSourceOver, fraction:1.0, respectFlipped:true, hints:nil) if @image_object
    # This is really confusing. If I want to make smaller image , I have to make the source_frame larger
    source_height = frame.size.height / (frame.size.width/@image_frame.size.width)
    @source_frame.origin.x = 0
    @source_frame.origin.y = (@image_frame.size.height - source_height)/2.0
    @source_frame.size.height = source_height
    @source_frame.size.width = @image_frame.size.width
  end
  
  def fit_keep_ratio
    return unless @owner_graphic
    return unless @image_object
    @image_frame.size = @image_object.size
    grapaphic_rect_width_to_height_ratio  = frame.size.width/frame.size.height
    image_frame_width_to_height_ratio     = @image_frame.size.width/@image_frame.size.height
    if grapaphic_rect_width_to_height_ratio > image_frame_width_to_height_ratio
      # fit vertical and reduce image_frame_width
      # Todo
    else
      
    end
    # Todo
    # I need to figure out best fit
  end
  
  def fit_ignore_ratio
    @source_frame = NSZeroRect
  end
  

end