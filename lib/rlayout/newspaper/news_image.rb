# NewsImage
# there are couple of ways to specify size aize ans location
# surest way is to use grid_frame, but grid_frames are hard to generalize,
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

# minimum image height in grid? 3?

IMAGE_COLUMN_POSITION_TABLE = {
  '1'=> {size: [1,1], position: 'top_right'},
  '2'=> {size: [2,2], position: 'top_right'},
  '3'=> {size: [2,2], position: 'top_right'},
  '4'=> {size: [3,3], position: 'top_right'},
  '5'=> {size: [3,3], position: 'top_center'},
  '6'=> {size: [3,3], position: 'top_right'},
  '7'=> {size: [3,3], position: 'top_right'},
}

IMAGE_SIZE_POSITION_TABLE = {
  '1x1'=> {size: [1,1], position: 'top_right'},
  '1x2'=> {size: [1,1], position: 'top_right'},
  '1x3'=> {size: [1,1], position: 'top_right'},

  '2x2'=> {size: [2,2], position: 'top_right'},
  '2x3'=> {size: [2,2], position: 'top_right'},
  '2x4'=> {size: [2,2], position: 'top_right'},
  '2x5'=> {size: [2,2], position: 'top_right'},

  '3x3'=> {size: [2,2], position: 'top_right'},
  '3x4'=> {size: [2,2], position: 'top_right'},
  '3x5'=> {size: [2,2], position: 'top_right'},
  '3x6'=> {size: [2,2], position: 'top_right'},

  '4x4'=> {size: [2,4], position: 'top_right'},
  '4x5'=> {size: [2,5], position: 'top_right'},
  '4x6'=> {size: [2,6], position: 'top_right'},
  '4x7'=> {size: [2,3], position: 'top_right'},
  '4x3'=> {size: [2,3], position: 'top_right'},

  '5x5'=> {size: [3,3], position: 'top_center'},
  '5x6'=> {size: [3,3], position: 'top_center'},
  '5x7'=> {size: [3,3], position: 'top_center'},
  '5x4'=> {size: [3,3], position: 'top_center'},
  '5x3'=> {size: [3,3], position: 'top_center'},

  '6x6'=> {size: [3,3], position: 'top_right'},
  '6x5'=> {size: [3,3], position: 'top_right'},
  '6x4'=> {size: [3,3], position: 'top_right'},

  '7x7'=> {size: [3,3], position: 'top_right'},
  '7x6'=> {size: [3,3], position: 'top_right'},
  '7x5'=> {size: [3,3], position: 'top_right'},
  '7x4'=> {size: [3,3], position: 'top_right'},
}

NUMBER_TO_POSITION = {
  '0'=> 'before_title',
  '1'=> 'top_left',
  '2'=> 'top_center',
  '3'=> 'top_right',
  '4'=> 'center_left',
  '5'=> 'center_center',
  '6'=> 'center_right',
  '7'=> 'bottom_left',
  '8'=> 'bottom_center',
  '9'=> 'bottom_right',
}

module RLayout
  class NewsImage < Container
    attr_accessor :article_column, :column, :article_row, :row, :image_size, :image_position, :caption_title
    attr_accessor :image_box, :caption_column, :caption_paragraph, :position, :before_title, :fit_type, :expand, :has_caption
    attr_reader   :image_kind

    def initialize(options={})
      if options[:parent]
        @article_column       = options[:parent].column_count
        @article_row          = options[:parent].row_count
      else
        @article_column       = 3
        @article_row          = 3
      end
      @image_path             = options[:image_path]
      @image_kind             = options[:image_kind]
      @column                 = options[:column]
      @row                    = options[:row]
      @position               = options[:position]
      options[:grid_frame]    = convert_column_row_position_to_frame(options) if @position
      options[:layout_expand] = nil
      options[:fill_color]    = 'clear'
      @fit_type               = options[:fit_type] if options[:fit_type]
      @expand                 = options[:expand] if options[:expand]
      @before_title           = options.fetch(:before_title, false)
      super
      frame_rect              = @parent.grid_frame_to_image_rect(options[:grid_frame])
      @x                      = frame_rect[0]
      @y                      = frame_rect[1]
      @width                  = frame_rect[2]
      @height                 = frame_rect[3]
      if options[:extra_height_in_lines] # && options[:extra_height_in_lines] > 0
        @height += options[:extra_height_in_lines]*@parent.body_line_height
        @y -= options[:extra_height_in_lines]*@parent.body_line_height if @image_position =~/^bottom/ 
      end

      has_caption_text?(options)
      if @has_caption
        @caption_column         = CaptionColumn.new(parent:self, width: @width, top_space_in_lines: 0.3, caption_line_height: 12)
        @caption_paragraph      = CaptionParagraph.new(options)
        @caption_paragraph.layout_lines(@caption_column)
      end
      image_options                = {}
      image_options[:width]        = @width
      image_options[:height]       = @height
      image_options[:height]       = @height - @caption_column.height if @caption_column

      unless top_position?
        image_options[:y]          = @parent.body_line_height
        image_options[:height]     -= @parent.body_line_height
      end
      # IMAGE_FIT_TYPE_KEEP_RATIO     = 3
      # IMAGE_FIT_TYPE_IGNORE_RATIO   = 4
      image_options[:stroke_width]   = 0.3
      image_options[:stroke_width]   = 0.0 if @image_kind == 'graphic'
      image_options[:image_fit_type] = 3 #IMAGE_FIT_TYPE_KEEP_RATIO
      image_options[:image_fit_type] = @fit_type if @fit_type
      image_options[:image_path]     = @image_path
      image_options[:layout_expand]  = nil
      image_options[:layout_expand]  = @expand if @expand
      image_options[:parent]         = self
      if @parent.kind == '기고' || @parent.kind == 'opinion'
        image_options[:stroke_width]  = 0
      end
      @image_box                    = Image.new(image_options)
      if @caption_column
        @caption_column.y             = @image_box.height
        @caption_column.y             += @parent.body_line_height unless top_position?
      end
      # make space after the news_image when we have following text
      # for full sized news_image, this will be adjusted by adjust_image_height
      @height                       += @parent.body_line_height
      self
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
      @image_position =~/top/
      # @position == 1 || @position == 2 || @position == 3
    end

    def before_title?
      @before_title
    end

    def adjust_image_height
      @image_box.height  = @height - @caption_column.height if @caption_column
      @image_box.apply_fit_type
      @caption_column.y  = @image_box.height if @caption_column
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

    # convert column, row, and position into x,y,width, and height
    def convert_column_row_position_to_frame(options={})
      default_image_options   = IMAGE_SIZE_POSITION_TABLE["#{@article_column}x#{@article_row}"]
      default_image_options   = IMAGE_COLUMN_POSITION_TABLE[@article_column.to_s] unless default_image_options
      image_size              = options.fetch(:size, default_image_options[:size])
      @image_position         = "top_right"
      if options[:position]
        position_number = options[:position].to_i
        # fix invalid numbers
        if position_number > 9
          position_number = 9 
        elsif position_number < 0
          position_number = 1
        end
        @image_position = NUMBER_TO_POSITION[position_number.to_s]
      end
      #TODO this is only for upper right, do it for other positions as well
      if options[:column] && options[:row]
        image_size[0] = options[:column]
        image_size[1] = options[:row]
      end
      position_array = @image_position.split("_")
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
