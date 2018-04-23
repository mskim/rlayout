module RLayout

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
      @heading   = @parent_graphic.floats.first
      if options[:width_in_colum] == 'half'
        @first_column           = @parent_graphic.graphics.first
        @x                      = @first_column.x + @first_column.width/2
        @height                 = 85
        @width                  = 170
        bottom_room             = options[:bottom_room_margin]*@parent_graphic.body_line_height
        @y                      = @first_column.height - bottom_room*2 - @height
        @y                      += @heading.height if @heading
      else
        @first_column           = @parent_graphic.graphics.first
        @x                      = 0
        @height                 = @parent_graphic.body_line_height*options[:image_height_in_line]
        @width                  = @first_column.width
        bottom_room             = options[:bottom_room_margin]*@parent_graphic.body_line_height
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
      # @height                       += @parent_graphic.body_line_height
      self
    end



    def size_to_grid(size)
      mid_column      = @article_column/2
      large_column    = mid_column + 1
      small_column    = mid_column - 1
      case size
      when 'large'
      when 'medium'
      when 'small'
      end
    end

    # convert size, position into x,y,width, and height
    def convert_size_position_to_frame(options={})
      default_image_options   = IMAGE_SIZE_POSITION_TABLE["#{@article_column}x#{@article_row}"]
      default_image_options   = IMAGE_COLUMN_POSITION_TABLE[@article_column.to_s] unless default_image_options
      image_size              = options.fetch(:size, default_image_options[:size])
      image_position          = "top_right"
      image_position          = NUMBER_TO_POSITION[options[:position].to_s] if options[:position]
      #TODO this is only for upper right, do it for other positions as well
      if options[:column] && options[:row]
        image_size[0] = options[:column]
        image_size[1] = options[:row]
      end
      position_array = image_position.split("_")
      v_position = position_array[0]
      h_position = position_array[1]
      x_grid = @article_column - image_size[0]
      y_grid = 0 #@article_row - image_size[1]

      # horizontal posiion
      if h_position == 'center'
        diff   = @article_column - image_size[0]
        if diff.odd?
          x_grid = (diff + 1)/2
        else
          x_grid = diff/2
        end
      elsif h_position == 'left'
        x_grid = 0
      end
      # veritical posiion
      if v_position == 'center'
        diff   = @article_row - image_size[1]
        if diff.odd?
          y_grid = (diff + 1)/2
        else
          y_grid = diff/2
        end
      elsif v_position == 'bottom'
        y_grid = @article_row - image_size[1]
      end
      [x_grid, y_grid, image_size[0], image_size[1]]
    end

  end



end
