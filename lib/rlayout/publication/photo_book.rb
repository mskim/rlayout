
# PhotoBook
# PhotoBook is create with a given path.
# in the path, we have series of photos.
# 001.jpg, 002.jpg, .... and so on.
# 001 prefix indicates that this photo belongs to page_1
# 002 prefix indicates that this photo belongs to page_2
# 001 and 002 are paired to create spread_001
# 003 and 004 are paired to create spread_002 so on.
# PhotoBook has multiple PhotoSpreads

# PhotoSpread
# If we have single photo per page, photo is placed in Image
# Image is created on each side of page, left and right
# Image has bleeding and its fitting mode is set to virtical fit.

# How do we put more than single image to a page?
# We can place 001_1.jpg,  001_2.jog, 001_3.jpg.
# This will place all three images in the page 001
# Default 3 images pattern will be applied for this page.

# How do we apply specific layout design to PhotoSpread?
# We can place 001_i3_1.template which will lookup tempate of category i3 and option 1 from template library.

# or we can even place 001.layout along with images for custom design layout code.
# layout file contains pgscript for that page layout as following example.

# { klass: Container,
#     x: #{x}
#     y: #{y}
#     width: #{width},
#     height: #{height},
#     grid_base: [3,3]
#     graphics: [
#       { klass: Image, image_path: image_1, grid_frame: [0,0,1,3]},
#       { klass: Image, image_path: image_2, grid_frame: [1,0,2,2]},
#       { klass: Image, image_path: image_3, grid_frame: [1,2,2,2]}
#     ],
# }

# we can alos apply custom desing to spread as 001_002.layout for page_1, page_2 spread


# if file naming is inconvinent, we can use folders.
# create subfolders named 1, 2, 3, or create subfolders named 1-2, 3-4, 5-6

# place images, layout or templates in the folder

# Or create subfolders with and template in the filename
# 1(wedding), 1-2(student), 3-4(teachers), 5-6(trip)
# it will parse the number of pictures in GIM groups and pull matching templates for the folder.

# randomizing
# If we have repeating patterns, we can randomly select template from same profiled group.
# This should make pages look more human touched.

module RLayout
  class PhotoBook < Document
    attr_accessor :path, :image_files, :template
	  def initialize(options={})
	    super
	    @path     = options[:path]
	    @template = options[:template]
      collect_page_images
	    parse_folder
	    layout_photos
      # save_pdf(@path + "/photobook.pdf")
	    self
	  end

    def collect_page_images
      # Collect same page images into page folder
      # done in two passes
      # In the first pass, check for multiple images for same page,
      # Create page folders
      # And in the second pass, collect images into page folders
      #TODO refactor it to do in a single pass

      current_page = ""
      Dir.glob("#{@path}/*") do |image_file|
        basename = File.basename(image_file)
        new_page = basename.match(/^\d+/)
        if "#{new_page}" == "#{current_page}"
          # we have same page images
          # make folder named current_page
          page_foler = File.dirname(image_file) + "/#{current_page}"
          unless File.exist?(page_foler)
            system("mkdir #{page_foler}") unless File.exist?(page_foler)
          end
        else
          current_page = new_page
        end
      end

      # second pass
      Dir.glob("#{@path}/*") do |image_file|
        basename = File.basename(image_file)
        new_page = basename.match(/^\d+/)
        if !File.directory?(image_file)
          if "#{new_page}" == "#{current_page}"
            page_foler = File.dirname(image_file) + "/#{current_page}"
            system "mv #{image_file} #{page_foler}/#{basename}"
          else
            current_page = new_page
          end
        else
          current_page = new_page
        end
      end

    end

    def parse_folder
	    @image_files = []
	    Dir.glob("#{@path}/*") do |image_file|
        # parse image file
        # or image folder in case we have multipe page
	      @image_files << File.basename(image_file)
      end
	  end

	  def layout_photos
	    @spreads    = []
	    spred_number = 1

      while @image_files.length > 0 do
        left_image  = @image_files.shift
        right_image = @image_files.shift
        sp          = PhotoSpread.new(self, :path: @path, left: left_image, right: right_image, width: 1500, height: 600)
        pdf_path    = @path + "/page_#{spred_number}.pdf"
        puts "pdf_path:#{pdf_path}"
        sp.save_pdf(pdf_path)
        spred_number += 1
      end

	  end

  end

  class PageFoldingRect < Graphic
    def initialized(parent_graphic, options={})
      super

      self
    end

    def draw_fill(r)
      @middle_x = @width/2
      left_middle_rect = NSMakeRect(@middle_x - 10, -5, 10, @height + 10)
      right_middle_rect = NSMakeRect(@middle_x, -5, 10, @height + 10)

      left_gradient = NSGradient.alloc.initWithStartingColor(NSColor.clearColor, endingColor: NSColor.blackColor)
      left_gradient.drawInRect(left_middle_rect, angle:0)

      right_gradient = NSGradient.alloc.initWithStartingColor(NSColor.blackColor , endingColor:  NSColor.clearColor)
      right_gradient.drawInRect(right_middle_rect, angle:0)
    end

  end

  # PhotoSpread
  # We have left_side and right_side
  # @left_images folds images on the left side of spread
  # @right_images folds images on the right side of spread
	class PhotoSpread < Page
	  attr_accessor :parent_graphic, :middle_gutter, :template
	  def initialize(parent_graphic, options={})
	    super
	    @klass = "PhotoSpread"
	    @middle_x = @width/2
      @image_folder = options[:path]
      @left_image = options[:left]
      @right_image = options[:left]

      if File.directory?(@image_folder + "/" + @left_image)
        #TODO multiple images in left page
        # do multiple image layout
      else
        # Single image on left side
        Image.new(self, image_path: @image_folder + "/#{@left_images}", x: -5, y: -5, width: @middle_x + 5, height: @height + 10)
      end

      if File.directory?(@image_folder + "/" + @left_image)
        #TODO multiple images in right page
        # Single image on left side
      else
        Image.new(self, image_path: @image_folder + "/#{@right_images}", x: @middle_x, y: -5, width: @middle_x + 5, height: @height + 10)
      end

      PageFoldingRect.new(self, x: @middle_x - 10, y: -5, width: 20, height: @height + 10)
	    self
	  end
	end

end
