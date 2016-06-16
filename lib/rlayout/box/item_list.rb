
# ItemList is used for billing letter printing
# Where there is a already designed backgroud and table, 
# and we just want to puts the text on top of the table as 
# a separate layer for variable printing rip.
# It should be called with x, y, width, height, items, column_width_array, max_item_count
module RLayout
  class ItemList < Container
    attr_accessor :items, :item_height, :column_width_array, :column_alignment_array
    def initialize(options={})
      @items              = options[:items]
      @max_item_count     = options.fetch(:max_item_count, 20)
      unless @items
        puts "No items given!!!"
        return
      end
      super
      @item_height        = @height/@max_item_count
      @column_width_array = options[:column_width_array] if options[:column_width_array]
      @column_alignment_array = options[:column_alignment_array] if options[:column_alignment_array]
      options[:fill_color] = "clear"
      layout_items_row
      self
    end
    
    def layout_items_row
      y = 0
      @items.each do |item|
        next unless is_valid?(item)
        row = ItemRow.new(parent:self, y: y, item: item, width: @width, height: item_height, column_width_array: @column_width_array, column_alignment_array: @column_alignment_array)
        y += row.height
      end
    end
    
    def is_valid?(item_array)
      return false if item_array.nil?
      valid = true
      item_array.each do |e|
        if  e.nil? || e.empty?
          valid = false
        else
        end
      end
      valid
    end
    
  end
  
  class ItemRow < Container
    attr_accessor :item_text_array, :column_width_array, :column_alignment_array
    def initialize(options={})
      options[:fill_color]        = "clear"
      options[:layout_direction]  = "horizontal"
      @item_text_array            = options[:item]
      @column_width_array         = default_column_width
      @column_width_array         = options[:column_width_array] if options[:column_width_array]
      @column_alignment_array     = default_alignment
      @column_alignment_array     = options[:column_alignment_array] if options[:column_alignment_array]
      super
      @item_text_array.each_with_index do |cell_text, i|
        Text.new(parent:self, text_string: cell_text, text_size: (@height - 4), fill_color: "clear", layout_length: @column_width_array[i], text_alignment: @column_alignment_array[i])
      end
      relayout!
      self
    end
        
    def default_column_width
      @item_text_array.map {|t| 1}
    end
    
    def default_alignment
      @item_text_array.map {|t| "center"}
    end
  end
end