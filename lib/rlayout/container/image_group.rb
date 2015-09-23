
# ImageGroup is a convient way to place multiple images on to page
#  
module RLayout
	class ImageGroup < Container
	  attr_accessor :group_path, :images, :grid_base, :gutter
	  def initialize(parent_graphic, options={})
	    super
	    @group_path = options.fetch(:group_path, "images")
	    @grid_base      = grid_base
	    create_images
	    self
	  end
	  
	  def parse_images
	    Dir.glob("#{$ProjectPaht}/#{group_path}/*{.jpg,.pdf,.tiff}")
	  end
	  
	  def create_images
	    parse_images
	    @images.each_with_index do |image_path|
	      Image.new(self)
      end
	  end
	end


end