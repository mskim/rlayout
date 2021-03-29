module RLayout
  
  # BoxGroupImage creats GroupImage Layout using BoxTable.
  # 2D array of image_path's are passed to table.
  # BoxGroupImage creates table_cell_image at the cell.
  
  class BoxGroupImage < BoxTable
    attr_reader :image_data
    def initialize(options={})

    end
  end
end