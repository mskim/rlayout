module RLayout

  # NewsImageBox is a Image Box in place of Articles
  # has top margin when not in the top row
  # left_edge, and right_edge rules are applied

  class NewsImageBox < NewsBox
    # attr_accessor :on_left_edge, :on_right_edge, :is_front_page, :top_story, :top_position,:grid_size, :grid_frame, :body_line_height
    # attr_accessor :page_heading_margin_in_lines, :article_bottom_spaces_in_lines
    # attr_accessor :column_count, :row_count
    # Use news_image instead of float_image
    attr_accessor :news_image
    def initialize(options={}, &block)
      super
      if block
        instance_eval(&block)
      end

      if @floats.length > 0
        # layout_floats!
      end
      relayout!
      self
    end

    def grid_frame_to_image_rect(grid_frame, bottom_position=false)
      x_position  = 0
      y_position  = 0
      height      = @height - @article_bottom_spaces_in_lines*@body_line_height
      width       = @width
      if  @top_position
        y_position = 0
        # y_position += @body_line_height*2 #top_title_space_before_in_lines
        # height     -= @body_line_height*2 #top_title_space_before_in_lines
      else
        y_position += @body_line_height
        height     -= @body_line_height
      end
      unless @on_left_edge
        x_position += @gutter
        width -= @gutter
        @left_margin = @gutter
      end
      unless @on_right_edge
        width -= @gutter
        @right_margin = @gutter
      end
      [x_position, y_position, width, height]
    end

    # Use news_image instead of float_image
    def news_image(options={})
      options[:parent]    = self
      options[:y]         = 0
      options[:height]    = @height
      @news_image         = NewsImage.new(options)
    end
  end

  class NewsComicBox < NewsBox
    # Use news_image instead of float_image
    def initialize(options={}, &block)
      super
      if @floats.length > 0
        layout_floats!
      end
      self
    end
  end
end
