module RLayout
  class BoxTableRow < Container
    attr_reader :row_data, :row_styles, :row_index
    def initialize(options={})
      @row_data   = options[:row_data]
      @row_styles = options[:row_styles]
      @row_index  = options[:row_index]
      super
      create_cells
      self
    end

    def row_index
      @parent.graphics.index(self)
    end

    def create_cells
      @row_data.each_with_index do |cell, i|
        h                 = {}
        h[:parent]        = self
        h[:layout_expand] = [:width, :height]
        if cell.is_a?(String) 
          h[:layout_direction]  = 'horizontal'
          h[:string]            = cell
          h[:graphic_style]     = {fill_color: 'yellow', stroke_color: 'black', stroke_width: 1}
          h[:text_style]        = {font: 'Shinmoon', font_size: 12, text_color: 'black'}
          # TODO: tag
          h[:style_name]        = tag || 'body'
          h[:style_name]        = 'subtitle'
          h[:v_alignment]       = 'top'
          h[:column_index]      = i
          h[:row_index]         = @row_index
          BoxTableTextCell.new(h)
        elsif options[:cell_data].is_a?(Hash)
          # cell is text cell or image cell
        elsif options[:cell_data].is_a?(Array)
          @cell_type == 'subtable'
          # create subtable
        end
      end
    end

  end
end