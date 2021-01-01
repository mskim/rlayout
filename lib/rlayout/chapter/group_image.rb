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
      # @parent       = options[:parent]
      # @x            = options[:x]
      # @y            = options[:y]
      # @width        = options[:width]
      # @height       = options[:height]
      @column       = options[:column]
      @row          = options[:row]
      @image_items  = options[:image_items]
      layout_items
      self
    end

    def layout_items
      row_width = width/column
      row_height = height/row
      @image_items.each do |item|
        if item[:cation_collection]

        else
          item_column_number = item[position]%column
          item_row_number = item[position]/column
          item_x = (column_number - 1)*row_width
          item_y = (row_number - 1)*row_height
          Image.new(parent:self, image_path: item[:image_path], x:item_x, y:item_y, width:item_width, height:item_height)
        end

      end
    end
  end
end