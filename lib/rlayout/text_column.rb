module RLayout
  

  # TextColumn 
  # simple_rect == false, means column has overlapping graphic. It is non-rectanle.
  # need non-rectanglar shaped bezier path to flow text.
  # But rather than using bezeier curve, I can simulate it using path with straight liens.
  # I am using seris of GridRect to determin the shape of text flowing region. 
  # finer the line_rect, closer it gets to bezier curve. I am using half body_line_height sized rect.
  # this should be suffient for laying out text.
  class TextColumn < Container
    attr_accessor :current_position, :current_line
    attr_accessor :complex_rect, :grid_rects, :body_line_height
    
    def initialize(parent_graphic, options={}, &block)
      super
      @klass = "TextColumn"
      @layout_space = 0
      @complex_rect = false
      @line_width   = 2
      @line_color   = 'black'
      @current_position = @top_margin + @top_inset
      @body_line_height = options.fetch(:body_line_height, 16)
      if block
        instance_eval(&block)
      end
      self
    end
    
    
    def create_grid_rects
      if @grid_rects
        return
      end
      @grid_rects = []
      column_rect = text_rect
      x     = @x + column_rect[0] # text_box cordinate
      y     = @y + column_rect[1] # text_box cordinate
      width = column_rect[2]
      height = @body_line_height/2
      while (y + height) < column_rect[3]
        @grid_rects << GridRect.new([x,y,width, height])
        y += height
      end
    end
    
    #TODO it should not start at the half height starting position
    def set_text_layout_starting_position
      @current_position = 0 unless @current_position #@top_margin + @top_inset
      @grid_rects.each do |grid_rect|
        # puts "grid_rect.rect:#{grid_rect.rect}"
        # puts "!grid_rect.fully_covered_grid?:#{!grid_rect.fully_covered_grid?}"
        if !grid_rect.fully_covered
          @current_position = grid_rect.rect[1]
          break 
        end
      end
    end
        
    def current_grid_rect_at_position(current_y_position)
      unless @grid_rects
        create_grid_rects
      end
      @grid_rects.each do |grid_rect|
        return grid_rect if current_y_position >= grid_rect.rect[1]
      end
    end
    
    # create path from current line to the bottom
    # this us used for layout CTFrame of non-simple rect
    def path_from_current_position
      unless @grid_rects
        create_grid_rects
      end
      # if @complex_rect
      #   puts "complex column, get the complex path created as result of overlapping"
      #   path_operations = []
      #   starting_line = current_grid_rect_at_position(@current_position)
      #   starting_index = @grid_rects.index(starting_line)
      #   path   = CGPathCreateMutable()
      #   usable_rects = []
      #   # CGPathAddRects (path, const CGAffineTransform *m, const CGRect rects[], size_t count );
      #   #TODO pass path from text_box
      #   CGPathAddRect(@path, nil, bounds)
      #   @frame          = CTFramesetterCreateFrame(@frame_setter,CFRangeMake(0, 0), @path, nil)
      #   
      #   return path
      # end
      
      path    = CGPathCreateMutable()
      # puts "frame_rect:#{frame_rect}"
      # puts "@current_position:#{@current_position}"
      # column_frame   = [frame_rect[0],frame_rect[1],frame_rect[2],frame_rect[3]]
      # x       = frame_rect[0]
      # y       = @current_position
      # puts "frame_rect[2]:#{frame_rect[2]}"
      # width   = frame_rect[2]
      # height  = @height - @bottom_margin - @bottom_inset - @current_position
      # bounds  = CGRectMake(x, y, width, height)
      # puts "++++++++ path"
      # puts "x: #{frame_rect[0]}"
      # puts "y: #{@current_position}"
      # puts "width:#{frame_rect[2]}"
      # puts "height:#{@height - @bottom_margin - @bottom_inset - @current_position}"
      bounds  = CGRectMake(frame_rect[0], @current_position, frame_rect[2], @height - @bottom_margin - @bottom_inset - @current_position)
      CGPathAddRect(path, nil, bounds)
      return path
      
    end
    
    def text_width
      text_rect[WIDTH_VAL]
    end
    
    def set_over_lapping_grid_lines(float_rect, float_klass)
      @grid_rects.each do |grid_rect|
        grid_rect.overlap_grid_rect_with_float(float_rect)
      end
      set_text_layout_starting_position
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
    
    # set @current_pasotion as start of non-overlapping y
    def set_starting_position_at_non_overlapping_area
      rect = non_overlapping_frame
      @current_position = rect[Y_POS] + @top_margin + @top_inset
    end
    
    def can_fit?(height)
      height <= room
    end
    
    def room
      room = @height - @current_position - @bottom_margin - @bottom_inset - @layout_space
    end
    
    def place_item(item)
      @graphics << item
      item.parent_graphic = self
      item.x              = @left_margin + @left_inset
      item.y              = @current_position
      @current_position  += item.height + @layout_space        
    end
  end
  
  
  # rect: position rect in TexBox cordinate
  # usable_rect: useable area, when overlapped in TextColumn cordinate
  class GridRect
    attr_accessor :rect, :overlap, :fully_covered
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
      # return if @overlap == true
      return unless intersects_rect(floating_rect, @rect)
      if contains_rect(floating_rect, @rect)
        set_fully_covered_grid
        @overlap = true
      elsif max_x(floating_rect) < max_x(@rect)
        # puts "left side covered"
        # puts "@rect:#{@rect}"
        
        # float is on the left side
        #TODO what about the hole in the middle, float sits in the middle of the line
        new_x = max_x(floating_rect)
        overlap_width = new_x - min_x(@rect)
        @rect[0] = new_x
        puts "left side ++++++++++ @rect[2]:#{@rect[2]}"
        @rect[2] -= overlap_width
        puts "@rect[2]:#{@rect[2]}"
        set_fully_covered_grid if @rect[2] < 50  # if the layout area is too small, treat is as fully covered
        @overlap = true
      elsif min_x(floating_rect) > min_x(@rect)
        # puts "right side covered"
        # puts "@rect:#{@rect}"
        
        # float is on the right side
        @rect[2] = min_x(floating_rect) - min_x(@rect)
        puts "right side ++++++++++ @rect[2]:#{@rect[2]}"
        set_fully_covered_grid if @rect[2] < 50 # if the layout area is too small, treat is as fully covered
        @overlap = true
      else
         left_side_room = min_x(floating_rect) - min_x(@rect)
         right_side_room = min_x(@rect) - max_x(floating_rect)
         @overlap = true
         set_fully_covered_grid if left_side_room < 50 && right_side_room < 50
      end
    end
    
    def overlap?
      @overlap == true 
    end
    
  end
  
end