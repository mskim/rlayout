# TableMaker 
# Role of TableMaker is to determine setting for the table,
# given width, height and  data,
# column_width, and row_height for the data
# and detemine the font_size for cell text 

module RLayout
  class TableMaker
    attr_reader :project_path, :output_path
    attr_reader :lyout_rb, :table_data
    attr_reader :column_width_array, :row_height

    def initialize(options={})
      @project_path = options[:project_path]
      @output_path  = @project_path + "/table.pdf"
      @table_data = options[:table_data]
      @table_style = options[:table_style]
      @width = options[:width]
      @height = options[:height]
      create_table
      self
    end

    def create_table
      # analize data and box size
      # detemine the font_size

      t = Table.new(@width, @height, @table_data, @table_style)
      t.save_pdf_with_ruby(@output_path, :jpg=>true, :ratio => 2.0)

    end


  end



end