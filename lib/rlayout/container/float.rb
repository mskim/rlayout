
# float
# floats are floating graphic on top of the body of TextBox.
# floats are heading, images, side_box, and quotation box, 
# There should be a rule to manage floats if there are multiples of them and gets crowded.
# see layout_floats!

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
#     float_grid_frame float frame in grid

# One way to layout floats is using patters and profile, a pre-designed template
# 1. Define set of patters per grid_base with grid_frame
# float_patters_profile
# float_patters
# 3x3.rb
# '1' = {
#    {[0,0,1,1]}
#    {[0,0,2,2]}
#    {[0,0,2,1]}
# }
#
# '2' = {
#    {[0,0,3,1], [0,1,1,1]}
#    {[0,0,3,1], [0,1,2,2]}
#
# }


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
      if contains_rect(float_rect, column_rect)
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
                    
    def to_hash
      floats=[]
      @floats.each do |float|
        floats << float.to_hash
      end
      floats
    end
    
    # layout_floats!
    # floats are Heading, Image, Quotes, SideBox
    # Float should have frame_rect, 
    #   x value in frame_rect, represents the column starting location  [x,y,width,height]
    #   y value are in unit of grid_rects, but this could get pushed if previous float occupied the space. 
    #   width value in columns
    #   height value are in grid_rect units, but this could vary with content.
    # default frame_rect for float is [0,0,1,1], grid_rect in cordinates
    # For Images, default height is natural height proportional to image width/height ratio.
    # For Text, default height is natural height proportional to thw content of text, unless specified otherwise.

    # float are layed out in oder of @floats array
    # if a starting location is occupies, following float is placed below.
    # if I want to put float at the bottom of the TextBox, should pass 
    #     float_bottom:true 
    # if more than one bottm stacking float in the same location, it moves up as we do with top down.
    # if float_bleed:true, it bleeds at the location, top, bottom and side
    
    def layout_floats!
      return unless @floats
      @occupied_rects =[]
      @floats.each_with_index do |float, i|
        puts float.fill_color
        if i==0
          @occupied_rects << float.frame_rect
        elsif intersects_with_occupied_rects?(@occupied_rects, float.frame_rect)
              # move to some place  
              push_float_to_no_mens_land(@occupied_rects,float)
              @occupied_rects << float.frame_rect
        else
          @occupied_rects << float.frame_rect
        end
        float.puts_frame
        puts "++++ "
        
      end
      # test for overflow of floats
      @floats.each do |float|
        return "oveflow" if contains_rect(frame_rect, float.frame_rect)
      end
      true
    end
    
    def intersects_with_occupied_rects?(occupied_arry, new_rect)
      occupied_arry.each do |occupied_rect|
        return true if intersects_rect(occupied_rect, new_rect)
      end
      false
    end
    
    def push_float_to_no_mens_land(occupied_arry, float)
      occupied_arry.each do |occupied_rect|
        float.y = max_y(occupied_rect) if intersects_rect(occupied_rect, float.frame_rect)
      end
    end
  end
  

end

