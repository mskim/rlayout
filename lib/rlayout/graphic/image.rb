
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

    def init_image(options)

      @image_record  = options.fetch(:image_record,nil)
      unless options[:image_path]
        if options[:local_image] && $ProjectPath
          @local_image          = options[:local_image]
          options[:image_path]  = $ProjectPath + "/images/" + options[:local_image]
        else
        # elsif options[:local_image]
        #   @local_image          = options[:local_image]
          return
        end
      end
      @image_path       = options[:image_path]
      @image_fit_type   = options.fetch(:image_fit_type, image_defaults[:image_fit_type])
      @image_fit_type   = @image_fit_type.to_i
      unless File.exists?(@image_path)
        @image_path = "/Users/Shared/SoftwareLab/images/dummy.jpg"
        @stroke[:color] = 'black'
        @stroke[:thickness] = 1.0
        @stroke[:sides] = [1,1,1,1,1,1]
        @fill[:color] = 'lightGray'
      end
      @image_path
      #TODO Get rid of this and do it for MRI
      if RUBY_ENGINE == 'rubymotion'
        @image_object     =NSImage.alloc.initByReferencingFile(@image_path)
        @image_dimension  = [@image_object.size.width, @image_object.size.height]
        if @image_object && options[:adjust_height_to_keep_ratio]
          @height *= image_object_height_to_width_ratio
        end
        apply_fit_type
      else
        # @image_object     = MiniMagick::Image.open(@image_path)
        # @image_dimension  = @image_object.dimensions
        # if @image_object && options[:adjust_height_to_keep_ratio]
        #   @height *= image_object_height_to_width_ratio
        # end
        # apply_fit_type
      end

      if options[:image_caption] || options[:image_caption]
        @image_caption = options[:image_caption] || options[:image_caption]
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
      case @image_fit_type
      when  IMAGE_FIT_TYPE_ORIGINAL
        fit_original
      when  IMAGE_FIT_TYPE_VERTICAL
        fit_vertical
      when  IMAGE_FIT_TYPE_HORIZONTAL
        fit_horizontal
      when  IMAGE_FIT_TYPE_KEEP_RATIO
        fit_keep_ratio
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
      else
        @height/@width
      end
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
        @source_frame.origin.x = @image_frame.size.width/2.0 - frame_rect.size.width/2.0
        @source_frame.origin.y = @image_frame.size.height/2.0 - frame_rect.size.height/2.0
      else

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
         source_width = @width / (@height/@image_frame.size.height)
         @source_frame.origin.x = (@image_frame.size.width - source_width)/2.0
         @source_frame.origin.y = 0
         @source_frame.size.width = source_width
         @source_frame.size.height = @image_frame.size.height
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
        # @image_object.drawInRect(rect, fromRect:@source_frame, operation:NSCompositeSourceOver, fraction:1.0, respectFlipped:true, hints:nil) if @image_object
        # This is really confusing. If I want to make smaller image , I have to make the source_frame larger
        source_height = @height / (@width/@image_frame.size.width)
        @source_frame.origin.x = 0
        @source_frame.origin.y = (@image_frame.size.height - source_height)/2.0
        @source_frame.size.height = source_height
        @source_frame.size.width = @image_frame.size.width
      else

      end
    end

    def fit_keep_ratio
      return unless @image_object
      if RUBY_ENGINE == 'rubymotion'
        @image_frame      = NSZeroRect
        @image_frame.size = @image_object.size
        grapaphic_rect_width_to_height_ratio  = @width/@height
        image_frame_width_to_height_ratio     = @image_frame.size.width/@image_frame.size.height
        if grapaphic_rect_width_to_height_ratio > image_frame_width_to_height_ratio
          fit_horizontal
        else
          fit_vertical
        end
      else

      end
    end


    def fit_ignore_ratio
      @source_frame = [0,0,0,0]
    end

    def fit_by_changing_box_size
      puts "fit_by_changing_box_size"
    end

  end
end
