module RLayout
  # caption_paragraph creates caption_title, cation, and source tokens
  # them it is layed out into the CaptionColumn
  # CaptionColumn grows upward from bottom with caption_paragraph content
  class CaptionColumn < Container
    attr_accessor :bottom_space_in_lines, :body_line_height, :current_line
    attr_reader :top_space_in_lines, :bottom_space_in_lines, :caption_line_height

    def initialize(options={})
      @top_space_in_lines             = options[:top_space_in_lines] || 0.0
      @bottom_space_in_lines          = options[:bottom_space_in_lines] || 1
      @caption_line_height            = options[:caption_line_height] || 9
      @body_line_height               = options[:body_line_height] || 14
      super
      @height                         = 0
      @line_count                     = 0
      @space_width                    = 3 #TODO
      add_new_line
      self
    end

    def add_new_line(options={})
      @space_width = options[:space_width] if options[:space_width]
      current_x     = 0
      if @line_count == 0
        current_y   = @top_space_in_lines*@caption_line_height
      else
        current_y   = @current_line.y_max
      end
      options       = {parent:self, x: current_x, y: current_y , width: @width - 1, height: @caption_line_height, space_width: @space_width}
      @current_line = RLineFragment.new(options)        # @graphics << line
      @line_count   += 1
      @height       = @current_line.y_max
      @current_line
    end

  end
end
