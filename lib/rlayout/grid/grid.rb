#  Created by Min Soo Kim on 9/1/2013.
#  Copyright 2013 SoftwareLab. All rights reserved.

# Grid
#  There are two layout modes, auto_layout and grid mode.
#  layout using auto_layout is subclassed from Conatainer
#    Page, Heading, Column, TextBox, ... most of layout classes are subclass of Conatainer
#  and layout using grid is subclassed from Grid
#    GroupImage, GroupedCaption, GridTable
#
#  In grid mode,
#   grid_cells: acting as place holder for cells to be placed
#   grid[col,row]:  number of columns and rows in its own view
#   grid_cells:     array of grid cells in following hash format
#   example cell:
#   cell =  {
#       column: 3,
#       row: 3,
#       x: 50,
#       y: 50,
#       width: 234.12,
#       height: 122.23,
#     }
#  grid_color:         color of the grid lines
#  grid_frame:         [x,y, width, height] frame in grid unit of parent's grid
#  grid_width:    unit grid with
#  grid_height    unit grid height
#  show_grid:          boolean whether to show or hide grid
#  show_text_line:     boolean whether to show or hide body text lines
#
#  And with each types of publication, we can set the grid system to fit the needs.

# cell margins are different from graphic margins
# graphic margins are used to for stroke and fill
# cell margins are used place cell with margin, but to fill and stroke with graphic margins.
# attr_reader :cell_left_margin, :cell_top_margin, :cell_right_margin, :cell_bottom_margin

module  RLayout

  class Grid < Graphic
    attr_accessor :column, :row, :grid_base, :grid_width, :grid_height, :grid_frame, :grid_h_gutter, :grid_v_gutter, :lines_in_grid
    attr_accessor :gutter, :v_gutter, :grid_cells, :grid_color, :show_grid
    attr_accessor :grid_frame #[x,y, width, height] frame in grid unit of parent's grid
    attr_reader :cell_left_margin, :cell_top_margin, :cell_right_margin, :cell_bottom_margin
    def initialize(options)
      options[:left_margin] = options[:left_margin] || 0
      options[:top_margin] = options[:top_margin] || 0
      options[:right_margin] = options[:right_margin] || 0
      options[:bottom_margin] = options[:bottom_margin] || 0

      @column = options[:column] || 3
      @row = options[:row] || 3
      options[:stroke_width] = 2
      @cell_left_margin = options[:cell_left_margin] || 10
      @cell_top_margin = options[:cell_top_margin] || 10
      @cell_right_margin = options[:cell_right_margin] || 10
      @cell_bottom_margin = options[:cell_bottom_margin] || 10

      super

      @grid_cells = []
      @graphics = []
      @grid_frame = options.fetch(:grid_frame,[0,0,@column,@row])
      if options[:grid_base].class == String && options[:grid_base] =~/x/
        @grid_base    = options[:grid_base].split("x").map{|e| e.to_i}
      elsif options[:grid_base].class == Array
        @grid_base   = options[:grid_base]
      else
        @grid_base = [@column,@row]
      end
      @grid_color     = options.fetch(:grid_color, 'blue')
      @gutter         = options.fetch(:gutter, 0)
      @v_gutter       = options.fetch(:v_gutter, 0)
      @show_grid      = options.fetch(:show_grid, false)
      update_grid
    end


    def update_grid
      @grid_width   = (@width - @cell_left_margin - @cell_right_margin - (@grid_base[0]-1)*@gutter)/@grid_base[0]
      @grid_height  = (@height - @cell_top_margin - @cell_bottom_margin - (@grid_base[1]-1)*@v_gutter)/@grid_base[1]
      @grid         = GridStruct.new(@grid_base, @grid_width, @grid_height, @gutter, @v_gutter)
      update_grid_cells
    end
    
    # over ride container relayout!
    def relayout!
      update_grid_cells
    end

    def update_grid_cells
      @grid_cells   = []
      @grid_width   = (@width - @cell_left_margin - @cell_right_margin - (@grid_base[0]-1)*@gutter)/@grid_base[0]
      @grid_height  = (@height - @cell_top_margin - @cell_bottom_margin - (@grid_base[1]-1)*@v_gutter)/@grid_base[1]
      x_position = @cell_left_margin
      y_position = @cell_top_margin
      @grid_base[1].times do |row|
        @grid_base[0].times do |column|
          grid_cell = {
            column: column,
            row: row,
            x: x_position,
            y: y_position,
            width: @grid_width,
            height: @grid_height,
          }
          @grid_cells << grid_cell
          x_position += @grid_width + @gutter
        end
        x_position = @cell_left_margin
        y_position += @grid_height + @v_gutter
      end
    end

    def grid_to_hash
      h = {}
      h[:grid_base]     = @grid_base unless @grid_base != [1,1]
      h[:grid_frame]    = @grid_frame unless @grid_frame != [0,0,1,1]
      h[:gutter]        = @gutter unless @gutter != 0
      h[:v_gutter]      = @v_gutter unless @v_gutter != 0
    end

    def grid_size
      [@grid_width, @grid_height]
    end

    def grid_area
      @grid_width*@grid_height
    end

    def frame_for(grid_frame)
      x       = @left_margin + @left_inset + grid_frame[0]*@grid_width + grid_frame[0]*@gutter
      y       = @top_margin + @top_inset + grid_frame[1]*@grid_height + grid_frame[1]*@v_gutter
      width   = grid_frame[2]*@grid_width + (grid_frame[2] - 1)*@gutter
      height  = grid_frame[3]*@grid_height+ (grid_frame[3] - 1)*@v_gutter
      [x, y, width, height]
    end

    # size of single grid
    def single_grid_size
      [@grid_width, @grid_height]
    end

    def move_cell_to_left_most(cell)

    end

    def move_cell_to_right_most(cell)

    end

    def move_cell_to_top_most(cell)

    end

    def move_cell_to_bottom_most(cell)

    end

    def flipp_cell_horizontally(cell)
      frame    = cell.grid_record.grid_frame
      right_space = @grid_base[0] - (frame[X_POS] + frame[WIDTH_VAL])
      frame[X_POS] = right_space
    end

    def flipp_cell_vertically(cell)
      frame    = cell.grid_record.grid_frame
      bottom_space = @grid_base[1] - (frame[Y_POS] + frame[HEIGHT_VAL])
      frame[Y_POS] = bottom_space
    end

    def flipp_grid_cells_horizontally
      @graphics.each do |cell|
        flipp_cell_horizontally(cell)
      end
      relayout_grid!
    end

    def flipp_grid_cells_vertically
      @graphics.each do |cell|
        flipp_cell_vertically(cell)
      end
      relayout_grid!
    end

    def flipp_grid_cells_both_way
      flipp_grid_cells_horizontally
      flipp_grid_cells_vertically
      relayout_grid!
    end

    # save to map library
    # 1. find grid size
    # 1. fine file with number of children
    # 1. see if the duplicate exists
    def save_map(options={})
      if File.exists?(grid_map_path)
        # check if the contetn is equal
        if map == read_grid_map
        else
          if available_path_name = make_an_other_grid_map_name
            puts "available_path_name:#{available_path_name}"
            File.open(available_path_name, 'w'){|f| f.write map.to_yaml}
          end
        end
      else
        folder = File.dirname(grid_map_path)
        system("mkdir -p #{folder}") unless File.exists?(folder)
        File.open(grid_map_path, 'w'){|f| f.write map.to_yaml}
      end
    end

    def grid_cells_html
      html= ""
      @graphics.each do |graphic|
        html += graphic.to_html
      end
      html
    end

    def save_map_html(options={})
      html = <<-EOF.gsub(/^\s*/, "")
      <div class="grid_map">
        #{grid_cells_html}
      </div>

      EOF
      html
    end

    def read_grid_map
      YAML::load_file(grid_map_path)
    end

    def duplicate_map_exists?
      File.exists?(grid_map_path)
    end

    # create an other name
    def make_an_other_grid_map_name
      current = grid_map_path
      cadidate = current.gsub(".yml","_1.yml")
      return cadidate unless File.exists?(cadidate)
      20.times do |i|
        cadidate.gsub!(/_(\d+).yml$/,"_#{i+1}.yml")
        return cadidate unless File.exists?(cadidate)
      end
      nil
    end

    def grid_map_path
      "/Users/Shared/SoftwareLab/composite/#{grid_name}/#{@graphics.length}.yml"
    end

    def grid_name
      "#{@grid_base[0]}x#{grid[1]}"
    end

    # return true if all grids are occupied
    def fully_occupied?

    end

    # return true if ant cells are overlapping
    def over_lapping_calls?

    end

    def map
      list = []
      @graphics.each do |cell|
        list << cell.grid_record.grid_frame
      end
      h = {}
      h[grid_name.to_sym]= list
    end

    # given cell index, get x, y position in grid unit
    def grid_frame_of(grid_index)
      origin_array = origin_of_cell(grid_index)
      origin_array << 1
      origin_array << 1
      origin_array
    end

    def origin_of_cell(cell_index)
      if cell_index < 0
        return [0,0]
      elsif cell_index > @grid_base[0]*@grid_base[1]
        return [@grid_base[0] - 1, @grid_base[1] - 1]
      end
      row = cell_index / @grid_base[0]
      column = cell_index % @grid_base[0]
      [column, row]
    end

    # given cell number, calculate needed rows and columns
    def best_fitting_grid_base(number, options={})
      adjust_columns_and_rows_for(number, column:true)
    end

    # given cell number, calculate needed rows and columns
    def adjust_columns_and_rows_for(number, options={})
      int_value = Math.sqrt(number).to_i
      @grid_base = []
      if Math.sqrt(number) == Math.sqrt(number).to_i
        @grid_base[0] = int_value
        @grid_base[1] = int_value
      else
        if (int_value+1)*(int_value) >=  number
          if options[:column]
            @grid_base[0] = int_value+1
            @grid_base[1] = int_value
          elsif options[:row]
            @grid_base[0] = int_value
            @grid_base[1] = int_value+1
          else
            @grid_base[0] = int_value+1
            @grid_base[1] = int_value
          end
        else
          @grid_base[0] = int_value+1
          @grid_base[1] = int_value+1
        end
      end
      @grid_base
    end

    def cells
      return nil unless @owner_graphic
      return nil unless @graphics.length == 0
      @graphics
    end

    # def adjust_cell_sizes_to_fill(options={})
    #   return unless cells
    #
    #   cell_count = cells.length
    #   if cells.length < @grid_base[1]
    #
    #   else
    #
    #   end
    #
    # end

    def layout_cells
      return unless @owner_graphic
      row     = 0
      column  = 0
      @graphics.each_with_index do |graphic, i|
        graphic.grid_record.grid_frame=[column,row,1,1]
        column +=1
        if column >= @grid_base[0]
          row += 1
          column = 0
        end
      end
    end

    def grid_unit_size
      [@grid_width, @grid_height]
    end

    # set grid_cell index
    # adjust grid cells with grid_width, grid_height
    def relayout_grid!
      return unless @grid_cells
      @grid_width  = (@width - @left - @left_inset - @right - @right_inset)/@grid_base[0]
      @grid_height = (@height - @top - @top_inset - @bottom - @bottom_inset)/@grid_base[1]

      update_grids
      x   = @left + @left_inset
      y   = @top + @top_inset
      col = 0
      row = 0

      @graphics.each_with_index do |graphic, i|
        unless graphic.grid_frame
          graphic.grid_frame   = [0,0,1,1]
        end
        graphic.x    = x + graphic.grid_frame[X_POS]*@grid_width
        graphic.y    = y
        graphic.width  = graphic.grid_frame[WIDTH_VAL]*@grid_width
        graphic.height = graphic.grid_frame[HEIGHT_VAL]*@grid_height

        if graphic.class == Image
          graphic.image_record.apply_fit_type if graphic.image_record
        end

        # recursive layout for children of graphic
        if graphic.kind_of?(Container)
          graphic.relayout
        end

        x+= graphic.width
        col +=1
        if col >= @grid_base[0]
          col = 0
          x   = @left + @left_inset
          y+= graphic.height
          row+=1
        end
      end

      # when some changes, we want to inform parent to auto_save
      if @auto_save
        if @parent_grapic
          @parent_grapic.auto_save
        else
          # do save
        end
      end
    end

    # given a point, return grid cell,
    def point_in_rect?(point, rect)
      ((point[X_POS] >= rect[X_POS]) && (point[X_POS] <= rect[X_POS]+rect[WIDTH_VAL])) && ((point[Y_POS] >= rect[Y_POS]) && (point[Y_POS] <= rect[Y_POS]+rect[HEIGHT_VAL]))
    end

    # given a point, return grid cell,
    def grid_cell_of(point)
      @grid_cells.each do |cell|
          return cell if point_in_rect?(point, cell)
      end
      nil
    end

    def occupying_grids(graphic)
      occupied_grid = []
      starting_grid_index = graphic.grid_record.grid_frame[X_POS]  + graphic.grid_record.grid_frame[Y_POS] * @grid_base[1]
      @grid_frame[HEIGHT_VAL].times do
        @grid_frame[WIDTH_VAL].times do |i|
          occupied_grid << starting_grid_index + i
        end
        starting_grid_index = starting_grid_index + @grid_base[1]
      end
      occupied_grid
    end

    # find unoccupied_girds
    def unoccupied_grids
      return unless @owner_graphic
      # go through all the graphics and get occupied grid collection
      # from occupied grid collection get empty grid collection

      occupied = []
      @graphics.each do |graphic|
        starting_grid_index = graphic.grid_record.grid_frame[X_POS]  + graphic.grid_record.grid_frame[Y_POS] * @grid_base[1]
        graphic.grid_record.grid_frame[HEIGHT_VAL].times do
          graphic.grid_record.grid_frame[WIDTH_VAL].times do |i|
            occupied << starting_grid_index + i
          end
          starting_grid_index = starting_grid_index + @grid_base[1]
        end
      end

      empty_grids = Array(0..(@grid_base[0]*@grid_base[1]-1))
      occupied.each do |occupaying_grid|
        empty_grids.delete(occupaying_grid)
      end
      empty_grids
    end

    # place the graphic at given grid index of parent grid with width of 1 and height of 1
    def place_graphic_at(grid_index)
      @grid_frame = grid_frame_of(grid_index)
    end

    # ++++++++++++++ getting the  grid at point
    def grid_cell_at_point(point)
      @graphics.each_with_index do |cell, i|
        if point_in_rect?(point, cell.frame)
          return i
        end
      end
      return nil
    end

  end

end
