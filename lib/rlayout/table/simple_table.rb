module RLayout
  

INDENT = /^(?:\t| {4})/
OPT_SPACE = / {0,3}/
TABLE_SEP_LINE = /^([+|: \t-]*?-[+|: \t-]*?)[ \t]*\n/
TABLE_HSEP_ALIGN = /[ \t]?(:?)-+(:?)[ \t]?/
TABLE_FSEP_LINE = /^[+|: \t=]*?=[+|: \t=]*?[ \t]*\n/
TABLE_ROW_LINE = /^(.*?)[ \t]*\n/
TABLE_PIPE_CHECK = /(?:\||.*?[^\\\n]\|)/
TABLE_LINE = /#{TABLE_PIPE_CHECK}.*?\n/
TABLE_START = /^#{OPT_SPACE}(?=\S)#{TABLE_LINE}/

  class SimpleTable < Container
    attr_accessor :has_head, :header, :rows
    attr_accessor :body_styles, :has_head_column, :header_array
    attr_reader   :column_align_array

    def initialize(options={})
      super
      @has_head         = false
      @row_data         = options[:rows]
      @rows = []
      if @row_data 
        if @row_data[1].include?("---")
          @has_head_column = true
          make_column_align_array(@row_data[1])
          @row_data.delete_at(1)
        end
        # delete divider row
      end

      @row_data.each_with_index do |row, i|
        if i == 0 && @has_head_column
          SimpleTableRow.new(parent: self, fill_color: 'gray', stroke_sides:[1,1,1,], stroke_width: 1, head_row: @has_head_column, width: @width, height: 20, items: row)
        else
          SimpleTableRow.new(parent: self, fill_color: 'yellow', stroke_sides:[1,1,1,], stroke_width: 1, width: @width, height: 25, items: row)
        end
      end
      layout_items
      self
    end
    
    def layout_items
      height_sum = @graphics.map{|g| g.height}.reduce(:+)
      @height   = height_sum + height_sum
      relayout!
    end
    
    def make_column_width_array
      width_ratio = [1, 6, 6, 6]
      # if width_ratio is given 
      if @table_head_style && @table_head_style[:column_width_array]
        width_ratio = @table_head_style[:column_width_array]
      end
      ratio_sum = width_ratio.reduce(:+)
      width_ratio.map{|w| w*@width/ratio_sum}
    end
    
    def make_column_align_array(divider_string)
      @column_align_array = []
      divider_array = divider_string.split("|")
      divider_array.shift
      divider_array.each do |cell_string|
        if cell_string =~/^\S*:/ && cell_string =~/:\S*$/
          @column_align_array << 'justified'
        elsif cell_string =~/^\S*:/
          @column_align_array << 'left'
        elsif cell_string =~/:\S*$/
          @column_align_array << 'right'
        else
          @column_align_array << 'center'
        end
      end
    end
  end
  
  class SimpleTableRow < Container
    attr_accessor :items, :head_row, :column_width_array, :column_align_array
    def initialize(options={})
      super
      @table_style    = RLayout::StyleService.shared_style_service.chapter_style
      @layout_direction   = "horizontal"
      @layout_expand      = :width
      @items              = options[:items].split("|")
      @items.shift
      @head_row           = options.fetch(:head_row, false)
      @column_align_array = @parent.column_align_array if @parent.column_align_array
      @table_head_style   = @table_style[:table_head_style].dup
      @items.each_with_index do |item, i|
        if @head_row
          token = RTextToken.new(parent: self,string: item.strip, para_style: @table_style['h4'], layout_expand: :width)
        else
          token = RTextToken.new(parent: self, string:item.strip, para_style: @table_style['body'], layout_expand: :width)
        end
      end
      self
    end
  end
  
end
  
  
  