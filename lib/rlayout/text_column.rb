module RLayout
  

  # TextColumn 
  # complex_rect == true, means column has overlapping graphic. I need non-rectanle shaped region.
  # need non-rectanglar shaped bezier path to flow text.
  # But rather than using bezeier curve, I simulate it using path with straight liens.
  # I am using seris of GridRect class rects to determin the shape of text flowing region. 
  # finer the GridRect, closer it gets to bezier curve. I am using half body_text_height sized rect.
  # Half of body text size should be suffient for text layout.
  # I do not want body text to align at odd numbered grid.
  # I want to align all body text to even numbered grids, this will keep vertical text alignment across the columns
  class TextColumn < Container
    attr_accessor :current_position, :current_line, :room
    attr_accessor :complex_rect, :grid_rects, :grid_rects_frame, :body_line_height
    def initialize(parent_graphic, options={}, &block)
      super
      @klass = "TextColumn"
      @layout_space = 0
      @complex_rect = false
      # @line_width   = 2
      # @line_color   = 'black'
      @current_position = @top_margin + @top_inset
      @room = text_rect[3] - @current_position
      @body_line_height = options.fetch(:body_line_height, 16)
      if block
        instance_eval(&block)
      end
      self
    end
    
    # create grid_rects after relayou!
    # make sure the grids are created after adjusting the column size for the final layout
    def create_grid_rects
      @grid_rects = []
      column_rect = text_rect
      @grid_rects_frame = column_rect
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
    
    #TODO it should not start at the half height starting position using options[:align_to_body_text}
    # set @current_pasotion as start of non-overlapping y
    # this happens when Heading or Image is covering the top part of column
    # make sure we 
    def set_column_starting_position(options={})
      @current_position = text_rect[1] unless @current_position #@top_margin + @top_inset
      unless @grid_rects
        update_room
        return
      end
      @grid_rects.each do |grid_rect|
        # puts "grid_rect.rect:#{grid_rect.rect}"
        # puts "!grid_rect.fully_covered_grid?:#{!grid_rect.fully_covered_grid?}"
        if !grid_rect.fully_covered
          @current_position = grid_rect.rect[1]
          break 
        end
      end
      update_room
    end
    
    def update_room
      @room = max_y(text_rect) - @current_position
    end
    
    
    def can_fit?(height)
      puts "room:#{room}"
      return false if @room < 16
      height <= @room
    end
        
    # find the grid_rect that conatines the y position
    # options[:align_to_body_text] for body text
    def grid_line_position_at(position, options={})
      unless @grid_rects
        create_grid_rects
      end
      @grid_rects.each_with_index do |grid_rect, i|
        if position >= min_y(grid_rect.rect) && position <= max_y(grid_rect.rect)
          if options[:align_to_body_text]
            # align to even grid for body text alignment
            if i.even?
              return max_y(grid_rect.rect)
            elsif @grid_rects.length > i+1
              even_rect = @grid_rects[i+1] 
              return max_y(even_rect.rect)
            end
          end
          return max_y(grid_rect.rect)
        end
      end
      max_y(@grid_rects.last.rect) 
    end
    
    
    #TODO it should not start at the half height starting position using options[:align_to_body_text}
    def current_grid_rect_index_at_position(options={})
      @current_position = @top_margin + @top_inset unless @current_position #@top_margin + @top_inset
      @grid_rects.each_with_index do |grid_rect, i|
        if @current_position >= min_y(grid_rect.rect) && @current_position <= max_y(grid_rect.rect)
          # return grid_rect 
          return i
        end
      end
      @grid_rects.length # index is beyond the array range
    end
    
    # create bezier_path from current position to the bottom
    # by appending series of rectangle path to CGPath
    # this us used for layout CTFrame of non-simple rect path
    # for simple_rect case, construct rectangle path using column rect
    def path_from_current_position
      if @complex_rect
        puts "complex column, get the complex path created as result of overlapping"
        path   = CGPathCreateMutable()
        starting_index = current_grid_rect_index_at_position
        if starting_index >= @grid_rects.length
          # if we have positin beyond the bottom
          # return empty rect path
          CGPathAddRect(path, nil, NSZeroRect)
          return path
        end
        ending_index    = @grid_rects.length - 1
        @grid_rects[starting_index..ending_index].each do |line|
          rect = line.non_overlapping_rect
          non_overlapping_rect = NSMakeRect(rect[0], rect[1], rect[2], rect[3])
          CGPathAddRect(@path, nil, non_overlapping_rect)
        end
        return path
      end
      path    = CGPathCreateMutable()
      bounds  = CGRectMake(frame_rect[0], @current_position, frame_rect[2], @height - @bottom_margin - @bottom_inset - @current_position)
      bounds  = CGRectMake(frame_rect[0], @current_position, frame_rect[2], 1000)
      CGPathAddRect(path, nil, bounds)
      return path
    end
    
    def text_width
      text_rect[WIDTH_VAL]
    end
    
    def set_overlapping_grid_lines(float_rect, float_klass)
      @grid_rects.each do |grid_rect|
        grid_rect.overlap_grid_rect_with_float(float_rect)
      end
      set_column_starting_position
    end
    
    # non_overlapping_rect is a actual layout frame that is not overlapping with flaots
    def non_overlapping_frame
      #TODO
      # 
      if @non_overlapping_rect
        return @non_overlapping_rect 
      end
      bounds_rect
    end

    def place_item(item)
      @graphics << item
      item.parent_graphic = self
      item.x              = @left_margin + @left_inset
      item.y              = @current_position
      @current_position  += item.height + @layout_space
      @room = text_rect[3] - @current_position
    end

    def draw_grid_rects
      NSColor.yellowColor.set
      @grid_rects.each {|line| line.draw_grid_rect}
    end
    
  end
  
  
  # rect:             position of grid_rect in TexBox cordinate
  # non_overlap_rect: non overlap area, when overlapped in TextColumn cordinate
  class GridRect
    attr_accessor :rect, :non_overlap_rect, :overlap, :fully_covered
    def initialize(rect)
      @rect = rect
      @overlap = false
      @fully_covered = false
      self
    end
        
    def set_fully_covered_grid
      @fully_covered = true
    end
    
    # when grid_rect overlaps with given float, 
    # moidify the rect with available areas. 
    def overlap_grid_rect_with_float(floating_rect)
      return if @fully_covered == true
      return unless intersects_rect(floating_rect, @rect)
      if contains_rect(floating_rect, @rect)
        set_fully_covered_grid
        @overlap = true
      elsif max_x(floating_rect) < max_x(@rect)
        # puts "left side covered"
        # puts "@rect:#{@rect}"
        @non_overlap_rect = @rect.dup
        @non_overlap_rect[0] = 0 # @non_overlap_rect uses local cordinate
        # float is on the left side
        #TODO what about the hole in the middle, float sits in the middle of the line
        new_x = max_x(floating_rect)
        overlap_width = new_x - min_x(@rect)
        @non_overlap_rect[0] = new_x
        puts "left side ++++++++++ @rect[2]:#{@rect[2]}"
        @non_overlap_rect[2] -= overlap_width
        puts "@rect[2]:#{@rect[2]}"
        set_fully_covered_grid if @non_overlap_rect[2] < 50  # if the layout area is too small, treat is as fully covered
        @overlap = true
      elsif min_x(floating_rect) > min_x(@rect)
        # puts "right side covered"
        @non_overlap_rect = @rect.dup
        @non_overlap_rect[0] = 0 # @non_overlap_rect uses local cordinate
        # float is on the right side
        @non_overlap_rect[2] = min_x(floating_rect) - min_x(@rect)
        puts "right side ++++++++++ @rect[2]:#{@rect[2]}"
        set_fully_covered_grid if @non_overlap_rect[2] < 50 # if the layout area is too small, treat is as fully covered
        @overlap = true
      else
        @non_overlap_rect = @rect.dup
        @non_overlap_rect[0] = 0 # @non_overlap_rect uses local cordinate
        # overlap is in the middle of the line
        # take one side only, the larger side, not both
        left_side_room = min_x(floating_rect) - min_x(@rect)
        right_side_room = min_x(@rect) - max_x(floating_rect)
        if left_side_room >= right_side_room
          @non_overlap_rect[2] = left_side_room
        else
          @non_overlap_rect[0] = max_x(floating_rect) - min_x(@rect)
          @non_overlap_rect[2] = right_side_room
        end
        @overlap = true
        set_fully_covered_grid if left_side_room < 50 && right_side_room < 50
      end
    end
    
    def overlap?
      @overlap == true 
    end
    
    def draw_grid_rect
      if @non_overlap_rect
        grid_rect = NSMakeRect(@non_overlap_rect[0], @non_overlap_rect[1], @non_overlap_rect[2], @non_overlap_rect[3])
        path = NSBezierPath.bezierPathWithRect(grid_rect)
      else
        # make @rect in local cordinate
        grid_rect = NSMakeRect(0, @rect[1], @rect[2], @rect[3])
        path = NSBezierPath.bezierPathWithRect(grid_rect)
      end
      path.setLineWidth(1)
      path.stroke
    end
  end
  
end