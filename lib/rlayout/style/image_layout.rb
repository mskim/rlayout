
# We should keep pre-designed image patterns for auto layout image.
# For given image profile, we should be able to layout images without manual process.
# image profile example
#   - 1_large-2_small
# We could have multiple choices for given, 2,3 or more

module RLayout
  
  class ImagePattern
    attr_accessor :profile, :grid_base, :star
    def initialize(profile, grid_base)
      @profile    = profile
      @grid_base  = grid_base
      generate_image_layout
      self
    end
    
    def generate_image_layout
      
    end
    
  end
  
  
  
end