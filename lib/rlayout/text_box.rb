
FLOAT_NO_PUSH       = 0
FLOAT_PUSH_RECT     = 1
FLOAT_PUSH_SHAPE    = 2

module RLayout

  # TextBox is container of flowing paragraphs.
  # TextBox has columns(TextColumn). Paragraphs flow along TextColumn.
  # TextBox can be linked to other TextBoxs, "next_link" and "previous_link" points to them.
  # ObjectBox, a sister class, handls other types of objects, such as
  # flowing product items, Images, BoxAds, Directory elements, quiz items or any other graphic objects other than paragraphs,
  # Both of the class support flowing item protocol, namely "set_width_and_adjust_height", 
  # to adjust flowing items into different size columns.
  # They also support :breakable?, which tells whether the flowing item can be broken into parts.
  # Breakable item should split itself into two or more parts, it brakes with  orphan/widow consideration.
  # Currently, Paragraph can be broken up into two parts at the oveflowing column.
  # Another example of breakable flowing object is a Table.
  
  # TextBox adds another layer called "floats", (Containers also have floats)
  # Floats sit on top layer and pushes out text content underneath it.
  # Typocal floats are Heading, Image, Quates, SideBox
  # Each float has its weight(float on top or push down), starting_posion, starting_column, width_in_column
  # Floats can be layed out with rules, or pre-design templates with profile.
  # Floats default layout method is using Grid.

  # TextColumn
  # TextColumn is columns used in TextBox.
  # TextColumn has line_grids.
  # Line_grids are used to calculate overlapping areas between flowing text and
  # floats on top
  # I am using line_grids, instead of BezierPath for text wrap around of ilregular shapes.
  # By have Line_grids of half the height of body text. This is good enough for text wrapping.
  # Line_grids are also useed for vertically aligning text across differnt columns.
  # We can force non-body paragraphs to spnap to line-grids.
  
  # side_column
  # side_column is used when we have flowing images along side paragraphs
  # side_column can be place on the right or left side of TextBox
  
  #TODO
  # 1. text box with overlapping floats on top, sometimes fully covered with hole in the middle of the column.
  # 1. flowing image alone the text. attached Math block, inline math
  # 1. Image that are floating and bleeding at the edge.
  # 1. Dropcap suppoert. Dropcap Image
  # 1. side_column
  
  # align_body_text
  # If align_body_text is on, start body paragraphs on even numbered grid_rects only.
  # so that body texts are horozontally aligned, across the columns
  # We have grid_rects with height 1/2 of body text height.
  
  # laying out running float images
  # This is when we have images that are larger than the column width and floating.
  # We need to sit them, rearrange floats, and adjust other items
  
  # add text_path option, for importing marddown text at the time.
  
  # side_column image markup??
  # ![] {}
  # side_column text markup??
  # ![] 
  
  
  class TextBox < Container
    attr_accessor :heading_columns, :quote_box, :grid_size
    attr_accessor :starting_item_index, :ending_item_index
    attr_accessor :column_count, :next_link, :previous_link, :align_body_text
    attr_accessor :has_side_column, :left_side_column, :side_column
    
    def initialize(parent_graphic, options={}, &block)
      @grid_base        = options.fetch(:grid_base, '3x3')
      super
      @klass            = "TextBox"
      @layout_direction = options.fetch(:layout_direction, "horizontal")
      @layout_space     = options.fetch(:layout_space, 10)
      @column_count     = options.fetch(:column_count, 1).to_i
      @heading_columns  = options.fetch(:heading_columns, @column_count)
      @floats           = options.fetch(:floats, [])
      @has_side_column  = options.fetch(:has_side_column, false)
      @left_side_column = options.fetch(:left_side_column, false)
      create_columns
      if options[:column_grid]
        create_column_grid_rects
      end
      
      if block
        instance_eval(&block)
      end      
      self
    end
    
    def modify(&block)
      if block
        instance_eval(&block)
      end
    end
    
    def create_columns
      if @has_side_column
        @column_count = 2
        if @left_side_column
          @side_column = TextColumn.new(self, layout_length: 1, fill_color: 'lightGray')
          TextColumn.new(self, layout_length: 3)
        else
          TextColumn.new(self, layout_length: 3)
          @side_column = TextColumn.new(self, layout_length: 1, fill_color: 'lightGray')
        end
      else
        @column_count.times do
          TextColumn.new(self)
        end
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
      @parent_graphic.document if @parent_graphic
    end

    def add_to_toc_list(item)
      if is_toc_item?(item)
        document.add_to_toc_list(item)
      end
    end
    
    def heading(options={})
      options[:is_float] = true
      h = Heading.new(self, options)
      unless h== @floats.first
        # make heading as first one in floats
        h = @floats.pop
        @floats.unshift(h)
      end      
    end
    
    # does current text_box include Heading in floats
    def has_heading?
      @floats.each do |float|
        return true if float.class == RLayout::Heading
      end
      false
    end
    
    def get_heading
      @floats.each do |float|
        return float if float.class == RLayout::Heading
      end
      nil
    end
    
    def has_leading_box?
      @floats.each do |float|
        return true if float.tag == "leading"
      end
      false
    end
    
    def has_quote_box?
      @floats.each do |float|
        return true if float.tag == "quote"
      end
      false
    end
    
    # sum of width columns width including gaps
    def width_of_columns(columns)
      return 0 if columns==0
      if columns <= @graphics.length
        return (@graphics.last.frame_rect)[2] + (@graphics.last.frame_rect)[0] - (@graphics.first.frame_rect)[0]
      end
      (@graphics.last.frame_rect)[2] + (@graphics.last.frame_rect)[0] - (@graphics.first.frame_rect)[0]
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
    # 0. Array of flowing_items are passed as parameter.
    # 1. front_most_item is taken out(shift) from flowing_items array,
    #    and layouted out untill all items are consumed.
    # 2. layout_text is called for each item. layout_text calles @text_layout_manager.layout_text_lines for line layout.
    #   I pass two key/values as options, path?(this should be changed to passing grid_rect id) and proposed_height.
    #   "proposed_height" is the height of path, and also the room(avilable space) of current column.
    #   @text_layout_manager.layout_text_lines returns actual item height after line layout.
    #   Text overflow is detected by comparing "proposed_height" and returned actual height.
    #   if the result is greater than the prososed_height, text is overflowing.
    #   this is deprecated, I am now using grid_rects for detecting float overlapping.
 
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
    #   if item has text_overflow, paragraph are splited into two, at overflowing location.
    #   Insert first_half to current column and put the second_half of splited paragraph back to the flowing_items array,
    #   and return true.
    #   I tred to insert overflowing second half to the next column,
    #   but becase I don't know about next column, whether it is complex colimn.
    #   leave it to the next iteration to take care of it.
    #
    
    # layout paragraphs into columns
    def layout_items(flowing_items)
      column_index = 0
      current_column = @graphics[column_index]
      while item      = flowing_items.shift do
        if item.text_layout_manager
          # We have text
          item.width  = current_column.text_width
          if current_column.room < current_column.body_line_height || current_column.room < item.text_line_height
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
          #TODO????
          # check if current column is simple
          # text_area_path  = current_column.path_from_current_position
          # bounding_rect = CGPathGetPathBoundingBox(text_area_path)
          # current_column.current_position = bounding_rect.origin.y
          # item.layout_text(:proposed_path=>text_area_path) # item.width:
          item.layout_text(:proposed_height=>current_column.room) # item.width is set already
        elsif item.class == RLayout::Image
          # We have image
            # check if the image is floating image, out of the column
            if item.grid_frame #&& item.grid_frame[2]> 1
              # "we have floating image"
              item.x      = current_column.width * item.grid_frame[0]
              item.x      += @gutter*(item.grid_frame[0]-1) if item.grid_frame[0] > 1
              item.width  = current_column.width * item.grid_frame[2] + @gutter*(item.grid_frame[2]-1)
              # puts "@grid_base:#{@grid_base}"
              # puts "@gutter:#{@gutter}"
              # puts "item.grid_frame:#{item.grid_frame}"
              # puts "current_column.width:#{current_column.width}"
              # puts "item.width:#{item.width}"
              grid_height = @height/@grid_base[1].to_f
              item.y      = grid_height * item.grid_frame[1]              
              item.height = grid_height * item.grid_frame[3]
              if item.bleed
                #TODO do bleeding on the edges
              end
              @floats << item
              # push out paragraphs 
              set_overlapping_grid_rect
              #TODO
              # I need to redo layout_items
              
            else
              # we have column running image
              item.width  = current_column.text_width
              item.layout_expand  = [:width]
              # if item is image, height should be proportional to image_object ratio, not frame width height ratio
              item.height = item.image_object_height_to_width_ratio*item.width
              item.apply_fit_type
              if @has_side_column
                #TODO set y position
                @side_column.graphics <<  item if @side_column
              end
            end
        elsif item.class == RLayout::QuizItem
          item.width  = current_column.text_width
          item.height = item.width
          item.set_quiz_content_with_width(:width=> current_column.text_width)
        elsif item.class == RLayout::QuizRefText # GeeMoon
          item.width  = current_column.text_width
          item.height = item.width
        else
          item.width  = current_column.text_width
          item.height = item.width
        end
        
        if !item.respond_to?(:overflow?)
          current_column.place_item(item)
        elsif !item.overflow? # item fits in column
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
    
    # place imaegs that are in the head of the story as floats
    def float_image(options)
      image_options = {}
      image_options[:image_path] = "#{options[:image_path]}" if options[:image_path]
      image_options[:image_path] = "#{$ProjectPath}/images/#{options[:local_image]}" if options[:local_image]
      frame_rect = grid_frame_to_frame_rect(options[:grid_frame]) if options[:grid_frame]
      image_options[:x]       = frame_rect[0]
      image_options[:y]       = frame_rect[1]
      image_options[:width]   = frame_rect[2]
      image_options[:height]  = frame_rect[3]
      image_options[:layout_expand]   = nil
      image_options[:is_float]        = true
      @image  = Image.new(self, image_options)   
    end
    
    def float_images(images)
      if images.class == Array
        images.each do |image_info|
          float_image(image_info)
        end
      elsif images.class == Hash
        float_image(images)
      end
    end
    
    def grid_frame_to_frame_rect(grid_frame)
      return [0,0,100,100]          unless @graphics
      return [0,0,100,100]          if grid_frame.nil?
      return [0,0,100,100]          if grid_frame == ""
      grid_frame    = eval(grid_frame) if grid_frame.class == String
      width_val     = grid_frame[2]
      column_frame  = @graphics.first.frame_rect
      column_width  = column_frame[2]
      x             = @graphics[grid_frame[0]].x
      y             = column_frame[1]
      width         = column_width*width_val + (width_val - 1)*@layout_space
      height        = width 
      [x,y,width, height]
    end

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
      

  end
  
  class TextBoxWithSide < TextBox
    def initialize(parent_graphic, options={})
      
      self
    end
    
    
  end

end
