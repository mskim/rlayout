

module RLayout
  
  # TextBox is container of flowing paragraphs.
  # TextBox has Columns. Paragraphs flow along Columns. 
  # TextBox can be linek to other TextBox, "next_link" and "previous_link" points to them.
  # ObjectBox, a sister class. It handls other types of objects, such as 
  # product items, BoxAds, Directory elements, quiz items or any other graphic objects, 
  # that support flowing item protocol, namely "set_width_and_adjust_height"
  # one other flowing item protocol is :breakable?, whick tells whether the flowing item can be broken into parts.
  # Breakable item should split itself into two or more parts, if it can with no orphan or widow consideration. 
  # Currently, I break paragraph up into two at the oveflowing point in att_string.

  # TextBox adds another layer called "floats"
  # Floats sit on top layer and pushes out text content underneath it.
  # Typocal floats are Heading, Image, Quates, SideBox
  # Each float has its weight(float on top or push down), starting_posion, starting_column, width_in_column
  # Floats can be layed out with rules, or pre-design templates with profile.
  
  #TODO
  # 1. text box with overlapping floats on top, sometimes fully covered with hole in the middle of the column.
  # 1. flowing image alone the text. attached Math block, inline math
  # 1. Image that are floating and bleeding at the edge.
  # 1. Dropcap suppoert. Dropcap Image
   
  # align_body_text
  # If align_body_text is on, start body paragraphs on even numbered grid_rects only. 
  # so that body texts are horozontally aligned, across the columns
  #
  class TextBox < Container
    attr_accessor :heading, :heading_columns, :image, :side_box, :quote_box, :shoulder_column, :grid_size
    attr_accessor :starting_item_index, :ending_item_index
    attr_accessor :column_count, :next_link, :previous_link
    attr_accessor :floats, :align_body_text
    
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
        
    def width_of_column(columns)
      return 0 if columns==0
      if columns <= @graphics.length
        return max_x(@graphics[columns-1].frame_rect) - min_x(@graphics.first.frame_rect)
      end
      max_x(@graphics.last.frame_rect) - min_x(@graphics.first.frame_rect)
    end
        
    def create_column_grid_rects
      @graphics.each do |col|
        if col.class == "TextColumn"
          col.create_grid_rects
        end
      end
    end
    
    # set text_column's overlapping grid_rect area
    # this method is called after float is added and relayout!
    def set_overlapping_grid_rect
      @floats.each do |float|
        float_rect = float.frame_rect
        @graphics.each_with_index do |text_column, i|
          next if text_column.class != RLayout::TextColumn
          text_column.create_grid_rects unless text_column.grid_rects
          if intersects_rect(float_rect, text_column.frame_rect)
            text_column.mark_overlapping_grid_rects(float_rect,float.klass)
          end
        end
      end
    end
    
    # layout_items steps
    # 1. take out(shift) front_most_item from flowing_items array,
    #    and processed in the loop untill all items are consumed.
    # 2. call item.layout_text, which calles @text_layout_manager.layout_ct_lines for line layout.
    #   I pass two key/values as options, path and proposed_height.
    #   "proposed_height" is the height of path, and also the room(avilable space) of current column.
    #   @text_layout_manager.layout_ct_lines returns actual item height after line layout.
    #   Text overflow is detected by comparing "proposed_height" and returned actual height.
    #   if the result is greater than the prososed_height, text is overflowing.
    # 3. path is contructed by " def path_from_current_position"
    #   a. if column is simple with no overlapping floats, path is rectange.
    #   b. if column is complex with overlapping floats, path is constructed from grid_rects, with non-overlapping shapes.
    #   c. if column is complex and is discontinuous, I need to have multiple path for each of them.
    #   "path_from_current_position" handles all three cases. It return array of path.
    #   This is how I hanlde overlappings float on top of the text.
    #   Rather than using bezier cureve, I am using series of rects to simulate irregular shape.
    # 4. path is constructed from current position to the bottom of the column.     
    #   If we have a hole in the middle, fully_covered lines, we can still construct a single path including the coverd lines.
    #   My trick for solving this is to treat fully_covered lines as tall thin 5 point width rect on the right side.
    #   Those thin rectangles will not be able to containe any text, but able to form continuos path from currnet position to the bottom.
    # 5. place item in the column, if it fits(does not overflow). 
    #   placing item sets the y value of item and updates @current_position, and room
    #   if item has text_overflow, paragraph are splited the into two, at overflowing location.
    #   Insert first_half to current column and put the second_half of splited paragraph back to the flowing_items array, 
    #   and return true.
    #   I tred to insert overflowing second half to the next column, 
    #   but becase I don't know about next column, whether it is complex colimn.
    #   leave it to the next iteration to take care of it.
    #  
    def layout_items(flowing_items)
      column_index = 0
      current_column = @graphics[column_index]
      # puts "current_column.text_rect:#{current_column.text_rect}"
      # puts "current_column.frame_rect:#{current_column.frame_rect}"
      # puts "flowing_items.length:#{flowing_items.length}"
      # puts "frame_rect:#{frame_rect}"
      while item      = flowing_items.shift do
        if item.respond_to?(:layout_text)
          item.width  = current_column.text_width
          # puts "item.text_markup:#{item.text_markup}"
          # puts "item.text_string:#{item.text_string}"
          # puts "current_column.text_rect:#{current_column.text_rect}"
          # puts "current_column.room:#{current_column.room}"
          # puts "@current_column.current_position:#{current_column.current_position}"
          # "item underflow" case where there is no room at the bottom enven for a single line
          if current_column.room < current_column.body_line_height || current_column.room < item.text_line_height 
            puts "item underflow"
            column_index +=1
            if column_index < @column_count
              current_column = @graphics[column_index]
              flowing_items.unshift(item)
              next
            else
              flowing_items.unshift(item)
              return false
            end
          end
          current_column.update_current_position
          text_area_path  = current_column.path_from_current_position
          # puts "++++column_index:#{column_index}"
          bounding_rect = CGPathGetPathBoundingBox(text_area_path)
          current_column.current_position = bounding_rect.origin.y
          # puts "bounding_rect.size.height:#{bounding_rect.size.height}"
          # puts "bounding_rect.origin.y:#{bounding_rect.origin.y}"
          # puts "current_column:#{current_column}"
          height = item.layout_text(:proposed_path=>text_area_path) # item.width:
          # puts "height:#{height}"
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
        
        if !item.overflow?
          current_column.place_item(item)
        else 
          second_half = item.split_overflowing_lines
          current_column.place_item(item)
          column_index +=1
          if column_index < @column_count
            current_column = @graphics[column_index]   
            flowing_items.unshift(second_half)
          else
            # we are done with this text_box
            # insert second_half  back to the item list
            # current_column.relayout!
            flowing_items.unshift(second_half)
            return false
          end
        end

      end
      true
    end
    
    def grid_frame_to_frame_rect(grid_frame)
      return [0,0,100,100]          unless @graphics
      return [0,0,100,100]          if grid_frame.nil?
      return [0,0,100,100]          if grid_frame == ""
      grid_frame = eval(grid_frame) if grid_frame.class == String
      
      x_val = grid_frame[0]
      y_val = grid_frame[1]
      width_val = grid_frame[2]
      height_val = grid_frame[3]
      column_frame = @graphics.first.frame_rect
      column_width = column_frame[2]
      x= @graphics[x_val].x
      y = column_frame[1]
      width = column_width*width_val + (width_val - 1)*@layout_space
      height = width # TODO ?
      [x,y,width, height]
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