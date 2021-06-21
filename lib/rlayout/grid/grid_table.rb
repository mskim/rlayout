module RLayout
  # GridTable
  # Grid base table

  # It can have nested table

  class GridTable < Grid
    attr_reader :csv_path, :table_data
    attr_reader :has_head, :output_path

    def initialize(options={})
      if options[:csv_path] 
        @table_data = RLayout::parse_csv(options[:csv_path])
        return unless @table_data
      elsif options[:table_data]
        @table_data = options[:table_data]
      end
      @output_path = options[:output_path]
      @has_head = options[:has_head] || true
      options[:column] = @table_data.first.length
      options[:row] = @table_data.length
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