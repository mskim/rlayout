module RLayout

  # GroupImage
  # column
  # row
  # image_items = [{position: 1, image_path:some_oath}]
  # 
  # TODO
  # add member caption 

  class GroupImage < Container
    attr_reader :x, :y ,:width, :height, :column, :row, :image_items
    attr_reader :direction, :group_caption, :output_path
    def initialize(options={})
      super
      @width        = options[:width]
      @height       = options[:height]
      @height       = options[:height]
      @direction    = options[:direction] || 'horizontal'
      @group_caption = options[:group_caption]
      @image_items  = options[:image_items]
      @output_path  = options[:output_path]
      if @direction == 'horizontal'
        @column       = options[:column] || @image_items.length
        @row          = options[:row]    || 1  
      else
        @column       = options[:column] || 1 
        @row          = options[:row]    || @image_items.length
      end
      layout_items
      self
    end

    def dummy_image_path
      "/Users/Shared/SoftwareLab/images/dummy.jpg"
    end
    
    def layout_items
      row_width = width/column
      row_height = height/row
      x_position = 0
      y_position = 0
      @image_items.each do |item|
        # Image.new(parent:self, image_path: item[:image_path], x:item[:x], y:item[:y], width:item[:width], height:item[:height])
        h = {}
        h[:parent]      = self
        h[:image_path]  = item
        h[:x]           = x
        h[:y]           = y_position
        h[:width]       = row_width
        h[:height]      = row_height
        Image.new(h)
        x_position += row_width
      end
    end
  end
end