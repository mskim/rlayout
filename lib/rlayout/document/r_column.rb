module RLayout

  # RColumn
  # RColumn is covered with series of "LineFragment".
  # Unlike TextColunm, "LineFragments" are used to determine the shapes of text layout area, to avoid text from overlapping floats.
  # Complex_rect means column has overlapping graphic.
  # We need non-rectanglar shaped bezier path to flow text.
  # But rather than using bezeier curve, simulate it using "LineFragments".
  # sing seris of LineFragments class rects to determin the shape of text flowing region.
  # Finer the GridRect, closer it gets to bezier curve. I am using half body_text_height sized rect.
  # Half of body text height should be suffient for text layout.
  # If align_body_text is set to "true", body text are aligned by starting the body paragraph at odd numbered grid.
  # If all body text starts at even numbered grids, this will horozontally alignment body text across the columns.

  # body_line_height
  # line_height = body_style[:font_size] # default line_height, set to font_size*1.3
  # @body_line_height = (line_height + body_style[:text_line_spacing])

  # article_bottom_space_in_lines
  # this is used for intensionally putting emtype space at the bottom of the columns.
  # some newspapder articles use it as such.

  # add FootnoteBox
  # empty FootnoteBox is created when creaing RColumn
  # footnote item is added to FootnoteBox as paragraph is layed out.
  # FootnoteBox grows from bottom to top as footnote item is added
  # 
  class RColumn < Container
    attr_accessor :current_position, :current_grid_index
    attr_accessor :line_count, :current_line_index, :current_line
    attr_accessor :grid_rects, :body_line_height
    attr_accessor :complex_rect, :align_body_text, :show_grid_rects
    attr_accessor :article_bottom_space_in_lines
    attr_accessor :column_type, :empty_lines
    attr_reader  :left_side_bar, :right_side_bar
    attr_reader :footnote_box

    def initialize(options={}, &block)
      options[:width]     = 200 unless options[:width]
      options[:height]    = 500 unless options[:height]
      # options[:stroke_width] = 1.0
      # options[:stroke_width] = 1
      super
      @footnote_box = FootnoteBox.new(parent:self, width: @width, y: @height + 10, height: 0, is_float: true,  fill_color: 'clear')
      @left_side_bar = options[:left_side_bar] 
      @right_side_bar = options[:right_side_bar] 
      @empty_lines          = options[:empty_lines] || false
      @column_type          = options[:column_type] || 'regular_column'
      @current_line_index   = 0
      @article_bottom_space_in_lines  = options[:article_bottom_space_in_lines] || 0
      if options[:column_line_count]
        @line_count = options[:column_line_count]
        @body_line_height = ((@height - @top_margin - @bottom_margin)/@line_count)
      elsif options[:body_line_height]
        @body_line_height     = options[:body_line_height]    
        @line_count      = ((@height - @top_margin - @bottom_margin)/@body_line_height).to_i
      end
      @line_count           =  @line_count - @article_bottom_space_in_lines
      @current_position     = @top_margin + @top_inset
      @show_grid_rects      = options[:show_grid_rects] || true
      @layout_space         = options.fetch(:column_layout_space, 0)
      @complex_rect         = false
      create_lines
      if block
        instance_eval(&block)
      end
      self
    end

    def log
      column_log = ""
      @graphics.each do |l| 
        column_log += l.log
      end
      column_log
    end

    def page
      @parent
    end

    def page_number
      @parent.page_number
    end

    def adjust_column_lines
      @line_count           = ((@height - @top_margin - @bottom_margin)/@body_line_height).to_i
      @line_count           -= @article_bottom_space_in_lines if @article_bottom_space_in_lines
      create_lines
    end

    def adjust_height(changing_line_count)

      if changing_line_count > 0
        add_lines(changing_line_count)
      elsif changing_line_count < 0
        remove_lines(changing_line_count)
      end
      @height += changing_line_count*@body_line_height
    end

    def collect_line_content
      line_data = []
      layed_out_lines.map do |line|  
        line_data << line.collect_line_content
      end
      line_data
    end

    def layout_line_content(line_content)
      if line_content.nil?
        puts "line_content is nil !!!!!"
        return 
      end
      ready_line = content_cleared_lines
      ready_line.each do |cleared_line|
        break if line_content == []
        line_data = line_content.shift
        cleared_line.place_line_content_from(line_data) if line_data
      end
    end

    def content_cleared_lines
      @graphics.select{|line| line.unoccupied_line? || line.layed_out_line == true}
      # @graphics.select{|line| line.layed_out_line == true}
    end

    def oveflow_column_text_lines
      parent.overflow_column.text_lines
    end

    def create_lines(options={})
      return if @empty_lines
      @graphics = []
      current_x   = @left_inset
      current_y   = @top_inset
      line_width  = @width - @left_inset - @right_inset
      previoust_line = nil
      @line_count.times do
        options = {parent:self, x: current_x, y: current_y , width: line_width, height: @body_line_height}
        if @left_side_bar
          options = {parent:self, x: current_x + @left_side_bar, y: current_y , width: line_width - @left_side_bar, height: @body_line_height}
        elsif @left_side_bar
          options = {parent:self, x: current_x, y: current_y , width: line_width - @right_side_bar, height: @body_line_height}
        end
        line = RLineFragment.new(options)        # @graphics << line
        previoust_line.next_line = line if previoust_line
        current_y += @body_line_height
        previoust_line = line
      end
      @current_line_index = 0
      @current_line       = @graphics[@current_line_index]
    end

    def add_lines(changing_line_count)
      return if @empty_lines
      @line_count += changing_line_count
      current_x   = 0
      current_y   = @graphics.last.y + @graphics.last.height
      line_width  = @width - @left_inset - @right_inset
      previoust_line = @graphics.last
      changing_line_count.times do
        options = {parent:self, x: current_x, y: current_y , width: line_width, height: @body_line_height}
        line = RLineFragment.new(options)        # @graphics << line
        previoust_line.next_line = line if previoust_line
        line.content_cleared = true
        current_y += @body_line_height
        previoust_line = line
      end
    end

    def remove_lines(changing_line_count)
      @line_count += changing_line_count # since changing_line_count is minus number
      @graphics = @graphics[0...@line_count]
    end

    def to_svg
      s = "<rect fill='white' x='#{@parent.x + @x}' y='#{@parent.y + @y}' width='#{@width}' height='#{@height}' />"
      @graphics.each do |line|
        line_svg = line.to_svg
        unless line_svg == ""
          s +=line.to_svg
          s += "\n"
        end
      end
      s
    end

    def column_grid_rect
      @parent.column_grid_rect(self)
    end

    def fixed_page_document?
      return true if @parent && @parent.parent.class == RDocument && @parent.parent.fixed_page_document?
      false
    end

    def add_new_page
      @parent.add_new_page if @parent && @parent.is_a?(RPage)
    end

    def next_text_line(current_line)
      next_line_index = @graphics.index(current_line) + 1
      @graphics[next_line_index..-1].each do |line|
        return line if line.has_text_room?
      end
      nil
    end

    def column_index
      return 0 unless @parent
      @parent.graphics.index(self)
    end

    def previous_column
      if @column_type == 'overflow_column'
        return @parent.graphics.last
      end
      i = column_index
      i -= 1
      return @parent.graphics[i] if 1 >= 0
      nil
    end

    def layed_out_lines
      if @empty_lines
        []
      else
        @graphics.select{|line| line.layed_out_line?}
      end
    end

    def text_lines
      @graphics.select{|line| line.text_line?}
    end

    def last_text_line
      text_lines.last
    end

    def unoccupied_lines_count
      unoccupied_lines_count = 0
      @graphics.reverse.each do |line_in_reverse|
        break if line_in_reverse && line_in_reverse.layed_out_line?
        next if line_in_reverse.unoccupied_line? == false
        unoccupied_lines_count += 1
      end
      unoccupied_lines_count
    end

    def layed_out_line_count
      @graphics.select{|line| line.layed_out_line}.length
    end

    def overflow_text
      text = ""
      @graphics.each do |line|
        line_text = "<p style='text-align:left;'>"
        line_text += line.line_string
        line_text += "</p>"
        text      += line_text
      end
      text
    end

    def column_text
      column_text = []
      @graohics.each do |line|
        column_text << line.line_string
      end
    end

    def adjust_overlapping_lines(overlapping_floats)
      floats = overlapping_floats.dup
      floats.each do |float|
        float_rect = float.frame_rect
        @graphics.each do |line|
          line.adjust_text_area_away_from(float_rect)
        end
      end
    end

    # called by RColumnArticle
    def adjust_overlapping_lines_with_floats
      @floats.each do |float|
        float_rect = float.frame_rect
        @graphics.each do |line|
          line.adjust_text_area_away_from(float_rect)
        end
      end
    end

    def adjust_overlapping_footnote_box
      return if @footnote_box.footnote_list == 0
      @graphics.each do |line|
        line.adjust_text_area_away_from(@footnote_box)
      end
    end

    def footnote_list
      @document.footnote_list
    end

    # add footnote_text with given footnote_item_number to FootnoteBox
    def add_footnote_description_items(footnote_description_items)
      @footnote_box.add_footnote_descriptions footnote_description_items
    end

    def char_count
      lines_char_count = 0
      @graphics.each do |line|
        lines_char_count += line.char_count
      end
      lines_char_count
    end

    def available_lines_count
      available_lines = 0
      @graphics.each do |line|
        available_lines +=1 if line.text_line?
      end
      available_lines
    end

    def empty_lines
      @line_count - @current_line_index
    end

    def average_characters_per_line
      line_count = available_lines_count
      if line_count == 0
        return 1
      end
      char_count/line_count
    end

    def first_line
      @graphics.first
    end

    def last_line
      @graphics.last
    end

    def first_text_line
      first_text_line = nil
      @graphics.each do |line|
        return line if line.text_line?
      end
      nil
    end

    def get_line_with_text_room
      return nil unless @current_line
      if @current_line.has_text_room?
        return @current_line
      end
        #code
      while go_to_next_line
        if @current_line.has_text_room?
          return @current_line
        end
      end
      #code
    end

    # get text for each line lines
    def column_line_string
      line_text = @graphics.map{|l| l.line_string}
      line_text.join("\n")
    end

    def has_room?
      @current_line_index <= @line_count
    end

    def is_last_line?
      @current_line_index == @line_count
    end

    def move_current_position_by(y_amount)
      @current_position += y_amount
    end

    def overlapping_rects
      overlapping_rects = []
      @grid_rects.each do |rect|
        overlapping_rects << rect if rect.overlap
      end
      overlapping_rects
    end

    def fully_covered_rects
      overlapping_rects = []
      @grid_rects.each do |rect|
        overlapping_rects << rect if rect.fully_covered
      end
      overlapping_rects
    end

    def room
      max_y(text_rect) - @current_position
    end

    def room_in_grid
      @grid_rects.length - @current_grid_index
    end

    def can_fit?(height)
      return false if @room < 16
      height <= @room
    end

    # find the grid_rect that conatines the y position
    # options[:align_to_body_text] for body text
    def grid_rect_at_position(position, options={})
      unless @grid_rects
        create_grid_rects
      end
      @grid_rects.each_with_index do |grid_rect, i|
        if position >= min_y(grid_rect.rect) && position <= max_y(grid_rect.rect)
          if options[:align_to_body_text]
            # align to even grid for body text alignment
            if i.even?
              return grid_rect.rect
            elsif @grid_rects.length > i
              even_rect = @grid_rects[i+1]
              return even_rect.rect
            end
          end
          return grid_rect.rect
        end
      end
      @grid_rects.last.rect
    end

    def text_width
      text_rect[2]
    end


    # snap to grid_rect if the position is very near top snap to top
    # otherwise return bottom position of grid_rect
    def snap_to_grid_rect(position)
      return position unless @grid_rects
      if position < @grid_rects.first.rect[1]
        return @grid_rects.first.rect.y
      end
      @grid_rects.each_with_index do |grid_rect, i|
        if position >= min_y(grid_rect.rect) && position <= (max_y(grid_rect.rect) + 0.1) #make sure for flaot rounding
          # grid_rect height is half of body text rect
          # we always wont to snap to even numbered lines
          if i.odd?
            return max_y(@grid_rects[i+1].rect) unless i >= (@grid_rects.length - 1)
          else
            return max_y(@grid_rects[i].rect)
          end
        end
      end
      max_y(@grid_rects.last.rect)
    end

  
    # this is used to place overlapping floars to non-overlapping position
    def layout_floats
      return unless @floats
      @occupied_rects =[]
      @floats.each_with_index do |float, i|
        @float_rect = float.frame_rect
        if i==0
          @occupied_rects << float.frame_rect
        elsif intersects_with_occupied_rects?(@occupied_rects, @float_rect)
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

  end

  class FootnoteBox < Container
    attr_reader :footnote_list
    def initialize(options={})
      super
      @is_float = true
      @footnote_list =  []
      self
    end

    def add_footnote_descriptions(footnote_descripions)
      last_footnote = @graphics.last
      if last_footnote
        @y_position = last_footnote.y + last_footnote.height
      else
        @y_position = 0
      end
      footnote_descripions.each do |footnotes|
        new_footnote = create_footnote(footnotes[:para_string], y: @y_position)
        @y_position += new_footnote.height
      end
      #TODO adjust footnote object position
    end

    def create_footnote(string, options={})
      atts  = {}
      atts[:y] = options[:y]
      atts[:style_name]           = 'footnote'
      atts[:text_string]          = string
      atts[:width]                = @width
      atts[:text_alignment]       = options[:text_alignment] || 'left'
      atts[:fill_color]           = options.fetch(:fill_color, 'clear')
      atts[:line_spacing]         = options.fetch(:line_spacing, 0)
      atts[:space_before]         = options.fetch(:space_before, 0)
      atts[:space_after]         = options.fetch(:space_before, 0)
      atts[:parent]               = self
      @footnote_object = TitleText.new(atts)
      @footnote_object
    end

  end
end
