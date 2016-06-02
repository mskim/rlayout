
# ItemList is used for billing letter printing
# Where there is a already designed backgroud and table, 
# and we just want to puts the text on top of the table as 
# a separate layer for variable printing rip.

module RLayout
  class ItemList < Container
    attr_accessor :items, :column_width_array, :item_height
    def initialize(options={})
      @items              = options[:items]
      @item_height        = options.fetch(item_height, 20)
      @column_width_array = options[:column_width_array]
      options[:fill_color] = "clear"
      unless @items
        puts "No items given!!!"
        return
      end
      super
      layout_items_row
      self
    end
    
    def layout_items_row
      y = 0
      @items.each do |item|
        row = ItemRow.new(parent:self, y: y, item: item, width: @width, height: item_height, colums_width: column_width_array)
        y += row.height
      end
    end
  end
  
  class ItemRow < Container
    attr_accessor :item_text_array, :column_width_array, :column_alignment_array
    def initialize(options={})
      options[:fill_color]        = "clear"
      options[:layout_direction]  = "horizontal"
      @item_text_array            = options[:item]
      @column_width_array         = options.fetch(:column_width_array, default_column_width)
      @column_alignment_array     = options.fetch(:column_alignment_array, default_alignment)
      super
      @item_text_array.each_with_index do |cell_text, i|
        Text.new(parent:self, text_string: cell_text, layout_length: @column_width_array[i], text_alignment: @column_alignment_array[i])
      end
      relayout!
      self
    end
    
    # def make_actual_column_width
    #   
    # end
    
    def default_column_width
      @item_text_array.map {|t| 1}
    end
    
    def default_alignment
      @item_text_array.map {|t| "center"}
    end
  end
end