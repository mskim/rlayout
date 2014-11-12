# require 'pry'
#

module RLayout
  class Container
    #  relayout! is done in two passes
    #    in the first pass, we gather information about children graphics
    #    and in the second pass, we lay them out 
    #  There are two cases for relayout!
    #  First case is when we have layout direction expanding child as a member
    #    when this happens, we should not have any left over rooms, 
    #    since expanding members will expand to fill up the column
    #  Second case is when none of the children are expanding at layout direction
    #    when this happns, we could have some left over rooms, 
    #    we need to aligmn them at layout direction, 
    #       top, middle, bottom, justified for vertical mode
    #       left, center, right, justified for horizontal mode, they can be used interchablly
    #       we can still have graphics expanding at perpendicular diretion to the layout direct to take care of
    #  have_expanding_child is set to false at first 
    #  and in the first pass, if we detect andy expanding graphic, it is set to true
    def relayout!
      return unless @graphics
      return if @graphics.length <= 0
      vertical            = @layout_direction == "vertical"
      have_expanding_child = false # Do we have layout direction expending child?
      column_size         = [non_overlapping_frame[WIDTH_VAL], non_overlapping_frame[HEIGHT_VAL]]
      @starting_y         = non_overlapping_bounds[Y_POS] # i need non_overlapping_bounds, not non_overlapping_frame
      current_position    = vertical ? (@starting_y + @top_margin +  @top_inset) : (@left_margin + @left_inset)
      ending_position     = vertical ? (column_size[1] - @top_margin - @bottom_margin - @top_inset - @bottom_inset)  : (column_size[X_POS] - @left_margin - @right_margin - @left_inset - @right_inset)
      column_room         = ending_position
      expandable_length   = ending_position
      expandable_graphics = 0
      layout_length_sum   = 0
      non_expanding_length_sum   = 0
      # This is the first pass
      @graphics.each_with_index do |graphic, index|
        next if !graphic.layout_member || graphic.layout_expand.nil?                  
        if (vertical ? graphic.expand_height? : graphic.expand_width?)
          expandable_graphics += 1
          have_expanding_child = true
          layout_length_sum +=graphic.layout_length
        else
          expandable_length -= vertical ? graphic.height : graphic.width
          non_expanding_length_sum += vertical ? graphic.height : graphic.width
        end
          vertical ? graphic.top_margin + graphic.bottom_margin
                    : graphic.left_margin + graphic.right_margin
      end
      spacing_number   = @graphics.length - 1
      unit_size        = 0
      @layout_space    = 0 if @layout_space.nil?
      if spacing_number>0
        expandable_length -= spacing_number*@layout_space if @layout_space
        if layout_length_sum ==0
          unit_size    = expandable_length
        else
          unit_size    = expandable_length/layout_length_sum
        end
      else
        unit_size
      end
      # we set starting current_position for none expanding case
      unless have_expanding_child    
       room = column_room - non_expanding_length_sum  
       case @layout_align
       when "top","left" 
       # nothing to do
       when "center", "middle"
         current_position = room/2
       when "bottom", "right"
         current_position = room
       when "justified"
         # we need different @layout_space for justified case
         @layout_space = room/spacing_number if spacing_number !=0
       end
      end
      # This is the second pass
      @graphics.each do |graphic|
        next if !graphic.layout_member || graphic.layout_expand.nil?                  
        graphic_frame  = graphic.frame_rect      
        # adjust size
        if (vertical ? graphic.expand_height? : graphic.expand_width?)
          if spacing_number == 0
            graphic_dimension = expandable_length
          else
            graphic_dimension = unit_size*graphic.layout_length
          end
          if vertical
            graphic_frame[HEIGHT_VAL]  = graphic_dimension
          else
            graphic_frame[WIDTH_VAL]   = graphic_dimension
          end
        end
        graphic_dimension = vertical ? graphic_frame[HEIGHT_VAL] : graphic_frame[WIDTH_VAL]
        # set current_position and update current_position
        if have_expanding_child
          if vertical
            graphic_frame[Y_POS] = current_position             
            current_position += graphic_dimension + @layout_space
            current_position += graphic.bottom_margin + graphic.top_margin #if graphic.bottom_margin && graphic.top_margin 
          else
            graphic_frame[X_POS] = current_position
            current_position += graphic_dimension + @layout_space
            current_position += graphic.left_margin + graphic.right_margin #if graphic.left_margin && graphic.right_margin
          end
        else
          # for non-expanding 
          if vertical
            graphic_frame[Y_POS] = current_position
            current_position += graphic.height + @layout_space
          else
            graphic_frame[X_POS] = current_position
            current_position += graphic.width + @layout_space
          end           
        end
       
        # perpedicular alignment
        if (vertical ? graphic.expand_width? : graphic.expand_height?)
          if vertical
            graphic_frame[WIDTH_VAL]  = column_size[X_POS] - (@left_margin + @right_margin + @right_inset + @left_inset) - graphic.right_margin - graphic.left_margin
            graphic_frame[X_POS]      = (@left_margin  + @left_inset)
          else
            graphic_frame[HEIGHT_VAL] = column_size[Y_POS] - (@top_margin + @bottom_margin + @top_inset + @bottom_inset) - graphic.top_margin - graphic.bottom_margin
            graphic_frame[Y_POS]      = (@top_margin + @top_inset)
          end  
        end
        #perpedicular alignment for non perpedicular expanding child 
        # if !graphic.layout_align.nil?  
        #   case graphic.layout_align
        #   when "left", "top" #{}"bottom"
        #     # Nothing to do
        #   when "center", "middle"
        #     if vertical
        #       graphic_frame[X_POS] = (column_size[0] / 2.0) - (graphic_frame[X_POS] / 2.0)
        #     else
        #       graphic_frame[Y_POS] = (column_size[1] / 2.0) - (graphic_frame[Y_POS] / 2.0)
        #     end
        #   when "right", "bottom"
        #     if vertical
        #       graphic_frame[X_POS] = column_size[X_POS] - graphic_frame[X_POS] - @bottom_margin
        #     else
        #       graphic_frame[Y_POS] = column_size[Y_POS] - graphic_frame[Y_POS] - @top_margin
        #     end
        #   end
        # end
        graphic.set_frame(graphic_frame)

        
        # recursive layout_member for child graphics
        if graphic.layout_expand.nil?
        else
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