# module RLayout

#   class TextCell < Text
#     attr_reader :v_align, :column_index, :row_index
#     def initialize(options={})
#       options[:fill_color]   = 'clear'
#       options[:stroke_color] = 'green'
#       options[:stroke_width] = 1
#       options[:v_alignment]  = 'top'
#       @column_index = options[:column_index]
#       @row_index    = options[:row_index]
#       super
#       @graphics_style = options[:graphic_style] || default_cell_graphic_style
#       @text_style     = options[:text_style] || default_cell_text_style
#       @column_index   = options[:column_index]
#       @row_index      = options[:row_index]
#       set_cell_style
#       self
#     end

#     def default_cell_graphic_style
#       {fill_color: 'yellow', stroke_color: 'black', stroke_width: 1}
#     end

#     def default_cell_text_style
#       {font: 'KoPubDotumPL', font_color: 'black', font_size: 9, } 
#     end
#   end
# end