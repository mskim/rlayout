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

# iamge crop is done with image_crop rect
# crop: {6x6, [1,1,4,4]}
# this will crop image with grid_base and grid_frame

# image catopn file
# location along side the image with file extention of .captopn
# first line is the caption title, if ther are more than single line

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
    def init_image(options)

      @image_record  = options.fetch(:image_record,nil)
      unless options[:image_path]
        if options[:local_image] && $ProjectPath
          @local_image          = options[:local_image]
          puts "++++++ $ProjectPath:#{$ProjectPath}"
          options[:image_path]  = $ProjectPath + "/images/" + options[:local_image]
        else
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
      # @image_path
      if RUBY_ENGINE == 'rubymotion'
        @image_object  = NSImage.alloc.initByReferencingFile(@image_path)
        if @image_path =~/pdf$/ || @image_path =~/PDF$/ || @image_path =~/eps$/ || @image_path =~/EPS$/ || @image_path =~/dummy\.jpg$/
          # do not convert color space for pdf and eps
        else
          sourceImageRep = NSBitmapImageRep.imageRepWithData(@image_object.TIFFRepresentation)
          targetColorSpace = NSColorSpace.deviceCMYKColorSpace
          if (sourceImageRep.colorSpace == targetColorSpace)
            targetImageRep = sourceImageRep
          else
            targetImageRep = sourceImageRep.bitmapImageRepByConvertingToColorSpace(targetColorSpace, renderingIntent:NSColorRenderingIntentPerceptual)
            targetImageData = targetImageRep.representationUsingType(NSJPEGFileType, properties:nil)
            @image_object = NSImage.alloc.initWithData(targetImageData)
          end
        end
        @image_dimension  = [@image_object.size.width, @image_object.size.height]
        if @image_object && options[:adjust_height_to_keep_ratio]
          @height *= image_object_height_to_width_ratio
        end
        apply_fit_type
      else
        @image_object     = MiniMagick::Image.open(@image_path)
        @image_dimension  = @image_object.dimensions
        if @image_object && options[:adjust_height_to_keep_ratio]
          @height *= image_object_height_to_width_ratio
        end
        apply_fit_type
      end
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
      if RUBY_ENGINE == 'rubymotion'
        @image_frame.size = @image_object.size
        # mid_x = NSMidX(@image_frame)
        # mid_y = NSMidY(@image_frame)
        if frame
          @source_frame = frame_rect.dup
        else
          @source_frame = NSZeroRect
          return
        end
        @source_frame.origin.x = @image_frame.size.width/2.0 - frame_rect[2]/2.0
        @source_frame.origin.y = @image_frame.size.height/2.0 - frame_rect[3]/2.0
      else

      end
    end

    def fit_crop_rect
      if RUBY_ENGINE == 'rubymotion'
        @crop_rect[1] += 380 # this is a hack, quess there are some difference in offset from cropper.js
        image_height = @image_object.size.height
        image_width = @image_object.size.width
        @zoom_factor = @width/@image_object.size.width
        @source_frame = NSZeroRect
        @source_frame.origin.x = @crop_rect[0]
        @source_frame.origin.y = (@height - @crop_rect[3] + @crop_rect[1]).abs
        @source_frame.size.width = @crop_rect[2]
        @source_frame.size.height = @crop_rect[3]

      else

      end
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
      if RUBY_ENGINE == 'rubymotion'
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
        puts "++++++++ In fit_vertical"
        if @zoom_level !='0%' && @zoom_anchor !=5
          source_width = @width / (@height/@image_frame.size.height)
          @source_frame.origin.x = (@image_frame.size.width - source_width)/2.0
          @source_frame.origin.y = 0
          @source_frame.size.width = source_width
          @source_frame.size.height = @image_frame.size.height

          @source_frame.size.height*@zoom_factor
          @source_frame.size.width*@zoom_factor
          case @zoom_anchor
          when 1
          when 2
            @source_frame.origin.y += @source_frame.origin.y*@zoom_factor/2
          when 3
            @source_frame.origin.y += @source_frame.origin.y*@zoom_factor
          when 4
            @source_frame.origin.x    += @source_frame.origin.x*@zoom_factor/2
            @source_frame.size.width -= @source_frame.size.width*@zoom_factor
          when 5
            @source_frame.origin.x    += @source_frame.origin.x*@zoom_factor/2
            @source_frame.origin.y    += @source_frame.origin.y*@zoom_factor/2
          when 6
            @source_frame.origin.x    += @source_frame.origin.x*@zoom_factor
            @source_frame.origin.y    += @source_frame.origin.y*@zoom_factor/2
          when 7
            @source_frame.origin.x    += @source_frame.origin.x*@zoom_factor
            @source_frame.size.width -= @source_frame.size.width*@zoom_factor
          when 8
            @source_frame.origin.x    += @source_frame.origin.x*@zoom_factor/2
            @source_frame.origin.y    += @source_frame.origin.y*@zoom_factor
          when 9
            @source_frame.origin.x    += @source_frame.origin.x*@zoom_factor
            @source_frame.origin.y    += @source_frame.origin.y*@zoom_factor
          end
        else
          source_width = @width / (@height/@image_frame.size.height)
          @source_frame.origin.x = (@image_frame.size.width - source_width)/2.0
          @source_frame.origin.y = 0
          @source_frame.size.width = source_width
          @source_frame.size.height = @image_frame.size.height
          puts "@image_frame.origin.x:#{@image_frame.origin.x}"
          puts "@image_frame.origin.y:#{@image_frame.origin.y}"
          puts "@image_frame.size.width:#{@image_frame.size.width}"
          puts "@image_frame.size.height:#{@image_frame.size.height}"

          puts "@source_frame.origin.x:#{@source_frame.origin.x}"
          puts "@source_frame.origin.y:#{@source_frame.origin.y}"
          puts "@source_frame.size.width:#{@source_frame.size.width}"
          puts "@source_frame.size.height:#{@source_frame.size.height}"
        end
      else

      end
    end

    def fit_horizontal
      return unless @image_object
      if RUBY_ENGINE == 'rubymotion'
        @image_frame      = NSZeroRect
        @image_frame.size = @image_object.size
        if @image_frame
          @source_frame = @image_frame.dup
        else
          @source_frame = NSZeroRect
          return
        end
        # if @parent.class == RLayout::NewsImage
        #   puts "++++++++ In fit_horizontal"
        #   puts "++++++++ In @zoom_level:#{@zoom_level}"
        #   puts "++++++++ In @zoom_factor:#{@zoom_factor}"
        #   puts "++++++++ In @zoom_anchor:#{@zoom_anchor}"
        # end
        # @image_object.drawInRect(rect, fromRect:@source_frame, operation:NSCompositeSourceOver, fraction:1.0, respectFlipped:true, hints:nil) if @image_object
        # This is really confusing. If I want to make smaller image , I have to make the source_frame larger
        if @zoom_level !='0%' || @zoom_anchor !=5
          puts "+++++ in adjusting "
          # set_zoom_factor converts @zoom_level to @zoom_factor
          source_height = @height / (@width/@image_frame.size.width)
          @source_frame.origin.x = 0
          @source_frame.origin.y = (@image_frame.size.height - source_height)/2.0
          @source_frame.size.height = source_height
          @source_frame.size.width = @image_frame.size.width
          
          @source_frame.size.height*@zoom_factor
          @source_frame.size.width*@zoom_factor
          case @zoom_anchor
          when 1
            @source_frame.origin.y    += @source_frame.origin.y*@zoom_factor
          when 2
            puts "+++++++ anchor when 2"
            @source_frame.origin.y    += @source_frame.origin.y*@zoom_factor
            if @zoom_level !='0%'
              @source_frame.origin.x += @source_frame.origin.x*@zoom_factor/2
            end
          when 3
            @source_frame.origin.y    += @source_frame.origin.y*@zoom_factor
            @source_frame.origin.x += @source_frame.origin.x*@zoom_factor
          when 4
            @source_frame.origin.y    += @source_frame.origin.y*@zoom_factor/2
          when 5
            @source_frame.origin.x    += @source_frame.origin.x*@zoom_factor/2
            @source_frame.origin.y    += @source_frame.origin.y*@zoom_factor/2
          when 6
            @source_frame.origin.x    += @source_frame.origin.x*@zoom_factor
            @source_frame.origin.y    += @source_frame.origin.y*@zoom_factor/2
          when 7
            @source_frame.origin.y    += @source_frame.origin.y*@zoom_factor
            @source_frame.size.height -= @source_frame.size.height*@zoom_factor
          when 8
            @source_frame.origin.y = 0

            # @source_frame.origin.x    += @source_frame.origin.x*@zoom_factor/2
            # @source_frame.origin.y    += @source_frame.origin.y*@zoom_factor

          when 9
            @source_frame.origin.y = 0

            @source_frame.origin.x    += @source_frame.origin.x*@zoom_factor
            @source_frame.origin.y    += @source_frame.origin.y*@zoom_factor
          end
        else
          source_height = @height / (@width/@image_frame.size.width)
          @source_frame.origin.x = 0
          @source_frame.origin.y = (@image_frame.size.height - source_height)/2.0
          @source_frame.size.height = source_height
          @source_frame.size.width = @image_frame.size.width
        end
      else

      end
    end

    def fit_direction
      return unless @image_object
      if RUBY_ENGINE == 'rubymotion'
        @image_frame      = NSZeroRect
        @image_frame.size = @image_object.size
        grapaphic_rect_width_to_height_ratio  = @width/@height
        image_frame_width_to_height_ratio     = @image_frame.size.width/@image_frame.size.height
        if @crop_rect
          crop_rect_width_to_height_ratio       = @crop_rect[2]/@crop_rect[3]
          if grapaphic_rect_width_to_height_ratio > crop_rect_width_to_height_ratio
            return 'fit_horizontal'
          else
            return 'fit_vertical'
          end

        end
        if grapaphic_rect_width_to_height_ratio > image_frame_width_to_height_ratio
          'fit_horizontal'
        else
          'fit_vertical'
        end
      else
        #TODO for ruby mode
      end
    end

    def fit_keep_ratio
      if fit_direction == 'fit_horizontal'
        fit_horizontal
      elsif fit_direction == 'fit_vertical'
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
