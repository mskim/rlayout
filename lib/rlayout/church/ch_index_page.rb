module RLayout

  # TODO:
  # fix last page table row height is differnt from the previous table
  # since the last page has less data. FIX THIS
  # if table data is shorter than body_line_count
  # change the height of table for shorter table

  class ChIndexPage < Container
    attr_reader :page_number, :page_image, :image_column, :image_row
    attr_reader :page_members, :list_column, :body_line_count
    attr_reader :table_row_height
    def initialize(options={})
      @page_number = options[:page_number]
      @page_members = options[:page_members]
      @list_column = options[:list_column] || 1
      @body_line_count = options[:body_line_count] + 1 || 31
      @gutter = options[:gutter] || 5
      # make table row heiht equal for all pages, even for the last page where row number maybe shorter than other pages.
      @table_row_height = options[:table_row_height]
      options[:left_margin] = options[:left_margin] || 30
      options[:top_margin] = options[:top_margin] || 30
      options[:right_margin] = options[:right_margin] || 30
      options[:bottom_margin] = options[:bottom_margin] || 30
      super
      layout_index
      self
    end

    def layout_index
      # column_members = @page_members.each_slice(@body_line_count).to_a
      x_position = @left_margin
      table_width = (@width - @left_margin - @right_margin - @gutter*(@list_column - 1))/@list_column
      table_height = @height - @top_margin - @bottom_margin
      table_data_count = @page_members.length
      if @body_line_count > table_data_count
        table_height = (table_height*table_data_count)/@body_line_count
      end
      @page_members.each_slice(@body_line_count).to_a.each do |column_member|
        h = {}
        h[:parent] = self
        h[:x] = x_position
        h[:y] = @top_margin
        h[:width] = table_width
        h[:height] = table_height
        h[:table_data] = column_member
        h[:calculate_column_width] = true
        h[:row] = @body_line_count
        RLayout::GridTable.new(h)
        x_position += table_width + @gutter
      end
    end
  end

end