module RLayout

NEWS_COLUMN_IMAGE_WIDTH   = 158.737
NEWS_COLUMN_IMAGE_HEIGHT  = 75

  class NewsColumnImage < Container
    attr_accessor :article_column, :column, :article_row, :row, :image_size, :image_position, :caption_title
    attr_accessor :image_box, :position, :before_title, :fit_type, :expand, :has_caption

    def initialize(options={})
      if options[:parent]
        @article_column       = options[:parent].column_count
        @article_row          = options[:parent].row_count
      else
        @article_column       = 3
        @article_row          = 3
      end
      @image_path             = options[:image_path]
      @column                 = options[:column]
      @row                    = options[:row]
      @position               = options[:position]
      options[:layout_expand] = nil
      options[:fill_color]    = 'clear'
      @fit_type               = options[:fit_type] if options[:fit_type]
      @expand                 = options[:expand] if options[:expand]
      super
      @heading   = @parent.floats.first
      if options[:width_in_colum] == 'half'
        @first_column           = @parent.graphics.first
        @x                      = @first_column.x + @first_column.width/2 - 6.77
        @height                 = NEWS_COLUMN_IMAGE_HEIGHT
        @width                  = NEWS_COLUMN_IMAGE_WIDTH
        bottom_room             = options[:bottom_room_margin]*@parent.body_line_height
        @y                      = @first_column.height - (bottom_room*2 + 8)- @height - @parent.body_line_height
        @y                      += @heading.height if @heading
      else
        @first_column           = @parent.graphics.first
        @x                      = 0
        @height                 = @parent.body_line_height*options[:image_height_in_line]
        @width                  = @first_column.width
        bottom_room             = options[:bottom_room_margin]*@parent.body_line_height
        @y                      = @first_column.height - bottom_room - @height + @first_column.y
        @y                      += @heading.height if @heading
      end

      image_options                  = {}
      image_options[:width]          = @width
      image_options[:height]         = @height
      image_options[:image_fit_type] = 3 #IMAGE_FIT_TYPE_KEEP_RATIO
      image_options[:image_fit_type] = @fit_type if @fit_type
      image_options[:image_path]     = @image_path
      image_options[:layout_expand]  = nil
      image_options[:layout_expand]  = @expand if @expand
      image_options[:parent]         = self
      @image_box                    = Image.new(image_options)
      # @height                       += @parent.body_line_height
      self
    end

  end
end
