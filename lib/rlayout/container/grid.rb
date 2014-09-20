#
#  ggrid.rb
# 
#  Created by Min Soo Kim on 9/1/2013.
#  Copyright 2013 SoftwareLab. All rights reserved.

#  GGridRecord .
#  GGridRecord replaces GMatrixRecord, GMatrixRecord is deprocated
#  Matrix object should use GGridRecord.
#  GGridRecord handles grid based layout.
#  We have two layout modes, stack mode and grid mode.
#  Container can have its own layout mode.
#  A grid elements can have stack based layer . And it's childd can have grid based layer.
#  Default layou is the stack mode.

#  
#  In stack mode, 
#     1. have direction(mode) of vertical or horizontal, for adding and aligning children graphics. 
#     1. Graphic's size and positions are auto adjusted.

#  In grid based mode, graphics adjust sizes based on the grid.
#     1. graphic origin is snapped to upper left grid corner.
#     1. size are set to unit grid block size.
#     1. sizes are expanded or reduced at grid block width and height.
#     1. they move by grid block width and height.
#     1. Grid element can push_a_way overlaping elements to none overlapping spot. 
#.
#  Usually grid mode is used at page level, and auto_layout mode are used in Containers.
#  ex. Portait Page will have 12 x 6 grid system
#      Newpaper at 7 x 12 and some article with auto_layout mode.
#  And with each types of publication, we can set the grid system to fit the needs.


# TODO
#  When child graphic is created in grid mode, it looks for empty space where it does not overlap with other grapic
#  So, the first child will be placed at the upper left corner with size of unit block.
#  And the second child will be placed the right of the first one, if the first row is filled it will place the next child 
#  If one of child's size are changed, it can causing the following cells to be pushed to a new position or it can cause overflow,
#  needing following cells to change it's size.
#  There can be several options for changes the other cells.

#  grid_rect [x,y, width, height]
#  cell_position x,y, position of cell

#   grid_column_count:  number of columns
#   grid_row_count:     number of rows
#   grid_cells:         array of grid cells
#   grid_v_lines:       array of vertical grid lines
#   grid_h_lines:       array of horizontal grid lines
#   grid_color:         color of the grid lines
#   show_grid:          boolean whether to show or hide the lines
#   grid_rect:         frame rect in grid unit

#  Graphic frame is expressed in ralative value to grid
#   grid_rect: cell origen qne width and height

#  frame can be mutated from snapping to the grid by 
#   grid_top_inset:
#   grid_bottom_inset:
#   grid_letf_inset:
#   grid_right_inset:
#   grid_x_shift:
#   grid_y_shift:

# For newspaper
# given number of story
# number of ads
# It should create best fit for given resouces


# Todo
# combine grid_record with auto_layout in to one, since many of them are overlapping
# They should be part of Container methods

require 'yaml'

module  RLayout
  
  # this should go under as Container methods with AutoLayout
  #, since both of them only apply when it has children
  class Container < Graphic
    
    def grid_size
      [@unit_grid_width, @unit_grid_height]
    end
    
    def grid_area
      @unit_grid_width*@unit_grid_height
    end
    
    def frame_for(grid_rect)
      [left_inset + grid_rect[0]*@unit_grid_width, @left_inset + grid_rect[1]*@unit_grid_height, grid_rect[2]*@unit_grid_width, grid_rect[3]*@unit_grid_height]
    end
    
    # size of single grid
    def single_grid_size
      [@unit_grid_width, @unit_grid_height]      
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
      frame    = cell.grid_record.grid_rect
      right_space = @grid_column_count - (frame[0] + frame[2])
      frame[0] = right_space
    end
    
    
    def flipp_cell_vertically(cell)
      puts __method__
      frame    = cell.grid_record.grid_rect
      bottom_space = @grid_row_count - (frame[1] + frame[3])
      frame[1] = bottom_space
    end
    
    def flipp_grid_cells_horizontally
      puts __method__
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
          puts "++ saving different content"
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
      html =<<EOF
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
      "#{@grid_column_count}x#{grid_row_count}"
    end
    
    # return true if all grids are occupied
    def fully_occupied?
      
    end
    
    def over_lapping_calls?
      
    end
    
    def map
      list = []
      @graphics.each do |cell|
        list << cell.grid_record.grid_rect
      end
      h = {}
      h[grid_name.to_sym]= list
    end
    
    # update the size of grid with new frame, new grid_column_count or grid_row_count 
    def update_grids
      return unless @layout_mode=="grid"
      @grid_v_lines      = []
      
      # Todo fix this
      unless @left
        @top    = 0
        @bottom = 0
        @left   = 0
        @right  = 0
        @left_inset     = 0
        @right_inset    = 0
        @top_inset      = 0
        @bottom_inset   = 0
      end
      
      x   = @left + @left_inset
      x2  = x
      y   = @top + @top_inset
      y2  = @height - @bottom - @bottom_inset      
      (@grid_column_count + 1).times do
        @grid_v_lines << [x, y, x2, y2]
        x   += @unit_grid_width
        x2  += @unit_grid_width
      end

      x   = @left + @left_inset
      x2  = @width - @right - @right_inset      
      y   = @top + @top_inset
      y2  = y
      @grid_h_lines      = []      
      
      
      (@grid_row_count + 1).times do |i|
        line = [x, y, x2, y2]
        @grid_h_lines << line
        y   += @unit_grid_height
        y2  += @unit_grid_height
      end
            
      @grid_cells   = []
      @grid_h_lines.each do |h_line|
        @grid_v_lines.each do |v_line|
          next if v_line == @grid_v_lines.last
          @grid_cells << [v_line[0], h_line[1], @unit_grid_width, @unit_grid_height]
        end
        next if h_line == @grid_h_lines.last
      end      
    end
    
    
    # def self.include_relavant_key?(options)
    #   keys=[:grid_column_count, :grid_row_count, :grid_color, :grid_rect, :grid_inset]
    #   keys.each do |key|
    #     return true if options.has_key?(key)
    #   end
    #   false
    # end
    
    # def defaults
    #   hash={}
    #   hash[:grid_rect] = [0,0,1,1]
    #   hash[:grid_column_count]  = 3
    #   hash[:grid_row_count]     = 3
    #   hash[:grid_color]         = "blue"
    #   hash[:grid_inset]         = 0
    #   hash
    # end
    #     
    # def to_hash
    #   hash={}
    #   hash[:grid_rect] = @grid_rect
    #   hash[:grid_column_count]  = @grid_column_count  if @grid_column_count  != defaults[:grid_column_count]
    #   hash[:grid_row_count]     = @grid_row_count     if @grid_row_count     != defaults[:grid_row_count]
    #   hash[:grid_color]         = GraphicRecord.string_from_color(@grid_color)  if @grid_color!= defaults[:grid_color] && GraphicRecord.string_from_color(@grid_color) != ""
    #   hash[:grid_inset]         = @grid_inset         if @grid_inset         != defaults[:grid_inset]
    #   hash   
    # end
    # 
    # def self.awake_from_rlib(rlib_path)
    #   unless File.exists?(rlib_path)
    #     puts "file #{rlib_path} not found!!!"
    #     return 
    #   end      
    #   GGridRecord.new(nil, YAML::load_file(rlib_path + "/layout.yml"))
    # end
    # 
    # # un-archive object from hash
    # def self.from_hash(owner_graphic, grid_hash)
    #   GGridRecord.new(owner_graphic, grid_hash)      
    # end
    
              
    # for macruby
    # def draw_lines(r)
    #   return unless @show_grid
    #   if RUBY_ENGINE == 'macruby'
    #     @grid_color  = GraphicRecord.convert_to_nscolor(@grid_color)    unless @grid_color.class == NSColor  
    #     @grid_color.set
    #   end
    #   x_offset = r.origin.x
    #   y_offset = r.origin.y
    #   @grid_v_lines.each do |line|
    #     path = NSBezierPath.new
    #     path.lineWidth = 0.5                
    #     path.moveToPoint NSMakePoint(line[0] + x_offset, line[1] + y_offset)
    #     path.lineToPoint NSMakePoint(line[2] + x_offset, line[3] + y_offset)
    #     path.stroke
    #   end
    # 
    #   @grid_h_lines.each do |line|
    #     path = NSBezierPath.new
    #     path.lineWidth = 0.2        
    #     path.moveToPoint NSMakePoint(line[0] + x_offset, line[1] + y_offset)
    #     path.lineToPoint NSMakePoint(line[2] + x_offset, line[3] + y_offset)
    #     path.stroke
    #   end      
    # 
    # end
    # 
    # def drawRecord(r) 
    #   # NSColor.lightGrayColor.set
    #   # NSBezierPath.bezierPathWithRect(r).fill
    #   draw_lines(r) if @show_grid
    # end
    
    # Push other cell away from the selected cell
    # by reorder and re-positioning cells
    def push_away_cells
      
    end
    
    # given cell index, get x, y position in grid unit
    def grid_rect_of(grid_index)
      origin_array = origin_of_cell(grid_index)
      origin_array << 1
      origin_array << 1
      origin_array
    end
    
    def origin_of_cell(cell_index)
      if cell_index < 0
        return [0,0]
      elsif cell_index > @grid_column_count*@grid_row_count
        return [@grid_column_count - 1, @grid_row_count - 1]
      end
      row = cell_index / @grid_column_count
      column = cell_index % @grid_column_count
      [column, row]
    end
    
    # given cell number, calculate needed rows and columns 
    def adjust_columns_and_rows_for(number)
      int_value=Math.sqrt(number).to_i
      
      if Math.sqrt(number) > Math.sqrt(number).to_i
        if (int_value+1)*(int_value) >=  number
          @grid_column_count  = int_value+1
          @grid_row_count     = int_value
        else
          @grid_column_count  = int_value+1
          @grid_row_count     = int_value+1
        end
      elsif Math.sqrt(number) == Math.sqrt(number).to_i
        @grid_column_count  = int_value
        @grid_row_count     = int_value
      end
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
    #   if cells.length < @grid_row_count
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
        graphic.grid_record.grid_rect=[column,row,1,1]
        column +=1
        if column >= @grid_column_count 
          row += 1 
          column = 0
        end
      end
    end
    
    def unit_grid_size
      [@unit_grid_width, @unit_grid_height]
    end
    
    # set grid_cell index
    # adjust grid cells with unit_grid_width, unit_grid_height
    def relayout_grid! 
      return unless @grid_cells
      @unit_grid_width  = (@width - @left - @left_inset - @right - @right_inset)/@grid_column_count 
      @unit_grid_height = (@height - @top - @top_inset - @bottom - @bottom_inset)/@grid_row_count 
      
      update_grids
      x   = @left + @left_inset
      y   = @top + @top_inset
      col = 0
      row = 0
      
      @graphics.each_with_index do |graphic, i|
        unless graphic.grid_rect
          graphic.grid_rect   = [0,0,1,1]
        end
        graphic.x    = x + graphic.grid_rect[0]*@unit_grid_width
        graphic.y    = y
        graphic.width  = graphic.grid_rect[2]*@unit_grid_width
        graphic.height = graphic.grid_rect[3]*@unit_grid_height
                
        if graphic.klass == "Image"
          graphic.image_record.apply_fit_type if graphic.image_record
        end
        
        # recursive layout for children of graphic
        # it could be relayout! or relayout_grid! depending on the graphic's layout_mode
        if graphic.kind_of?(Container)
          graphic.relayout  
        end
        
        x+= graphic.width
        col +=1
        if col >= @grid_column_count
          col = 0
          x   = @left + @left_inset
          y+= graphic.height
          row+=1
        end
      end
      
      # when some changes, we want to inform parent_graphic to auto_save 
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
      ((point[0] >= rect[0]) && (point[0] <= rect[0]+rect[2])) && ((point[1] >= rect[1]) && (point[1] <= rect[1]+rect[3]))
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
      starting_grid_index = graphic.grid_record.grid_rect[0]  + graphic.grid_record.grid_rect[1] * @grid_row_count
      @grid_rect[3].times do 
        @grid_rect[2].times do |i|
          occupied_grid << starting_grid_index + i
        end
        starting_grid_index = starting_grid_index + @grid_row_count
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
        starting_grid_index = graphic.grid_record.grid_rect[0]  + graphic.grid_record.grid_rect[1] * @grid_row_count
        graphic.grid_record.grid_rect[3].times do 
          graphic.grid_record.grid_rect[2].times do |i|
            occupied << starting_grid_index + i
          end
          starting_grid_index = starting_grid_index + @grid_row_count
        end
      end
       
      empty_grids = Array(0..(@grid_column_count*@grid_row_count-1))
      occupied.each do |occupaying_grid|
        empty_grids.delete(occupaying_grid)
      end
      empty_grids
    end
    
    # place the graphic at given grid index of parent grid with width of 1 and height of 1
    def place_graphic_at(grid_index)
      @grid_rect = grid_rect_of(grid_index)
    end
    
    def place_child_at(child, grid_index)
      if child.grid_record.nil?
        child.grid_record   = RLayout::GGridRecord.new(graphic)
      end
      child.grid_record.grid_rect = grid_rect_of(grid_index)
    end
    
    # This assums that all childern are unit side,
    # Todo 
    # implement for children of variable size
    def relayout_children_grid
      @graphics.each_with_index do |child,i|
        place_child_at(child,i)
      end 
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



