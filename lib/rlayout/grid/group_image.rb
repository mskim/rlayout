module RLayout

  # GroupImage < Grid
  # column
  # row
  # 

  # captopm
  # cell cation and group_cell_caption

  # group_cell_caption
  # member_image captions are grouped and placed at one of the cell location 
  # This is used in yearbook layout, where students names are place as grouped_caption with same location as the images.
  
  # usage
  # specifiy column and row
  # GroupImage.new(column: 3, row: 3, width: 400, height: 400, images_folder: folder_path, images: images_list_array)

  # single row GroupImage
  # Newspaper personal picture are layout in horizonral fashion.
  # dirction 
  # direction: 'horizontal 
  # This will make horizontally spaning images 4x1 with single row.
  # direction: 'vertical'
  # This will make vertical spaning images 1x4 with single column.

  # best fit column and row
  # if no direction nor column row value is given, it will try to make column and row value as squre as possible column and row values.
  # class Grid
  # def best_fitting_grid_base(number, options={})

  # only column value is specified
  # in this case row value can vary with number of member cells

  # image_path
  # there are two ways to pass image_path_info
  # first way is to pass "images_folder" and "image_items"
  # or image_items_full_path_array of each full image_path

  # caption
  # caption text for each member cells can be provide with image_item_captions array
  # or each cation text can be read from filename, if @caption_from_basename is set to true
  # default @caption_from_basename value is set to true
 
  
  class GroupImage < Grid
    attr_reader :image_items
    attr_reader :direction,  :output_path
    attr_reader :images_folder, :image_item_captions, :caption_from_basename, :hide_caption
    attr_reader :profile, :gutter, :v_gutter
    attr_reader :member_shape # rect, circle
    attr_reader :image_flow # linked, each_row
    attr_reader :group_caption, :group_caption_cell, :group_caption_text
    attr_reader :horizontal_caption

    def initialize(options={})
      @column       = options[:column] #|| 2
      @row          = options[:row] #|| 2
      @direction    = options[:direction] #|| 'horizontal'

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
      if @direction == 'horizontal'
        @column       = options[:column] || @image_items_full_path_array.length
        @row          = options[:row]    || 1  
      elsif @direction == 'vertical'
        @column       = options[:column] || 1 
        @row          = options[:row]    || @image_items_full_path_array.length
      elsif @column && @row
        options[:grid_base] = [@column, @row]
      elsif @column
        # only column valus is given, calculate row value
        result = @image_items_full_path_array.length/@column
        if (@image_items_full_path_array.length % @column) !=0
          @row = result.to_i + 1
        end
        options[:grid_base] = [@column, @row]
      else
        options[:grid_base] = best_fitting_grid_base(@image_items_full_path_array.length)
      end

      super
      @output_path  = options[:output_path]
      @group_caption = options[:group_caption] || false
      @hide_caption = options[:show_caption] || true
      @member_shape = options[:member_shape] || 'rect'
      @member_shape = options[:member_shape] || 'circle'
      @gutter       = options[:gutter] || 3
      @v_gutter     = options[:v_gutter] || 3
      @image_item_captions = options[:image_item_captions]
      @caption_from_basename = options[:caption_from_basename] || true
      layout_items if @image_items_full_path_array.length > 0
      self
    end

    def dummy_image_path
      "/Users/Shared/SoftwareLab/images/dummy.jpg"
    end
    
    def layout_items
      # @row_width  = (@width - (@column-1)*@gutter)/@column
      # @row_height = (@height - (@row-1)*@v_gutter)/@row
      # x_position = 0
      # y_position = 0
      # TODO: handle mutile row 
      @group_cation_cell = @image_items_full_path_array.length
      @image_items_full_path_array.each_with_index do |item, i|
        # Image.new(parent:self, image_path: item[:image_path], x:item[:x], y:item[:y], width:item[:width], height:item[:height])
        h = {}
        h[:parent]      = self
        h[:image_path]  = item
        cell            = @grid_cells[i]
        h[:x]           = cell[:x]
        h[:y]           = cell[:y]
        h[:width]       = cell[:width]
        h[:height]      = cell[:height]
        h[:shape]       = @member_shape || 'circle'
        h[:stroke_width] = 5
        h[:stroke_color] = 'red'
        h[:fill_color] = 'clear'
        if @group_caption
          h[:caption] = nil
        else
          # indivisual caption
          if @image_item_captions
            h[:caption] = @image_item_captions[i]
          else
            h[:caption_from_basename] = @caption_from_basename
          end
        end
        ImagePlus.new(h)
        # Image.new(h)
      end
      if @group_caption
        h = {}
        h[:parent]      = self
        i = @image_items_full_path_array.length
        cell            = @grid_cells[i]
        h[:column]      = @column
        h[:row]         = @row
        h[:x]           = cell[:x]
        h[:y]           = cell[:y]
        h[:width]       = cell[:width]
        h[:height]      = cell[:height]/3
        h[:text_string_array] = @image_items_full_path_array.map{|f| File.basename(f,".jpg")}
        GroupedCaption.new(h)
      end
    end

  end

end