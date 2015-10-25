# Listing
# Similar to Story, but using csv 
# Creates ListCategoryRow, and ListItemRow
#
module RLayout
  attr_accessor :catagory_level, :path, :item_data, :rows
  
  class ListingBox < Container
    def initialize()
      parse_csv
      
      self
    end
    
    def layout_list!
      
    end
  end
  
  class ListCategoryRow < Container
    attr_accessor :level, :category
    def initialize(parent_graphics, options={}, &block)
      
    end
  end
  
  class ListItemRow  < Container
    def initialize(parent_graphics, options={}, &block)
      
    end
    
  end
  

end
