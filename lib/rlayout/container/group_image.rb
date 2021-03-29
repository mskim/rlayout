module RLayout

  # GroupImage
  # column
  # row
  # image_items = [{position: 1, image_path:some_oath}]
  # 
  # TODO
  # add member caption 
  # default is to show caption for each individual images
  # if group_caption can be # false, collection_cell, bottom 

  class GroupImage < Container
    attr_reader :column, :row, :image_items
    attr_reader :direction,  :output_path
    attr_reader :images_folder, :group_caption, :image_item_captions, :hide_caption

    def initialize(options={})
      super
      @group_caption = options[:group_caption] || false
      @hide_caption = options[:show_caption] || true
      # there are two ways to pass image_path_info
      # first way is to pass "images_folder" and "image_items"
      # and an other way is to pass image_items_full_path of each image
      if options[:images_folder] && options[:image_items]
        @images_folder  = options[:images_folder]
        @image_items  = options[:image_items]
        # create image_items_full_path
        @image_items_full_path = @image_items.map do |item|
          @images_folder + "/#{item}"
        end
      else
        @image_items_full_path  = options[:image_items_full_path]
      end
      @width        = options[:width]
      @height       = options[:height]
      @direction    = options[:direction] || 'horizontal'
      if options[:image_item_captions]
        @image_item_captions = options[:image_item_captions]
      elsif options[:group_caption]
        @group_caption = options[:group_caption]
      end
      
      @output_path  = options[:output_path]
      if @direction == 'horizontal'
        @column       = options[:column] || @image_items_full_path.length
        @row          = options[:row]    || 1  
      else
        @column       = options[:column] || 1 
        @row          = options[:row]    || @image_items_full_path.length
      end
      layout_items if @image_items_full_path.length > 0
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
      @image_items_full_path.each_with_index do |item, i|
        # Image.new(parent:self, image_path: item[:image_path], x:item[:x], y:item[:y], width:item[:width], height:item[:height])
        h = {}
        h[:parent]      = self
        h[:image_path]  = item
        if @image_item_captions
          h[:caption]     = @image_item_captions[i]
        end
        h[:x]           = x_position
        h[:y]           = y_position
        h[:width]       = row_width
        h[:height]      = row_height
        ImagePlus.new(h)
        x_position += row_width
      end
    end
  end
end