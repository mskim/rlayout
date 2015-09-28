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
#   body_cycling: {bgcolor:["black", "green"]}
# }


module RLayout
  # DEFAULT_TABLE_STYLE = {
  #   :head_row_atts    => { fill_color: "gray", text_color: 'white', font: "Helvetica", stroke_sides: [0,1,0,1]},
  #   :body_row_atts    => {font: "smSSMyungjoP-W35", stroke_sides: [0,1,0,1]},
  #   :body_row_colors  => ["green", "blue"],
  #   :category_colors  => [["green", "green_10%"],["blue", "blue_10%"],["pink", "pink_10%"]]
  # }
  # notice :body_row_atts   => { cycle_color: ["green", "blue"],
  # cycle_color is a array of colors, this means row has cycling colors  

  # notice :body_cell_atts  => {font: "smSSMyungjoP-W35", stroke_sides: [[0,0,1,0], [1,0,1,0], [1,0,0,0]]},
  # stroke_sides is a array of stroke_sides, first one is the left most cell, second one is the cells in the middle, and the last one is the right most cell.

  # category_colors
  # category_colors are array of arrays of category color
  # first element represents category color, and second element represent items color
  DEFAULT_TABLE_STYLE = {
    :head_row_atts   => { row_type: "head_row", fill_color: 'gray', stroke_sides: [1,1,1,1]},
    :head_cell_atts  => { fill_color: "clear", text_color: 'white', font: "Helvetica", stroke_sides: [1,0,1,0]},
    :body_row_atts   => { row_type: "body_row", fill_color: "white", stroke_sides: [0,1,0,1]},
    :body_cell_atts  => { font: "smSSMyungjoP-W35", stroke_sides: [[0,0,1,0], [1,0,1,0], [1,0,0,0]]},
    # :body_row_atts   => { row_type: "head_row", cycle_color: ["green", "blue"], stroke_sides: [0,1,0,1]},
    # :category_colors  => [["green", "green"],["blue", "blue"],["pink", "pink"]]
}
  
  class Table < Container
    attr_accessor :title, :source, :category_level
    attr_accessor :has_head_row
    attr_accessor :column_width_array, :column_alignment_arrau,:column_v_alignment
    attr_accessor :column_v_alignment
    attr_accessor :table_data_array, :rows, :body
    attr_accessor :table_style, :csv
    attr_accessor :column_count, :next_link, :prev_link
    attr_accessor :body_row_colors
    attr_accessor :column_line_color
    
    def initialize(parent_graphic, options={}, &block)
      super
      @column_count       = options.fetch(:column_count, 1)
      @category_level     = options.fetch(:category_level, 0)
      @column_width_array = options.fetch(:column_width_array, [1,1,1])
      @column_alignment   = options.fetch(:column_alignment, %w[left left left])
      @column_v_alignment = options.fetch(:column_v_alignment, %w[top top top])
      @table_data_array               = []
      if options[:csv_data]
        @csv              = options[:csv_data]
      elsif options[:csv_path]
        @csv        = File.open(options[:csv_path], 'r'){|f| f.read}
      else
        puts "No csv data:#{@data}"
      end
      
      if options[:table_style_path]        
        @table_style  = eval(File.open(options[:table_style_path], 'r'){|f| f.read})
        #TOFO
        # @table_style = DEFAULT_TABLE_STYLE.merge(@table_style)
        # puts "@table_style:#{@table_style}"
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
      if @table_style[:body_row_atts][:cycle_color]
        @body_row_colors    = @table_style[:body_row_atts][:cycle_color] 
      else    
        @body_row_colors    = [@table_style[:body_row_atts][:fill_color]]
      end
      @has_head_row       = options.fetch(:has_head_row, true)
      @title              = options.fetch(:title, nil)
      @source             = options.fetch(:source, nil)
      #TODO fix this for quoted ,
      @table_data_array = @csv.split("\n")
      @table_data_array = @table_data_array.map{|row| row.split","}
      @head_row = @table_data_array.shift if has_head_row?
       
      create_rows
      make_cetegory_cells if @category_level > 0
      relayout!
      if block
        instance_eval(&block)
      end            
      self
    end
        
    def create_rows
      if has_head_row?
        row_options               = @table_style[:head_row_atts]
        row_options[:row_data]    = @table_data_array[0]
        row_options[:cell_atts]   = @table_style[:head_cell_atts]
        TableRow.new(self, row_options)
      end
      body_cycle = @body_row_colors.length
      @table_data_array.each_with_index do |row_data, i|
        next if i == 0
        row_options               = @table_style[:body_row_atts]
        current_cylcle            = i % body_cycle        
        row_options[:fill_color]  =  @body_row_colors[current_cylcle]
        row_options[:row_data]    = row_data
        row_options[:cell_atts]   = @table_style[:body_cell_atts]
        # puts "row_options;#{row_options}"
        # row_options[:font]        =  body_styles[current_cylcle][:font]
        TableRow.new(self, row_options)
      end      
    end
    
    def make_cetegory_cells
      
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
      @header = TableRow.new(self, options, &block)
    end
    
    def tr(options={}, &block)
      TableRow.new(self, options, &block)
    end
  end
  
  class TableRow < Container
    attr_accessor :row_type, :fit_type, :font
    attr_accessor :column_sytle_array, :column_alignment,:column_v_alignment
    def initialize(parent_graphic, options={}, &block)
      super
      cell_atts = options[:cell_atts]
      @row_data = options[:row_data]
      @row_type             = options.fetch(:row_type, "body_row")
      @layout_direction     = 'horizontal'
      # @column_width_array   = parent_graphic.column_width_array
      # @column_alignment     = parent_graphic.column_alignment
      # @column_v_alignment   = parent_graphic.column_v_alignment
      @row_data.each_with_index do |cell_text, i|
        cell_atts[:text_string] = cell_text
        cell_sides_type = cell_atts[:stroke_sides].length
        case cell_sides_type
        when 4
          # do noting. This is single array [0,0,0,0]
        when 3
          # binding.pry
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
          # [[0,0,1,0], [o,0,0,0]]
          
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
        td(cell_atts)
      end
            
      self
    end
        
    def td(options={})
      options[:fill_color] = 'clear'
      options[:stroke_thickness]  = 1
      if @row_type == "head_row"
        options[:stroke_thickness]  = 1 
        TableCell.new(self, options)
      else
        TableCell.new(self, options)
      end
      self
    end
  end
  

end
