# NewsImage
# there are couple of ways to specify size aize and location
# surest way is to use grid_frame, but grid_frames are hard to specify by users,
# so we use size, and position to translate those values to grid_fgram at run time

#IMAGE_HEIGHT_TYPES = ['full', 'fit', 'half', 'balanced']
# FULL_HEIGHT     = 0   # full box height
# FIT_HEIGHT      = 1   # fit under title
# HALF_HEIGHT     = 2   # abotu half of the box under tttle
# BALANCED_HEIGHT = 2   # column and row count is equal, giving the nice balnced look

# TOP_LEFT      = 0
# TOP_MIDDLE    = 1
# TOP_RIGHT     = 2
# MIDDLE_LEFT   = 3
# MIDDLE_MIDDLE = 4
# MIDDLE_RIGHT  = 5
# RIGHT_LEFT    = 6
# RIGHT_MIDDLE  = 7
# RIGHT_RIGHT   = 8

#  quote_box_size               :integer
#  quote_position               :integer
#  quote_x_grid                 :integer
#  quote_v_extra_space          :integer
#  quote_alignment              :string
#  quote_line_type              :string

module RLayout
  class NewsQuote < Container
    attr_accessor :article_column, :column, :article_row, :row, :image_size, :caption_title
    attr_accessor :quote_box, :caption_paragraph, :position, :before_title, :fit_type, :expand, :has_caption
    attr_reader   :x_grid, :quote

    def initialize(options={})
      if options[:parent]
        @article_column       = options[:parent].column_count
        @article_row          = options[:parent].row_count
      else
        @article_column       = 3
        @article_row          = 3
      end
      @column                 = options[:column]
      @row                    = options[:row]
      @quote                  = options[:quote]
      @position               = options[:quote_position] || 3
      @position               = 9  if @position > 9
      @position               = 1  if @position < 0
      @x_grid                 = options[:quote_x_grid]

      options[:grid_frame]    = convert_column_row_position_to_frame(options) if @position
      options[:grid_frame][0] = @x_grid if @x_grid 
      options[:layout_expand] = nil
      options[:fill_color]    = 'clear'
      @fit_type               = options[:fit_type] if options[:fit_type]
      @expand                 = options[:expand] if options[:expand]
      @before_title           = options.fetch(:before_title, false)
      super
      if @parent
        frame_rect              = @parent.grid_frame_to_rect(options[:grid_frame], bottom_position: bottom_position?)
      else
        frame_rect              = [0,0, 400, 100]
      end
      @x                      = frame_rect[0]
      @y                      = frame_rect[1]
      @width                  = frame_rect[2]
      @height                 = frame_rect[3] - 4 #TODO body_leading
      if options[:quote_v_extra_space]  && options[:quote_v_extra_space] > 0
        @height += options[:quote_v_extra_space]*@parent.body_line_height
        @y -= options[:quote_v_extra_space]*@parent.body_line_height if bottom_position?
      end

      quote_options                = {}
      quote_options[:width]        = @width
      quote_options[:height]       = @height

      unless top_position?
        quote_options[:y]          = @parent.body_line_height
        quote_options[:height]     -= @parent.body_line_height
      end
      quote_options[:stroke_width]   = 0.3
      quote_options[:stroke_width]   = 0.0 if @image_kind == 'graphic'
      quote_options[:image_fit_type] = 3 #IMAGE_FIT_TYPE_KEEP_RATIO
      quote_options[:image_fit_type] = @fit_type if @fit_type
      quote_options[:image_path]     = @image_path
      quote_options[:layout_expand]  = nil
      quote_options[:layout_expand]  = @expand if @expand
      quote_options[:parent]         = self
      quote_options[:text_string]    = @quote
      quote_options[:style_name]     = 'quote'
      @image_box                     = TitleText.new(quote_options)
      # make space after the news_image when we have following text
      @height                       += @parent.body_line_height if @parent
      self
    end

    def top_position?
      @position == 1 || @position == 2 || @position == 3
    end

    def bottom_position?
      @position == 7 || @position == 8|| @position == 9
    end

    def before_title?
      @before_title
    end

    def horizontal_center?
      @position == 2 || @position == 5 || @position == 8
    end
    
    def horizontal_left?
      @position == 1 || @position == 4 || @position == 7
    end

    def vertical_center?
      @position == 4 || @position == 5 || @position == 6
    end

    def vertical_bottom?
      bottom_position?
    end


    # convert column, row, and position into x,y,width, and height
    def convert_column_row_position_to_frame(options={})

      #TODO this is only for upper right, do it for other positions as well
      if options[:column] && options[:row]
        @image_size[0] = options[:column]
        @image_size[1] = options[:row]
      else
        @image_size = [1,1]
      end
      x_grid = @article_column - @image_size[0]
      y_grid = 0 #@article_row - image_size[1]

      # horizontal posiion
      if horizontal_center?
        diff   = @article_column - @image_size[0]
        if diff.odd?
          x_grid = (diff + 1)/2
        else
          x_grid = diff/2
        end
      elsif horizontal_left?
        x_grid = 0
      end
      # veritical posiion
      if vertical_center?
        diff   = @article_row - @image_size[1]
        if diff.odd?
          y_grid = (diff + 1)/2
        else
          y_grid = diff/2
        end
      elsif vertical_bottom?
        y_grid = @article_row - @image_size[1]
      end
      [x_grid, y_grid, @image_size[0], @image_size[1]]
    end

  end
end
