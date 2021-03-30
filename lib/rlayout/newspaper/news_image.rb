# NewsImage
# there are couple of ways to specify size aize and location
# surest way is to use grid_frame, but grid_frames are hard to specify by users,
# so we use size, and position to translate those values to grid_fgram at run time

#IMAGE_HEIGHT_TYPES = ['full', 'fit', 'half', 'balanced']
FULL_HEIGHT     = 0   # full box height
FIT_HEIGHT      = 1   # fit under title
HALF_HEIGHT     = 2   # abotu half of the box under tttle
BALANCED_HEIGHT = 2   # column and row count is equal, giving the nice balnced look

TOP_LEFT      = 0
TOP_MIDDLE    = 1
TOP_RIGHT     = 2
MIDDLE_LEFT   = 3
MIDDLE_MIDDLE = 4
MIDDLE_RIGHT  = 5
RIGHT_LEFT    = 6
RIGHT_MIDDLE  = 7
RIGHT_RIGHT   = 8

PERSONAL_IMAGE_HEIGHT_IN_LINES = 6.5
# name caption goes downward
# gutter shift half towards picture side
module RLayout
  class NewsImage < Container
    attr_accessor :parent_column, :column, :parent_row, :row, :image_size, :caption_title
    attr_accessor :image_box, :caption_column, :caption_paragraph, :position, :before_title, :fit_type, :expand, :has_caption
    attr_reader   :image_kind, :x_grid, :draw_frame, :zoom_level, :zoom_anchor, :gutter, :crop_rect

    def initialize(options={})
      if options[:parent]
        @parent_column       = options[:parent].column_count
        @parent_row          = options[:parent].row_count
      else
        @parent_column       = 3
        @parent_row          = 3
      end
      @image_path             = options[:image_path]
      @image_kind             = options[:image_kind]
      @x_grid                 = options[:x_grid]
      @draw_frame             = options[:draw_frame] || true
      @column                 = options[:column]
      @row                    = options[:row]
      @position               = options[:position] || 3
      @position               = 9  if @position > 9
      @position               = 1  if @position < 0
      @zoom_level             = options[:zoom_level] if options[:zoom_level]
      @zoom_anchor            = options[:zoom_anchor] if options[:zoom_anchor]
      @crop_rect              = options[:crop_rect] if options[:crop_rect]      
      grid_frame              = position_to_grid_frame(options)
      grid_frame[0]           = @x_grid if @x_grid 
      options[:layout_expand] = nil
      options[:fill_color]    = 'clear'
      @fit_type               = options[:fit_type] if options[:fit_type]
      @expand                 = options[:expand] if options[:expand]
      @before_title           = options.fetch(:before_title, false)
      super
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

      if @image_kind == '인물_좌'  || @image_kind == 'person_image_left'
        @width                  = @parent.column_width*0.5 + @gutter/2
        @height                 = @parent.body_line_height*PERSONAL_IMAGE_HEIGHT_IN_LINES
      elsif @image_kind == '인물_우' || @image_kind == 'person_image_right'
        @x                      += @parent.column_width*0.5 - @gutter/2
        @width                  = @parent.column_width*0.5 + @gutter/2
        @height                 = @parent.body_line_height*PERSONAL_IMAGE_HEIGHT_IN_LINES
      end
      if options[:extra_height_in_lines]  && options[:extra_height_in_lines] != 0
        @height += options[:extra_height_in_lines]*@parent.body_line_height
        @y -= options[:extra_height_in_lines]*@parent.body_line_height if bottom_position?
      end
      has_caption_text?(options)
      image_options                = {}
      image_options[:width]        = @width
      image_options[:height]       = @height
      caption_width = @width
      caption_x     = 0
      if @image_kind == '인물_좌'  || @image_kind == 'person_image_left'
        image_options[:width]     = @width - @gutter
        caption_width             = @width - @gutter

      elsif @image_kind == '인물_우' || @image_kind == 'person_image_right'
        image_options[:x]         = @gutter
        image_options[:width]     = @width - @gutter
        caption_width             = @width - @gutter
        caption_x                 = @gutter
      end

      if @has_caption
        @caption_column         = CaptionColumn.new(parent:self, x: caption_x, width: caption_width, top_space_in_lines: 0.3, caption_line_height: 12)
        @caption_paragraph      = CaptionParagraph.new(options)
        @caption_paragraph.layout_lines(@caption_column)
      end
      
      image_options[:height]       = @height - @caption_column.height if @caption_column
      # image_options[:height]       = @height + @caption_column.height if @caption_column

      unless top_position?
        image_options[:y]          = @parent.body_line_height
        image_options[:height]     -= @parent.body_line_height
      end
      # IMAGE_FIT_TYPE_KEEP_RATIO     = 3
      # IMAGE_FIT_TYPE_IGNORE_RATIO   = 4
      image_options[:stroke_width]   = 0.3
      image_options[:stroke_width]   = 0 if @draw_frame == false
      image_options[:stroke_width]   = 0.0 if @image_kind == 'graphic'
      image_options[:image_fit_type] = 3 #IMAGE_FIT_TYPE_KEEP_RATIO
      image_options[:image_fit_type] = @fit_type if @fit_type
      image_options[:image_path]     = @image_path
      image_options[:layout_expand]  = nil
      image_options[:layout_expand]  = @expand if @expand
      image_options[:zoom_level]     = @zoom_level
      image_options[:zoom_anchor]    = @zoom_anchor
      image_options[:crop_rect]      = @crop_rect
      image_options[:parent]         = self
      if @parent && (@parent.kind == '기고' || @parent.kind == 'opinion')
        image_options[:stroke_width]  = 0
      end
      @image_box                    = Image.new(image_options)
      if @caption_column
        @caption_column.y             = @image_box.height
        @caption_column.y             += @parent.body_line_height unless top_position?
      end
      # make space after the news_image when we have following text
      # for full sized news_image, this will be adjusted by adjust_image_height
      @height                       += @parent.body_line_height if @parent
      self
    end

    def to_svg
      "<rect fill='red' x='#{@parent.x + @x}' y='#{@parent.y + @y}' width='#{@width}' height='#{@height - 2}' />"
    end

    def has_caption_text?(options)
      @has_caption = false
      if options[:caption_title] && options[:caption_title] != ""
         @has_caption = true
      elsif options[:caption] && options[:caption] !=""
        @has_caption = true
      elsif options[:source] && options[:source] !=""
        @has_caption = true
      else
        @has_caption = false
      end
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

    def adjust_image_height
      @image_box.height  = @height - @caption_column.height if @caption_column
      @image_box.apply_fit_type
      @caption_column.y  = @image_box.height if @caption_column
    end

    # convert column, row, and position into x,y,width, and height
    def position_to_grid_frame(options={})
      #TODO this is only for upper right, do it for other positions as well
      @image_size = {}
      if options[:column] && options[:row]
        @image_size[0] = options[:column]
        @image_size[1] = options[:row]
      else
        @image_size = [1,1]
      end
      x_grid = @parent_column - @image_size[0]
      y_grid = 0 #@parent_row - image_size[1]

      # horizontal posiion
      if horizontal_center?
        diff   = @parent_column - @image_size[0]
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
        diff   = @parent_row - @image_size[1]
        if diff.odd?
          y_grid = (diff + 1)/2
        else
          y_grid = diff/2
        end
      elsif vertical_bottom?
        y_grid = @parent_row - @image_size[1]
      end
      [x_grid, y_grid, @image_size[0], @image_size[1]]
    end

  end
end
