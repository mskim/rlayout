
# float
# floats are floating graphic on top of the body of TextBox and Containers.
# floats are heading, images, side_box, and quotation box, 
# There should be a rule to manage floats if there are multiples of them and gets crowded.
# see layout_floats!

# float weight
# FLOAT_NO_PUSH:      do not push out contents underneath
# FLOAT_PUSH_RECT:    push out contents underneath the frame rect
# FLOAT_PUSH_SHAPE:   push out contents underneath the shape, cicle or bezier path

#     weight:     0. float, 1 push_out_rect, 2. push_out_shape
#     position:   top, middle, bottom
#     grid_frame float frame in grid

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


module RLayout
  
  class Graphic
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
                    
        
    # place imaegs that are in the head of the story as floats
    def place_float_images(images)
      @gutter = @layout_space
      return unless images
      images.each do |image_info|
        # image path only in String
        image_options = {}
        if image_info.class == String
          frame_rect = grid_frame_to_frame_rect([0,0,1,1])
          image_options[:x]       = frame_rect[0]
          image_options[:y]       = frame_rect[1]
          image_options[:width]   = frame_rect[2]
          image_options[:height]  = frame_rect[3]
          image_options[:image_path] = @images_dir + "/#{image_info}"
        # image path with grid_frame for layout as Hash
        elsif image_info.class == Hash
          image_options[:image_path] = @images_dir + "/#{image_info["image_path"]}"
          image_options[:image_path] = @images_dir + "/#{image_info[:image_path]}" if image_info[:image_path]
          frame_rect = grid_frame_to_frame_rect(image_info["grid_frame"])
          frame_rect = grid_frame_to_frame_rect(image_info[:grid_frame]) if image_options[:grid_frame]
          image_options[:x]       = frame_rect[0]
          image_options[:y]       = frame_rect[1]
          image_options[:width]   = frame_rect[2]
          image_options[:height]  = frame_rect[3]
        end
        image_options[:layout_expand]   = nil
        image_options[:is_float]        = true
        place_float_image(image_options)
      end
    end
    
    def place_float_image(options={})
      # options[:adjust_height_to_keep_ratio]     = true
      # puts "options:#{options}"
      # puts File.exists?(options[:image_path])
      @image  = Image.new(self, options)   
    end
    
    
    # change frame with grid frame values
    # def relayout_floats!
    #   update_grid_cells
    #   @floats.each do |float|
    #     # TODO clean this up
    #     float.set_frame frame_for(float.grid_frame)
    #   end
    # end
    

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
      @occupied_rects =[]
      #TODO position bottom bottom_occupied_rects
      # middle occupied rect shoul
      @middle_occupied_rects = []
      @bottom_occupied_rects = []
      @floats.each_with_index do |float, i|
        next unless float.kind_of?(Image) || float.kind_of?(Heading)
        if i==0
          @occupied_rects << float.frame_rect
        elsif intersects_with_occupied_rects?(@occupied_rects, float.frame_rect)
              # move to some place  
              move_float_to_unoccupied_area(@occupied_rects,float)
              @occupied_rects << float.frame_rect
        else
          @occupied_rects << float.frame_rect
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
          float.y = max_y(occupied_rect)           
        end
      end
    end
  end
  

end

