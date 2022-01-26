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
# Other alternitive is to put image_path in the meta_data, along with title
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

# image cation file
# location along side the image with file extention of .captopn
# first line is the caption title, if ther are more than single line

# iamge crop is done with image_crop rect
# clip_rect_delta_x and clip_rect_delta_y are used for drawing origianl image in larger area.
# and final image clipped from larger image

IMAGE_FIT_TYPE_ORIGINAL       = 0
IMAGE_FIT_TYPE_VERTICAL       = 1
IMAGE_FIT_TYPE_HORIZONTAL     = 2
IMAGE_FIT_TYPE_KEEP_RATIO     = 3
IMAGE_FIT_TYPE_IGNORE_RATIO   = 4
IMAGE_FIT_TYPE_REPEAT_MUTIPLE = 5
IMAGE_CHANGE_BOX_SIZE         = 6 #change box size to fit image source as is at origin

# local_image is used for getting images in project, images in images folder
# ex. should put images in project.rlayout/images/my_image.jpg
module RLayout
  class Graphic
    attr_accessor :image_path, :image_object, :image_dimension, :image_frame, :image_fit_type, :source_frame, :local_image, :image_caption, :image_crop_rect, :image_crop_grid
    attr_reader :zoom_level, :zoom_anchor, :zoom_factor
    attr_accessor :clip_ready_image_rect, :caption_height

    def init_image(options)
      @shape = options[:shape] if options[:shape]
      @image_record  = options.fetch(:image_record,nil)
      @caption_height = options[:caption_height]
      unless options[:image_path]
        if (options[:local_image] && $ProjectPath) || (options[:local_image] && @project_path)
          @local_image          = options[:local_image]
          options[:image_path]  = $ProjectPath + "/images/" + options[:local_image]
        else
          puts "local_image without @project_path!!!"
          return
        end
      end
      @image_path       = options[:image_path]
      @image_fit_type   = options.fetch(:image_fit_type, image_defaults[:image_fit_type])
      @image_fit_type   = @image_fit_type.to_i
      unless File.exists?(@image_path)
        @image_path = "/Users/Shared/SoftwareLab/images/dummy.jpg"
        @stroke[:color] = 'CMYK=0,0,0,100'
        @stroke[:thickness] = 1.0
        @stroke[:sides] = [1,1,1,1,1,1]
        @fill[:color] = 'CMYK=0,0,0,10'
      end
      @zoom_level     = options[:zoom_level] || "0%"
      @image_crop_rect = options[:crop_rect] if options[:crop_rect]
      set_zoom_factor
      @zoom_anchor    = options[:zoom_anchor] unless @zoom_anchor
      @zoom_anchor    = 5 unless @zoom_anchor
      @image_object   = Vips::Image.new_from_file(@image_path)
      # @image_object   = MiniMagick::Image.open(@image_path)
      @image_dimension  = [@image_object.width, @image_object.height]
      if @image_object && options[:adjust_height_to_keep_ratio]
        @height *= image_object_height_to_width_ratio
      end
      apply_fit_type
      if options[:image_caption]
        @image_caption = options[:image_caption]
      else
        return false unless @image_path
        ext = File.extname(@image_path)
        image_caption_path = @image_path.sub(ext, ".caption")
        if File.exist?(image_caption_path)
          @image_caption = File.open(image_caption_path, 'r'){|f| f.read}
        end
      end

      self
    end

    def image_defaults
      {
        image_path: nil,
        local_image: nil,
        # image_fit_type: IMAGE_FIT_TYPE_KEEP_RATIO,
        image_fit_type: IMAGE_FIT_TYPE_IGNORE_RATIO,
        # source_frame: NSZeroRect,
        clip_path: nil,
        rotation: 0
      }
    end

    def apply_fit_type
      if @crop_rect
        @image_fit_type = 'fit_crop_rect'
        fit_crop_rect
        # x = @crop_rect[0]
        # y = @crop_rect[1]
        # puts "crop_rect y#{y}"
        # puts "fit_direction:#{fit_direction} "
        # if fit_direction == 'fit_horizontal'
        #   puts "@image_object.size.height:#{@image_object.size.height}"
        #   y = (@image_object.size.height - y)/2
        #   puts "new y: #{y}"
        # end
        # w = @crop_rect[2]
        # h = @crop_rect[3]
        # @source_frame = NSMakeRect(x,y,w,h)
        return
      end

      case @image_fit_type
      when  IMAGE_FIT_TYPE_ORIGINAL
        fit_original
      when  IMAGE_FIT_TYPE_VERTICAL
        fit_vertical
      when  IMAGE_FIT_TYPE_HORIZONTAL
        fit_horizontal
      when  IMAGE_FIT_TYPE_KEEP_RATIO
        fit_keep_ratio #최적
      when  IMAGE_FIT_TYPE_IGNORE_RATIO
        fit_ignore_ratio
      when IMAGE_CHANGE_BOX_SIZE
        fit_by_changing_box_size
      end
    end

    def can_split_at?(position)
      false
    end

    def image_object_height_to_width_ratio
      return 1 unless @image_object
      if @image_dimensions
        @image_dimensions[1]/@image_dimensions[0]
      end
      1
      #   @height/@width
      # end
      # return 1 unless
    end

    def fit_original

      #TODO:
    end

    def fit_crop_rect

      # we should have @crop_rect 
      # In order to crop image, we need to draw image that is larger than the
      # cropping rect, final cropped result shoud be our image_rect
      # so the drawing rect should be drawing larger than the resulting clipped image
      # so we need to make drawing rect that surround clipping final rect
      # drawing_rect is what we draw, and we pass @drawing_x_offset, and @drawing_y_offset, @drawing_width, @drawing_height
      #  
      image_to_canvas_ratio = @crop_rect[2]/@width
      @drawing_width    = image_dimension[0]/@crop_rect[2].to_f*@width
      @drawing_height   = image_dimension[1]/@crop_rect[3].to_f*@height
      @drawing_top      = @crop_rect[1]/image_to_canvas_ratio
      @drawing_bottom   = @drawing_top + @drawing_height
      @drawing_y_offset = (image_dimension[1] - @crop_rect[1] - @crop_rect[3])/image_to_canvas_ratio
      @drawing_x_offset = @crop_rect[0]/image_to_canvas_ratio
      # @drawing_x_offset = (@crop_rect[0] + image_dimension[0] )/image_to_canvas_ratio
      # 
      @clip_rect        = [@drawing_x_offset, @drawing_y_offset, @drawing_width, @drawing_height]
    end

    # It took me a while to figure this one out!!
    # Cocoa image zooming works by setting the target rect and reducing the source image rect.
    # we have to reduce the source rect in order to enlarge image
    # this is why  @zoom_factor < 1,  when enlarging the image
    # few!!!! 
    def set_zoom_factor
      case @zoom_level
      when '0%'
        @zoom_factor = 1
      when '20%'
        @zoom_factor = 0.9
      when '40%'
        @zoom_factor = 0.8
      when '60%'
        @zoom_factor = 0.7
      when '80%'
        @zoom_factor = 0.6
      when '100%'
        @zoom_factor = 0.5
      else
        @zoom_factor = 1
      end
    end

    def fit_vertical
      return unless @image_object
      # w/dim_w = h/dim_h
      # w = h/dim_h*w
      clip_width = @height/@image_dimension[1].to_f*@image_dimension[0]
      @clip_rect_delta_x = (@width - clip_width)/2.0
      @clip_rect_delta_y = 0
    end

    def fit_horizontal
      return unless @image_object
      @clip_rect_delta_x = 0
      @clip_rect_delta_y = (@height/@image_dimension[1]/@image_dimension[0] - @height)/2.0
    end

    def fit_direction
      return unless @image_object
      grapaphic_rect_width_to_height_ratio  = @width / @height.to_f
      image_frame_width_to_height_ratio     = @image_dimension[0] / @image_dimension[1].to_f
      if grapaphic_rect_width_to_height_ratio > image_frame_width_to_height_ratio
        return 'fit_horizontal'
      else
        return 'fit_vertical'
      end
    end

    def fit_keep_ratio
      sugested_direction = fit_direction
      if sugested_direction == 'fit_horizontal'
        fit_horizontal
      elsif sugested_direction == 'fit_vertical'
        fit_vertical
      end
    end


    def fit_ignore_ratio
      @source_frame = [0,0,0,0]
    end

    def fit_by_changing_box_size
      @width       = @image_object.width
      @height      = @image_object.height
    end

    # Convert RGB to CMYK
    # NSColorSpace *targetColorSpace = [NSColorSpace genericCMYKColorSpace];
    # NSBitmapImageRep *targetImageRep;
    # if ([sourceImageRep colorSpace] == targetColorSpace)
    #   { targetImageRep = sourceImageRep; }
    # else
    #   { targetImageRep = [sourceImageRep bitmapImageRepByConvertingToColorSpace:targetColorSpace renderingIntent:NSColorRenderingIntentPerceptual]; }
    # NSData *targetImageData = [targetImageRep representationUsingType:NSJPEGFileType properties:nil];
    # NSImage *targetImage = [[NSImage alloc] initWithData:targetImageData];


  end
end
