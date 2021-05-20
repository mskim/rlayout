
# The decision time!:
# whether to create main_text within page or not is the question?
# RPage need to implement bleeding image, and floats.
# if we have main_text as main text hendling object, bleeding implementation could be tricky.
# But if we implement r_page as big text_box with columns, this would be simpler to implent.
# So, let do it without main_box.
# use text_box as side_box.

module RLayout
  class RPage < Container
    attr_accessor :page_number
    attr_accessor :heading_object, :header_object, :footer_object, :side_box_object
    attr_accessor :fixtures, :floats, :document, :column_count, :row_count, :first_page, :body_line_count, :body_line_height
    attr_accessor :body_lines, :gutter, :body_line_count
    attr_reader :float_layout, :page_by_page
    attr_reader :empty_first_column

    def initialize(options={}, &block)
      options[:fill_color] = 'white'
      super
      if options[:parent] || options[:document]
        @parent       = options[:parent] || options[:document]
        @document     = @parent
        @column_count   = @document.column_count
        @row_count      = @document.row_count
      else
        @column_count   = 1
        @column_count   = options[:column_count] if options[:column_count]
        @row_count      = 6
        @row_count   = options[:row_count] if options[:row_count]
      end

      # default grid is 6x12 grid

      @grid_size = []
      @grid_size << (@width - @left_margin - @right_margin)/@column_count
      @grid_size << (@height - @top_margin - @bottom_margin)/@row_count
      @float_layout   = options[:float_layout] || []
      @first_page     = options[:first_page] || false

      @page_number    = options[:page_number] || 1
      if @document
        @column_count      = @document.column_count
        @body_line_height  = @document.body_line_height
        @body_line_count   = @document.body_line_count
        @column_width      = @document.column_width
        @gutter            = @document.gutter
        @width             = @document.width
        @height            = @document.height
        @left_margin       = @document.left_margin
        @top_margin        = @document.top_margin
        @right_margin      = @document.right_margin
        @bottom_margin     = @document.bottom_margin
        @heading_height_type      = @document.heading_height_type
        @body_line_count   = @document.body_line_count || 30 
        if !@document.pages.include?(self)
          @document.pages << self
        end
      else
        @body_line_count    = 30
        @body_line_height   = (@height - @top_margin - @bottom_margin)/@body_line_count
        @gutter             = 10
        @column_width       = (@width - @left_margin - @right_margin - (@column_count-1)*@gutter)/@column_count
      end
      if options[:page_number]
        @page_number = options[:page_number]
      end
      # if @parent && @parent.double_side
      @fixtures = []  # header, footer
      @floats   = []
      create_columns
      # add_floats
      # relayout!
      if block
        instance_eval(&block)
      end
      self
    end

    # create news_columns
    def create_columns
      current_x = @left_margin
      @column_height = @height - @top_margin - @bottom_margin
      @column_count.times do |i|
        if @empty_first_column && i == 0
          g= RColumn.new(parent:self, empty_lines: true, x: current_x, y: @top_margin, width: @column_width, height: @column_height, column_line_count: @body_line_count, body_line_height: @body_line_height)
          current_x += @column_width + @gutter
        else
          # TODO: why? parent:self
          g= RColumn.new(parent:self, x: current_x, y: @top_margin, width: @column_width, height: @column_height, column_line_count: @body_line_count, body_line_height: @body_line_height)
          current_x += @column_width + @gutter
        end
      end
      @column_bottom = max_y(@graphics.first.frame_rect)
      link_column_lines
    end

    def link_column_lines
      previous_column_last_line = nil
      @graphics.each_with_index do |column, i|
        next if @empty_first_column && i == 0
        first_line                          = column.graphics.first
        last_line                           = column.graphics.last
        previous_column_last_line.next_line = first_line if previous_column_last_line
        previous_column_last_line           = last_line
      end
    end

    def add_floats(page_floats)
      page_floats.each do |float_info|
        if float_info.class == Array
          float = {}
          float[:parent]      = self
          float[:is_float]    = true
          float[:image_path]  = float_info[0]
          float[:position]    = float_info[1]
          size                = float_info[2]
          float[:column]      = size.split("x")[0].to_i
          float[:row]         = size.split("x")[1].to_i
          # float[:x_grid]      = float_info[:x_grid] if float_info[:x_grid]
          NewsFloat.new(float)
        elsif float_info.class == Hash
          float = {}
          float[:parent]      = self
          float[:is_float]    = true
          float[:image_path]  = float_info[:image_path]
          float[:position]    = float_info[:position]
          float[:column]      = float_info[:column]
          float[:row]         = float_info[:row]
          # float[:x_grid]      = float_info[:x_grid] if float_info[:x_grid]
          NewsFloat.new(float)
        end
      end

    end

    def first_page?
      if @parent
        @parent.pages.first == self
      end
      true
    end

    def first_line
      @graphics.first.graphics.first
    end

    def last_line
      @graphics.last.graphics.last
    end

    def body_lines
      body_lines = []
      @graphics.each do |column|
        body_lines += column.graphics
      end
      body_lines.flatten
    end

    def text_lines
      body_lines.select{|l| l.text_line?}
    end

    def first_text_line
      body_lines.select{|l| l.text_line?}.first
    end

    def add_new_page
      @parent.add_new_page
    end

    def next_page
      @parent.next_page(self)
    end

    def adjust_page_size_to_document
      @width          = @document.width
      @height         = @document.height
      @left_margin    = @document.left_margin
      @top_margin     = @document.top_margin
      @right_margin   = @document.right_margin
      @bottom_margin  = @document.bottom_margin
      relayout!
    end

    def is_left_page?
      @page_number.even?
    end

    def to_pgscript
      pgscript =<<~EOF
        page do
          #{floats_pgscript}
          #{graphics_pgscript}
        end
      EOF
      pgscript
    end

    def floats_pgscript
      script = ""
      @floats.each do |g|
        script +=g.to_pgscript
      end
      script
    end

    def graphics_pgscript
      script = ""
      @graphics.each do |g|
        script +=g.to_pgscript
      end
      script
    end

    # does page include Heading in graphics
    def get_heading?
      @graphics.each do |graphic|
        return graphic if graphic.class == RLayout::Heading
      end
      nil
    end

    def to_hash
      h= super
      if @fixtures && @fixtures.length > 0
        h[:fixtures]=[]
        h[:fixtures] = @fixtures.map{|fixture| fixture.to_hash}
      end
      h
    end

    def page_story_md
      "some page content"
    end

    # TODO:
    def save_page_story(page_story_path)
      File.open(page_story_path, 'w'){|f| f.write page_story_md}
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
      frame_y             = @grid_size[1]*grid_frame[1] + @top_margin
      column_index = (grid_frame[0] + grid_frame[2] - 1).to_i
      if @graphics[column_index]
        frame_width         = @graphics[column_index].x_max - frame_x
      else
        frame_width         = @graphics[0].x_max - frame_x
      end
      frame_height          = @grid_size[1]*grid_frame[3]
      # if image is on bottom, move up by @article_bottom_spaces_in_lines*@body_line_height

      # bottom   = (grid_frame[1] + grid_frame[3])*7
      if options[:bottom_position] == true
        frame_y  = @height - frame_height - @bottom_margin #@article_bottom_spaces_in_lines*@body_line_height
      end
      [frame_x, frame_y, frame_width, frame_height]
    end

    # TODO:
    def layout_floats
      return unless @floats
      @occupied_rects =[]
      if has_heading? && (@heading_columns != @column_count)
        heading = get_heading
        heading.width = @column_width
        heading.x     = @starting_column_x
      end
      #TODO position bottom bottom_occupied_rects

      @middle_occupied_rects = []
      @bottom_occupied_rects = []
      @floats.each_with_index do |float, i|
        @float_rect = float.frame_rect
        if i==0
          @occupied_rects << float.frame_rect
        elsif @column_count == 2 && float.class == RLayout::NewsHeadingForOpinion
          # when we have 2 column opinion, width gets too small for title
          # so we are overlapping title on top of the image
          next
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

    # adjust overlapping line_fragment text area
    # this method is called when float positions have changed
    def adjust_overlapping_columns
      @graphics.each_with_index do |column, i|
        overlapping_floats = overlapping_floats_with_column(column)
        column.adjust_overlapping_lines(overlapping_floats)
      end
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


    def set_overlapping_grid_rect

    end

    def update_column_areas

    end

    def layout_default
      {
        left_margin:  50,
        top_margin:   50,
        right_margin: 50,
        bottom_margin: 50,
        left_inset:   0,
        top_inset:    0,
        right_inset:  0,
        bottom_inset: 0,
        layout_direction: "vertical",
        layout_member: true,
        layout_expand: [:width, :height], # auto_layout expand
        layout_length:  1
      }
    end

    def add_heading(heading_object)
      @heading_object = heading_object
      @heading_object.parent = self
      @graphics << @heading_object
    end
    # does current text_box include Heading in floats
    def has_heading?
      @graphics.each do |g|
        if g.class == RLayout::RHeading
          @heading_object = g unless @heading_object
          return true
        end
      end
      false
    end

    def get_heading
      @graphics.each do |g|
        return g if g.class == RLayout::Heading
      end
      nil
    end


    def to_data
      h = {}
      instance_variables.each{|a|
        next if a==@parent
        next if a==@graphics
        next if a==@floats
        next if a==@fixtures
        next if a==@header_object
        next if a==@footer_object
        next if a==@side_box_object
        v = instance_variable_get a
        s = a.to_s.sub("@","")
        h[s.to_sym] = v if !v.nil?
      }
      if @graphics.length > 0
        h[:graphics]= @graphics.map do |child|
          child.to_data
        end
      end
      if @floats && @floats.length > 0
        h[:floats]= @floats.map do |child|
          child.to_data
        end
      end
      if @fixtures && @fixtures.length > 0
        h[:fixtures]= @fixtures.map do |child|
          child.to_data
        end
      end
      h
    end

    def is_first_page?
      return true unless @document
      return true if @document.pages.first == self
      false
    end

    def first_page?
      if @parent
        return @parent.pages.index(self) == 0
      end
      false
    end

    def left_page?
      @left_page == true
    end

    def header_rule
      return Hash.new unless @parent
      @parent.header_rule.dup
    end

    def footer_rule
      return Hash.new unless @parent
      @parent.footer_rule.dup
    end

    def save_yml(path)
      h = to_hash
      File.open(path, 'w'){|f| f.write h.to_yaml}
    end

    def save_json(path)
      # my_json = { :array => [1, 2, 3, { :sample => "hash"} ], :foo => "bar" }
      h = to_hash
      File.open(path, 'w'){|f| f.write JSON.pretty_generate(h)}
    end

    ########### PageScritp Verbs #############

    def text_box(options={}, &block)
      options[:parent] = self
      @main_box = RTextBox.new(options) unless @main_box
    end

    def toc_table(options={}, &block)
      options[:parent] = self
      @main_box = TocTable.new(options) unless @main_box
    end

    def table(options={}, &block)
      options[:parent] = self
      Table.new(options, &block)
    end

    def image_plus(options={}, &block)
      options[:parent] = self
      ImagePlus.new(options, &block)
    end

    def group_image(options={}, &block)
      options[:parent] = self
      GroupImage.new(options, &block)
    end

    def image_box(options={}, &block)
      options[:parent] = self
      ImageBox.new(options, &block)
    end

    def object_box(options={}, &block)
      options[:parent] = self
      ObjectBox.new(options)
    end

    def header(options={})
      #TODO
      # Header.new(:parent=>self, :text_string=>options[:text_string], :font_size=>options[:font], :is_fixture=>true)
      TitleText.new(:parent=>self, :text_string=>options[:text_string], :font_size=>options[:font], :is_fixture=>true)
    end

    def footer(options={})
      # Footer.new(:parent=>self, :text_string=>options[:text_string], :font_size=>options[:font], :is_fixture=>true)
      TitleText.new(:parent=>self, :text_string=>options[:text_string], :font_size=>options[:font], :is_fixture=>true)
    end

    def side_bar(options={})
      SideBar.new(:parent=>self, :text_string=>options[:text_string], :is_fixture=>true)
    end

    def self.magazine_page(document)
      Page.new(:parent=>document, :header=>true, :footer=>true, :text_box=>true)
    end
  end
end
