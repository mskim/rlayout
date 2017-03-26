
# NewsArticleBox
# grid_frame is passed to detemine the width, height, and column_number of text_box
# Used when creating newspaper article, called from NewsArticleMaker

# show_overflow_lines
#
# 1. create NewsArticleBox
# 1. generate columns
#   1. create_lines
# 1. generate floats and layout floats
#   1. mark lines that over lapping floats
# 4.5*28.34646 = 12.755907
# 15*28.34646 = 425.1969

GridLineCount = 6

module RLayout

  class NewsArticleBox < Container
    attr_accessor :top_story, :heading_columns, :grid_size, :grid_frame, :body_line_height
    attr_accessor :story_path, :show_overflow_lines, :overflow_column
    attr_accessor :column_count, :row_count, :column_layout_space, :line_count_per_column
    attr_accessor :draw_gutter_stroke, :gutter, :v_gutter
    attr_accessor :heading, :subtitle_box, :quote_box, :personal_image, :image
    attr_accessor :before_lines, :after_lines
    attr_accessor :current_column, :current_column_index

    def initialize(options={}, &block)
      options[:left_margin]   = 5 unless options[:left_margin]
      options[:top_margin]    = 0 unless options[:top_margin]
      options[:right_margin]  = 5 unless options[:right_margin]
      options[:bottom_margin] = 0 unless options[:bottom_margin]
      super
      @column_count           = options[:column]
      @row_count              = options[:row]
      @current_column_index   = 0
      @top_story              = options.fetch(:top_story, false)

      if options[:grid_frame]
        @grid_frame = options[:grid_frame]
        if @grid_frame.class == String
          @grid_frame = eval(@grid_frame)
        end
      else
        @grid_frame  = [0,0,@column_count, @row_count]
      end
      if options[:heding_columns]
        @heading_columns = options[:heding_columns]
      else
        @heading_columns = @column_count
      end

      @grid_width           = options.fetch(:grid_width, 200)
      @grid_height          = options.fetch(:grid_height, 200)
      @gutter               = options.fetch(:gutter, 10)
      @v_gutter             = 0 #options.fetch(:v_gutter, 0)
      @grid_size            = [@grid_width , @grid_height]
      @layout_direction     = options.fetch(:layout_direction, "horizontal")
      @layout_space         = options.fetch(:layout_space, @gutter)
      @column_layout_space  = options.fetch(:column_layout_space, 0)
      @floats               = options.fetch(:floats, [])
      @width                = @column_count*@grid_width + @column_count*@gutter # we have @gutter/2 on each side
      @height               = @row_count*@grid_height + (@row_count- 1)*@v_gutter
      @body_line_height     = @grid_height/GridLineCount
      @column_line_count    = @row_count*GridLineCount

      create_columns
      if block
        instance_eval(&block)
      end
      if @floats.length > 0
        layout_floats!
      end
      self
    end

    # create news_columns
    #  news_columns are different from text_column
    def create_columns
      current_x = @gutter/2
      @column_count.times do
        g= NewsColumn.new(:parent=>nil, x: current_x, y: 0, width: @grid_width, height: @height, column_line_count: @column_line_count, body_line_height: @body_line_height)
        g.parent_graphic = self
        @graphics << g
        current_x += @grid_width + @gutter
      end
    end

    def is_top_story?
      @top_story
    end

    # # create lines that are adjusted for overflapping floats
    # # This is called after floats are layoued out.
    # def create_column_lines
    def overlapping_floats_with_column(column)
      overlapping_floats = []# IDEA: ndi
      @floats.each do |float|
        overlapping_floats << float if intersects_rect(column.frame_rect, float.frame_rect)
      end
      overlapping_floats
    end

    # adjust overlapping line_fragment text area
    # this method is called when float positions have changed
    def adjust_overlapping_columns
      @graphics.each_with_index do |column, i|
        overlapping_floats = overlapping_floats_with_column(column)
        column.adjust_overlapping_lines(overlapping_floats)
      end
    end


    def overflow_box
      # take the last columns last paragraphs
      last_para = @graphics.last.graphics.last
      if last_para && @graphics.last.graphics.last.overflow?
        return last_para.split_overflowing_lines
      end
      nil
    end

    # get next line from curretn line

    def reduce_lines(overflow_count)
      paragraphs = []
      @graphics.each do |column|
        paragraphs += column.graphics
      end
      reduced_line = 0
      paragraphs.reverse.each do |para|
        exit if reduced_line == overflow_count
        goal = overflow_count - reduced_line
        result = para.try_reducing_line_numbers_by_changing_space_width(goal)
      end
    end

    def next_text_line
      @current_column = @graphics[@current_column_index]
      return nil unless @current_column
      if line = @current_column.get_line_with_text_room
        return line
      else
        @current_column_index +=1
        return nil if @current_column_index >= @graphics.length
        @current_column = @graphics[@current_column_index]
        if line = @current_column.get_line_with_text_room
          return line
        end
      end
      nil
    end

    def current_location
      [@current_column_index, @current_column.current_line_index]
    end

    def layout_items(flowing_items)
      @column_index       = 0
      @current_column     = @graphics[@column_index]
      overflow = false
      while @item = flowing_items.shift do

        break if overflow = @item.layout_lines(self)

        # while left_over   = @item.layout_lines(current_column)
        #   column_index    += 1
        #   break if column_index >= column_count
        #   current_column  = @graphics[column_index]
	      #   left_over       = @item.layout_lines(current_column)
        # end
      end
      if overflow
        #TODO
        # puts "oveflow"
      end
    end

    # make heading as float
    def heading(options={})
      h_options = options.dup
      h_options[:is_float]  = true
      h_options[:is_float]  = true
      h_options[:parent]    = self
      h_options[:width]     = @width - @gutter
      h_options[:column_count] = @column_count
      h_options[:x]         = @gutter/2
      h_options[:top_story] = @top_story
      if @heading_columns != @column_count
        h_options[:width] = width_of_columns(@heading_columns)
      end
      @heading = NewsArticleHeading.new(h_options)
      unless @heading== @floats.first
        # make heading as first one in floats
        #
        @heading = @floats.pop
        @floats.unshift(@heading)
      end
    end

    # does current text_box include Heading in floats
    def has_heading?
      @floats.each do |float|
        return true if float.class == RLayout::Heading
      end
      false
    end

    def get_heading
      @floats.each do |float|
        return float if float.class == RLayout::NewsArticleHeading
      end
      nil
    end

    def get_image
      @floats.each do |float|
        return float if float.class == RLayout::Image
      end
      nil
    end

    def has_leading_box?
      @floats.each do |float|
        return true if float.tag == "leading"
      end
      false
    end

    def has_quote_box?
      @floats.each do |float|
        return true if float.tag == "quote"
      end
      false
    end

    # sum of width columns width including gaps
    def width_of_columns(columns)
      return 0 if columns==0
      if columns <= @graphics.length
        return @graphics[columns - 1].x_max - @graphics.first.x
      end
      @graphics.last.x_max - @graphics.first.x
    end

    def make_floats(heading_hash)
      # don't create another subtitle, if it is top_story, It is created by heading
      if !@top_story && heading_hash['subtitle'] && heading_hash['subtitle'] != ""
        float_subtitle(heading_hash['subtitle'])
      end

      if heading_hash['personal_image']

      end

      if heading_hash['quote']
        hash = {}

        float_quote(hash)
      end

      if heading_hash['image']

      end
      layout_floats!
    end

    # text_height_in_lines should be calculated dynamically
    def float_subtitle(subtitle_string)
      subtitle_13     = '부제13'
      subtitle_15     = '부제15'
      options = NEWSPAPER_STYLE[subtitle_13]
      if @column_count > 3
        options = NEWSPAPER_STYLE[subtitle_15]
      end
      options[:text_string]   = subtitle_string
      options[:text_fit_type] = 'adjust_box_height'
      # options[:body_line_height] = @body_line_height
      options[:x]             = 5
      options[:y]             = 0
      options[:grid_frame]    = [0,0,1,1]
      options[:width]         = @grid_width
      options[:layout_expand] = nil
      options[:is_float]      = true
      options[:parent]        = self
      # options[:stroke_width]  = 1
      #TODO put top_margin and bottom_margin
      subtitle = Text.new(options)
    end

    def float_quote(options={})
      options = {}
      frame_rect = grid_frame_to_image_rect(options[:grid_frame]) if options[:grid_frame]
      options[:x]       = frame_rect[0]
      options[:y]       = frame_rect[1]
      options[:width]   = frame_rect[2]
      options[:height]  = frame_rect[3]
      options[:layout_expand]   = nil
      options[:is_float]        = true
      options[:parent]          = self
      Text.new(options)
    end

    def float_personal_image(options={})
      options = options.dup
      frame_rect = grid_frame_to_image_rect(options[:grid_frame]) if options[:grid_frame]
      options[:x]       = frame_rect[0]
      options[:y]       = frame_rect[1]
      options[:width]   = frame_rect[2]
      options[:height]  = frame_rect[3]
      options[:layout_expand]   = nil
      options[:is_float]        = true
      options[:parent]          = self
      Quote.new(options)
    end

    # place imaegs that are in the head of the story as floats
    def float_image(options={})
      options = {}
      options[:image_path] = "#{options[:image_path]}" if options[:image_path]
      options[:image_path] = "#{$ProjectPath}/images/#{options[:local_image]}" if options[:local_image]
      frame_rect              = grid_frame_to_image_rect([0,0,1,1])
      frame_rect              = grid_frame_to_image_rect(options[:grid_frame]) if options[:grid_frame]
      options[:x]       = frame_rect[0]
      options[:y]       = frame_rect[1]
      options[:width]   = frame_rect[2]
      options[:height]  = frame_rect[3]
      options[:layout_expand]   = nil
      options[:is_float]= true
      options[:parent]  = self
      @image                  = Image.new(options)
    end

    def float_images(images)
      if images.class == Array
        images.each do |image_info|
          float_image(image_info)
        end
      elsif images.class == Hash
        float_image(images)
      end
    end

    def grid_frame_to_image_rect(grid_frame)
      return [0,0,100,100]    unless @graphics
      return [0,0,100,100]    if grid_frame.nil?
      return [0,0,100,100]    if grid_frame == ""
      return [0,0,100,100]    if grid_frame == []
      grid_frame          = eval(grid_frame) if grid_frame.class == String
      column_frame        = @graphics.first.frame_rect
      # when grid_frame[0] is greater than columns
      frame_x             = column_frame[0]
      if grid_frame[0] >= @graphics.length
        frame_x           = @graphics.last.x_max
      else
        # frame_x           = @grid_size[0]*grid_frame[0]
        frame_x           = @grid_size[0]*grid_frame[0] + (grid_frame[0])*@gutter + @gutter/2
      end
      frame_y             = @grid_size[1]*grid_frame[1]
      frame_width         = @grid_size[0]*column_count + (column_count - 1)*@layout_space
      frame_height        = @grid_size[1]*grid_frame[3] + (grid_frame[3] - 1)*@column_layout_space
      [frame_x, frame_y, frame_width, frame_height]
    end

    # layout_floats!
    # Floats are Heading, Image, Quotes, SideBox ...
    # Floats should have frame_rect, float_position, and flaot_bleeding.
    # Height value is in grid_rect units, but this could vary with content.
    # Default frame_rect for float is [0,0,1,1], grid_rect in cordinates
    # For Images, default height is natural height proportional to image width/height ratio.
    # For Text, default height is natural height proportional to thw content of text, unless specified otherwise.

    # Floats are grouped in three categories
    # 1. top to bottom:         default image layout
    # 2. middle moving across:  used for leading, Quotes, and Image
    # 3. bottom to up:          sidebox, bleeding image
    # Floats are layed out in order of @floats array from top to bottom.
    # If starting location is occupies, following float is placed below the position of pre-occupied one.
    # Floats can also move up from the bottom, it moves up with top down.
    # Floats string at the bottom of the TextBox, should pass float_bottom:true
    # If float_bleed:true, it bleeds at the location, top, bottom and side
    # TODO centered floats
    # For Leading, Quotes or Image, should implement cented float
    # It is common for Centered floats to have width slightly larger than column width on each side.
    # float_paistion: "center"
    def layout_floats!
      return unless @floats
      # reset heading width
      @occupied_rects =[]
      if has_heading? && (@heading_columns != @column_count)
        heading = get_heading
        heading.width = width_of_columns(@heading_columns)
        heading.x     = @gutter/2
      end
      #TODO position bottom bottom_occupied_rects
      # middle occupied rect shoul
      @middle_occupied_rects = []
      @bottom_occupied_rects = []
      @floats.each_with_index do |float, i|
        # next unless float.kind_of?(Image) || float.kind_of?(Heading)
        @float_rect = float.frame_rect
        if i==0
          @occupied_rects << float.frame_rect
        elsif intersects_with_occupied_rects?(@occupied_rects, @float_rect)
              # move to some place
              move_float_to_unoccupied_area(@occupied_rects, float)
              @occupied_rects << float.frame_rect
        else
          @occupied_rects << @float_rect
        end
      end
      @floats.each do |float|
        return "floats oveflow!!" if contains_rect(frame_rect, float.frame_rect)
      end
      true
    end

    def intersects_with_occupied_rects?(occupied_arry, new_rect)
      occupied_arry.each do |occupied_rect|
        return true if intersects_rect(occupied_rect, new_rect)
      end
      false
    end

    # if float is overlapping, move float to unoccupied area
    # by moving float to the bottom of the overlapping float.
    def move_float_to_unoccupied_area(occupied_arry, float)
      occupied_arry.each do |occupied_rect|
        if intersects_rect(occupied_rect, float.frame_rect)
          float.y = max_y(occupied_rect) + 0
        end
      end
    end

    def non_overlapping_area(column_rect, float_rect, min_gap =10)
      if contains_rect(float_rect, column_rect)
        #  "float_rect covers the entire column_rect"
        return [0,0,0,0]
      elsif min_y(float_rect) <= min_y(column_rect) && max_y(float_rect) >= max_y(column_rect)
        #  "hole or block in the middle"
        rects_array = []
        upper_rect = column_rect.dup
        upper_rect.size.height = min_y(float_rect)
        # return only if rect height is larger than minimun
        rects_array << upper_rect if  upper_rect.size.height > min_gap
        lower_rect = column_rect.dup
        lower_rect.origin.y = max_y(float_rect)
        lower_rect.size.height -= max_y(float_rect)
        # return only if rect height is larger than minimun
        rects_array << lower_rect if  lower_rect.size.height > min_gap
        # return [0,0,0,0] if none of them are big enough
        return [0,0,0,0] if rects_array.length == 0
        # return single rect rather than the Array, if one of them is big enough
        return rects_array[0] if rects_array.length == 1
        # return both rects in array, if both are big enough
        return rects_array
      elsif min_y(float_rect) <= min_y(column_rect)
        #  "overlapping at the top "
        new_rect = column_rect.dup
        new_rect[1] = max_y(float_rect)
        new_rect[HEIGHT_VAL] -= float_rect[HEIGHT_VAL]
        return new_rect
      elsif max_y(float_rect) >= max_y(column_rect)
        #  "overlapping at the bottom "
        new_rect = column_rect.dup
        new_rect[HEIGHT_VAL] = min_y(float_rect)
        return new_rect
      end
    end

  end
end
