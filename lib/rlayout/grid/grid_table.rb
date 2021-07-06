module RLayout
  # GridTable
  # Grid base table

  # table column width 
  # 1. default value of column width is uniform width
  # each column can have diffent value if
  # 2. when column_width_array is provided
  # 3. when calculate_column_width: true


  class GridTable < Grid
    attr_reader :csv_path, :table_data
    attr_reader :has_head, :output_path
    attr_reader :column_width_array, :calculate_column_width
    attr_reader :column_alignment_array, :body_line_count

    def initialize(options={})
      if options[:csv_path] 
        @table_data = RLayout::parse_csv(options[:csv_path])
        return unless @table_data
      elsif options[:table_data]
        @table_data = options[:table_data]
      end
      @output_path = options[:output_path]
      @has_head = options[:has_head] || true
      @column_width_array = options[:column_width_array]
      @column_alignment_array = options[:column_alignment_array] || %w[center center center left]
      @calculate_column_width = options[:calculate_column_width]
      options[:column] = @table_data.first.length
      options[:row] = options[:body_line_count] || @table_data.length
      options[:gutter] = 0
      super
      layout_items
      if @output_path
        save_pdf(@output_path, jpg:true)
      end
      self
    end

    def default_style
      h = {}
      h[:head] = {}
      h[:head][:color] = %w[DarkGray]
      h[:head][:font] = RLayout.Korean_sanserif_bold # 고딕계열
      h[:head][:text_color] = RLayout.contrasting_color(h[:head][:color][0])
      h[:head][:alignment] = %w[center]
      h[:body] = {}
      h[:body][:color] = %w[white AliceBlue]
      h[:body][:font] = RLayout.Korean_serif_medium # 명조계열
      h[:category] = {}
      h[:category][:color] = %w[LightGray]
      h[:sides] = [0,0,0,1]
      h
    end

    def layout_items
      # 1. default table column width is uniform width
      # 2. However if column_width_array is given, use that value,
      # 3. if @calculate_column_width:true
      # calculate average width of each column and create news cell_width_array
      
      @cell_width_array = @grid_cells[0...@column].map{|c| c[:width]}
      @table_width = @width - @cell_left_margin - @cell_right_margin
      if @column_width_array
        column_width_sum = @column_width_array.reduce(:+)
        @cell_width_array = []
        @column_width_array.each_with_index do |col_width|
          @cell_width_array << (col_width/column_width_sum)*@table_width
        end
      elsif @calculate_column_width
        @column_width_array = calculate_column_width_array
        column_width_sum = @column_width_array.reduce(:+)
        @cell_width_array = []
        @column_width_array.each_with_index do |col_width|
          @cell_width_array << (col_width*@table_width)/column_width_sum
        end
      end
      @table_data.each_with_index do |row, j|
        x_pos = @cell_left_margin
        row.each_with_index do |cell_text, i|
          h = {}
          h[:parent]      = self
          cell            = @grid_cells[@column*j + i]
          next if cell.nil?
          h[:x]           = x_pos # 
          cell[:x]        = x_pos
          h[:y]           = cell[:y]
          h[:width]       = @cell_width_array[i]
          cell[:width]    = @cell_width_array[i]
          h[:height]      = cell[:height]
          h[:stroke_width] = 1
          # h[:fill_color] = default_style[:head][:color][0]
          h[:fill_color] = 'white'
          h[:alignment]  = 'center'
          h[:font_size]  = cell[:height]*0.5
          h[:text_string] = cell_text
          if @has_head && j == 0
            h[:fill_color] = default_style[:head][:color][0]
            h[:font] = "KoPubDotumPB"
            # AntiqueWhite, AliceBlue
          elsif default_style[:category][:color] && i == 0
            h[:fill_color] = default_style[:category][:color][0]
          elsif @has_head && j.even?
            h[:fill_color] = 'AntiqueWhite' #Teal' #Beige'  #
            # h[:fill_color] = default_style[:head][:color][1] if (default_style[:head][:color]).length > 1
          end
          h[:text_alignment] = @column_alignment_array[i] if @column_alignment_array
          Text.new(h)
          x_pos += h[:width]
        end
      end
    end

    # calculate width average cells for each column from table_data
    def calculate_column_width_array
      # column_width_array = []
      # @column.times do |i|
      #   cells_of_column = nth_body_column_cells(i)
      #   string_width_of_column = cells_of_column.map{|c| c.text_string.length}
      #   body_row_count = @row
      #   body_row_count -= 1 if @has_head
      #   column_width_array << string_width_of_column.sum/body_row_count
      # end
      # column_width_array

      column_width_array = []
      @column.times do |i|
        data_of_column = nth_body_column_data(i)
        string_width_of_column = data_of_column.map{|st| st.length}
        body_row_count = @row
        body_row_count -= 1 if @has_head
        column_width_array << string_width_of_column.sum/body_row_count
      end
      column_width_array
    end

    ###### accessing table_data  
    def head_row_data
      if @has_head
        @table_data.first
      else
        []
      end
    end

    def body_data
      if @has_head
        @table_data[1..-1]
      else
        @table_data
      end
    end

    def nth_body_column_data(n)
      nth_column_data = []
      body_data_array = body_data.dup
      body_row_count = @row
      body_row_count -= 1 if @has_head
      body_row_count.times do |i|
        nth_column_data << body_data_array[i][n]
      end
      nth_column_data
    end    


    ###### accessing cells 
    def head_row_cells
      if @has_head
        @graphics[0...@column]
      else
        []
      end
    end


    def body_cells
      if @has_head
        @graphics[@column..-1]
      else
        @graphics
      end
    end

    def nth_body_column_cells(n)
      nth_column_cells = []
      body_cells_array = body_cells.dup
      body_row_count = @row
      body_row_count -= 1 if @has_head
      body_row_count.times do |i|
        nth_column_cells << body_cells_array[@column*i + n]
      end
      nth_column_cells
    end

    def nth_body_row_cells(n)
      cells = body_cells[n*@column...(n+1)*@column]
      cells
    end

    def even_body_rows
      cells = []
      (@row - 1).times do |i|
        cells << nth_body_row_cells(i) if i.even?
      end
      cells
    end

    def odd_body_rows
      cells = []
      (@row - 1).times do |i|
        cells << nth_body_row_cells(i) if i.odd?
      end
      cells   
    end
  end
end