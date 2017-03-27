# NewsImage
# there are couple of ways to specify size aize ans location
# surest way is to use grid_frame, but grid_frames are hard to generalize,
# so we use size, and position to translate those values to grid_fgram at run time

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

  '4x4'=> {size: [3,3], position: 'top_right'},
  '4x5'=> {size: [3,3], position: 'top_right'},
  '4x6'=> {size: [3,3], position: 'top_right'},
  '4x7'=> {size: [3,3], position: 'top_right'},
  '4x3'=> {size: [3,3], position: 'top_right'},

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
  class NewsImage < Image
    attr_reader :article_column, :article_row, :image_size, :image_position, :caption_title
    attr_reader :caption_title_text, :caption_object, :caption
    def initialize(options={})
      super
      @article_column  = options.fetch(article_column,3)
      @article_row     = options.fetch(article_row,3)
      size_string = "#{@article_column}x#{@article_row}"
      default_image_options = IMAGE_SIZE_POSITION_TABLE[size_string]
      default_image_options = IMAGE_COLUMN_POSITION_TABLE[@article_column.to_s] unless default_image_options
      @image_size     = options.fetch(:size, default_image_options[:size])
      @image_position = options.fetch(:position, default_image_options[:position])
      @caption_title  = options[:caption_title]
      @caption        = options[:caption]
      convert_size_position_to_frame
      if @caption_title
        make_caption_title
      end
      if @caption
        make_caption
      end
      self
    end

    # convert size, position into x,y,width, and height
    def convert_size_position_to_frame
      #code
    end

    def make_caption_title
      caption_title                 = '사진제목'
      atts                          = NEWSPAPER_STYLE[caption_title]
      atts[:text_string]            = @caption_title
      if @parent_graphic
        atts[:body_line_height]     = @parent_graphic.body_line_height
      else
        atts[:body_line_height]     = 12
      end
      atts[:width]                  = @width
      atts[:text_fit_type]          = 'adjust_box_height'
      atts[:layout_expand]          = [:width]
      atts[:layout_length_in_lines] = true
      @caption_title_text           = Text.new(atts)
    end

    def make_caption
      caption                       = '사진설명'
      atts                          = NEWSPAPER_STYLE[caption]
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
