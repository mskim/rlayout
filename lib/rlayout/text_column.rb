module RLayout

  # TextColumn
  # TextColumn is covered with series of "grid_rects".
  # "grid_rects" are used to determine the shapes of text layout area, to avoid overlapping floats.
  # Complex_rect means column has overlapping graphic and it has non-rectanle shaped region.
  # We need non-rectanglar shaped bezier path to flow text.
  # But rather than using bezeier curve, I simulate it using "grid_rects".
  # I am using seris of GridRect class rects to determin the shape of text flowing region.
  # Finer the GridRect, closer it gets to bezier curve. I am using half body_text_height sized rect.
  # Half of body text size should be suffient for text layout.
  # If align_body_text is set to "true", body text are aligned by starting the body paragraph at odd numbered grid.
  # If all body text to even numbered grids, this will horozontally alignment body text across the columns.
  class TextColumn < Container
    attr_accessor :current_position, :current_index
    attr_accessor :grid_rects, :body_line_height
    attr_accessor :complex_rect, :align_body_text, :show_grid_rects

    def initialize(parent_graphic, options={}, &block)
      super
      @klass = "TextColumn"
      @show_grid_rects = options[:show_grid_rects] || true
      @layout_space = 0
      @complex_rect = false
      # @line_width   = 2
      # @line_color   = 'black'
      # @body_line_height = StyleService.shared_style_service.current_style['p'][:text_size]
      body_style = StyleService.shared_style_service.current_style['p']
      line_height = body_style[:text_size]*1.3 # default line_height, set to text_size*1.3
      line_height = body_style[:line_height] if body_style[:line_height]
      @body_line_height = (line_height + body_style[:text_line_spacing])
      @current_position = @top_margin + @top_inset
      @room = text_rect[3] - @current_position
      if block
        instance_eval(&block)
      end
      self
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
              return max_y(grid_rect.rect)
            elsif @grid_rects.length > i
              even_rect = @grid_rects[i+1]
              return max_y(even_rect.rect)
            end
          end
          return max_y(grid_rect.rect)
        end
      end
      max_y(@grid_rects.last.rect)
    end

    def text_width
      text_rect[2]
    end

    def mark_overlapping_grid_rects(float_rect, float_klass)
      @complex_rect = true
      @grid_rects.each do |grid_rect|
        grid_rect.update_text_area(float_rect)
      end
    end

    # non_overlapping_rect is a actual layout frame that is not overlapping with flaots
    def non_overlapping_frame
      if @non_overlapping_rect
        return @non_overlapping_rect
      end
      bounds_rect
    end

    #TODO it should not start at the half height starting position using options[:align_to_body_text}
    def current_grid_rect_index_at_position(options={})
      return 0 unless @grid_rects
      @current_position = @top_margin + @top_inset unless @current_position #@top_margin + @top_inset
      @grid_rects.each_with_index do |grid_rect, i|
        if @current_position >= min_y(grid_rect.rect) && @current_position <= (max_y(grid_rect.rect) + 1) #make sure for flaot rounding
          # return grid_rect
          return i
        end
      end
      @grid_rects.length # index is beyond the array range
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

    def place_item(item)
      @graphics << item
      item.parent_graphic = self
      item.x              = @left_margin + @left_inset
      item.y              = @current_position
      @current_position   += item.height + @layout_space
      @current_position   = snap_to_grid_rect(@current_position)
      @room               = text_rect[3] - @current_position
    end

    # skip fully_covered_rect and update current_position
    def update_current_position
      return unless @grid_rects
      @current_index = current_grid_rect_index_at_position(@current_position)
      while @current_index < @grid_rects.length do
        if !@grid_rects[@current_index].fully_covered
          if @current_index.odd? && @current_index < (@grid_rects.length - 1)
            # return even numbered grid
            @current_position = max_y(@grid_rects[@current_index + 1].rect)
            return
          end
          @current_position = max_y(@grid_rects[@current_index].rect)
          return
        else
          @current_index += 1
        end
      end
    end

  end

  # GridRect has two rectangle,
  # @rect represents the position of grid_rect in TexBox cordinate.
  # @rect is used to determine the overlappings with floats, which are in TexBox cordinate.
  # and @text_area represents non overlapping area for text layout in TextColumn cordinate(local cordinate)
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
    def overlap?
      @overlap == true
    end



  end

end
