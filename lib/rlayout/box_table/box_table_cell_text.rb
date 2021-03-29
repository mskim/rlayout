module RLayout
  
  # Nested Table in  a cell
  # cell_data can be String, Hash or Array

  # graphic_style
  # fill_color, stroke_color, stroke_width, 
  # border_type solid, dotted, dash
  #                                         
  # text_style
  # alignment
  # font, font_size, font_style, text_color, outline_color
  
  class BoxTableCellText < Text
    attr_reader :v_align, :column_index, :row_index
    def initialize(options={})
      options[:fill_color]   = 'yellow'
      options[:stroke_color] = 'green'
      options[:stroke_width] = 1
      options[:v_alignment]  = 'top'
      @column_index = options[:column_index]
      @row_index    = options[:row_index]
      super
      @graphics_style = options[:graphic_style] || default_cell_graphic_style
      @text_style     = options[:text_style] || default_cell_text_style
      @column_index   = options[:column_index]
      @row_index      = options[:row_index]
      set_cell_style
      self
    end


  end

  # def table
  #   @parent.table
  # end

  # def column_index
  #   @parent.graphics.index(self)
  # end

  # def row_index
  #   @parent.row_index
  # end

  # look up graphic style from table using column_index, row_index and set it
  def set_cell_style
    # @graphic_style = table.graphic_style_of_cell(column_index, row_index)
    # @text_style    = table.text_style_of_cell(column_index, row_index)
    
  end

  # 2021-03-14
  # def RTextCell < Container
  #   attr_reader :text_style, :graphic_style
  #   def initialize(options={})
  #     @text_style = options[:text_style]
  #     @graphic_style = options[:grapih_style]
  #     create_tokens

  #     self
  #   end

  #   def create_tokens

  #   end

  #   def scale_tokens_to_fit

  #   end

  #   def set_frame
  #     layout_tokens

  #   end

  #   def layout_tokens


  #   end
  # end

end