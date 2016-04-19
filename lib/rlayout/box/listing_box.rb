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
    def initialize(options={}, &block)
      
    end
  end
  
  # text list
  class ListItemRow  < Container
    def initialize(options={}, &block)
      
    end
    
  end
  
  # image list
  
  class ListImageRow < Container
    attr_accessor :images_array
    
    def initialize(options={}, &block)
      options[:layout_direction] = "horizontal" unless options[:layout_direction]
      super
      @images_array = options[:images_array]
      @images_array.each do |image_path|
        if image_path
          Image.new(image_path: image_path)
        elsif options[:images_array] =~/[.jpg|.pdf$]/
          Text.new(text_string: image_path)
        else
          Rectangle.new(image_path: image_path)
        end
      end
      
      self
    end
    
    
    
    
    
  end

end
