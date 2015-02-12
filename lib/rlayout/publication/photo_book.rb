
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
	    parse_folder
	    layout_photos
      # save_pdf(@path + "/photobook.pdf")
	    self
	  end
	  
	  def parse_folder
	    @image_files = []
	    Dir.glob("#{@path}/*.jpg") do |image_file|
	      @image_files << image_file
      end
	  end
	  	  
	  def layout_photos
	    @spreads = []
	    page_number = 1
	    while @image_files.length > 0 do
	      left_image = @image_files.shift
	      right_image = @image_files.shift 
	      sp = PhotoSpread.new(self, left: left_image, right: right_image, width: 1500, height: 600)
        sp.save_pdf(@path + "/page_#{page_number}.pdf")
        page_number += 1
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
  
  class PhotoPage < Page
    
  end
  
	class PhotoSpread < Page
	  attr_accessor :parent_graphic, :middle_gutter, :template
	  def initialize(parent_graphic, options={})
	    super
	    @klass = "PhotoSpread"
	    middle_image_path = "Users/mskim/Development/photo_layout/middle.psd"
	    @middle_x = @width/2
	    puts "options[:left]:#{options[:left]}"
	    puts "options[:right]:#{options[:right]}"
      Image.new(self, image_path: options[:left], x: -5, y: -5, width: @middle_x + 5, height: @height + 10)
      Image.new(self, image_path: options[:right], x: @middle_x, y: -5, width: @middle_x + 5, height: @height + 10)
      PageFoldingRect.new(self, x: @middle_x - 10, y: -5, width: 20, height: @height + 10)	     
	    self
	  end
	end

end

