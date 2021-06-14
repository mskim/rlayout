module RLayout

  # GroupedCaption is placed in one of the empty GroupImage cells.
  # It displays grouped captions for image_cells at a location of images.
  # Think yearbook pictures with collected names area away from pictures. 
  class GroupedCaption < Grid
    attr_reader :cell_position, :column, :row
    attr_reader :text_string_array
    def initialize(options = {})

      @column = options[:column]
      @row = options[:row]
      @text_string_array = options[:text_string_array]
      # TODO: get x, y, width, height from parent
      # put the GroupedCaption in the middle of parent cell
      @parent = options[:parent]
      options[:fill_color] = 'clear'
      super
      layout_item
      self
    end

    def layout_item
      @text_string_array.each_with_index do |caption, i|
        h = {}
        h[:parent]      = self
        h[:text_string] = caption.unicode_normalize
        cell            = @grid_cells[i]
        h[:row]         = cell[:x]
        h[:x]           = cell[:x]
        h[:y]           = cell[:y]
        h[:width]       = cell[:width]
        h[:height]      = cell[:height]
        h[:font_size]   = 12
        Text.new(h)
      end
    end
  end




end