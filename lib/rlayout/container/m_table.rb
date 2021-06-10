module RLayout

  # MTable 
  # Table that is subclassed form matic
  # Size are fixed 

  class MTable < Matrix
    attr_reader :project_path
    attr_reader :title, :source, :category_level, :heading_level
    attr_reader :has_head_row, :can_grow, :calculate_column_width
    attr_reader :column_width_array, :column_alignment, :column_v_alignment
    attr_reader :table_data, :rows, :body
    attr_reader :table_style, :csv
    attr_reader :column_count
    attr_reader :body_row_colors
    attr_reader :column_line_color, :row_spacing

    def initialize(options={})
      @column_width_array = options[:column_width_array]
      @has_head_row = options[:has_head_row]

      if options[:table_data]
        # this is an Array row data
        @table_data = options[:table_data]
      elsif options[:csv_path] 
        @table_data = RLayout::parse_csv(options[:csv_path])
      else
        puts "no table data given!!!"
      end
      unless @column_width_array
        calculate_column_width_array
      end
      super
      self
    end

    def layout_items
      # TODO: implement variable column width
      # replace the text cell content 
      end
    end

    # TODO: maybe we should impleamnt deviation, where one or two deviats from the rest
    # get longest, and average if they differ 50% or more, use average
    
    # calculate width of longest or average cells for each column, 
    # so that we can set good looking layout
    # We might need average width?? option

    def calculate_column_width_array
      @column_width_array = []
      @column_width_array = @table_data[0].map{|cell| cell.length}
      @table_data.each do |row|
        row.each_with_index do |cell, i|
          @column_width_array[i] = cell.length if cell.length > @column_width_array[i]
        end
      end

    end
    




  end

end