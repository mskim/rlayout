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

  # image_flow 
  # first line of member_images are placed starting from top left[0,0] to right 
  # but for the second line on we have two ways of placing member_images. "linked" and "from_start"
  # "linked": when member_images reached right edge, next image will be placed below the right edge and start flowing to the left.
  # "from_start": when member_images reached right edge, next image will be placed at the start left edge like the first line.
  
  # grouped_caption:boolean
  # member_image captions are not place under the images, but they are grouped and placed at one of the cell location 
  # This is used in yearbook layout, where students names are place as grouped_caption with same location as the images.
  
  class GroupImage < Matrix
    attr_reader :image_items
    attr_reader :direction,  :output_path
    attr_reader :images_folder, :group_caption, :image_item_captions, :hide_caption
    attr_reader :profile, :gutter, :v_gutter
    attr_reader :member_shape # rect, circle
    attr_reader :image_flow # linked, each_row
    attr_reader :grouped_caption, :grouped_caption_cell

    def initialize(options={})
      super
      @group_caption = options[:group_caption] || false
      @hide_caption = options[:show_caption] || true
      @member_shape = options[:member_shape] || 'rect'
      # there are two ways to pass image_path_info
      # first way is to pass "images_folder" and "image_items"
      # and an other way is to pass image_items_full_path_array of each image
      if options[:images_folder] && options[:image_items]
        @images_folder  = options[:images_folder]
        @image_items  = options[:image_items]
        @image_items_full_path_array = @image_items.map do |item|
          @images_folder + "/#{item}"
        end
      elsif options[:image_items_full_path_array]
        @image_items_full_path_array  = options[:image_items_full_path_array]
      else
        puts "member_image path not given"
        return
      end
      @width        = options[:width]
      @height       = options[:height]
      @gutter       = options[:gutter] || 3
      @v_gutter     = options[:v_gutter] || 3
      @direction    = options[:direction] || 'horizontal'
      if options[:image_item_captions]
        @image_item_captions = options[:image_item_captions]
      elsif options[:group_caption]
        @group_caption = options[:group_caption]
      end
      @output_path  = options[:output_path]
      if @direction == 'horizontal'
        @column       = options[:column] || @image_items_full_path_array.length
        @row          = options[:row]    || 1  
      else
        @column       = options[:column] || 1 
        @row          = options[:row]    || @image_items_full_path_array.length
      end
      layout_items if @image_items_full_path_array.length > 0
      self
    end

    def dummy_image_path
      "/Users/Shared/SoftwareLab/images/dummy.jpg"
    end
    
    def layout_items
      @row_width  = (@width - (@column-1)*@gutter)/@column
      @row_height = (@height - (@row-1)*@v_gutter)/@row
      x_position = 0
      y_position = 0
      # TODO: handle mutile row 
      @image_items_full_path_array.each_with_index do |item, i|
        # Image.new(parent:self, image_path: item[:image_path], x:item[:x], y:item[:y], width:item[:width], height:item[:height])
        h = {}
        h[:parent]      = self
        h[:image_path]  = item
        if @image_item_captions
          h[:caption]     = @image_item_captions[i]
        end
        h[:x]           = x_position
        h[:y]           = y_position
        h[:width]       = @row_width
        h[:height]      = @row_height
        h[:shape]       = @member_shape
        ImagePlus.new(h)
        x_position += row_width + @gutter
      end
    end

    def graphics_with_image
      @graphics.map{|g| g.image_path !=nil}
    end

    def grouped_caption_cell
      @graphics.map{|g| g.cell_position == graphics_with_image.length + 1}
    end

    def generate_group_caption_map
      h = {}
      h[:cell_type] = 'text'
      h[:captions_array] = @graphics.map{|g| g.caption}
      h[:parent] = grouped_caption_cell
      GroupedCaption.new(h)
    end
  end

  # GroupedCaption is placed in one of the empty GroupImage cells.
  # It displays grouped captions for image_cells at a location of images.
  # Think yearbook pictures with collected names area away from pictures. 
  class GroupedCaption < Matrix
    attr_reader :cell_position, :column_index, :row_index
    attr_reader :captions_array
    def initialize(options = {})
      @column_index = options[:column_index]
      @row_index = options[:row_index]
      @captions_array = options[:captions_array]
      # TODO: get x, y, width, height from parent
      # put the GroupedCaption in the middle of parent cell
      @parent = options[:parent]
      options[:x] = parent.width/4
      options[:y] = parent.height/4
      options[:width] = parent.width/2
      options[:height] = parent.height/2
      super
      self
    end
  end

end