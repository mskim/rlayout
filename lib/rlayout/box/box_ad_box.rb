module RLayout
  class BoxAdBox < Container
    attr_accessor :catagory_level, :path, :item_data, :box_ad_array
    
    def initialize()
      parse_csv
      
      self
    end
    
    def layout_box_ad!
      
    end
  end
  
  class BoxAd < Container
    attr_accessor :category, :ad_type
    attr_accessor :company, :phone, :address, :copy1, :copy2, :copy3
    attr_accessor :map
    
    def initialize(parent_graphics, options={}, &block)
      
      self
    end
  end
  
end