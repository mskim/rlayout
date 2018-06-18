# GridBox is used to display items in grid.
# Ww could have different number of items. and our task is to create grid cells that can accomodate those items.

# GirdCell Structure
# [column, row, [x,y,width, height]]

# GridBox can have 3 different layout modes.
# 1. grid_base: grid_base is given and items should fit to those grid.
# 3. grid_base is nil": grid items are given and grid_base should be determinded to fit items.

module RLayout
  class GridBox < Container
    attr_accessor :grid_base, :grid_width, :grid_height, :grid_h_gutter, :grid_v_gutter
    attr_accessor :starting_item_index, :ending_item_index
    attr_accessor :next_link, :previous_link
    attr_accessor :draw_gutter_stroke, :over_flow
    def initialize(options={}, &block)
      super
      @grid_h_gutter = options.fetch(:grid_h_gutter, 10)
      @grid_v_gutter = options.fetch(:grid_v_gutter, 10)

      if block
        instance_eval(&block)
      end
      self
    end

    def over_flow?

    end

    # given cell number, calculate needed grid_base
    def calculate_grid_base_for_items
      number = @grid_items.length
      int_value=Math.sqrt(number).to_i
      @grid_base = []
      if Math.sqrt(number) > Math.sqrt(number).to_i
        if (int_value+1)*(int_value) >=  number
          @grid_base[0]= int_value+1
          @grid_base[1]   = int_value
        else
          @grid_base[0]= int_value+1
          @grid_base[1]   = int_value+1
        end
      elsif Math.sqrt(number) == Math.sqrt(number).to_i
        @grid_base[0]     = int_value
        @grid_base[1]     = int_value
      end
      make_better_fitting_rows_and_column
    end

    # flip @grid_base, if graphic height is greater than the width
    def make_better_fitting_rows_and_column
      horizontal_room = @width - @left_margin - @right_margin
      vertical_room = @height - @top_margin - @bottom_margin
      if horizontal_room < vertical_room
        temp_value  = @grid_base[0]
        @grid_base[0]= @grid_base[1]
        @grid_base[1]   = temp_value
      end
      # TODO
      # we have done calculate_columns_and_rows_for
      # now we know number of cells, rows, columns, frame width and height
      # But still, this can produce matrix of very thin rectangles
      # Check if curent cell size produces a thin rectange
      # if so, we should switch row and column values to make it better fit, close to square.
      # I want cells to be closed to the square as possible
      # Many cases, just switching rows and column number will do the trick
      # current_cell_width_height_ratio
      # flipped_cell_width_height_ratio
      # if need_switch
      #    switch
      #    @product_matrix.grid_record.update_grids
      # end
    end

    # layout items into grid_cells
    def layout_items(grid_items, options={})
      @grid_items = grid_items
      @grid_h_gutter = options[:grid_h_gutter] if options[:grid_h_gutter]
      @grid_v_gutter = options[:grid_v_gutter] if options[:grid_v_gutter]

      if options[:grid_base]
        @grid_base      = options[:grid_base]
        if @grid_base.class == String
          grid_array    = @grid_array.split("x")
          @grid_base    = []
          @grid_base[0] = grid_array[0].to_i
          @grid_base[1] = grid_array[1].to_i
        end
        @grid_base[0]   = options[:grid_base][0]
        @grid_base[1]   = options[:grid_base][1]
      else
        # if options[:grid_base] is not specified, calculate optimun grid_base foth items
        calculate_grid_base_for_items
      end
      generate_grid_cells
      # place items in the cell locations
      index = 0
      while @item  = grid_items.shift do
        break if index >= @grid_cells.length
        cell_frame  = @grid_cells[index][2]
        @item.x     = cell_frame[0]
        @item.y     = cell_frame[1]
        @item.width = cell_frame[2]
        @item.height= cell_frame[3]
        @item.parent = self
        @graphics << @item
        index += 1
      end

      self
    end

    def generate_grid_cells
      @grid_cells   = []
      @grid_width   = (@width - @left_margin - @right_margin - (@grid_base[0] - 1)*@grid_h_gutter)/@grid_base[0]
      @grid_height  = (@height - @top_margin - @bottom_margin - (@grid_base[1] - 1)*@grid_v_gutter)/@grid_base[1]
      x = @left_margin
      y = @top_margin
      index = 0
      @grid_base[1].times do |i|
        @grid_base[0].times do |j|
          @grid_cells           << []
          @grid_cells[index][0] = j
          @grid_cells[index][1] = i
          @grid_cells[index][2] = [x, y, @grid_width, @grid_height]
          x += @grid_h_gutter + @grid_width
          index += 1
         end
         x  = @left_margin
         y  += @grid_v_gutter + @grid_height
      end

    end


    def document
      @parent.document if @parent
    end

  end
end

__END__
# FLOAT_PATTERNS = {
#   "1/A1/1" => [[]],
#   "1/A1/2" => [[]],
#   "1/A1/3" => [[]],
#   "1/A1/4" => [[]],
#   "1/A1/5" => [[]],
#   "1/A1/6" => [[]],
#   "1/A1/7" => [[]],
#   "1/A1/8" => [[]],
#   "1/A1/9" => [[]],
#
#   "2/A1_B1/1" => [[],[]],
#   "2/A1_B1/2" => [[],[]],
#   "2/A1_B1/3" => [[],[]],
#
#   "2/A1_C1/1" => [[],[]],
#   "2/A1_C1/2" => [[],[]],
#   "2/A1_C1/3" => [[],[]],
#
#   "2/B2/1" => [[],[]],
#   "2/B2/2" => [[],[]],
#   "2/B2/3" => [[],[]],
#
#   "2/C2/1" => [[],[]],
#   "2/C2/2" => [[],[]],
#   "2/C2/3" => [[],[]],
#
#   "3/A1_B2/1" => [[],[],[]],
#   "3/A1_B2/2" => [[],[],[]],
#   "3/A1_B2/3" => [[],[],[]],
#
#   "3/A1_B2_C1/1" => [[],[],[]],
#   "3/A1_B2_C1/2" => [[],[],[]],
#   "3/A1_B2_C1/3" => [[],[],[]],
#
#   "4/A1_B3/1" => [[],[],[],[]],
#   "4/A1_B3/2" => [[],[],[],[]],
#   "4/A1_B3/3" => [[],[],[],[]],
#
#   "4/A1_B1_C2/1" => [[],[],[],[]],
#   "4/A1_B1_C2/2" => [[],[],[],[]],
#   "4/A1_B1_c2/3" => [[],[],[],[]],
#
#   "4/A1_B2_C1/1" => [[],[],[],[]],
#   "4/A1_B2_C1/2" => [[],[],[],[]],
#   "4/A1_B2_C1/3" => [[],[],[],[]],
#
# }
