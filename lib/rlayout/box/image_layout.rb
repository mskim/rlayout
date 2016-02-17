module RLayout
  
  # ImageLayout is used for processing long document, 
  # where images are inserted along the flowing text.
  # It is a tricky task to layout images, if we treated each images as images come along, 
  # so I dediced to groupt the Images before hand. This makes it much easier to handle.
  # We want to indicated images are placed in a page as a group. 
  # ![image_layout] markup is used as triggering mechanism for pre-designed image layout pattern for the page
  
  # sample markdown markup
  # ![image_layout] {
  #   profile: "4/4x4/3"
  #   image_1: "1.jpg"
  #   image_2: "2.jpg"
  #   image_3: "3.jpg"
  #   image_4: "4.jpg"
  # }
  #
  # # So, this markup should be used at the beginning of the page.
  # This will trigger a new page, layout 4 image as IMAPE_PATTERN frames
  # They will all be floats, and texts will flow around them.
  #
  class ImageLayout < Container
    attr_accessor :profile, :grid_base, :grid_cells
    
    def initialize(parent_graphic, options={})
      super
      @profile = options[:profile]
      
      self
    end
    
    
    
    
    
  
  
  end
end