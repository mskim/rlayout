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

module RLayout
  class NewsImage < Container
    attr_accessor :article_column, :column, :article_row, :row, :image_size, :image_position, :caption_title
    attr_accessor :image_box_object, :caption_title_object, :caption_object
    attr_accessor :caption_string, :caption_title_string
    attr_accessor :caption_height_sum
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
      options[:grid_frame]    = convert_size_position_to_frame(options)
      options[:layout_expand] = nil
      options[:fill_color]    = 'clear'

      super
      frame_rect              = @parent_graphic.grid_frame_to_image_rect(options[:grid_frame]) if @parent_graphic
      #TODO use set_frame_rect?
      @x                      = frame_rect[0]
      @y                      = frame_rect[1]
      @width                  = frame_rect[2]
      @height                 = frame_rect[3]
      @caption_title_string   = options[:caption_title]
      @caption_string         = options[:caption]
      @caption_height_sum     = 0
      if @caption_title_string
        make_caption_title
      end
      if @caption_string
        make_caption
      end
      image_optins                = {}
      image_optins[:width]        = @width
      image_optins[:height]       = @height - @caption_height_sum
      image_optins[:stroke_width] = 0.3
      image_optins[:image_fit_type] = IMAGE_FIT_TYPE_KEEP_RATIO
      image_optins[:image_path]   = @image_path
      # image_optins[:layout_expand] = [:width, :height]
      image_optins[:layout_expand] = nil
      image_optins[:parent]       = self
      @image_box_object           = Image.new(image_optins)
      # @image_box_object.apply_fit_type
      current_y                   = @image_box_object.y_max
      if @caption_title_object
        @caption_title_object.y   = current_y
        current_y                 += @caption_title_object.height
      end
      @caption_object.y           = current_y     if @caption_object

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

    def adjust_image_height
      @image_box_object.height = @height - @caption_height_sum
      @image_box_object.apply_fit_type
      @caption_object.y       = @height - @caption_object.height
      @caption_title_object.y = @caption_object.y - @caption_title_object.height
    end

    # convert size, position into x,y,width, and height
    def convert_size_position_to_frame(options={})
      size_string             = "#{@article_column}x#{@article_row}"
      default_image_options   = IMAGE_SIZE_POSITION_TABLE[size_string]
      default_image_options   = IMAGE_COLUMN_POSITION_TABLE[@article_column.to_s] unless default_image_options
      image_size              = options.fetch(:size, default_image_options[:size])
      image_position          = options.fetch(:position, default_image_options[:position])
      x_grid = @article_column - image_size[0]
      y_grid = 0 #@article_row - image_size[1]
      [x_grid, y_grid, image_size[0], image_size[1]]
    end




  end

end
