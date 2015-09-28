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
  DEFAULT_TABLE_STYLE = {
    :head_row_atts    => { fill_color: "gray", text_color: 'white', font: "Helvetica", stroke_sides: [0,1,0,1]},
    :body_row_atts    => {font: "smSSMyungjoP-W35", stroke_sides: [0,1,0,1]},
    :body_row_colors  => ["green", "blue"],
    :category_colors  => [["green", "green_10%"],["blue", "blue_10%"],["pink", "pink_10%"]]
  }
  
  class Table < Container
    attr_accessor :title, :source, :category_level
    attr_accessor :head_row, :body_rows, :has_head_row
    attr_accessor :column_width_array, :column_alignment_arrau,:column_v_alignment
    attr_accessor :column_v_alignment
    attr_accessor :rows, :body
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
      @rows               = []
      if options[:csv_data]
        @csv              = options[:csv_data]
      elsif options[:csv_path]
        @csv        = File.open(options[:csv_path], 'r'){|f| f.read}
      else
        puts "No csv data:#{@data}"
      end
      
      if options[:table_style_path]        
        @table_style  = eval(File.open(options[:table_style_path], 'r'){|f| f.read})
        unless @table_style.class == Hash
          puts "invalid table style !!!"
          @table_style  = DEFAULT_TABLE_STYLE
        end
      else
        @table_style  = DEFAULT_TABLE_STYLE
      end
      @body_row_colors    = @table_style[:body_row_colors]     
      @has_head_row       = options.fetch(:has_head_row, true)
      @title              = options.fetch(:title, nil)
      @source             = options.fetch(:source, nil)
      #TODO fix this for quoted ,
      @rows = @csv.split("\n")
      @rows = @rows.map{|row| row.split","}
      @head_row = @rows.shift if has_head_row?
      set_table_attributes 
      create_rows
      relayout!
      if block
        instance_eval(&block)
      end            
      self
    end
    
    def set_table_attributes
      # After parsing csv file, we have array of rows, each row containing row's cell data.
      # Before creating actuall TableRows, and TableCells, cell string data is converted to attributes hash for cells.
      # Row attribute Hash is also created and inserted at the front, for row itself.
      # followed by hash, representing cell attributes for the row.
      if has_head_row?
        # decorate head_row
        @head_row.map! do |cell_data|
          hash = {}
          hash[:text_string] = cell_data
          hash[:font] = @table_style[:head_row_atts][:font]
          hash
        end
        row_attribute = @table_style[:head_row_atts]
        row_attribute[:row_type] = "head_row"
        row_attribute[:row_data] = @head_row
        @head_row = row_attribute        
      end
      
      if @category_level > 0
        # span for same category rows
        @rows.map do |row|

        end
      end
      @rows.each do |row|
        row.map! do |cell_data| 
          hash = {}
          hash[:text_string] = cell_data
          hash
        end
        row_attribute = @table_style[:body_row_atts]
        row_attribute = {row_type: "body_row"}
        row.unshift(row_attribute)
      end
    end
    
    def create_rows
      if has_head_row?
        TableRow.new(self, @head_row)
      end
      body_cycle = @body_row_colors.length
      @rows.each_with_index do |row, i|
        row_options = row.shift
        current_cylcle = i % body_cycle        
        row_options[:fill_color]  =  @body_row_colors[current_cylcle]
        # row_options[:font]        =  body_styles[current_cylcle][:font]
        row_options[:row_data]    =  row
        TableRow.new(self, row_options)
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
      puts "TableRow init options:#{options}"
      options[:stroke_sides] = [0,1,0,1] unless options[:stroke_sides]
      options[:stroke_width] = 1 unless options[:stroke_width]
      @font = options.fetch(:font, "Helvetica")
      if options[:row_data]
        @row_data = options.delete(:row_data)
      else
        puts "no row-data!!!"
        return
      end
      super
      @row_type             = options.fetch(:row_type, "body_row")
      @layout_direction     = 'horizontal'
      # @column_width_array   = parent_graphic.column_width_array
      # @column_alignment     = parent_graphic.column_alignment
      # @column_v_alignment   = parent_graphic.column_v_alignment

      create_row_cells(@row_data, options) 
      
      if block
        instance_eval(&block)
      end            
      
      self
    end
    
    def create_row_cells(row_data, options={})
      row_data.each do |cell_text|
        options[:text_string] = cell_text
        td(options)
      end
    end
    
    def td(options={})
      puts "++++++++ td options:#{options}"
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
