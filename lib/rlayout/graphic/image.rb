
# Inserting Images in Markdown
# Image can be inserted in couple of ways,
# For magazine_article and news_article, common way is to have images data hash defined in the meda-data area above markdown.
# images = [
#     {
#         image_path: "/path/to image.jpg",
#         caption: image caption,
#         size: 3x4/3x6
#         location: [0,0]
#      },
#     {
#         image_path: "/path/to image.jpg",
#         caption: image caption,
#         size: middle,
#         location: top_left
#      }
#]
#    
#
# One way is to put image_path in the meta_data as hash, along with title
# For book_chaper_article, place image tag along paragraph text
# as ![alt_text](path/to/image/file)
# image will flows along with other paragraphs in column.
# Where as if images were place in metadata is place as flost, usually occupying on top of mutiple columns.

# crating Image Only Page
# we might have some pages with images only.
# This can be done using page_script to describe it
# page.new do
#   container do
#
#   end
# end

IMAGE_FIT_TYPE_ORIGINAL       = 0
IMAGE_FIT_TYPE_VIRTICAL       = 1
IMAGE_FIT_TYPE_HORIZONTAL     = 2
IMAGE_FIT_TYPE_KEEP_RATIO     = 3
IMAGE_FIT_TYPE_IGNORE_RATIO   = 4
IMAGE_FIT_TYPE_REPEAT_MUTIPLE = 5

module RLayout
  class Graphic
    def init_image(options)
      return unless options[:image_path]
      @image_path       = options[:image_path]
      # @image_frame      = options.fetch(:image_frame, image_defaults[:image_frame])
      @image_caption    = options[:image_caption]      
      @image_fit_type   = options.fetch(:image_fit_type, image_defaults[:image_fit_type])
      if @image_path && File.exists?(@image_path)
        @image_object=NSImage.alloc.initByReferencingFile(@image_path)
        if @image_object && options[:adjust_height_to_keep_ratio]
          # change height 
          @height *= image_object_height_to_width_ratio
        end
        apply_fit_type
      elsif @local_image
        #TODO
        puts "handle local image"
      end
    end
    
    def image_defaults
      {
        image_path: nil,
        local_image: nil,
        image_fit_type: IMAGE_FIT_TYPE_VIRTICAL, 
        source_frame: NSZeroRect,
        clip_path: nil,
        rotation: 0
      }
    end
    
    def can_split_at?(position)
      false
    end
    
    def image_to_hash
      h = {}
      h[:image_path] = @image_path if @image_path
      h[:image_fit_type] = @image_fit_type if @image_fit_type != image_defaults[:image_defaults]
      h
    end
    
    def draw_image(rect)      
      return unless @image_object
      # This is confusing. 
      # If I want to displace image with reduced % , I have to make the source_frame larger
      if @image_fit_type == IMAGE_FIT_TYPE_IGNORE_RATIO 
        @image_object.drawInRect(rect, fromRect:NSZeroRect, operation:NSCompositeSourceOver, fraction:1.0, respectFlipped:true, hints:nil) if @image_object
      else
        @image_object.drawInRect(rect, fromRect:@source_frame, operation:NSCompositeSourceOver, fraction:1.0, respectFlipped:true, hints:nil) if @image_object
      end
    end

    def image_object_height_to_width_ratio
      return 1 unless @image_object
      @image_object.size.height/@image_object.size.width
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
      @image_frame      = NSZeroRect
      @image_frame.size = @image_object.size
      if @image_frame
        @source_frame = @image_frame.dup
      else
        @source_frame = NSZeroRect
        return
      end
      # @image_object.drawInRect(rect, fromRect:@source_frame, operation:NSCompositeSourceOver, fraction:1.0, respectFlipped:true, hints:nil) if @image_object
      # This is really confusing. If I want to make smaller image , I have to make the source_frame larger
      source_width = @width / (height/@image_frame.size.height)
      @source_frame.origin.x = (@image_frame.size.width - source_width)/2.0
      @source_frame.origin.y = 0
      @source_frame.size.width = source_width
      @source_frame.size.height = @image_frame.size.height

    end

    def fit_horizontal
      return unless @image_object
      @image_frame      = NSZeroRect
      @image_frame.size = @image_object.size
      if @image_frame
        @source_frame = @image_frame.dup
      else
        @source_frame = NSZeroRect
        return
      end
      # @image_object.drawInRect(rect, fromRect:@source_frame, operation:NSCompositeSourceOver, fraction:1.0, respectFlipped:true, hints:nil) if @image_object
      # This is really confusing. If I want to make smaller image , I have to make the source_frame larger
      source_height = @image_frame.size.height / (@image_frame.size.width/@image_frame.size.width)
      @source_frame.origin.x = 0
      @source_frame.origin.y = (@image_frame.size.height - source_height)/2.0
      @source_frame.size.height = source_height
      @source_frame.size.width = @image_frame.size.width
    end

    def fit_keep_ratio
      return unless @owner_graphic
      return unless @image_object
      @image_frame      = NSZeroRect
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
end