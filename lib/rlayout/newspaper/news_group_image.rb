module RLayout

  # layout_direction horizontal, vertical, nxn(2x2 or 3x3)

  class NewsGroupImage < NewsFloat
    attr_reader :image_items_full_path, :image_item_captions, :group_caption

    def initialize(options={})
      if options[:parent]
        @parent               = options[:parent]
        @article_column       = options[:parent].column_count
        @article_row          = options[:parent].row_count
      else
        @article_column       = 3
        @article_row          = 3
      end
      @x_grid                 = options[:x_grid]
      @draw_frame             = options[:draw_frame] || true
      @column                 = options[:column]
      @row                    = options[:row]
      @position               = options[:position] || 3
      @extenteded_line_count  = options[:extenteded_line_count]
      @position               = options[:position] || 3
      grid_frame              = position_to_grid_frame(options)
      grid_frame[0]           = @x_grid if @x_grid 
      @gutter = 10
      if @parent
        frame_rect              = @parent.grid_frame_to_rect(grid_frame, bottom_position: bottom_position?)
        @gutter = @parent.gutter
      else
        frame_rect              = [0,0, 400, 100]
      end
      @x                      = frame_rect[0]
      @y                      = frame_rect[1]
      @width                  = frame_rect[2]
      @height                 = frame_rect[3] - 4 #TODO body_leading
      options[:layout_expand] = nil
      options[:fill_color]    = 'clear'
      @image_items_full_path  = options[:image_items_full_path]
      @image_item_captions    = options[:image_item_captions]
      @group_caption          = options[:group_caption] || nil
      @hide_caption           = options[:show_caption] || true
      super

      create_float_object
      self
    end

    def create_float_object
      @image_object = GroupImage.new(width:@width, height:height, image_items_full_path: @image_items_full_path, image_item_captions: @image_item_captions)
    end
    
  end
end
