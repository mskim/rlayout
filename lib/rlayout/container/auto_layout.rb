# require 'pry'
#
#  There are three layout layout_modes
#   1. vertical_stack
#   2. horizontal_stack

#TODO
# alignment # top

module RLayout
  class Container

    def relayout!
      return unless @graphics
      return if @graphics.length <= 0
      vertical          = @layout_direction == "vertical"
      column_size       = [non_overlapping_frame[WIDTH_VAL], non_overlapping_frame[HEIGHT_VAL]]
      @starting_y       = non_overlapping_bounds[Y_POS] # i need non_overlapping_bounds, not non_overlapping_frame
      starting_position = vertical ? (@starting_y + @top_margin +  @top_inset) : (@left_margin + @left_inset)
      ending_position   = vertical ? (column_size[Y_POS] - @top_margin - @bottom_margin - @top_inset - @bottom_inset)  : (column_size[X_POS] - @left_margin - @right_margin - @left_inset - @right_inset)
      expandable_size   = ending_position
      expandable_graphics = 0
      layout_length_sum   = 0

       # This is the first pass
       @graphics.each_with_index do |graphic, index|
         next if !graphic.layout_member || graphic.layout_expand.nil?                  
         if (vertical ? graphic.expand_height? : graphic.expand_width?)
           expandable_graphics += 1
           layout_length_sum +=graphic.layout_length
         else
           expandable_size -= vertical ? graphic.height : graphic.width            
         end
            expandable_size -= 
            vertical ? graphic.top_margin + graphic.bottom_margin
                    : graphic.left_margin + graphic.right_margin
       end
       spacing_number   = @graphics.length - 1
       unit_size        = expandable_size
       @layout_space    = 0 if @layout_space.nil?
       if spacing_number>0
         expandable_size -= spacing_number*@layout_space if @layout_space
         if layout_length_sum ==0
           unit_size    = expandable_size
         else
           unit_size    = expandable_size/layout_length_sum
         end
       end
       
       @graphics.each do |graphic|
         next if !graphic.layout_member || graphic.layout_expand.nil?                  
         graphic_frame  = graphic.frame_rect
         graphic_x      = graphic_frame[X_POS]
         graphic_y      = graphic_frame[Y_POS]
         graphic_width  = graphic_frame[WIDTH_VAL]
         graphic_height = graphic_frame[HEIGHT_VAL]
         graphic_dimension = vertical ? graphic_y : graphic_x

         if vertical
           graphic_frame[X_POS] = @left_margin + @left_inset
           if @layout_strarting == "top"
             graphic_frame[Y_POS] = starting_position             
           else
             graphic_frame[Y_POS] = ending_position - graphic_dimension
           end        
         else
           if @layout_strarting == "top"
             graphic_frame[X_POS] = starting_position
           else
             graphic_frame[X_POS] = ending_position - graphic_dimension
           end        
           graphic_frame[Y_POS] = @top_margin + @top_inset
         end
         
         if (vertical ? graphic.expand_height? : graphic.expand_width?)
           if vertical
             graphic_frame[HEIGHT_VAL] = unit_size*graphic.layout_length
           else
             graphic_frame[WIDTH_VAL] = unit_size*graphic.layout_length
           end
           graphic_dimension = unit_size*graphic.layout_length
         end

         if (vertical ? graphic.expand_width? : graphic.expand_height?)
           if vertical
             graphic_frame[WIDTH_VAL] = column_size[X_POS] - (@left_margin + @right_margin + @right_inset + @left_inset) - graphic.right_margin - graphic.left_margin
           else
             graphic_frame[HEIGHT_VAL] = column_size[Y_POS] - (@top_margin + @bottom_margin + @top_inset + @bottom_inset) - graphic.top_margin - graphic.bottom_margin
           end
         else
           case @layout_align
           when "left", "top" #{}"bottom"
             # Nothing to do
           when "center"
             if vertical
               graphic_frame[X_POS] = (column_size[X_POS] / 2.0) - (graphic_x / 2.0)
             else
               graphic_frame[Y_POS] = (column_size[Y_POS] / 2.0) - (graphic_y / 2.0)
             end
           #TODO
           when "right", "bottom"
             if vertical
               graphic_frame[X_POS] = column_size[X_POS] - graphic_x - @bottom_margin
             else
               graphic_frame[Y_POS] = column_size[Y_POS] - graphic_y - @top_margin
             end
           when "justified"
             #TODO
             if vertical
                graphic_frame[X_POS] = column_size[X_POS] - graphic_x - @bottom_margin
             else
                graphic_frame[Y_POS] = column_size[Y_POS] - graphic_y - @top_margin
             end
           end
         end
         graphic_frame[X_POS] += graphic.left_margin
         graphic_frame[Y_POS] += graphic.top_margin
         if @layout_strarting == "top"
           starting_position += graphic_dimension + @layout_space
           if vertical
             starting_position += graphic.bottom_margin + graphic.top_margin if graphic.bottom_margin && graphic.top_margin
           else
             starting_position += graphic.left_margin + graphic.right_margin if graphic.left_margin && graphic.right_margin
           end
         else
           ending_position -= graphic_dimension + @layout_space
         end
         graphic.set_frame(graphic_frame)

         if graphic.layout_expand.nil?
         else
           # recursive layout_member for child graphics
           graphic.relayout! if graphic.kind_of?(Container)
         end
       end 
       # relayout @owner_graphic's text with new geometry
       @text_record.update_text_fit if @text_record && @text_record.class == GTextRecord
       # adjust image with new geometry
       @image_record.apply_fit_type if @image_record
       
    end


  end  
  
  
  
end