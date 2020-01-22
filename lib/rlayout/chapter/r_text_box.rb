
# NewsArticleBox
# grid_frame is passed to detemine the width, height, and column_number of text_box
# Used when creating newspaper article, called from NewsBoxMaker

# show_overflow_lines
#
# 1. create NewsArticleBox
# 1. generate columns
#   1. create_lines
# 1. generate floats and layout floats
#   1. mark lines that over lapping floats
# 4.5*28.34646 = 12.755907
# 15*28.34646 = 425.1969

# QUOTE_BOX_SPACE_BEFORE = 2

module RLayout
  class RTextBox < Container
    attr_accessor :heading_columns, :fill_up_enpty_lines
    attr_accessor :current_column, :current_column_index, :overflow, :underflow, :empty_lines
    attr_accessor :heading, :subtitle_box, :subtitle_in_head, :quote_box, :quote_box_size, :personal_image, :news_image
    attr_accessor :column_count, :column_width, :starting_column_x, :gutter, :column_bottom
    attr_accessor :page_number, :char_count, :gutter

    def initialize(options={}, &block)
      # options[:stroke_width] = 1
      super
      @overflow               = false
      @column_count           = options[:column] || options[:column_count] || 1
      @starting_column_x      = @left_margin
      @gutter                 = options[:gutter] || 10
      @column_width           = (@width - (@column_count - 1)*@gutter)/@column_count
      @page_number            = options[:page_number]
      @current_column_index   = 0
      @heading_columns        = @column_count
      @fill_up_enpty_lines    = options[:fill_up_enpty_lines] || false
      @quote_box_size         = options[:quote_box_size] || 0
      @body_line_height       = options[:body_line_height] || 24
      create_columns
      if block
        instance_eval(&block)
      end
      if @floats.length > 0
        layout_floats!
      end
      self
    end

    def relayout!
      adjust_column_lines
    end

    def add_new_page
      @parent.add_new_page
    end

    def first_line
      @graphics.first.graphics.first
    end

    # create news_columns
    #  news_columns are different from text_column
    def create_columns
      current_x = @starting_column_x
      column_height = @height
      @column_count.times do
        g= RColumn.new(:parent=>nil, x: current_x, y: 0, width: @column_width, height: column_height, body_line_height: @body_line_height, article_bottom_spaces_in_lines: @article_bottom_spaces_in_lines)
        g.parent = self
        @graphics << g
        current_x += @column_width + @gutter
      end
      @column_bottom = max_y(@graphics.first.frame_rect)
      link_column_lines
    end

    def adjust_column_lines
      @graphics.each do |col|
        col.height = @height
        col.adjust_column_lines
      end
    end

    def link_column_lines
      previous_column_last_line = nil
      @graphics.each do |column|
        first_line                          = column.graphics.first
        last_line                           = column.graphics.last
        previous_column_last_line.next_line = first_line if previous_column_last_line
        previous_column_last_line           = last_line
      end

    end

    def is_top_story?
      @top_story
    end

    # # create lines that are adjusted for overflapping floats
    # # This is called after floats are layoued out.
    # def create_column_lines
    def overlapping_floats_with_column(column)
      overlapping_floats = []# IDEA: ndi
      @floats.each do |float|
        overlapping_floats << float if intersects_rect(column.frame_rect, float.frame_rect)
      end
      overlapping_floats
    end

    # adjust overlapping line_fragment text area
    # this method is called when float positions have changed
    def adjust_overlapping_columns
      @graphics.each_with_index do |column, i|
        overlapping_floats = overlapping_floats_with_column(column)
        column.adjust_overlapping_lines(overlapping_floats)
      end
    end

    def average_characters_per_line
      @graphics.first.average_characters_per_line
    end

    def suggested_number_of_characters
      #TODO
      article_box_lines_count*average_characters_per_line
    end

    def article_box_character_count
      character_count = 0
      @graphics.each_with_index do |column, i|
        character_count += column.char_count
      end
      character_count
    end

    def article_box_unoccupied_lines_count
      if @kind == '사설' || @kind == 'editorial'
        return @graphics[0].unoccupied_lines_count
      end
      unoccupied_lines_count = 0
      @graphics.reverse.each do |column_from_last|
        break if column_from_last.graphics.last.layed_out_line?
        unoccupied_lines_count += column_from_last.unoccupied_lines_count
      end
      unoccupied_lines_count
    end

    def article_box_lines_count
      available_lines = 0
      @graphics.each_with_index do |column, i|
        lines = column.available_lines_count
        available_lines += lines
      end
      available_lines
    end

    def save_article_info
      article_info                      = {}
      article_info[:column]             = @column_count
      article_info[:row]                = @row_count
      article_info[:is_front_page]      = @is_front_page
      article_info[:top_story]          = @top_story
      article_info[:top_position]       = @top_position
      article_info[:extended_line_count]= @extended_line_count if @extended_line_count
      article_info[:pushed_line_count]  = @pushed_line_count if @pushed_line_count
      article_info[:quote_box_size]     = @quote_box_size

      if @underflow
        # if we have author image at the bottom from layout
        @empty_lines -= 6 if @news_image
        article_info[:empty_lines]            = @empty_lines
      elsif @overflow
        # article_info[:overflow]              = true
        article_info[:overflow_line_count]    = @overflow_column.layed_out_line_count
        article_info[:overflow_text]          = overflow_text
      else
        # article_info[:lines_count]            = article_box_lines_count
        # article_info[:current_characters]     = article_box_character_count
        # article_info[:suggested_characters]   = suggested_number_of_characters
        # article_info[:needed_chars]           = suggested_number_of_characters - article_box_character_count
      end
      info_path = "#{$ProjectPath}/article_info.yml"
      File.open(info_path, 'w'){|f| f.write article_info.to_yaml}
    end

    def count_chars
      #code
    end

    def overflow_text
      return @overflow_column.overflow_text #if @over_flow
      ""
    end

    def first_text_line
      @graphics.each do |column|
        line = column.first_text_line_in_column
        return line if line
      end
      @overflow_column.graphics.first
    end

    def save_appened_story
      #code
    end


    def layout_items(flowing_items, options={})
      current_line = first_text_line
      while @item = flowing_items.shift do
        current_line = @item.layout_lines(current_line)
      end
      @current_column  = current_line.column
      @overflow  = true if @overflow_column.graphics.first.layed_out_line?
      if @overflow

      else
        @empty_lines    = article_box_unoccupied_lines_count
        @underflow      = true if @empty_lines > 0
      end
      unless @fill_up_enpty_lines
        save_article_info
      end
    end

    # make heading as float
    def make_article_heading(options={})
      @is_front_page            = options['is_front_page'] || options[:is_front_page]
      @top_story                = options['top_story'] || options[:top_story]
      @top_position             = options['top_position'] || options[:top_position]
      @subtitle_in_head         = options['subtitle_in_head'] || options[:subtitle_in_head]

      h_options = options.dup
      h_options[:is_float]      = true
      h_options[:parent]        = self
      h_options[:width]         = @width # - @gutter
      h_options[:column_count]  = @column_count
      # h_options[:x]             = @starting_column_x
      h_options[:x]             = 0
      h_options[:y]             = 0

      if @heading_columns       != @column_count
        h_options[:width]       = @heading_columns*@column_width + @gutter*(@heading_columns - 1)
      end
      case @kind
      when 'editorial', "사설"
        @stroke[:sides] = [1,1,1,1]
        @stroke.thickness = 0.3
        h_options[:x]     += @left_inset
        h_options[:width] -= (@left_margin + @left_inset + @right_margin + @right_inset)
        @heading = NewsHeadingForEditorial.new(h_options)
      when 'opinion', "기고"
        @stroke[:sides] = [0,1,0,1]
        @stroke.thickness = 0.3
        h_options[:x]     += @left_margin + @column_width + @gutter
        h_options[:y]     = 2
        h_options[:width] -= (h_options[:x] + @right_inset + @right_margin )
        @heading = NewsHeadingForOpinion.new(h_options)
      else
        @stroke[:sides] = [0,0,0,1]
        @stroke.thickness = 0.3
        # @stroke.color = 'red'
        @heading = NewsHeadingForArticle.new(h_options)
      end
      # check if we have page_heading_place_holder
      # put heading after page_heading_place_holder
      if @page_heading_place_holder
        unless @heading == @floats[1]
          # make heading as second one in floats
          @heading = @floats.pop
          @floats.insert(1,@heading)
        end
      else
        unless @heading == @floats.first
          # make heading as first one in floats
          @heading = @floats.pop
          @floats.unshift(@heading)
        end
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
        return float if float.class == RLayout::NewsHeadingForArticle || float.class == RLayout::NewsHeadingForOpinion || float.class == RLayout::NewsHeadingForEditorial
      end
      nil
    end

    def get_image
      @floats.each do |float|
        return float if float.class == RLayout::Image
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

    def make_floats(heading_hash)
      # don't create another subtitle, if it is top_story, It is created by heading
      if !@top_story && heading_hash['subtitle'] && heading_hash['subtitle'] != ""
        float_subtitle(heading_hash['subtitle'])
      end

      if heading_hash['personal_image']
        float_personal_image(heading_hash)
      end

      if heading_hash['quote']
        hash = {}
        float_quote(heading_hash)
      end
      #
      # if heading_hash['image']
      #   float_image(heading_hash)
      # end
      layout_floats!
    end

    # text_height_in_lines should be calculated dynamically
    def float_subtitle(subtitle_string)
      options = {}
      options[:style_name] = 'subtitle_S'

      if @column_count > 3
        options[:style_name] = 'subtitle_M'
      end
      options[:text_string]   = subtitle_string
      options[:text_fit_type] = 'adjust_box_height'
      # options[:body_line_height] = @body_line_height
      options[:x]             = @starting_column_x
      options[:y]             = 0
      options[:top_inset]     = 0 if options[:space_before_in_lines] == 0
      # options[:grid_frame]    = [0,0,1,0.5]
      options[:width]         = @column_width
      options[:layout_expand] = nil
      options[:is_float]      = true
      options[:parent]        = self
      #TODO put top_margin and bottom_margin
      TitleText.new(options)
    end

    def float_quote(options={})
      return if @quote_box_size == '0'
      #TODO handle case when quote_box_size if type as 2x3
      text_height_in_lines  = @quote_box_size.to_i
      box_height        = (text_height_in_lines + QUOTE_BOX_SPACE_BEFORE)*@body_line_height
      # box_height += QUOTE_BOX_SPACE_BEFORE*@body_line_height
      y                 = @height - box_height - @article_bottom_spaces_in_lines*@body_line_height
      x                 = 0 #TODO
      text_options           = {}
      if @kind == '기고' || @kind == 'opinion'
        text_options[:x]       = x
        # text_options[:space_before_in_lines]  = text_height_in_lines
        # text_options[:text_height_in_lines]  = text_height_in_lines
        text_options[:height] = box_height
        text_options[:y]       = y
        text_options[:width]   = @grid_width*2 - @gutter
        text_options[:left_margin]   = 3
        text_options[:right_margin]  = 3
        # text_options[:stroke_width]  = 1
      else
        text_options[:x]       = @grid_width*1 + @gutter
        text_options[:height]  = @body_line_height*3
        text_options[:y]       = @height - options[:height] if options[:height]
        text_options[:width]   = @grid_width*2 + @gutter
      end

      text_options[:quote_text_lines]= text_height_in_lines
      text_options[:layout_expand]   = nil
      text_options[:is_float]        = true
      text_options[:text_string]     = options['quote']
      text_options[:style_name]      = 'quote'
      text_options[:parent]          = self
      # text_options[:stroke_width]    = 1
      text_options[:v_alignment]            = 'bottom'
      text_options[:height]                 = box_height
      @quote_box = QuoteText.new(text_options)
      @quote_box.y = @height - @quote_box.height - @article_bottom_spaces_in_lines*@body_line_height

    end

    def float_personal_image(options={})
      options = options.dup
      frame_rect = grid_frame_to_rect(options[:grid_frame]) if options[:grid_frame]
      options[:x]       = frame_rect[0]
      options[:y]       = frame_rect[1]
      options[:width]   = frame_rect[2]
      options[:height]  = frame_rect[3]
      options[:layout_expand]   = nil
      options[:is_float]        = true
      options[:parent]          = self
      Quote.new(options)
    end

    # Use news_image instead of float_image
    def news_image(options={})
      options[:parent]    = self
      options[:is_float]  = true
      @news_image         = NewsImage.new(options)
    end

    def news_column_image(options={})
      options[:parent]    = self
      options[:is_float]  = true
      @news_image         = NewsColumnImage.new(options)
    end

    def grid_frame_to_rect(grid_frame, options={})
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
        frame_x           = @graphics[grid_frame[0]].x
      end
      frame_y             = @grid_size[1]*grid_frame[1]
      index = (grid_frame[0] + grid_frame[2] - 1).to_i
      if @graphics[index]
        frame_width         = @graphics[index].x_max - frame_x
      else
        frame_width         = @graphics[0].x_max - frame_x
      end
      frame_height        = @grid_size[1]*grid_frame[3]

      # if image is on bottom, move up by @article_bottom_spaces_in_lines*@body_line_height
      if (grid_frame[1] + grid_frame[3]) == @row_count
        frame_height      -= @article_bottom_spaces_in_lines*@body_line_height
        # frame_y             = @grid_size[1]*grid_frame[1] - @article_bottom_spaces_in_lines*@body_line_height
      end
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
    # for article_box with bottom space,
    def layout_floats!
      return unless @floats
      # reset heading width
      @occupied_rects =[]
      if has_heading? && (@heading_columns != @column_count)
        heading = get_heading
        heading.width = @column_width
        heading.x     = @starting_column_x
      end
      #TODO position bottom bottom_occupied_rects
      # middle occupied rect shoul
      @middle_occupied_rects = []
      @bottom_occupied_rects = []
      @floats.each_with_index do |float, i|
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
          float.y = max_y(occupied_rect) + 0
          if max_y(float.frame_rect) > @column_bottom
            float.height = @column_bottom - float.y
            float.adjust_image_height if float.respond_to?(:adjust_image_height)
          end
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

    def border_x
      return @x  if @on_left_edge
      @x + @gutter
      @x + @left_margin

    end

    def border_width
      width = @width
      width -=@left_margin #unless @on_left_edge
      width -=@right_margin #unless @on_right_edge
      width
    end

  end

end
