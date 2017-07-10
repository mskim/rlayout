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
    attr_accessor :image_object
    attr_accessor :caption_string, :caption_title_string, :caption_title_text, :caption_object
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
      options[:fill_color]    = 'red'
      options[:grid_frame]    = convert_size_position_to_frame(options)
      options[:layout_expand] = nil
      super
      frame_rect              = @parent_graphic.grid_frame_to_image_rect(options[:grid_frame]) if @parent_graphic
      #TODO use set_frame_rect?
      @x                      = frame_rect[0]
      @y                      = frame_rect[1]
      @width                  = frame_rect[2]
      @height                 = frame_rect[3]
      image_optins            = {}
      image_optins[:width]    = @width
      image_optins[:height]   = @height
      image_optins[:height]   = @height
      image_optins[:stroke_width] = 1
      image_optins[:image_fit_type] = IMAGE_FIT_TYPE_KEEP_RATIO
      image_optins[:image_path] = @image_path
      image_optins[:parent]   = self
      @image_object           = Image.new(image_optins)
      @caption_title_string   = options[:caption_title]
      @caption_string         = options[:caption]
      if @caption_title_string
        #TODO
        # make_caption_title
      end
      if @caption_string
        #TODO
        # make_caption
      end
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
      @image_object.height = @height
      @image_object.apply_fit_type
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

    def make_caption_title
      caption_title                 = '사진제목'
      atts                          = NEWSPAPER_STYLE['caption_title']
      atts                          = Hash[atts.map{ |k, v| [k.to_sym, v] }]

      atts[:text_string]            = @caption_title_string
      if @parent_graphic
        atts[:body_line_height]     = @parent_graphic.body_line_height
      else
        atts[:body_line_height]     = 12
      end
      atts[:width]                  = @width
      atts[:text_fit_type]          = 'adjust_box_height'
      atts[:layout_expand]          = [:width]
      atts[:layout_length_in_lines] = true
      atts[:parent]                 = self
      @caption_title_text           = Text.new(atts)
    end

    def make_caption
      caption                       = '사진설명'
      atts                          = NEWSPAPER_STYLE['caption']
      atts                          = Hash[atts.map{ |k, v| [k.to_sym, v] }]

      atts[:text_string]            = @caption
      if @parent_graphic
        atts[:body_line_height]     = @parent_graphic.body_line_height
      else
        atts[:body_line_height]     = 12
      end
      atts[:width]                  = @width
      atts[:text_fit_type]          = 'adjust_box_height'
      atts[:layout_expand]          = [:width]
      atts[:parent]                 = self
      atts[:layout_length_in_lines] = true
      @caption_object               = Text.new(atts)
      if @caption_title_text
        #TODO merge title with caption
      end
      @caption_object
    end

    def change_position(new_position)
      #code
    end

    def change_size(new_size)
      #code
    end

    def change_grid_frame(new_grid_frame)
      #code
    end

  end

end
