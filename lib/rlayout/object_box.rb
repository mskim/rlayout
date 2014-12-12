#TODO
# 1.force fit first column first item, when it doesn't fit 

module RLayout
  
  # ObjectBox is general pulpose container of flowing objects.
  # ObjectBox has Columns. Objects flow along columns. 
  # ObjectBox can be linked to other ObjectBox, "next_link" and "previous_link" points to them.
  # When Text paragraphs flow, it acts as traditional TextBox.
  # ObjectBox handls other types of objects as well, such as 
  # product items, BoxAds, Directory elements, quiz items or any other graphic objects, 
  # that support flowing item protocol, namely "set_width_and_adjust_height"
  # one other flowing item protocol is :breakable?, whick tells whether the flowing item can be broken into parts.

  # Breakable item should split itself into two parts, if it can with no orphan or widow. 
  # TODO Currently I have parts as children graphics, but I should break it up into two.

  # ObjectBox adds another layer called "floats"
  # floats sit on top layer and pushes out text content underneath
  # Typocal floats are Heading, Image, Quates, SideBox
   
  class ObjectBox < Container
    attr_accessor :column_count, :next_link, :previous_link
    attr_accessor :starting_item_index, :ending_item_index
    attr_accessor :floats
    
    def initialize(parent_graphic, options={}, &block)
      super
      @klass = "ObjctBox"   
      @layout_direction = options.fetch(:layout_direction, "horizontal")
      @layout_space     = options.fetch(:layout_space, 5)
      @column_count     = options.fetch(:column_count, 3)
      create_columns(options)
      @floats           = options.fetch(:floats, [])
      if block
        instance_eval(&block)
      end
      
      @floats.each do |float|
        float.init_float
      end
      
      self
    end
    
    def create_columns(options={})
      column_options = {}
      column_options[:layout_space] = options.fetch(:item_space, 0)
      @column_count.times do
        ObjectColumn.new(self, column_options)
      end
      relayout!      
    end
    
    def toc_on?
      false
    end
    
    def is_toc_item?
      false
    end
    
    def document
      
    end
    
    def add_to_toc_list(item)
      if is_toc_item?(item)
        document.add_to_toc_list(item)
      end
    end
    
    # steps
    # 1. take out front_most_item from the array
    # 1. changes flowing objects width and height.
    # 1. proposed height is the available room
    # 1. place them in the column if it fits, 
    #    if it doen't fit, ask if we any part was inserted.
    #    if partilly_fit? go to next column and insert the left over to the next column
    # 1. if the last column is reached with un-placed item, place item back at the fornt of the array and return no
    # 1. if teh next column is available , repeat colum insert with partial item.
        
    def layout_items(flowing_items)
      column_index = 0
      current_column = @graphics[column_index]
      current_column.set_starting_position_at_non_overlapping_area
      while front_most_item = flowing_items.shift do
        result = current_column.insert_item(front_most_item)        
        if result == true
          # item fit into column successfully!
          #TODO
          add_to_toc_list(front_most_item) if toc_on?
        elsif result == false
          # item did not fit at all nothing fit
          column_index += 1
          if column_index == @column_count
            # we are finished for this ObjectBox
            # place back un-inserted item  in the front of the array
            #TODO
            flowing_items.unshift(front_most_item)
            return false
          else
            current_column = @graphics[column_index]
            current_column.set_starting_position_at_non_overlapping_area if current_column
            
            # This is the case where the item does not fit, even if this is the new empty column
            # For this case, force fit it into this column, since it is not going to fit anywhere.
            current_column.insert_item(front_most_item, :force_fit=>true)
          end
          
        else
            # second half of partial fit
            # relayout current column before going to the next
            current_column.relayout! 
            # go to next column
            column_index += 1
            if column_index == @column_count
              # place back un-inserted part  in the front of the array
              flowing_items.unshift(result)
              return false
            end
            current_column = @graphics[column_index]
            current_column.set_starting_position_at_non_overlapping_area
            if current_column.insert_item(result)
            else
              # force fit
              current_column.insert_item(result, :force_fit=>true)
            end
        end
      end
      # all item is placed!!! return true
      true
    end
    
    # adjust float sizes with object_box size change
    def relayout_floats!
      @floats.each do |float|
        #TODO adjust size with grid values
        float.width = text_rect[2]
        float.relayout!
      end
      
    end
  end
  
  
  
  class ObjectColumn < Container
    attr_accessor :current_position
    attr_accessor :floats
    
    def initialize(parent_graphic, options={}, &block)
      super
      @line_width = 1
      @line_color = "black"
      
      @klass = "ObjectColumn"
      @layout_space = options.fetch(:item_space, 0)
      @current_position = @top_margin + @top_inset
      if block
        instance_eval(&block)
      end
      self
    end
    
    # set @current_pasotion as start of non-overlapping y
    def set_starting_position_at_non_overlapping_area
      rect = non_overlapping_frame
      @current_position = rect[1] + @top_margin + @top_inset 
    end
    
    def insert_item(item, options={})
      item.parent_graphic = self
      new_frame = [0,0,0,0]
      new_frame[0] = @left_margin + @left_inset
      new_frame[1] = @current_position
      original_width = item.width
      original_height = item.height
      new_frame[2] = layout_area[0]
      #TODO
      # if item.is_breakable?   
      #   # puts " linked item was successfully inserted to column"     
      #   @current_position += item.height + @layout_space
      #   return true
      # end 
      room = @height - @current_position - @bottom_margin - @bottom_inset - @layout_space
      if item.image_object
        # if item is image, height should be proportional to image_object ratio, not frame width height ratio
        new_frame[3] = item.image_object_height_to_width_ratio*new_frame[2]
      else
        new_frame[3] = original_height/original_width*new_frame[2]
      end
      item.set_frame(new_frame)
      item.relayout! if item.kind_of?(Container)
      if item.height > room
        return false  
      else
        item.parent_graphic = self
        # set_frame triggers image re-adjusting
        @graphics << item
        @current_position += item.height
        return true  
      end
          
    end
    
  end
  
end