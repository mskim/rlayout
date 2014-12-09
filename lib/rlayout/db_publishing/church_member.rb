
# 1. parse church member csv
# 2. create tree
# 3. convert tree to ImageBars
# 4. layout ImageBars into pages

# cell_hash = {
#   type:   category , member
#   name:   name
#   spouse: spouse_name
#   title:  title
#   area:   area
#   phone:  phone
#}
# 
module RLayout
  
  # ChurchMember
  class MemberCell < Container
    attr_accessor :name, :spouse, :area, :phone, :image_folder
    
  end
  
  class CategoryCell < Container
    attr_accessor :name
    
  end
  
  class BodyImageBar < Container
    attr_accessor :column_count, :empty_first_column
    
  end
  
  class HeadImageBar < Container
    attr_accessor :column_count, :empty_first_column
    
  end
  
  def CategoryTree
    attr_accessor :csv_path, :node_tree, :image_bars
    attr_accessor :column_count, :empty_first_column
    def initialize(csv_path, options={})
      parse_csv
      make_image_bar
      self
    end
    
    def parse_csv
      @node_tree = []
      
    end
    
    def make_image_bar
      @image_bars = []
      
    end
  end
  
  class ChurchMember < Document
    attr_accessor :image_bars
    def initialize(options={})
      super
      @image_bars = CategoryTree.new(options).image_bars
      
      self
    end
  end
end
