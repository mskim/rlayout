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
      super
      @klass = "TextBox"               
      @layout_direction = options.fetch(:layout_direction, "horizontal")
      @layout_space     = options.fetch(:layout_space, 10)
      @column_count     = options.fetch(:column_count, 3)
      @heading_columns  = options.fetch(:heading_columns, @column_count)
      create_columns
      @floats           = options.fetch(:floats, [])
      if block
        instance_eval(&block)
      end
      self
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
    
    # def frame_from_grid(grid_frame)
    #   
    # end 
    # 
    # def orgin_from_grid(grid_frame)
    #   
    # end
    # 
    # def height_from_grid(grid_frame)
    #   
    # end
    
    def width_of_column(columns)
      return 0 if columns==0
      if columns <= @graphics.length
        return max_x(@graphics[columns-1].frame_rect) - min_x(@graphics.first.frame_rect)
      end
      max_x(@graphics.last.frame_rect) - min_x(@graphics.first.frame_rect)
    end
    
    def place_float_image(options={})
      @heading = @floats.first
      starting_y = 0
      starting_y += @heading.height if @heading
      options[:is_float]       = true
      starting_y               += options[:y] if options[:y]
      options[:y]              = starting_y  
      options[:adjust_height_to_keep_ratio]     = true
      @image  = Image.new(self, options) 
    end
    
    # place imaegs that are in the head of the story as floats
    def place_float_images(grid_width, grid_height, images)
        images.each do |image_options|
          image_frame = image_options[:image_frame]
          image_options[:width]       = grid_width*image_frame[2]
          image_options[:height]      = grid_height*image_frame[3]
          image_options[:layout_expand]  = nil
          place_float_image(image_options)
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
      @graphics.each do |g|
        g.set_starting_position_at_non_overlapping_area
      end
      column_index = 0
      current_column = @graphics[column_index]
      while item = flowing_items.shift do
        height = item.height
        if item.respond_to?(:layout_text)
          height = item.layout_text(current_column.text_width) # item.width:
        elsif item.class == RLayout::Image
          item.width  = current_column.text_width
          item.layout_expand  = [:width]
          if item.image_object
            # if item is image, height should be proportional to image_object ratio, not frame width height ratio
            item.height = item.image_object_height_to_width_ratio*item.width
            item.apply_fit_type
          else
            item.height = item.width
          end
        end
        
        if current_column.can_fit?(height)
          current_column.place_item(item)
        elsif item.can_split_at?(current_column.room)
          second = item.split_at(current_column.room)
          current_column.place_item(item)
          # current_column.relayout!
          column_index +=1
          if column_index < @column_count
            current_column = @graphics[column_index]            
            current_column.place_item(second)
          else
            # we are done with this text_box
            # insert second half back to the item list
            # current_column.relayout!
            flowing_items.unshift(second)
            return false
          end
        else  # was not able to split the item          
          column_index +=1
          if column_index < @column_count
            current_column = @graphics[column_index]            
            #insert item to next column
            #TODO this is forcing insert, to the new column
            # I should refine this for long item that might extent beyond next column.
            current_column.place_item(item)
          else
            # current_column.relayout!
            flowing_items.unshift(item)
            return false
          end
        end
      end
      # current_column.relayout!
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
    
    def text_width
      text_rect[WIDTH_VAL]
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
      item.x              = @left_inset
      item.y              = @current_position
      @current_position += item.height + @layout_space
    end
  end
  
  # ImageColumn has two columns within Column. 
  # One for image and other one for text.
  # This is used when flowing image with half size flows along the text.
  # ImageColumn divide or pushes main colum  when it is created depending on where is is placed.
  # it 
  class ImageColumn < Container
    attr_accessor :image, :text_column
    def initialize(paranet_graphic, options={})
      options[:layout_direction] = 'horizontal'      
      super
      Image.new(self)
      TextColumn.new(self)
      relayout!
      self
    end
  end
  
end