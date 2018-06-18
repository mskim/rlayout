# TODO
# 1. text fitting
# 1. line drawing, # book_mode, book_mode1, news_mode
# 1. row width array
# 1. Heading style, first row style, body cycling

# I tried motion-csv gem to parse csv files.
# It fails to display Korean strings correctly.
# It seems  motion-csv is changing the string encoding to single byte string during parsing.
# I am getting -[Array _encodingCantBeStoredInEightBitCFString]: unrecognized selector sent to instance
# So, I am using split("\n") and split(",") for now.
# I need to fix it for comma wrapped in quotes.
# 
# Table-data works similar to TextBox's Story.
# table-data is read from .csv file.
# table-data can have head_row and body_row
# Table heading can have title, souce, unit, category_level.
# Table info can be plcace at the top of the mete-csv file as yml?
#
# Table body_rows are similar to Paragraph. They can flow into TableBox columns.
# Table can also have multiple columns.

# layout is done in two steps for table and text_box.
# First phase is setting graphics position relativev to others.
# After the position is set, contents can be poured.
# "layout_content" is the second phase.

# Complex tables should use RLayout::Form, not Table.

# Table can have category columns.
# category_level is used to indicate catefory columns number. 
# Category columns are vertically spaned table cells to indicate categories.
# Category column start from left side of table.
# Category column are created when category_level is greated than 0
# and when cell data is empty or ditto.

# ---
# title: some title
# cetegory_level: 0
# ---
# head_1, head_2, head_3, head_4, head_5
# body1_1, body1_2, body1_3, body1_4, body1_5
# body2_1, body2_2, body2_3, body2_4, body2_5
# body3_1, body3_2, body3_3, body3_4, body1_5
# body4_1, body4_2, body4_3, body4_4, body4_5

# ---
# title: some title
# cetegory_level: 1
# ---
# head_1, head_2, head_3, head_4, head_5
# body1_1, body1_2, body1_3, body1_4, body1_5
#        , body2_2, body2_3, body2_4, body2_5
#        , body3_2, body3_3, body3_4, body1_5
#        , body4_2, body4_3, body4_4, body4_5

# Table creating by DSL
# @tbl = Table.new(nil) do
#   th do
#     td "heading cell 1", align: "right"
#     td "heading cell 2"
#     td "this is third column"
#   end
#   tr  do
#     td "row1 is body cell", align: "left"
#     td "row1 is second column"
#     td "row1 is third column"
#   end
#   tr  do
#     td "row2 cell 1", align: "left"
#     td "row2 cell 2"
#     td "row2 cell 3"
#   end
# end


# table_cell_style={
#   font: {}
#   text_alignment: {}
#   text_color: {}
#   bg_color: {}
# }
# head_row_style={
#   font: {}
#   text_alignment: {}
#   text_color: {}
#   bg_color: {}
# }
# 
# body_row_style={
#   font: {}
#   text_alignment: {}
#   text_color: {}
#   bg_color: {}
# }
# 
# table_style={
#   text_fit: "CELL_SIZE_FIT"  #FONT_SIZE_FIT
#   top_edge_line: {}
#   bottome_edge_line: {}
#   left_edge_line: {}
#   right_edge_line: {}
#   heading_line: {}
#   heading_text: {}
#   body_text: {}
#   row_line: {}
#   first_column_line: {}
#   column_line: {}
#   body_cycling: {bgcolor:["CMYK=0,0,0,100", "green"]}
# }

# It is tricky to layout multiple tables in a single page.
# Tables first need to be placed with right frames in parents, before contents can be layed out.
# ???
# I should devide Table init into two parts, first part init getting getting frame
# Second part actually layout the data after proper size is set.
# set_content(options={}) should be used for the later call.

module RLayout

# if body_row_atts has cycle_colors, it means body row is cycling with ["green", "blue", "orange"] something like it.  
# body_row_atts   => { cycle_colors: ["green", "blue"], ... }

# stroke_sides are a array of stroke_sides, first one is for left most cell, second one is for cells in the middle, and the last one is for right most cell.
# body_cell_atts  => {font: "smSSMyungjoP-W35", stroke_sides: [[0,0,1,0], [1,0,1,0], [1,0,0,0]]},

# category_colors
# category_colors are array of cycling category colors
# first element represents category color, and second element represent items color
# :category_colors  => [["CMYK=0.1,0,0,0,1", "CMYK=0.05,0,0,0,1"],["CMYK=0,0.1,0,0,1", "CMYK=0,0.05,0,0,1"],["CMYK=0,0,0.1,0,1", "CMYK=0,0,0.05,0,1"]]
# shading?, tone_down

# column_width_array
# when it is passed as options use it
# otherwise, calculate_column_width_array is called to create one.
# calculate_column_width_array scans all cells and get the longest text for each column, including head row.

DEFAULT_TABLE_STYLE = {
    :head_row_atts   => { row_type: "head_row", fill_color: 'gray', stroke_sides: [1,1,1,1]},
    :head_cell_atts  => { fill_color: "clear", text_color: 'white', font: "Helvetica", font_size: 12.0, stroke_sides: [1,0,1,0]},
    :body_row_atts   => { row_type: "body_row", fill_color: "white", stroke_sides: [0,1,0,1]},
    :body_cell_atts  => { font: "smSSMyungjoP-W35", font_size: 12.0, stroke_sides: [[0,0,1,0], [1,0,1,0], [1,0,0,0]]},
    :category_atts   => { font: "smSSMyungjoP-W35", font_size: 12.0, stroke_sides: [1,1,1,1]},
    :category_colors => [["CMYK=0.1,0,0,0,1", "CMYK=0.05,0,0,0,1"],["CMYK=0,0.1,0,0,1", "CMYK=0,0.05,0,0,1"],["CMYK=0,0,0.1,0,1", "CMYK=0,0,0.05,0,1"]]
}
  
  class Table < Container
    attr_accessor :title, :source, :category_level
    attr_accessor :has_head_row, :can_grow
    attr_accessor :column_width_array, :column_alignment, :column_v_alignment
    attr_accessor :column_v_alignment
    attr_accessor :table_data, :rows, :body
    attr_accessor :table_style, :csv
    attr_accessor :column_count, :next_link, :prev_link
    attr_accessor :body_row_colors
    attr_accessor :column_line_color, :row_spacing
    attr_accessor :proposed_height, :row_height_sum, :overflow, :underflow
    def initialize(options={}, &block)
      super
      @column_count       = options.fetch(:column_count, 1)
      @category_level     = options.fetch(:category_level, 0)
      @column_width_array = options.fetch(:column_width_array, nil)
      @column_alignment   = options.fetch(:column_alignment, nil)
      @layout_space       = options.fetch(:layout_space, 0)
      @overflow           = false
      @underflow          = false
      @table_data         = []      
      if options[:csv_data]
        @csv = options[:csv_data].gsub("|", ",")
      elsif options[:csv_path]
        @csv              = File.open(options[:csv_path], 'r'){|f| f.read}
      elsif options[:csv_data]
      else
        puts "No csv data:#{@data}"
        return
      end
      if options[:table_style_path]        
        @table_style  = eval(File.open(options[:table_style_path], 'r'){|f| f.read})
        # merge is with DEFAULT_TABLE_STYLE
        # this prevents from missing keys in table_style_path hash 
        @table_style = DEFAULT_TABLE_STYLE.merge(@table_style)
        unless @table_style.class == Hash
          puts "invalid table style !!!"
          @table_style  = DEFAULT_TABLE_STYLE
        end
      elsif options[:table_style]  
        @table_style  = options[:table_style]
        unless @table_style.class == Hash
          puts "invalid table style !!!"
          @table_style  = DEFAULT_TABLE_STYLE
        end
      else
        @table_style  = DEFAULT_TABLE_STYLE
      end
      if @category_level > 0 && @table_style[:category_colors]
        # do nothing yet if we are in category type 
      elsif @table_style[:body_row_atts][:cycle_colors]
        @body_row_colors  = @table_style[:body_row_atts][:cycle_colors] 
      else    
        @body_row_colors  = [@table_style[:body_row_atts][:fill_color]]
      end
      @has_head_row       = options.fetch(:has_head_row, true)
      @can_grow           = options.fetch(:can_grow, true)
      @title              = options.fetch(:title, nil)
      @source             = options.fetch(:source, nil)
      @table_data = @csv.split("\n")
      @table_data = @table_data.map{|row| row.split(",")}
      if block
        instance_eval(&block)
      end            
      self
    end

    def create_rows
      unless @column_width_array
        calculate_column_width_array
      end
      @row_height_sum = 0
      if has_head_row?
        row_options               = @table_style[:head_row_atts]
        row_options[:row_data]    = @table_data[0]
        row_options[:cell_atts]   = @table_style[:head_cell_atts]
        row_options[:column_width]= @column_width_array
        row_options[:parent]      = self
        if @can_grow
          row_options[:layout_expand]= [:width]
        end
        r = TableRow.new(row_options)
        @row_height_sum += r.height
      end
      body_cycle = @body_row_colors.length if @body_row_colors
      @table_data.each_with_index do |row_data, i|
        next if i == 0
        row_options               = @table_style[:body_row_atts]
        current_cylcle            = i % body_cycle if @body_row_colors       
        row_options[:fill_color]  =  @body_row_colors[current_cylcle] if @body_row_colors
        row_options[:row_data]    = row_data
        row_options[:cell_atts]   = @table_style[:body_cell_atts]
        row_options[:column_width]= @column_width_array
        row_options[:parent]      = self
        if @can_grow
          row_options[:layout_expand]= [:width]
        end
        r=TableRow.new(row_options)
        @row_height_sum += r.height
      end  
      row_space_sum = (@graphics.length - 1)*@layout_space
      @row_height_sum +=row_space_sum
      @height       = @row_height_sum + @top_margin + @bottom_margin + @top_inset + @bottom_inset
      relayout!
      make_cetegory_cells if @category_level > 0
    end
    
    def layout_lines(column)
      
    end
    
    def layout_rows(proposed_height)
      @proposed_height = proposed_height
      minimum_height = @graphics.first.height + @graphics[1].height + @top_margin + @top_inset
      if @height > @proposed_height
        @overflow = true
      elsif @proposed_height < minimum_height
        @underflow = true
      end
    end

    # split Table into two at height
    # Starting with new head_row and tableRows that are overflwoing 
    # return new table  
    def split_overflowing_lines
      # split rows
      # create second table
      second_half = Table.new(nil)
      second_half.width         = @width
      second_half.layout_space  = @layout_space
      second_half.top_margin    = @top_margin
      second_half.top_inset     = @top_inset
      second_half.bottom_margin = @bottom_margin
      second_half.bottom_inset  = @bottom_inset
      second_half.fill          = @fill
      second_half.stroke        = @stroke
      first_half = first_half_row_count
      second_half_count = @graphics.length - first_half
      head_row = @graphics.first
      second_half_count.times do
        row = @graphics.pop
        second_half.graphics.unshift(row)
      end
      second_half.graphics.unshift(head_row) 
      second_half.adjust_heihgt
      second_half
    end    
    
    def adjust_heihgt
      @row_height_sum     = 0
      @graphics.each do |row|
        @row_height_sum += row.height
      end
      @row_height_sum   += (@graphics.length - 1)*@layout_space
      @height           = @row_height_sum + @top_margin + @bottom_margin + @top_inset + @bottom_inset
      relayout!
      make_cetegory_cells if @category_level > 0
    end
    
    # return graphics index to split
    # avoid widow or orphan
    def first_half_row_count
      @graphics.each_with_index do |row, i|
        if @proposed_height < row.y_max
          if i == @graphics.length - 1
            # orphan, last row
            return i - 1
          end
          return i 
        end
      end
      @graphics.length
    end
    
    # Can I break table into two?
    # if row count is greater than 3 including head row
    # breakable when we have at least 5 rows including head row
    def is_breakable?
      if @graphics.length > 4 
        true 
      else
        false
      end
    end
    
    def overflow?
      @overflow
    end
    
    def underflow?
      @underflow
    end
    

    
    # calculate width of longest cells for each column, 
    # so that we can set good looking layout
    # We might need average width?? option
    def calculate_column_width_array(type="longest")
      @column_width_array = []
      @column_width_array = @table_data[0].map{|cell| cell.length}
      @table_data.each do |row|
        row.each_with_index do |cell, i|
          @column_width_array[i] = cell.length if cell.length > @column_width_array[i]
        end
      end
    end
    
    def make_cetegory_cells
      # make range of category range
      @current_category = @table_data[0][0]
      @category_range   = []
      @position = 0
      @table_data.each_with_index do |row_data, i|
        if row_data[0] != @current_category 
          new_range = @position..(i - 1)
          @category_range << new_range
          @current_category = row_data[0]
          @position = i 
        end        
      end
      # close the last range
      if @category_range.last.end < @table_data.length - 1
        @category_range << (@position..(@table_data.length - 1))
      end  
      if  @table_style[:category_colors]
        @category_colors = @table_style[:category_colors]
      else
        @category_colors = DEFAULT_TABLE_STYLE[:category_colors]
      end
      category_cycle = @category_colors.length
      @category_range.each_with_index do |range, i|
        next if has_head_row? && i == 0
        options         = @table_style[:category_atts]
        options[:x]     = @graphics[range.begin].x
        options[:y]     = @graphics[range.begin].y
        options[:width] = @graphics[range.begin].graphics.first.width
        options[:height]= @graphics[range.end].y_max - @graphics[range.begin].y
        current_cylcle  = i % category_cycle        
        options[:fill_color]  =  @category_colors[current_cylcle][0]
        options[:is_float] = true
        text(@table_data[range.begin][0], options)
        # make row body rows colors with paired color
        @graphics[range].each do |body_row|
          body_row.fill.color = @category_colors[current_cylcle][1]
        end
      end
    end
    
    def has_head_row?
      @has_head_row
    end
     
    #Todo need to check
    def delete_row_at(index)
      return if index < 0
      return if index > @graphics.length - 1 
      @graphics.delete(index)
    end
    
    def th(options={}, &block)
      options[:parent] = self
      @header = TableRow.new(options, &block)
    end
    
    def tr(options={}, &block)
      options[:parent] = self
      TableRow.new(options, &block)
    end
    

  end
  
  class TableRow < Container
    attr_accessor :row_type, :fit_type, :font
    attr_accessor :column_sytle_array, :column_alignment
    def initialize(options={}, &block)
      super
      cell_atts           = options[:cell_atts] 
      @row_data           = options[:row_data]
      @row_type           = options.fetch(:row_type, "body_row")
      @fit_type           = options.fetch(:fit_type, "adjust_row_height")
      @layout_direction   = 'horizontal'
      @cell_widths        = []
      @row_data.each_with_index do |cell_text, i|
        cell_atts[:text_string]   = cell_text
        # cell_atts[:font_size]     = 9.0
        if options[:column_width]
          cell_atts[:layout_length] = options[:column_width][i] 
        else
          @cell_widths[i] = 1
        end
        if cell_atts[:stroke_sides]
          cell_sides_type           = cell_atts[:stroke_sides].length 
          case cell_sides_type
          when 4
            # do noting. This is single array [0,0,0,0]
          when 3
            # this is when left most, middle, right most are different
            # [[0,0,1,0], [1,0,1,0], [1,0,0,0]]
            if i == 0
              cell_atts[:stroke_sides] = cell_atts[:stroke_sides][0]
            elsif i == (@row_data.length - 1)
              cell_atts[:stroke_sides] = cell_atts[:stroke_sides][2]
            else
              cell_atts[:stroke_sides] = cell_atts[:stroke_sides][1]
            end
          when 2
            # this is right of left most column
            # [[0,0,1,0], [0,0,0,0]]
            if i == 0
              cell_atts[:stroke_sides] = cell_atts[:stroke_sides][0]
            else
              cell_atts[:stroke_sides] = cell_atts[:stroke_sides][1]
            end
          when 1
            # this is nested case, just flatten it
            # [[0,0,1,0]]
            cell_atts[:stroke_sides] = cell_atts[:stroke_sides][0]
          end
          #TODO
          cell_atts[:width] = @width*(@cell_widths[i] - 20)/@cell_widths.reduce(:+).to_f if @width != 100
        end
        td(cell_atts)
      end
      case @fit_type
      when 'adjust_row_height'
        # find tallest cell and adjust height to accomodate it.
        @height = tallest_cell_height + 4
      else
        # we might have to sqeeze in the cells to fit???
      end
        
      self
    end
    
    def adjust_height
      @height = tallest_cell_height + 6
    end
    
    def td(options={})
      options[:fill_color]        = 'clear'
      options[:stroke_thickness]  = 1
      options[:text_fit_type]     = 'adjust_box_height'
      options[:parent]            = self
      if @row_type == "head_row"
        options[:stroke_thickness]  = 1 
        tc = TableCell.new(options)
      else
        tc = TableCell.new(options)
      end
      self
    end
    
    def tallest_cell_height
      tallest_height = @graphics.first.height
      @graphics.each do |graphic|
        tallest_height = graphic.height if graphic.height > tallest_height
      end
      tallest_height
    end
  end
  
end
