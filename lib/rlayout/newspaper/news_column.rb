module RLayout

  # NewsColumn
  # NewsColumn is covered with series of "LineFragments".
  # Unlike TextColunm, "LineFragments" are used to determine the shapes of text layout area, to avoid text from overlapping floats.
  # Complex_rect means column has overlapping graphic.
  # We need non-rectanglar shaped bezier path to flow text.
  # But rather than using bezeier curve, I simulate it using "LineFragments".
  # I am using seris of LineFragments class rects to determin the shape of text flowing region.
  # Finer the GridRect, closer it gets to bezier curve. I am using half body_text_height sized rect.
  # Half of body text height should be suffient for text layout.
  # If align_body_text is set to "true", body text are aligned by starting the body paragraph at odd numbered grid.
  # If all body text starts at even numbered grids, this will horozontally alignment body text across the columns.

  # body_line_height
  # line_height = body_style[:font_size] # default line_height, set to font_size*1.3
  # @body_line_height = (line_height + body_style[:text_line_spacing])


  class NewsColumn < Container
    attr_accessor :current_position, :current_grid_index
    attr_accessor :line_count, :current_line_index, :current_line
    attr_accessor :grid_rects, :body_line_height
    attr_accessor :complex_rect, :align_body_text, :show_grid_rects
    attr_accessor :article_bottom_space_in_lines
    def initialize(options={}, &block)
      options[:width]     = 200 unless options[:width]
      options[:height]    = 500 unless options[:height]
      # options[:stroke_width] = 1.0
      # options[:stroke_width] = 1
      super
      @article_bottom_space_in_lines  = options[:article_bottom_space_in_lines] || 2
      @line_count         = options[:column_line_count] - @article_bottom_space_in_lines
      @show_grid_rects    = options[:show_grid_rects] || true
      @layout_space       = options.fetch(:column_layout_space, 0)
      @complex_rect       = false
      @body_line_height   = options[:body_line_height]
      @height             -= @body_line_height*@article_bottom_space_in_lines
      @current_position   = @top_margin + @top_inset
      create_lines
      if block
        instance_eval(&block)
      end
      self
    end

    def create_lines(options={})
      current_x = 0
      current_y = 0
      @line_count.times do
        options = {parent:self, x: current_x, y: current_y , width: @width, height: @body_line_height}
        line = NewsLineFragment.new(options)        # @graphics << line
        current_y += @body_line_height
      end
      @current_line_index = 0
      @current_line       = @graphics[@current_line_index]
    end

    def adjust_overlapping_lines(overlapping_floats)
      floats = overlapping_floats.dup
      floats.each do |float|
        float_rect = float.frame_rect
        @graphics.each do |line|
          line.adjust_text_area_away_from(float_rect)
        end
      end
    end

    def char_count
      lines_char_count = 0
      @graphics.each do |line|
        lines_char_count += line.char_count
      end
      lines_char_count
    end

    def available_lines_count
      available_lines = 0
      @graphics.each do |line|
        available_lines +=1 if line.text_line?
      end
      available_lines
    end

    def empty_lines
      @line_count - @current_line_index
    end

    def average_characters_per_line
      line_count = available_lines_count
      if line_count == 0
        return 1
      end
      char_count/line_count
    end

    def get_line_with_text_room
      return nil unless @current_line
      if @current_line.has_text_room?
        return @current_line
      end
        #code
      while go_to_next_line
        if @current_line.has_text_room?
          return @current_line
        end
      end
      #code
    end


    # get text for each line lines
    def column_line_string
      line_text = @graphics.map{|l| l.line_string}
      line_text.join("\n")
    end

    # move the current_line to the next line
    def go_to_next_line
      return false       if @current_line_index >= @line_count
      @current_line_index += 1
      @current_line = @graphics[@current_line_index]
      @current_line
    end

    def has_room?
      @current_line_index <= @line_count
    end

    def is_last_line?
      @current_line_index == @line_count
    end

    def move_current_position_by(y_amount)
      @current_position += y_amount
    end

    # update current_grid_index after paragraph is placed
    def advance_current_grid_index_with_y_position(y_amount)
      unless @grid_rects
        create_grid_rects
      end
      grid_avance_count = y_amount/@grid_rects.first.rect[3]
      int_amount = grid_avance_count.to_i
      if (grid_avance_count - int_amount) < 0.1
        @current_grid_index += int_amount
      else
        @current_grid_index += int_amount + 1
      end
    end

    # create grid_rects after relayou!
    # make sure the grids are created after adjusting the column size for the final layout
    def create_grid_rects(options={})
      if options[:show_grid_rects] == false
        @show_grid_rects == false
      end
      @grid_rects = []
      column_rect = text_rect
      x     = column_rect[0] # text_box cordinate
      y     = column_rect[1] # text_box cordinate
      width = column_rect[2]
      height = @body_line_height/2
      grid_height_sum = 0
      while (y + height) < column_rect[3]
        @grid_rects << GridRect.new([x,y,width, height])
        y += height
        grid_height_sum += height
      end
    end

    def overlapping_rects
      overlapping_rects = []
      @grid_rects.each do |rect|
        overlapping_rects << rect if rect.overlap
      end
      overlapping_rects
    end

    def fully_covered_rects
      overlapping_rects = []
      @grid_rects.each do |rect|
        overlapping_rects << rect if rect.fully_covered
      end
      overlapping_rects
    end

    def room
      max_y(text_rect) - @current_position
    end

    def room_in_grid
      @grid_rects.length - @current_grid_index
    end

    def can_fit?(height)
      return false if @room < 16
      height <= @room
    end

    # find the grid_rect that conatines the y position
    # options[:align_to_body_text] for body text
    def grid_rect_at_position(position, options={})
      unless @grid_rects
        create_grid_rects
      end
      @grid_rects.each_with_index do |grid_rect, i|
        if position >= min_y(grid_rect.rect) && position <= max_y(grid_rect.rect)
          if options[:align_to_body_text]
            # align to even grid for body text alignment
            if i.even?
              return grid_rect.rect
            elsif @grid_rects.length > i
              even_rect = @grid_rects[i+1]
              return even_rect.rect
            end
          end
          return grid_rect.rect
        end
      end
      @grid_rects.last.rect
    end

    def text_width
      text_rect[2]
    end


    # snap to grid_rect if the position is very near top snap to top
    # otherwise return bottom position of grid_rect
    def snap_to_grid_rect(position)
      return position unless @grid_rects
      if position < @grid_rects.first.rect[1]
        return @grid_rects.first.rect.y
      end
      @grid_rects.each_with_index do |grid_rect, i|
        if position >= min_y(grid_rect.rect) && position <= (max_y(grid_rect.rect) + 0.1) #make sure for flaot rounding
          # grid_rect height is half of body text rect
          # we always wont to snap to even numbered lines
          if i.odd?
            return max_y(@grid_rects[i+1].rect) unless i >= (@grid_rects.length - 1)
          else
            return max_y(@grid_rects[i].rect)
          end
        end
      end
      max_y(@grid_rects.last.rect)
    end

  end


  # GridRect has two rectangle, rect and text_area
  # rect represents the position of grid_rect in TexBox cordinate.
  # rect is used to determine the overlappings with floats, which are in TexBox cordinate.
  # and text_area represents non overlapping area for text layout in NewsColumn cordinate(local cordinate)
  # We have a case where the grid_rect is fully_covered covered by the float.
  # We also have a case where the grid_rect is partially covered on the left or right side
  # We also have a case where it is coverd in the middle, with room at each sides
  # for this case, I am taking the larger area, and ignoreing the smaller area. it is TODO.
  class GridRect
    attr_accessor :rect, :text_area, :overlap, :fully_covered
    def initialize(rect)
      @rect = rect
      @text_area = @rect.dup
      @text_area[0] = 0 # make it a local cordinate
      @overlap = false
      @fully_covered = false
      self
    end

    def draw_grid_rect
      grid_rect = NSMakeRect(@text_area[0], @text_area[1], @text_area[2], @text_area[3])
      path = NSBezierPath.bezierPathWithRect(grid_rect)
      path.setLineWidth(1)
      path.stroke
    end

    #TODO refoctor this ############
    def min_x(rect)
      rect[0]
    end

    def min_y(rect)
      rect[1]
    end

    def mid_x(rect)
      rect[0] + rect[2]/2
    end

    def mid_y(rect)
      rect[1] + rect[3]/2
    end

    def max_x(rect)
      rect[0] + rect[2]
    end

    def max_y(rect)
      rect[1] + rect[3]
    end

    def contains_rect(rect_1,rect_2)
      (rect_1[0]<=rect_2[0] && max_x(rect_1) >= max_x(rect_2)) && (rect_1[1]<=rect_2[1] && max_y(rect_1) >= max_y(rect_2))
    end

    def intersects_x(rect1, rect2)
      (max_x(rect1) > rect2[0] && max_x(rect2) > rect1[0]) || (max_x(rect2) > rect1[0] && max_x(rect1) > rect2[0])
    end

    def intersects_y(rect1, rect2)
      (max_y(rect1) > rect2[1] && max_y(rect2) > rect1[1]) || (max_y(rect2) > rect1[1] && max_y(rect1) > rect2[1])
    end

    def intersects_rect(rect_1, rect_2)
      intersects_x(rect_1, rect_2) && intersects_y(rect_1, rect_2)
    end
    ############

    def set_fully_covered_grid
      @fully_covered = true
      @text_area = @rect.dup
      @text_area[0] = 0
      # for fully covered text_area, set width as very thin, for path construction porpose.
      # I want continuos path for entire column.
      # by making fully covered text_area as very thin rect, I can similate the empty line effect,
      # yet have the entire column as continus text region.
      @text_area[2] = 3
    end

    # when grid_rect overlaps with given float,
    # update available text area.
    def update_text_area(floating_rect)
      return unless intersects_rect(floating_rect, @rect)
      return if @fully_covered == true

      if contains_rect(floating_rect, @rect)
        set_fully_covered_grid
        @overlap = true
      elsif max_x(floating_rect) < max_x(@rect)
        # puts "left side is covered"
        @text_area = @rect.dup
        # float is on the left side
        overlap_width = max_x(floating_rect) - min_x(@rect)
        @text_area[0] = overlap_width
        @text_area[2] -= overlap_width
        set_fully_covered_grid if @text_area[2] < 5  # if the layout area is too small, treat is as fully covered
        @overlap = true
      elsif min_x(floating_rect) > min_x(@rect)
        # float is on the right side
        @text_area = @rect.dup
        @text_area[0] = 0 # @text_area is in local cordinate
        @text_area[2] = min_x(floating_rect) - min_x(@rect)
        set_fully_covered_grid if @text_area[2] < 5 # if the uncovered area is too small, treat is as fully covered
        @overlap = true
      else
        @text_area = @rect.dup
        @text_area[0] = 0 # @text_area uses local cordinate
        # overlap is in the middle of the line
        # take one side only, the larger side, not both
        left_side_room = min_x(floating_rect) - min_x(@rect)
        right_side_room = min_x(@rect) - max_x(floating_rect)
        if left_side_room >= right_side_room
          @text_area[2] = left_side_room
        else
          @text_area[0] = max_x(floating_rect) - min_x(@rect)
          @text_area[2] = right_side_room
        end
        @overlap = true
        set_fully_covered_grid if left_side_room < 50 && right_side_room < 50
      end
    end

    #TODO
    def fully_covered?
      @fully_covered == true
    end

    def overlap?
      @overlap == true
    end

  end

end
