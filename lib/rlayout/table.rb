# Table work similar to TextBox
# Table data works similar to Story. 
# Table data is read from .csv file.
# Table rows are similar to Paragraph. They can flow into TableBox columns.
# Table can also display it as graphic.

# TODO
# 1. text fitting
# 1. line drawing, # book_mode, book_mode1, news_mode
# 1. row width array
# 1. Heading style, first row style, body cycling

# Table creating with csv

# @tbl      = Table.new(nil, local_csv:my_data.csv, has_head_row: true)
# 
# @tbl      = Table.new(nil, csv_path:/some/csv/path, has_head_row: true)
# 
# @csv_path = "/Users/mskim/idcard/CardDemo.csv"
# csv_data  = File.open(@csv_path, 'r'){|f| f.read}
# @tbl      = Table.new(nil, csv_data: csv_data, has_head_row: true)



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

# has_category_column
# This is indicates that the first column is the category column
# It spans vertically if the item is same as above row or blank

# table_style
# {
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
  
  class Table < Container
    attr_accessor 
    attr_accessor :title, :source, :column_count, :next_link, :prev_link
    attr_accessor :rows, :has_head_row, :has_category_column, :source, :title
    attr_accessor :column_width_array, :column_alignment_arrau,:column_v_alignment, :column_text_color, :column_bgcolor
    attr_accessor :column_v_alignment, :column_text_color, :column_bgcolor
    attr_accessor :heading, :body, :source, :title
    attr_accessor :table_style, :csv
    
    def initialize(parent_graphic, options={}, &block)
      super
      @column_count       = options.fetch(:column_count, 1)
      @has_category_column= options.fetch(:has_category_column, false)
      @column_width_array = options.fetch(:column_width_array, [1,1,1])
      @column_alignment   = options.fetch(:column_alignment, %w[left left left])
      @column_v_alignment = options.fetch(:column_v_alignment, %w[top top top])
      @column_text_color  = options.fetch(:column_text_color, %w[black black black])
      @column_bgcolor     = options.fetch(:column_bgcolor,  %w[white white white])
      @rows               = []
      if options[:csv_data]
        @csv              = options[:csv_data]
      elsif options[:csv_path]
        if RUBY_ENGINE == 'macruby'
          # @csv        = NSString.alloc.initWithContentsOfFile(options[:csv_path], encoding:NSUTF16StringEncoding, error:nil)
          # @csv        = NSString.alloc.initWithContentsOfFile(options[:csv_path], encoding:-2147483645, error:nil)
          @csv        = File.open(options[:csv_path], 'r'){|f| f.read}
          
        else
          @csv        = File.open(options[:csv_path], 'r'){|f| f.read}
        end
      elsif options[:local_csv]
        loca_csv_path     = $ProjectPath + "/#{options[:local_csv]}"
        @csv              = File.open(loca_csv_path, 'r'){|f| f.read}
      else
        puts "No csv data:#{@data}"
      end
      @has_head_row       = options.fetch(:has_head_row, true)
      @title              = options.fetch(:title, nil)
      @source             = options.fetch(:source, nil)
      create_rows(options)
      relayout!
      if block
        instance_eval(&block)
      end            
      self
    end
    
    def create_rows(options)
      if RUBY_ENGINE == "rubymotion"
        @rows = MotionCSV.parse(@csv)
        @graphics << TableRow.new(self, :row_data=>@rows.headers, :raw_type=>"head_row")
      else
        @rows = CSV.parse(@csv)
        @graphics << TableRow.new(self, :row_data=>@rows[0], :raw_type=>"head_row")
        @rows.unshift
      end
      @rows.each_with_index do |row, i|
        @graphics << TableRow.new(self, :row_data=>row, :raw_type=>"body_row" )
      end      
    end
    
    def has_head_row?
      @has_head_row
    end
     
    def add_row(row_data)
      @graphics << TableRow.new(self, :row_data=>row_data)
    end
    
    def delete_row
      @graphics.pop
    end
    
    def insert_row_at(index, row_data)
      
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
    attr_accessor :row_type, :fit_type
    attr_accessor :column_sytle_array, :column_alignment,:column_v_alignment, :column_text_color, :column_bgcolor
    
    def initialize(parent_graphic, options={}, &block)
      options[:stroke_sides] = [0,1,0,1] unless options[:stroke_sides]
      options[:stroke_width] = 1 unless options[:stroke_width]
      super
      @row_type = options.fetch(:row_type, 'body_type')
      @layout_direction     ='horizontal'
      # @column_width_array   = parent_graphic.column_width_array
      # @column_alignment     = parent_graphic.column_alignment
      # @column_v_alignment   = parent_graphic.column_v_alignment
      # @column_text_color    = parent_graphic.column_text_color
      # @column_bgcolor       = parent_graphic.column_bgcolor   
      create_row_cells(options[:row_data]) if options[:row_data]
      if block
        instance_eval(&block)
      end            
      
      self
    end
    
    def create_row_cells(row_data, options={})
      row_data.each do |td_text|
        td(td_text)
      end
    end
    
    def td(text, options={})
      # text.encode("UTF-16")
      options[:text_string] = text.to_s
      options[:text_font]   = "smGothicP-W10"
      options[:stroke_sides] = [0,0,0,0]
      options[:stroke_thickness] = 0
      TableCell.new(self, options)
      self
    end
  end
  

end
