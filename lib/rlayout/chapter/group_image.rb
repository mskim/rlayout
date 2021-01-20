module RLayout

  # GroupImage
  # column
  # row
  # image_items = [{position: 1, image_path:some_oath}]
  # 
  class GroupImage < Container
    attr_reader :x, :y ,:width, :height, :column, :row, :image_items

    def initialize(options={})
      super
      @column       = options[:column]
      @row          = options[:row]
      @image_items  = options[:image_items]
      layout_items
      self
    end

    def dummy_image_path
      "/Users/Shared/SoftwareLab/images/dummy.jpg"
    end
    
    def layout_items
      row_width = width/column
      row_height = height/row
      @image_items.each do |item|
        if item[:cation_collection]

        else
          Image.new(parent:self, image_path: item[:image_path], x:item[:x], y:item[:y], width:item[:width], height:item[:height])
        end
      end
    end
  end
end