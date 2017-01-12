

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
  # Another example of breakable flowing object is Table.

  # TextColumn
  # TextColumn is columns used in TextBox.
  # TextColumn has line_grids.
  # Line_grids are used to calculate overlapping areas between flowing text and
  # floats on top
  # I am using line_grids, instead of BezierPath for text wrap around of ilregular shapes.
  # By have Line_grids of half the height of body text. This is good enough for text wrapping.
  # Line_grids are also useed for vertically aligning text across differnt columns.
  # We can force non-body paragraphs to spnap to line-grids.

  # TextBox adds another layer called "floats", (Containers also have floats)
  # Floats sit on top layer and pushes out text content underneath it.
  # Typocal floats are Heading, Image, Quates, SideBox
  # Each float has its weight(float on top or push down), starting_posion, starting_column, width_in_column
  # Floats can be layed out with rules, or pre-design templates with profile.
  # Floats default layout method is using Grid.

  # float_layout
  # float_layout markup is used to trigger a pre-definded float pattern for a page.
  # float_layout starts new page, so float_layout should be used at the begining of the page.
  # float_layout should have FLOAT_PATTERNS key and image_paths.
  # FLOAT_PATTERNS is used as lookup table.
  # FLOAT_PATTERNS has a key representing profile, and float frames as value.

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

FLOAT_NO_PUSH       = 0
FLOAT_PUSH_RECT     = 1
FLOAT_PUSH_SHAPE    = 2

# BREAKING_KIND = [RLayout::Paragraph, RLayout::Paragraph, RLayout::Table, ]

module RLayout
  class TextBox < Container
    attr_accessor :heading_columns, :quote_box, :grid_size
    attr_accessor :starting_item_index, :ending_item_index
    attr_accessor :column_count, :column_layout_space
    attr_accessor :next_link, :previous_link, :align_body_text
    attr_accessor :has_side_column, :left_side_column, :side_column
    attr_accessor :draw_gutter_stroke

    def initialize(options={}, &block)
      super
      @layout_direction = options.fetch(:layout_direction, "horizontal")
      @layout_space     = options.fetch(:layout_space, 10)
      @column_count     = options.fetch(:column_count, 1).to_i
      @column_layout_space = options.fetch(:column_layout_space, 0)
      @heading_columns  = options.fetch(:heading_columns, @column_count)
      @floats           = options.fetch(:floats, [])
      @has_side_column  = options.fetch(:has_side_column, false)
      @left_side_column = options.fetch(:left_side_column, false)
      @item_space       = options.fetch(:item_space, 30)
      @grid_size        = options[:grid_size]
      create_columns
      if options[:column_grid]
        create_column_grid_rects
      end

      if block
        instance_eval(&block)
      end
      if @floats.length > 0
        layout_floats!
        set_overlapping_grid_rect
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
          @side_column =
          TextColumn.new(:parent=>self, layout_length: 1, fill_color: 'lightGray')
          TextColumn.new(:parent=>self, layout_length: 3)
        else
          TextColumn.new(:parent=>self, layout_length: 3)
          @side_column = TextColumn.new(:parent=>self, layout_length: 1, fill_color: 'lightGray')
        end
      else
        @column_count.times do
          TextColumn.new(:parent=>self, layout_space: @column_layout_space)
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

    def page
      @parent_graphic
    end

    def page_index
      document.pages.index(@parent_graphic) if @parent_graphic
    end

    def empty?
      @graphics.first.graphics.length == 0
    end

    def add_to_toc_list(item)
      if is_toc_item?(item)
        document.add_to_toc_list(item)
      end
    end

    def heading(options={})
      options[:is_float]  = true
      options[:parent]    = self
      if @heading_columns != @column_count
        options[:width] = width_of_columns(@heading_columns)
      end
      h = Heading.new(options)
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
        return @graphics[columns - 1].x_max - @graphics.first.x
      end
      @graphics.last.x_max - @graphics.first.x
    end

    def create_column_grid_rects
      @graphics.each do |col|
        if col.class == "TextColumn"
          col.create_grid_rects
        end
      end
    end

    def justify_items
      @graphics.each do |column|
        column.justify_items
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
            text_column.mark_overlapping_grid_rects(float_rect,float.class)
          end
        end
      end
    end

    # layout_items steps
    # 0. Array of flowing_items are passed as parameter.
    # 1. front_most_item is taken out(shift) from flowing_items array,
    #    and layouted out. It is repeated untill all items are consumed.
    # 2. Paragraph Item's content is layed out in the column with column widht
    #    For simple and also for complex column, it is layout with avoiding overlapping float.
    #    @item.layout_lines(current_column)

    # 2. layout_lines is called for each Paragraph item.layout_lines calles @text_layout_manager.layout_lines for line layout.
    #   this is deprecated
    #   I pass two key/values as options, path?(this should be changed to passing grid_rect id) and proposed_height.
    #   "proposed_height" is the height of path, and also the room(avilable space) of current column.
    #   @text_layout_manager.layout_lines returns actual item height after line layout.
    #   Text overflow is detected by comparing "proposed_height" and returned actual height.
    #   if the result is greater than the prososed_height, text is overflowing.
    #   this is deprecated, I am now using grid_rects for detecting float overlapping.

    # 3. When we encounter floats, such as images or side_box,
    #    FLOAT_PATTERNS is looed up. and re do the layout.
    #    if we have room, go on, otherwise go to next page.
    #
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
      while @item  = flowing_items.shift do
        if @item.is_a?(Hash)
          #TODO add hash content to Heading
          if @item[:markup]
            next
          end
        # look for page heading and set content
        elsif @item.is_a?(RLayout::OrderedList) || @item.is_a?(RLayout::UnorderedList) || @item.is_a?(RLayout::OrderedSection) || @item.is_a?(RLayout::UpperAlphaList)
          # for List block insert list items to flowing_items
          while @item.graphics.length > 0
            list_item = @item.graphics.pop
            flowing_items.unshift(list_item)
          end
          next
        elsif @item.is_a?(RLayout::Paragraph)
          @item.layout_lines(current_column)
        elsif @item.is_a?(RLayout::ParagraphNSText) && @item.text_layout_manager
          # We have text
          @item.width  = current_column.text_width
          if current_column.room < current_column.body_line_height || current_column.room < @item.text_line_height
            # not enough room for even a line, no need to layout, go to next column
            column_index +=1
            if column_index < @column_count
              current_column = @graphics[column_index]
              flowing_items.unshift(@item)
              next
            else
              flowing_items.unshift(@item)
              return false
            end
          end
          @item.layout_lines(:proposed_height=>current_column.room) # item.width is set already

        elsif @item.class == RLayout::Table
          @item.width  = current_column.text_width
          @item.create_rows if @item.graphics.length == 0
          # given avalable room in column
          # layout rows into room. it can accomodate all rows or overflow
          @item.layout_rows(current_column.room)
        elsif @item.class == RLayout::FloatGroup
          @item.layout_page(document: document, page_index: page_index)
          unless @item.allow_text_jump_over
            # TODO
            # go to next
            #  "text jump over not allowed"
            # go to next page
          else
            #  "text jump over allowed"
          end
          next
        elsif @item.class == RLayout::ItemContainer
          # We have ItemContainer
          @item.width  = current_column.text_width
          @item.layout_expand  = [:width]
          # if item is image, height should be proportional to image_object ratio, not frame width height ratio
          @item.height = @item.image_object_height_to_width_ratio*@item.width
          @item.arrange_item
          if current_column.room < @item.height
            @item.underflow = true
          end

        elsif @item.class == RLayout::Image
          # We have image
          # check if the image is floating image, out of the column
          if @item.grid_frame #&& item.grid_frame[2]> 1
            # "we have floating image"
            @item.x      = current_column.width * @item.grid_frame[0]
            @item.x      += @gutter*(@item.grid_frame[0]-1) if @item.grid_frame[0] > 1
            @item.width  = current_column.width * @item.grid_frame[2] + @gutter*(@item.grid_frame[2]-1)
            grid_height = @height/@grid_base[1].to_f
            @item.y      = grid_height * @item.grid_frame[1]
            @item.height = grid_height * @item.grid_frame[3]
            if @item.bleed
              #TODO do bleeding on the edges
            end
            @floats << @item
            set_overlapping_grid_rect
          else
            # we have column running image
            @item.width  = current_column.text_width
            @item.layout_expand  = [:width]
            # if item is image, height should be proportional to image_object ratio, not frame width height ratio
            @item.height = @item.image_object_height_to_width_ratio*@item.width
            @item.apply_fit_type
            if @has_side_column
              #TODO set y position
              @side_column.graphics <<  @item if @side_column
            else
              if current_column.room < @item.height
                @item.underflow = true
              end
            end
            # check for overflow underflow
          end
        elsif @item.is_a?(EnglishQuizItem)
          unless  @item.q_line
            # this is un-layouted out EnglishQuizItem
            @item.layout_content(width: current_column.width)
          end
          if current_column.room < @item.height
            @item.overflow = true
          end

        elsif @item.is_a?(RLayout::QuizItem)
          @item.width  = current_column.text_width
          if current_column.room < @item.height
            @item.underflow = true
          else
            @item.set_content
          end
        elsif @item.class == RLayout::QuizRefText || @item.class == RLayout::QuizAnsText
          @item.width  = current_column.text_width
          if current_column.room < @item.height
            @item.underflow = true
          else
            @item.set_content
          end
        else
          @item.width  = current_column.text_width
          @item.height = @item.width
          if current_column.room < @item.height
            @item.underflow = true
          end
        end
        # now item is layed out with colum width, place them in the column
        # if @item.class != Paragraph

        if @item.respond_to?(:underflow?) && @item.underflow?

          # @item doesn't even fit a single line all
          # no need to split, go to next column
          column_index +=1
          @item.underflow = false
          if column_index < @column_count
            current_column = @graphics[column_index]
            flowing_items.unshift(@item)
            next
          else
            # "going to next page....................."
            flowing_items.unshift(@item)
            return false
          end
        elsif !@item.overflow? && !@item.underflow?
          current_column.place_item(@item)
        elsif @item.overflow? && @item.is_breakable?
          if @item.linked
            # @item is alread splited once so force fit to column
            current_column.place_item(@item)
          else
            second_half = @item.split_overflowing_lines
            current_column.place_item(@item)
          end
          column_index +=1

          if column_index < @column_count
            current_column = @graphics[column_index]
            flowing_items.unshift(second_half)
            next
          else
            # we are done with this text_box
            # insert second_half  back to the item list
            # current_column.relayout!
            flowing_items.unshift(second_half)
            return false
          end

        elsif !@item.is_breakable?
          if current_column.room < @item.height
            #  "not breakable and no room ++++++ "
            column_index +=1
            if column_index < @column_count
              current_column = @graphics[column_index]
              @item.overflow = false # clear oveflow flag
              flowing_items.unshift(@item)
              flowing_items.unshift(@item)
              next
            else
              #  "going to next page..."
              flowing_items.unshift(@item)
              return false
            end
          end
        end
      end
      true
    end

    def float_leading(options={})
      leading_options = {}
      frame_rect = grid_frame_to_image_rect(options[:grid_frame]) if options[:grid_frame]
      leading_options[:x]       = frame_rect[0]
      leading_options[:y]       = frame_rect[1]
      leading_options[:width]   = frame_rect[2]
      leading_options[:height]  = frame_rect[3]
      leading_options[:layout_expand]   = nil
      leading_options[:is_float]        = true
      leading_options[:parent]          = self
      Text.new(leading_options)
    end

    def float_quote(options={})
      quote_options = options.dup
      frame_rect = grid_frame_to_image_rect(options[:grid_frame]) if options[:grid_frame]
      quote_options[:x]       = frame_rect[0]
      quote_options[:y]       = frame_rect[1]
      quote_options[:width]   = frame_rect[2]
      quote_options[:height]  = frame_rect[3]
      quote_options[:layout_expand]   = nil
      quote_options[:is_float]        = true
      quote_options[:parent]          = self
      Quote.new(quote_options)
    end

    # place imaegs that are in the head of the story as floats
    def float_image(options={})
      image_options = {}
      image_options[:image_path] = "#{options[:image_path]}" if options[:image_path]
      image_options[:image_path] = "#{$ProjectPath}/images/#{options[:local_image]}" if options[:local_image]
      frame_rect              = grid_frame_to_image_rect([0,0,1,1])
      frame_rect              = grid_frame_to_image_rect(options[:grid_frame]) if options[:grid_frame]
      image_options[:x]       = frame_rect[0]
      image_options[:y]       = frame_rect[1]
      image_options[:width]   = frame_rect[2]
      image_options[:height]  = frame_rect[3]
      image_options[:layout_expand]   = nil
      image_options[:is_float]= true
      image_options[:parent]  = self
      @image                  = Image.new(image_options)
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

    def update_column_areas
      @graphics.each do |column|
        column.update_current_position
      end
    end

    def grid_frame_to_image_rect(grid_frame)
      return [0,0,100,100]    unless @graphics
      return [0,0,100,100]    if grid_frame.nil?
      return [0,0,100,100]    if grid_frame == ""
      return [0,0,100,100]    if grid_frame == []
      grid_frame          = eval(grid_frame) if grid_frame.class == String
      column_frame        = @graphics.first.frame_rect
      # when grid_frame[0] is greater than columns
      frame_x             = column_frame[0]
      if grid_frame[0] >= @graphics.length
        frame_x           = @graphics.last.x_max
      else
        # frame_x           = @grid_size[0]*grid_frame[0]
        frame_x           = @grid_size[0]*grid_frame[0] + (grid_frame[0])*@layout_space
      end
      frame_y             = @grid_size[1]*grid_frame[1]
      frame_width         = @grid_size[0]*grid_frame[2] + (grid_frame[2] - 1)*@layout_space
      frame_height        = @grid_size[1]*grid_frame[3] + (grid_frame[3] - 1)*@column_layout_space
      [frame_x, frame_y, frame_width, frame_height]
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
        # reset heading width
        @occupied_rects =[]
        if has_heading? && (@heading_columns != @column_count)
          heading = get_heading
          heading.width = width_of_columns(@heading_columns)
        end
        #TODO position bottom bottom_occupied_rects
        # middle occupied rect shoul
        @middle_occupied_rects = []
        @bottom_occupied_rects = []
        @floats.each_with_index do |float, i|
          next unless float.kind_of?(Image) || float.kind_of?(Heading)
          @float_rect = float.frame_rect
          if i==0
            @occupied_rects << float.frame_rect
          elsif intersects_with_occupied_rects?(@occupied_rects, @float_rect)
                # move to some place
                move_float_to_unoccupied_area(@occupied_rects, float)
                @occupied_rects << float.frame_rect
          else
            @occupied_rects << @float_rect
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
            float.y = max_y(occupied_rect) + 5
          end
        end
      end

      def non_overlapping_area(column_rect, float_rect, min_gap =10)
        if contains_rect(float_rect, column_rect)
          #  "float_rect covers the entire column_rect"
          return [0,0,0,0]
        elsif min_y(float_rect) <= min_y(column_rect) && max_y(float_rect) >= max_y(column_rect)
          #  "hole or block in the middle"
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
          #  "overlapping at the top "
          new_rect = column_rect.dup
          new_rect[1] = max_y(float_rect)
          new_rect[HEIGHT_VAL] -= float_rect[HEIGHT_VAL]
          return new_rect
        elsif max_y(float_rect) >= max_y(column_rect)
          #  "overlapping at the bottom "
          new_rect = column_rect.dup
          new_rect[HEIGHT_VAL] = min_y(float_rect)
          return new_rect
        end
      end
  end

  class TextBoxWithSide < TextBox
    def initialize(options={})

      self
    end
  end

end


FLOAT_PATTERNS = {
  "1/A1/1" => [[]],
  "1/A1/2" => [[]],
  "1/A1/3" => [[]],
  "1/A1/4" => [[]],
  "1/A1/5" => [[]],
  "1/A1/6" => [[]],
  "1/A1/7" => [[]],
  "1/A1/8" => [[]],
  "1/A1/9" => [[]],

  "2/A1_B1/1" => [[],[]],
  "2/A1_B1/2" => [[],[]],
  "2/A1_B1/3" => [[],[]],

  "2/A1_C1/1" => [[],[]],
  "2/A1_C1/2" => [[],[]],
  "2/A1_C1/3" => [[],[]],

  "2/B2/1" => [[],[]],
  "2/B2/2" => [[],[]],
  "2/B2/3" => [[],[]],

  "2/C2/1" => [[],[]],
  "2/C2/2" => [[],[]],
  "2/C2/3" => [[],[]],

  "3/A1_B2/1" => [[],[],[]],
  "3/A1_B2/2" => [[],[],[]],
  "3/A1_B2/3" => [[],[],[]],

  "3/A1_B2_C1/1" => [[],[],[]],
  "3/A1_B2_C1/2" => [[],[],[]],
  "3/A1_B2_C1/3" => [[],[],[]],

  "4/A1_B3/1" => [[],[],[],[]],
  "4/A1_B3/2" => [[],[],[],[]],
  "4/A1_B3/3" => [[],[],[],[]],

  "4/A1_B1_C2/1" => [[],[],[],[]],
  "4/A1_B1_C2/2" => [[],[],[],[]],
  "4/A1_B1_c2/3" => [[],[],[],[]],

  "4/A1_B2_C1/1" => [[],[],[],[]],
  "4/A1_B2_C1/2" => [[],[],[],[]],
  "4/A1_B2_C1/3" => [[],[],[],[]],

}
