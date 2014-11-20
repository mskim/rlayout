#TODO
# 1.force fit first column first item, when it doesn't fit 

# The challenge is to have text box with overlapping floats on top
# And flowing image alone the text, and Dropcap suppoert
# I have tried this with TextLayoutManager with paragraph base on each paragraph
# I am have difficulty with irregular shaped float on top.

# I guess another way I should try is to have TexBox Based text system, as I had with TextRecord
# 1. Yet keep the paragraph datat as paragraph, and merge them into text_box attr string after calumating the height fot the column
# 1. OR I can try attached cell as flowing image and float on top?


module RLayout
  
  # TextBox is container of flowing paragraphs.
  # TextBox has Columns. Paragraphs flow along Columns. 
  # TextBox can be linek to other TextBox, "next_link" and "previous_link" points to them.
  # When Text paragraphs flow, it acts as traditional TextBox.
  # TextBox handls other types of objects as well, such as 
  # product items, BoxAds, Directory elements, quiz items or any other graphic objects, 
  # that support flowing item protocol, namely "set_width_and_adjust_height"
  # one other flowing item protocol is :breakable?, whick tells whether the flowing item can be broken into parts.

  # Breakable item should split itself into two parts, if it can with no orphan or widow. 
  # TODO Currently I have parts as children graphics, but I should break it up into two.

  # TextBox adds another layer called "floats"
  # floats sit on top layer and pushes out text content underneath
  # Typocal floats are Heading, Image, Quates, SideBox
   
  class TextBox < Container
    attr_accessor :heading, :heading_columns, :image, :side_box, :quote_box, :shoulder_column, :grid_size
    attr_accessor :starting_item_index, :ending_item_index
    attr_accessor :column_count, :next_link, :previous_link
    attr_accessor :floats
    
    def initialize(parent_graphic, options={}, &block)
      options[:line_width] = 5
      options[:line_color] = 'black'
      super
      @klass = "TextBox"         
      @layout_direction = options.fetch(:layout_direction, "horizontal")
      @layout_space     = options.fetch(:layout_space, 10)
      @column_count     = options.fetch(:column_count, 3)
      @heading_columns  = options.fetch(:heading_columns, @column_count)
      create_columns
      @floats           = options.fetch(:floats, [])
      
      @floats.each do |float|
        float.init_float
      end
      if block
        instance_eval(&block)
      end
      self
    end
    
    def heading_width
      unless @heading_columns
        return text_rect[WIDTH_VAL]
      end
      if @graphics.length <= 1
        text_rect[WIDTH_VAL]
      elsif @heading_columns >= @graphics.length
        text_rect[WIDTH_VAL]
      else
        max_x(@graphics[@heading_columns-1].frame_rect) #- text_rect[X_POS]
      end
    end
    
    def create_columns
      @column_count.times do
        TextColumn.new(self)
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
      @graphics.each do |col|
        # adjust columns to avoid overlapping with floats
        col.set_starting_position_at_non_overlapping_area
      end
      column_index = 0
      current_column = @graphics[column_index]
      while front_most_item = flowing_items.shift do
        result = current_column.insert_item(front_most_item)
        if result == true
          # item fit into column successfully!
          #TODO
          add_to_toc_list(front_most_item) if toc_on?
        elsif result == false
          column_index += 1
          if column_index == @column_count
            # we are finished for this TextBox
            # place back un-inserted item  in the front of the array
            #TODO
            flowing_items.unshift(front_most_item)
            return false
          else
            current_column = @graphics[column_index]            
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
        float.width = text_rect[WIDTH_VAL]
        float.relayout!
      end
      
    end
  end
  
  
  
  class TextColumn < Container
    attr_accessor :current_position
    attr_accessor :floats
    
    def initialize(parent_graphic, options={}, &block)
      super
      @klass = "TextColumn"
      @layout_space = 0
      @current_position = @top_margin + @top_inset
      if block
        instance_eval(&block)
      end
      self
    end
    
    # set @current_pasotion as start of non-overlapping y
    def set_starting_position_at_non_overlapping_area
      rect = non_overlapping_frame
      @current_position = rect[Y_POS] + @top_margin + @top_inset 
    end
    
    def insert_item(item, options={})
      item.parent_graphic = self
      item.y = @current_position
      item.x = @left_margin + @left_inset
      item.width = layout_area[0]
      room = @height - @current_position - @bottom_margin - @bottom_inset - @layout_space
      if item.class == RLayout::Image
        if item.image_object
          # if item is image, height should be proportional to image_object ratio, not frame width height ratio
          item.height = item.image_object_height_to_width_ratio*item.width
          item.apply_fit_type
        else
          item.height = item.width
        end
        if room >= item.height
          @graphics << item
          @current_position += item.height + @layout_space
          return true
        else
          #TODO might have to stick it back to paragraphi array? 
          return false
        end
      end
      
      if item.is_linked?   
        @graphics << item
        @current_position += item.height + @layout_space
        # still have to test if the lined fits?
        return true
      end      
      item.height = room
      item.layout_text(room) # layout_text
      
      if item.text_layout_manager.text_overflow == false
        @graphics << item
        @current_position += item.height + @layout_space
        return true
      else
        #check if text_underflow, any lines were created in the text_container
        if item.text_layout_manager.text_underflow
          return item
        # check if some was partialLy_inserted?
        elsif item.text_layout_manager.partialLy_inserted?
          # puts " item was partially inserted to column"
          @graphics << item
          @current_position += item.height + @layout_space
          return item.text_layout_manager.split_overflowing_paragraph
        end
      end
    end
    
  end
  
end