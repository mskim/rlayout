# Table creating with csv
# @csv_path = "/Users/mskim/idcard/CardDemo.csv"
# @tbl      = Table.new(nil, csv: File.open(@csv_path, 'r'){|f| f.read}, head_row: true)
# 

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

module RLayout
  

  class Table < Container
    attr_accessor :prev_link, :next_link, :fit_type, :rows
    attr_accessor :head_row, :source, :title
    attr_accessor :column_width_array, :column_alignment_arrau,:column_v_alignment, :column_text_color, :column_bgcolor
    attr_accessor :heading, :body, :source, :title
    attr_accessor :table_info
    
    def initialize(parent_graphic, options={}, &block)
      super
      @column_width_array = options.fetch(:column_width_array, [1,1,1])
      @column_alignment   = options.fetch(:column_alignment, %w[left left left])
      @column_v_alignment = options.fetch(:column_v_alignment, %w[top top top])
      @column_text_color  = options.fetch(:column_text_color, %w[black black black])
      @column_bgcolor     = options.fetch(:column_bgcolor,  %w[white white white])
      @rows               = []
      @csv                = options.fetch(:csv,"")
      # puts "@data:#{@data}"
      @head_row           = options.fetch(:head_row, false)
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
      @rows = CSV.parse(@csv)
      @rows.each_with_index do |row, i|
        if @head_row && i==1
          @graphics << TableRow.new(self, :row_data=>row, :head_row=>true)
        end
        @graphics << TableRow.new(self, :row_data=>row)
      end
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
    attr_accessor :column_sytle_array, :column_alignment,:column_v_alignment, :column_text_color, :column_bgcolor
    
    def initialize(parent_graphic, options={}, &block)
      super
      if options[:options]
        @row_type = "head_row"
      else
        @row_type = "body_row"
      end
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
      options[:text_string] = text
      Text.new(self, options)
      self
    end
  end
  
end
