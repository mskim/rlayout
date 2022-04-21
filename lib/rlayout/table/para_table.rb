module RLayout

  class ParaTable
    attr_reader :csv_path, :csv_data

    def initialize(options={})
      if options[:csv_path]
        @csv_path = options[:csv_path]
        @csv_data = File.open(@csv_path, 'r'){|f| f.read}
      elsif options[:csv_data]
        @csv_data = options[:csv_data]
      end
      create_table_rows
      current_line = []
      self
    end

    def create_table_rows
      csv = CSV.parse(@csv_data, :headers => true)
      csv.each_with_index do |row, i|
        row_data = row.to_h

        if i == i
        else
        end
        ParaTableRow.new(row_data: row_data)
      end
    end

    # layout table rows starting at current_line location
    def layout_rows(current_line)

    end

  end
end