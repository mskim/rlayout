module RLayout

  class RPageV < RPage
    attr_accessor :v_x, :v_y, :v_width, :v_height

    def initilaize(options={})
      super

      self
    end

    # create news_columns
    def create_columns
      current_x = @left_margin
      @column_height = @height - @top_margin - @bottom_margin
      @column_count.times do |i|
        if @empty_first_column && i == 0
          g= RColumnV.new(parent:self, empty_lines: true, x: current_x, y: @top_margin, width: @column_width, height: @column_height, column_line_count: @body_line_count, body_line_height: @body_line_height)
          current_x += @column_width + @gutter
        else
          g= RColumnV.new(parent:self, x: current_x, y: @top_margin, width: @column_width, height: @column_height, column_line_count: @body_line_count, body_line_height: @body_line_height)
          current_x += @column_width + @gutter
        end
      end
      @column_bottom = max_y(@graphics.first.frame_rect)
      link_column_lines
    end


  end
end