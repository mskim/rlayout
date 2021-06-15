module RLayout
  # GridTable
  # Grid base table

  # It can have nested table

  class GridTable < Grid
    attr_reader :csv_path, :table_data
    attr_reader :has_head

    def initialize(options={})
      if options[:csv_path] 
        @table_data = RLayout::parse_csv(options[:csv_path])
        return unless @table_data
      elsif options[:table_data]
        @table_data = options[:table_data]
      end
      @has_head = options[:has_head] || true
      options[:column] = @table_data.first.length
      options[:row] = @table_data.length
      super
      layout_items
    end

    def layout_items
      @table_data.each_with_index do |row, j|
        row.each_with_index do |cell_text, i|
          h = {}
          h[:parent]      = self
          cell            = @grid_cells[@column*j + i]
          next if cell.nil?
          h[:x]           = cell[:x]
          h[:y]           = cell[:y]
          h[:width]       = cell[:width]
          h[:height]      = cell[:height]
          h[:stroke_width] = 1
          h[:fill_color] = 'clear'
          h[:alignment]  = 'center'
          h[:font_size]  = cell[:height]*0.5
          h[:text_string] = cell_text
          if @has_head && j == 0
            h[:fill_color] = 'gray'
          elsif @has_head && j.even?
            h[:fill_color] = 'orange'
          end
          Text.new(h)
        end
      end
    end

    def head_row
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