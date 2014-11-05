# require 'pry'
#
#  There are three layout layout_modes
#   1. vertical_stack
#   2. horizontal_stack
#   3. grid

#TODO
# def layout_vertical_stack
# end
# def layout_horizontal_stack
# end
# def layout_grid_matrix
# end

module RLayout
  class Container

    def relayout!
      return unless @graphics
      return if @graphics.length <= 0
      vertical  = @layout_direction == "vertical"
      view_size = [non_overlapping_frame[2], non_overlapping_frame[3]]
      
      @starting_y = non_overlapping_bounds[1] # i need non_overlapping_bounds, not non_overlapping_frame
      starting_position = vertical ? (@starting_y + @top_margin +  @top_inset) : (@left_margin + @left_inset)
      ending_position   = vertical ? (view_size[1] - @top_margin - @bottom_margin - @top_inset - @bottom_inset)  : (view_size[0] - @left_margin - @right_margin - @left_inset - @right_inset)
      expandable_size   = ending_position
      expandable_children = 0
      layout_length_sum   = 0

       # This is the first pass
       @graphics.each_with_index do |child, index|
         next if !child.layout_member || child.layout_expand.nil?                  
         if (vertical ? child.expand_height? : child.expand_width?)
           expandable_children += 1
           layout_length_sum +=child.layout_length
         else
           expandable_size -= vertical ? child.height : child.width            
         end
          expandable_size -= 
           vertical ? child.top_margin + child.bottom_margin
                    : child.left_margin + child.right_margin
       end
       spacing_number  = @graphics.length - 1
       unit_size = expandable_size
       @layout_space = 0 if @layout_space.nil?
       if spacing_number>0
         expandable_size -= spacing_number*@layout_space if @layout_space
         if layout_length_sum ==0
           unit_size    = expandable_size
         else
           unit_size    = expandable_size/layout_length_sum
         end
       end
       
       @graphics.each do |child|
         next if !child.layout_member || child.layout_expand.nil?                  
         subview_size = [child.width, child.height]
         view_frame = [0, 0, subview_size[0],subview_size[1]]
         subview_dimension = vertical ? subview_size[1] : subview_size[0]

         if vertical
           view_frame[0] = @left_margin + @left_inset # 2012 4 16
           if @layout_strarting == "top"
             view_frame[1] = starting_position             
           else
             view_frame[1] = ending_position - subview_dimension
           end        
         else
           if @layout_strarting == "top"
             view_frame[0] = starting_position
           else
             view_frame[0] = ending_position - subview_dimension
           end        
           view_frame[1] = @top_margin + @top_inset

         end
         if (vertical ? child.expand_height? : child.expand_width?)
           if vertical
             # view_frame[3] = expandable_size
             # view_frame[3] = unit_size*child.layout_length
             view_frame[3] = unit_size*child.layout_length
           else
             view_frame[2] = unit_size*child.layout_length
           end
           subview_dimension = unit_size*child.layout_length
         end

         if (vertical ? child.expand_width? : child.expand_height?)
           if vertical
             view_frame[2] = view_size[0] - (@left_margin + @right_margin + @right_inset + @left_inset) - child.right_margin - child.left_margin
           else
             view_frame[3] = view_size[1] - (@top_margin + @bottom_margin + @top_inset + @bottom_inset) - child.top_margin - child.bottom_margin
           end
         else
           case @layout_align
           when "left", "top" #{}"bottom"
             # Nothing to do

           when "center"
             if vertical
               view_frame[0] = (view_size[0] / 2.0) - (subview_size[0] / 2.0)
             else
               view_frame[1] = (view_size[1] / 2.0) - (subview_size[1] / 2.0)
             end
          
           #TODO
           when "right", "bottom"
             if vertical
               view_frame[0] = view_size[0] - subview_size[0] - @bottom_margin
             else
               view_frame[1] = view_size[1] - subview_size[1] - @top_margin
             end
           end
         end


         view_frame[0] += child.left_margin
         view_frame[1] += child.top_margin

         if @layout_strarting == "top"
           starting_position += subview_dimension + @layout_space
           if vertical
             starting_position += child.bottom_margin + child.top_margin if child.bottom_margin && child.top_margin
           else
             starting_position += child.left_margin + child.right_margin if child.left_margin && child.right_margin
           end
         else
           ending_position -= subview_dimension + @layout_space
         end

         child.set_frame(view_frame)

         if child.layout_expand.nil?
         else
           child.relayout! if child.kind_of?(Container) # recursive layout_member for child graphics
           #TODO
           # child.update_text_fit if child.kind_of?(Text) # update_text_fit 
         end
       end 

       # relayout @owner_graphic's text with new geometry
       @text_record.update_text_fit if @text_record && @text_record.class == GTextRecord
       @image_record.apply_fit_type if @image_record
       # relayout @owner_graphic's matrix_record with new geometry 
       # @matrix_record.relayout! if @matrix_record
       # @adjust_height_for_children if @is_a?(Paragraph)
       
    end


  end  
  
  
  
end