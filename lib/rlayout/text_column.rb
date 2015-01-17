module RLayout
  

  # TextColumn 
  # TextColumn is covered with series of grid_rects.
  # "grid_rects" are used to determine the shapes of text layout area, to avoid overlapping floats.
  # complex_rect means column has overlapping graphic and it has non-rectanle shaped region.
  # We non-rectanglar shaped bezier path to flow text.
  # But rather than using bezeier curve, I simulate it using this grid_rects.
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
    
    def can_fit?(height)
      puts "room:#{room}"
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

    def text_width
      text_rect[2]
    end
    
    def mark_overlapping_grid_rects(float_rect, float_klass)
      @complex_rect = true
      @grid_rects.each do |grid_rect|
        grid_rect.update_text_area(float_rect)
      end
      set_column_starting_position
    end
    
    # non_overlapping_rect is a actual layout frame that is not overlapping with flaots
    def non_overlapping_frame
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
      @current_position   += item.height + @layout_space
      @room               = text_rect[3] - @current_position
    end

    def draw_grid_rects
      NSColor.yellowColor.set
      @grid_rects.each {|line| line.draw_grid_rect}
      draw_path_from_current_position
    end
    
    # def draw_text_area_path
    #   ns_path = NSBezierPath.bezierPath
    #   ns_path = ns_path_from_current_position
    #   # cg_path = ns_path.CGPath
    #   cg_path = path_from_current_position
    #   ns_path.CGPath = cg_path
    #   NSColor.redColor.set
    #   ns_path.setLineWidth(1)
    #   ns_path.stroke
    # end
    # 
    
    def draw_path_from_current_position
      if @complex_rect
      	context = NSGraphicsContext.currentContext.graphicsPort
        CGContextBeginPath(context)
        starting_index  = current_grid_rect_index_at_position
        ending_index    = @grid_rects.length - 1
        starting_grid   = @grid_rects[starting_index]
        #move to top_left_position
        x,y = starting_grid.top_left_position
        # CGPathMoveToPoint(path, nil, x,y)
        CGContextMoveToPoint(context, x,y)
        # add top path from left to right
        starting_grid.draw_top_right(context)
        #loop each box for going down right side
        current_x, current_y = starting_grid.top_right_position
        @grid_rects[(starting_index)..ending_index].each do |grid|
          right_edge_x = max_x(grid.text_area)
          if right_edge_x == current_x
            # rigtt side is aligned with the previous grid
            grid.draw_right_down(context)
          else
            # rigtt side is not aligned with the previous grid
            # lineto right edge of next grid
            x,y = grid.top_right_position
            CGContextAddLineToPoint(context, x,y)
            current_x = x
            grid.draw_right_down(context)
          end 
        end
        # lineto left at the bottom
        last_grid     = @grid_rects.last
        last_grid.draw_bottom_left(context)  # draw up at the left edge
        current_x, current_y = last_grid.bottom_left_position
        # loop each grid for coming up left side
        @grid_rects[starting_index..ending_index].reverse.each_with_index do |grid, i|
          if min_x(grid.text_area) == current_x
            # left side is aligned with the above grid
            grid.draw_left_up(context)
          else
            # left side is not aligned with the above grid
            # lineto left edge of above line
            x,y = grid.bottom_left_position
            CGContextAddLineToPoint(context, x,y)
            current_x = x
            grid.draw_left_up(context)
          end 
        end
        # close path
        CGContextClosePath(context)
        # stroke
        # CGContextSetStrokeColor(context, )
        NSColor.redColor.set
        CGContextStrokePath(context)
      end
    end
    

    # 1. painful poth by path construction of irregular shape    
    def path_from_current_position
      if @complex_rect
        starting_index  = current_grid_rect_index_at_position
        ending_index    = @grid_rects.length - 1
        path            = CGPathCreateMutable()
        starting_grid   = @grid_rects[starting_index]
        #move to top_left_position
        x,y = starting_grid.top_left_position
        CGPathMoveToPoint(path, nil, x,y)
        # add top path from left to right
        starting_grid.path_top_right(path)
        #loop each box for going down right side
        current_x, current_y = starting_grid.top_right_position
        @grid_rects[(starting_index)..ending_index].each do |grid|
          right_edge_x = max_x(grid.text_area)
          if right_edge_x == current_x
            # rigtt side is aligned with the previous grid
            grid.path_right_down(path)
          else
            # rigtt side is not aligned with the previous grid
            # lineto right edge of next grid
            x,y = grid.top_right_position
            CGPathAddLineToPoint(path, nil, x,y)
            current_x = x
            grid.path_right_down(path)
          end 
        end
        # lineto left at the bottom
        last_grid     = @grid_rects.last
        last_grid.path_bottom_left(path)  # draw up at the left edge
        current_x, current_y = last_grid.bottom_left_position
        # loop each grid for coming up left side
        @grid_rects[starting_index..ending_index].reverse.each do |grid|
          if min_x(grid.text_area) == current_x
            # left side is aligned with the above grid
            grid.path_left_up(path)
          else
            # left side is not aligned with the above grid
            # lineto left edge of above line 
            x,y = grid.bottom_left_position
            CGPathAddLineToPoint(path, nil, x,y)
            current_x = x
            grid.path_left_up(path)
          end 
        end
        # close path
        CGPathCloseSubpath(path)
        return path
      end
      # simple column
      path    = CGPathCreateMutable()
      bounds  = CGRectMake(frame_rect[0], @current_position, frame_rect[2], @height - @bottom_margin - @bottom_inset - @current_position)
      bounds  = CGRectMake(frame_rect[0], @current_position, frame_rect[2], 1000)
      CGPathAddRect(path, nil, bounds)
      return path
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
    
    def overlap?
      @overlap == true 
    end
        
    def draw_grid_rect
      grid_rect = NSMakeRect(@text_area[0], @text_area[1], @text_area[2], @text_area[3])
      path = NSBezierPath.bezierPathWithRect(grid_rect)
      path.setLineWidth(1)
      path.stroke
    end
    
    ############ point construction #########
    # return x, y
    def top_left_position
      return text_area[0], text_area[1]
    end
    
    def top_right_position
      return max_x(text_area), text_area[1]
    end
    
    def bottom_right_position
      return max_x(text_area), max_y(text_area)
    end
    
    def bottom_left_position
      return text_area[0], max_y(text_area)
    end
    
    ############ CGContext drawing #########
    def draw_top_right(context)
      x,y = top_right_position
      CGContextAddLineToPoint(context, x,y)
    end
        
    def draw_right_down(context)
      x,y = bottom_right_position
      CGContextAddLineToPoint(context, x,y)
    end
    
    def draw_bottom_left(context)
      x,y = bottom_left_position
      CGContextAddLineToPoint(context, x,y)
    end
    
    def draw_left_up(context)
      x,y=top_left_position
      CGContextAddLineToPoint(context, x,y)
    end
    
    ############ path construction #########
    def path_top_right(path)
      x,y = top_right_position
      CGPathAddLineToPoint(path, nil, x,y)
    end
        
    def path_right_down(path)
      x,y = bottom_right_position
      CGPathAddLineToPoint(path, nil, x,y)
    end
    
    def path_bottom_left(path)
      x,y = bottom_left_position
      CGPathAddLineToPoint(path, nil, x,y)
    end
    
    def path_left_up(path)
      x,y=top_left_position
      CGPathAddLineToPoint(path, nil, x,y)
    end
  end
  
end