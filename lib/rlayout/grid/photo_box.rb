module RLayout
  # PhotoBox 
  # PhotoBox arranges photos into a box accoring to number of photos,
  
  # There are coulpe of ways to do this.
  # 1. given list of pictures
  # 2. given row  with  pictures
  # 3. given column  with  pictures
  # 4. given column row with  pictures
  # 5. cell_layout_info with specification of which one should be the large ones and column row.
  # %w[[colun,row], 1x1, 1x2, 1x1]

  class PhotoBox < Grid
    attr_reader :photo_item, :photo_item_count, :cell_layout_info
    attr_reader :column, :row

    def initialize(options={})
      @photo_item = options[:photo_item]
      # warning if 0 item
      @photo_item_count = @photo_item.length
      @column = options[:column]
      @row = options[:row]
      @cell_layout_info = options[:cell_layout_info]
      
      if @cell_layout_info
        options[:column] = @cell_layout_info[0]
        options[:row] = @cell_layout_info[1]
      end
      super

      if @cell_layout_info
        layout_photo_item_with_cell_layout_info
      elsif @column && @row
        layout_photo_item_with_column_and_row
      elsif @column 
        layout_photo_item_column
      elsif @row
        layout_photo_item_row
      else
        layout_photo_item
      end
      self
    end

    def layout_photo_item
      if @graphics > @photo_item_count
        differnces = @graphics - @photo_item_count
        create_cell_size_array
        layout_cells
      else

      end
    end

    def layout_photo_item_row
      bigger_count = (@photo_item_count/@row.to_f).ceil
      new_array = @photo_item.each_slice(bigger_count)
      
    end

    def layout_photo_item_column

    end

    def layout_photo_item_with_column_and_row
      cell_count = @column*@row
      if cell_count > @photo_item_count
        @room = @graphics - @photo_item_count
        create_cell_size_array
        layout_cells
      else

      end
    end

    def layout_photo_item_with_cell_layout_info
      @cell_size_array = cell_layout_info[1..-1]
      layout_cells
    end

    def create_cell_size_array
      @cell_size_array = cells.map{|c| "1x1"}
      @room.times do |i|
        
      end
    end

    def layout_cells

    end
  end


end