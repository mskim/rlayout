
# float
# float is floating graphic on top of the body of container.
# Usual floats are heading, images, and quotation box, 
# There should be a rule to manage floats if there are multiples of them and gets crowded.
# 
# float_record
# float_record handle floating properties and layout among them

# float weight
# FLOAT_NO_PUSH:      do not push out contents underneath
# FLOAT_PUSH_RECT:    push out contents underneath the frame rect
# FLOAT_PUSH_SHAPE:   push out contents underneath the shape, cicle or bezier path

#     weight:     0. float, 1 push_out_rect, 2. push_out_shape
# graphic float_record
#     position:   0. top_left, 1 top_middle, 2. top_right
#                 3. middle_left, 4 middle_middle, 5. middle_right
#                 6. bottom_left, 7 bottom_middle, 8. bottom_right
##    size:       1. small, 2 midium, 3. large 4.x_large

FLOAT_NO_PUSH       = 0
FLOAT_PUSH_RECT     = 1
FLOAT_PUSH_SHAPE    = 2

# positions
TOP_LEFT      = 0
TOP_CENTER    = 1
TOP_RIGHT     = 2
MIDDLE_LEFT   = 3
MIDDLE_CENTER = 4
MIDDLE_RIGHT  = 5
BOTTOM_LEFT   = 6
BOTTOM_CENTER = 7
BOTTOM_RIGHT  = 8



SIZE_SMALL    = 0
SIZE_MEDIUM   = 1
SIZE_LARGE    = 2
SIZE_X_LARGE  = 3

module RLayout
  
  class Graphic
    attr_accessor :float_weight, :float_position, :float_size
    def init_float(options={})
      @float_weight   = options.fetch(:float_weight, FLOAT_PUSH_RECT)
      @float_position = options.fetch(:float_position, TOP_LEFT)
      @float_size     = options.fetch(:float_size, SIZE_MEDIUM)
      self
    end
    
    def float_to_hash
      h = {}
    end
    
    # givein column rect and float_rect return non_ovelapping new rect for column
    # If there is a hole in the middle, return Array of two rects if upper and lower area is big enough
    #
    def non_overlapping_area(column_rect, float_rect, min_gap =10)
      if !intersects_rect(column_rect, float_rect)
        # puts "they don't intersect"
        return column_rect
      elsif contains_rect(float_rect, column_rect)
        # puts "float_rect covers the entire column_rect"
        return [0,0,0,0]
      elsif min_y(float_rect) <= min_y(column_rect) && max_y(float_rect) >= max_y(column_rect)
        # puts "hole or block in the middle"
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
        # puts "overlapping at the top "
        new_rect = column_rect.dup
        new_rect[1] = max_y(float_rect)
        new_rect[HEIGHT_VAL] -= float_rect[HEIGHT_VAL]
        return new_rect
      elsif max_y(float_rect) >= max_y(column_rect)
        # puts "overlapping at the bottom "
        new_rect = column_rect.dup
        new_rect[HEIGHT_VAL] = min_y(float_rect)    
        return new_rect
      end
    end
    
    def min_x(rect)
      rect[X_POS]
    end
    
    def min_y(rect)
      rect[1]
    end
    
    def mid_x(rect)
      
    end
    
    def mid_y(rect)
      
    end
    
    def max_x(rect)
      rect[X_POS] + rect[WIDTH_VAL]
    end
    
    def max_y(rect)
      rect[1] + rect[HEIGHT_VAL]
    end
    
    def contains_rect(rect_1,rect_2)
      (rect_1[X_POS]<=rect_2[X_POS] && max_x(rect_1) >= max_x(rect_2)) && (rect_1[1]<=rect_2[1] && max_y(rect_1) >= max_y(rect_2))
    end
    
    def intersects_rect(rect_1, rect_2)
      (rect_1[X_POS]>=rect_2[X_POS] && rect_1[X_POS] <= max_x(rect_2)) && (rect_1[1]<=rect_2[1] && rect_1[X_POS] <= max_x(rect_2))
    end
    
    # it sets the children graphic's non_overlapping_frame value
    # this method is called after float is added and relayout!
    def set_non_overlapping_frame_for_chidren_graphics
      @floats.each do |float|
        @graphics.each_with_index do |graphic, i|
          if intersects_rect(float.frame_rect, graphic.frame_rect)
            graphic.non_overlapping_rect = non_overlapping_area(graphic.frame_rect, float.frame_rect) 
          end
        end
      end
    end
        
    # 
    # given float position option, calculate the orgin value of float
    def float_origin_for(position_option)
      case position_option
        
      when  TOP_LEFT 
        [0,0]
      # when  TOP_CENTER
      # when  TOP_RIGHT
      # when  MIDDLE_LEFT
      # when  MIDDLE_CENTER
      # when  MIDDLE_RIGHT
      # when  BOTTOM_LEFT
      # when  BOTTOM_CENTER 
      # when  BOTTOM_RIGHT
      else
        [0,0]
      end
    end
    
    # given float size option, calculate the size value of float
    def float_size_for(size_option)
      size = @single_grid_size
      case size_option
      when  SIZE_SMALL
        size.width  *= 3
        size.height *= 3
      when  SIZE_MEDIUM
        size.width  *= 4
        size.height *= 4
      when  SIZE_LARGE
        [300,300]
        size.width  *= 6
        size.height *= 6
        
      when  SIZE_X_LARGE
        size.width  *= 12
        size.height *= 6
      else
      end
      
      size
  
    end
    
    
    def set_origin_and_size(float)
      float.origin  = float_origin_for(float.float_position)
      float.size    = float_size_for(float.float_size)
    end
    
    
    # Todo ????
    def relayout!
      return unless @floats.length <= 0
      @floats.each do |float|
        set_origin_and_size(float)
      end
    end
    
    def self.include_relavant_key?(options)
      keys=[:float_weight, :float_position, :float_size]
      keys.each do |key|
        return true if options.has_key?(key)
      end
      false
    end
    
    def defaults
      hash={}
      hash[:float_weight]   = 0
      hash[:float_position] = 0
      hash[:float_size]     = 0
      hash
    end
        
    def to_hash
      hash={}
      hash[:float_weight]   = @float_weight   if @float_weight    != defaults[:float_weight]
      hash[:float_position] = @float_position if @float_position  != defaults[:float_position]
      hash[:float_size]     = @float_size     if @float_size      != defaults[:float_size]
       hash
    end
    
    def self.from_hash(owner_graphic, hash)
      GFloatRecord.new(owner_graphic,hash)
    end
    
  end
  

end

