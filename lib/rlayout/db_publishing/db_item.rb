module RLayout
  # DbItem is a single column 
  # it can have left_image_column or left_image_colum
  # 
  class DBItem < Container
    attr_reader :width, :height, :body_line_height
    attr_reader :left_image_column_size, :right_image_column_size

    BODY_LINE_HEIGHT = 10
    BODY_LINE_COUNT = 5
    def initialize(options={})
      @width                    = options[:width] || BODY_LINE_HEIGHT
      @body_line_height         = options[:body_line_height] || BODY_LINE_HEIGHT
      @left_image_column_size   = opions[:left_image_column_size]
      @right_image_column_size  = opions[:right_image_column_size]
      create_column
      self
    end

    def create_column(options={})
      if @left_image_column_size 
        @line_x = @left_image_column_size
        @column_width = @width - @left_image_column_size
      elsif @right_image_column_size
        @line_x = 0
        @column_width = @width - @right_image_column_size
      else
        @line_x = 0
        @column_width = @width
      end
      DBColumn.new(x:@line_x, width:@column_width)
    end

    def set_content(options={})
      @title  = options[:title]
      @body   = options[:body]
    end

  end

end