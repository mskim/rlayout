module RLayout
  class NewsBox < Container
    attr_accessor :kind, :on_left_edge, :on_right_edge, :is_front_page, :top_story, :top_position, :bottom_article, :grid_size, :grid_frame, :body_line_height
    attr_accessor :page_heading_margin_in_lines, :page_heading_place_holder, :article_bottom_spaces_in_lines
    attr_accessor :column_width, :column_count, :row_count, :extended_line_count, :pushed_line_count

    def initialize(options={}, &block)
      # @is_ad_box            = options[:is_ad_box] || false
      options[:left_margin]   = 0
      options[:right_margin]  = 0
      options[:top_margin]    = options.fetch(:top_margin, 0)
      options[:bottom_margin] = options.fetch(:bottom_margin, 0)
      if options[:article_line_draw_sides]
        options[:stroke_sides]= eval(options[:article_line_draw_sides]) if options[:stroke_sides].class == String
      else
        options[:stroke_sides]= [0,0,0,1]
      end
      options[:stroke_width]  = options.fetch(:article_line_thickness,0.3)
      super
      @kind                   = options.fetch(:kind, 'article')
      @gutter                 = options.fetch(:gutter, 10)
      @on_left_edge           = options.fetch(:on_left_edge, false)
      @on_right_edge          = options.fetch(:on_right_edge, false)
      @page_heading_margin_in_lines    = options[:page_heading_margin_in_lines] || 0
      @extended_line_count    = options.fetch(:extended_line_count, 0)
      @pushed_line_count      = options.fetch(:pushed_line_count, 0)
      @column_count           = options[:column]
      @row_count              = options[:row]
      @is_front_page          = options.fetch(:is_front_page, false)
      @top_story              = options.fetch(:top_story, false)
      @top_position           = options.fetch(:top_position, false)
      @bottom_article         = options.fetch(:bottom_article, false)
      @article_bottom_spaces_in_lines = options.fetch(:article_bottom_spaces_in_lines, 2)
      if options[:grid_frame]
        @grid_frame = options[:grid_frame]
        if @grid_frame.class == String
          @grid_frame = eval(@grid_frame)
        end
      else
        @grid_frame  = [0,0,@column_count, @row_count]
      end
      @grid_width           = options.fetch(:grid_width, 200)
      @grid_height          = options.fetch(:grid_height, 200)
      @lines_per_grid       = options.fetch(:lines_per_grid, 7)
      @v_gutter             = 0 #options.fetch(:v_gutter, 0)
      @grid_size            = [@grid_width , @grid_height]
      @layout_direction     = options.fetch(:layout_direction, "horizontal")
      @layout_space         = options.fetch(:layout_space, @gutter)
      @floats               = options.fetch(:floats, [])
      if options[:width]
        @width = options[:width]
      else
        @width  = @column_count*@grid_width # we have @gutter/2 on each side
      end
      if @on_left_edge && @on_right_edge
        # touching both edge
        puts 
        @right_margin      = 0.0
        @left_margin       = 0.0
        @column_width      = (@width - (@column_count - 1)*@gutter)/@column_count
        @starting_column_x = 0.0
      elsif @on_left_edge
        # touching left edge
        @column_width       = (@width - @column_count*@gutter)/@column_count
        @starting_column_x  = 0.0
        @left_margin        = 0.0
        @right_margin       = @gutter
      elsif @on_right_edge
        # touching right edge
        @column_width       = (@width - @column_count*@gutter)/@column_count
        @starting_column_x  = @gutter
        @left_margin        = @gutter
        @right_margin       = 0.0
      else
        @column_width       = (@width - (@column_count + 1)*@gutter)/@column_count
        @starting_column_x  = @gutter
        @left_margin        = @gutter
        @right_margin       = @gutter
      end

      @body_line_height     = @grid_height/@lines_per_grid
      @column_line_count    = @row_count*@lines_per_grid
      @column_line_count   -= @page_heading_margin_in_lines if @top_position
      @column_line_count   += @extended_line_count
      @column_line_count   -= @pushed_line_count

      if options[:height]
        @height = options[:height]
      else
        # @height             = @row_count*@grid_height + @extended_line_count*@body_line_height
        @height             = @column_line_count*@body_line_height
      end
      self
    end

    def column_grid_rect(column)
      grid_x = @graphics.index(column)
      [grid_x, 0, 1, row_count]
    end

    def get_stroke_rect
      if RUBY_ENGINE == "rubymotion"
        # r = NSMakeRect(@x,@y,@width,@height)
        y_position = @top_margin
        y_position += @page_heading_place_holder.height if @page_heading_place_holder
        r = NSMakeRect(@left_margin,y_position,@width - (@left_margin + @right_margin) , @height - y_position)
        if @line_position == 1 #LINE_POSITION_MIDDLE
          return r
        elsif @line_position == 2
          #LINE_POSITION_OUTSIDE)
          return NSInsetRect(r, - @stroke[:thickness]/2.0, - @stroke[:thickness]/2.0)
        else
          # LINE_POSITION_INSIDE
          return NSInsetRect(r, @stroke[:thickness]/2.0, @stroke[:thickness]/2.0)
        end
      else
        [@x, @y, @width, @height]
      end
    end

  end

  class NewsAdBox < NewsBox
    # Use news_image instead of float_image
    def initialize(options={}, &block)
      super
      if @on_right_edge && @on_left_edge
        @left_margin = 0 
        @right_margin = 0
      elsif @on_left_edge
        @left_margin = 0 
        @right_margin = @gutter
      elsif @on_right_edge
        @left_margin = @gutter 
        @right_margin = 0
      end
      @layout_direction = 'vertical'
      @kind             = 'ad'
      unless @top_position == true
        @top_margin        = @body_line_height
      end
      @x                = 0
      # @width  -= 2

      if block
        instance_eval(&block)
      end
      if @floats.length > 0
        layout_floats!
      end
      self
    end
  end
end
