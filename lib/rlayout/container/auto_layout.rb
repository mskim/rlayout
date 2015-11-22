

module RLayout
  class Container < Graphic
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
      column_size         = [non_overlapping_frame[2], non_overlapping_frame[3]]
      starting_y          = non_overlapping_frame[1] # i need non_overlapping_bounds, not non_overlapping_frame
      current_position    = vertical ? (starting_y + @top_margin +  @top_inset) : (@left_margin + @left_inset)
      ending_position     = vertical ? (column_size[1] - @top_margin - @bottom_margin - @top_inset - @bottom_inset)  : (column_size[0] - @left_margin - @right_margin - @left_inset - @right_inset)
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
      if spacing_number > 0
        expandable_length -= spacing_number*@layout_space if @layout_space
        if layout_length_sum ==0
          unit_size    = expandable_length
        else
          unit_size    = expandable_length/layout_length_sum.to_f
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
         current_position = room/2.0
       when "bottom", "right"
         current_position = room
       when "justified"
         # we need different @layout_space for justified case
         @layout_space = room/spacing_number.to_f if spacing_number !=0
       end
      end
      ###### testing
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
            graphic_frame[3]  = graphic_dimension
          else
            graphic_frame[2]  = graphic_dimension
          end
        end
        graphic_dimension = vertical ? graphic_frame[3] : graphic_frame[2]
        # set current_position and update current_position
        if have_expanding_child
          if vertical            
            graphic_frame[1] = current_position             
            current_position += graphic_dimension + @layout_space
            current_position += graphic.bottom_margin + graphic.top_margin #if graphic.bottom_margin && graphic.top_margin 
          else
            graphic_frame[0] = current_position
            current_position += graphic_dimension + @layout_space
            current_position += graphic.left_margin + graphic.right_margin #if graphic.left_margin && graphic.right_margin
          end
        else
          # for non-expanding 
          if vertical
            graphic_frame[1] = current_position
            current_position += graphic.height + @layout_space
          else
            graphic_frame[0] = current_position
            current_position += graphic.width + @layout_space
          end           
        end
        # perpedicular alignment
        if (vertical ? graphic.expand_width? : graphic.expand_height?)
          # for vertical mode, align graphic in left, center, right
          if vertical
            graphic_frame[0]  = (@left_margin  + @left_inset)
            graphic_frame[2]  = column_size[0] - (@left_margin + @right_margin + @right_inset + @left_inset) #- graphic.right_margin - graphic.left_margin
          else
            graphic_frame[1]  = (@top_margin + @top_inset)
            graphic_frame[3]  = column_size[1] - (@top_margin + @bottom_margin + @top_inset + @bottom_inset) #- graphic.top_margin - graphic.bottom_margin
          end  
        end
        
        # layout alignment
        if vertical
          if @layout_alignment == 'justify' 
          
          
          
          elsif @layout_alignment == 'bottom'
          
          
          
          end
        else
          if @layout_alignment == 'justify' 
          
          
          
          elsif @layout_alignment == 'bottom'
          
          
          
          end
          
        end
        
        graphic.set_frame(graphic_frame)
        # recursive layout_member for child graphics
        if graphic.layout_expand.nil?
        else
         graphic.relayout! if graphic.kind_of?(Container)
        end
      end       
      @graphics.each do |graphic|
        graphic.update_shape
        graphic.update_grid if graphic.respond_to?(:update_grid)
      end
      # relayout @owner_graphic's text with new geometry
      # @text_record.update_text_fit if @text_record && @text_record.class ==  TextStruct
      @text_record.update_text_fit if @text_record && @text_record.class ==  text_layout_manager
      # adjust image with new geometry
      @image_record.apply_fit_type if @image_record
    end
    # self
  end  
  
  # layout_content! should be called to layout out content
  # after graphics positiona are settled from relayout!
  # text_box and table should respond and layout content
  def layout_content!
    return unless @graphics
    return if @graphics.length <= 0
    
    @graphics.each do |graphic|
      graphic.layout_content!
    end
  end
end