
# whether to create main_text within page or not is the question?
# RPage need to implement bleeding image, and floats.
# if we have main_text as main text hendling object, 
# bleeding implementation could be tricky.
# But if we implement r_page as big text_box with columns, this would be simpler to implent.
# So, lets do it without main_box.
# use text_box as side_box.

module RLayout
  class RPage < Container
    attr_accessor :heading_object, :header_object, :footer_object, :side_box_object
    attr_accessor :fixtures, :floats, :document, :column_count, :row_count, :first_page, :body_line_count, :body_line_height
    attr_accessor :body_lines, :gutter, :body_line_count
    attr_reader :float_layout, :page_by_page
    attr_reader :empty_first_column
    attr_reader :header_footer, :portrait_mode, :binding_margin
    attr_accessor :page_log

    def initialize(options={}, &block)
      options[:fill_color] = 'white'
      super
      @binding_margin = options[:binding_margin] || 10
      @portrait_mode = options[:portrait_mode] || true
      if options[:parent] || options[:document]
        @parent       = options[:parent] || options[:document]
        @document     = @parent
        @pdf_doc      = @document.pdf_doc
        @column_count   = @document.column_count
        @row_count      = @document.row_count
      else
        @column_count   = options[:column_count] || 1
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
        @heading_height_type  = @document.heading_height_type
        if !@document.pages.include?(self)
          @document.pages << self
        end
      else
        @body_line_count    = 30
        @body_line_height   = (@height - @top_margin - @bottom_margin)/@body_line_count
        @gutter             = 10
        @column_width       = (@width - @left_margin - @right_margin - (@column_count-1)*@gutter)/@column_count
      end

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

    def log
      page_log = ""
      @graphics.each do |c| 
        page_log += c.log if c.class ==  RLayout::RColumn
      end
      page_log
    end

    def page_number
      if @document
        @document.page_number(self)
      else
        1
      end
    end

    def page_index
      if @document
        @document.pages.index(self)
      else
        nil
      end
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
          g= RColumn.new(parent:self, x: current_x, y: @top_margin, width: @column_width, height: @column_height, column_line_count: @body_line_count, body_line_height: @body_line_height)
          current_x += @column_width + @gutter
        end
      end
      @column_bottom = max_y(@graphics.first.frame_rect)
      link_column_lines
    end

    def next_text_line(column)
      if @graphics.last == column
        @parent.next_text_line(self)
      else
        column_index = @graphics.index(column)
        @graphics[(column_index + 1)..-1].each do |coloum|
          next_column_text_line = coloum.first_text_line
          return next_column_text_line if next_column_text_line
        end
      end
      @parent.next_text_line(self)
    end


    # set next_line to every line in column
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

    def images_folder
      @document.images_folder
    end

    def tables_folder
      @document.tables_folder
    end
    # add single float to page
    def add_float(float_info, options={})
      float_info[:parent] = self
      float_info[:is_float] = true
      case float_info[:kind]
      when 'image'
        # ImagePlus.new(float_info)
        ImagePlus.new(float_info)
      when 'table'
        GridTable.new(float_info)
      when 'group_image'
        GroupImage.new(float_info)
      end
    end

    # add multiple floats to page
    def add_floats(page_floats)
      page_floats.each_with_index do |float_info, i|
        float_info[:parent]      = self
        float_info[:is_float]    = true
        float_info[:image_path]  = images_folder + "/#{float_info[:filename]}"
        float_info = convert_positioon_to_rect(float_info)
        add_float(float_info)
      end
    end

    def content_width
      @width - @left_margin - @right_margin
    end

    def content_height
      @height - @top_margin - @bottom_margin
    end

    def left_side_margin
      if page_number.odd?
        @left_margin + @binding_margin
      else
        @left_margin
      end
    end

    def content_height
      @height - @top_margin - @bottom_margin
    end
  
    def mid_width
      @left_margin + content_width/2
    end

    def mid_height
      @top_margin + content_height/2
    end

    def grid_width
      @portrait_mode == true ? content_width/6 : content_width/12
    end

    def grid_height
      @portrait_mode == true ? content_height/12 : content_height/6
    end

    def convert_positioon_to_rect(float_info)
      unit_grid_width = float_info[:size].split("x")[0].to_i || 6
      unit_grid_height = float_info[:size].split("x")[1].to_i || 6
      float_width = unit_grid_width*grid_width
      float_height = unit_grid_height*grid_height
      float_info[:width] = float_width
      float_info[:height] = float_height
      bleed_amount = 3
      inset_amount = 6
      bleed = float_info[:bleed]
      case float_info[:position] 
      when 1
        float_info[:x]  = @left_margin
        float_info[:y]  = @top_margin
        if bleed
          float_info[:x]  = -bleed_amount
          float_info[:width]  += bleed_amount + @left_margin
          float_info[:y] = -bleed_amount
          float_info[:height] += bleed_amount + @top_margin
        end
      when 2
        float_info[:x]  = mid_width - float_width/2
        float_info[:y]  = @top_margin
        if bleed
          float_info[:y]  = -bleed_amount
          float_info[:height]  += bleed_amount + @top_margin
        end
      when 3
        float_info[:x]  = @width - @right_margin - float_info[:width]
        float_info[:y]  = @top_margin
        if bleed
          float_info[:width]  += bleed_amount + @right_margin
          float_info[:y] = -bleed_amount
          float_info[:height] += bleed_amount + @top_margin
        end
      when 4
        float_info[:x]  = @left_margin
        float_info[:y]  = mid_height - float_height/2
        if bleed
          float_info[:x]  = -bleed_amount
          float_info[:width]  += bleed_amount + @left_margin
        end
      when 5
        float_info[:x]  = @width - @right_margin - float_info[:width]
        float_info[:y]  = mid_height - float_height/2
      when 6
        float_info[:x]  = @width - @right_margin - float_info[:width]
        float_info[:y]  = mid_height - float_height/2
        if bleed
          float_info[:width]  += bleed_amount + @right_margin
        end
      when 7
        float_info[:x]  = @left_margin
        float_info[:y]  = @top_margin + content_height - float_height
        if bleed
          float_info[:x]  = -bleed_amount
          float_info[:width]  += bleed_amount + @left_margin
          float_info[:height] += bleed_amount + @bottom_margin
        end
      when 8
        float_info[:x]  = @width - @right_margin - float_info[:width]
        float_info[:y]  = content_height - float_height
        if bleed
          float_info[:height] += bleed_amount + @bottom_margin
        end
      when 9
        float_info[:x]  = @width - @right_margin - float_info[:width]
        float_info[:y]  = @top_margin + content_height - float_height
        if bleed
          float_info[:width] += bleed_amount + @right_margin
          float_info[:height] += bleed_amount + @bottom_margin
        end
      else
        float_info[:x]  = @left_margin
        float_info[:y]  = @top_margin
      end

      # apply bleed only to 1,3,7,9? 
      if bleed
        # full width
        if unit_grid_width >=6
          float_info[:x]  = -bleed_amount
          float_info[:width]  = @width + bleed_amount*2
        end
        # full height
        if unit_grid_height >=12
          float_info[:y]  = -bleed_amount
          float_info[:height]  = @height + bleed_amount*2
        end
      end
      # add horizontal inset when float cuts the text line
      if unit_grid_width < 6
        case float_info[:position]
        when 1,4,7
          float_info[:right_inset] = inset_amount
        when 3,6,9
          float_info[:left_inset] = inset_amount
        when 3,6,9
          float_info[:both_sides_inset] = inset_amount
        end
      end
      float_info
    end

    def has_image?
      if is_first_page? && has_heading?
        @floats.length > 1
      else
        @floats.length > 0
      end
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

    def last_page?
      if @parent
        return @parent.pages.last == self
      end
      false
    end
    
    def next_page
      @parent.next_page(self)
    end

    def first_line
      @graphics.first.graphics.first
    end

    def last_line
      # @graphics.last.graphics.last
      if @graphics.last.graphics
        @graphics.last.graphics.last
      else
        nil
      end
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

    # def first_text_line
    #   body_lines.select{|l| l.text_line?}.first
    # end

    def first_text_line
      @graphics.each do |column|
        column_first_text_line = column.first_text_line
        return column_first_text_line if column_first_text_line
      end
      nil
    end

    def add_new_page
      @parent.add_new_page
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
      # if image is on bottom, move up by @article_bottom_space_in_lines*@body_line_height

      # bottom   = (grid_frame[1] + grid_frame[3])*7
      if options[:bottom_position] == true
        frame_y  = @height - frame_height - @bottom_margin #@article_bottom_space_in_lines*@body_line_height
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
        heading.x     = @starting_column_x || @left_margin
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
      # TODO:

      self
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
      @floats.each do |g|
        if g.class == RLayout::RHeading
          @heading_object = g unless @heading_object
          return true
        end
      end
      false
    end

    def heading(options={}, &block)
      options[:parent] = self
      options[:is_float] = true
      RHeading.new(options, &block)
    end

    def get_heading
      @floats.each do |g|
        return g if g.class == RLayout::RHeading
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

    def left_page?
      @left_page == true
    end

    def next_page
      index = @graphics.index(self)
      @graphics[index + 1]
    end

    def create_header_footer(options={})
      @header_footer = options
      if options[:footer_info]
        #create_footer
        h = {}
        h[:parent] = self
        h[:x] = @left_margin
        h[:y] = @height - @bottom_margin
        h[:width] = @width - @left_margin - @right_margin
        h[:height] = 10
        h[:font] = 'shinmoon'
        h[:font_size] = 7.0
        if page_number.odd?
          h[:text_alignment] = 'right'
        else
          h[:text_alignment] = 'left'
        end
        Text.new(h)
      end
      if options[:header_info]
        #create_header
      end
    end

    # def header_rule
    #   return Hash.new unless @parent
    #   @parent.header_rule.dup
    # end

    # def footer_rule
    #   return Hash.new unless @parent
    #   @parent.footer_rule.dup
    # end

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

    # def toc_table(options={}, &block)
    #   options[:parent] = self
    #   @main_box = TocTable.new(options) unless @main_box
    # end

    def table(options={}, &block)
      options[:parent] = self
      Table.new(options, &block)
    end

    def add_image(image_path)
      options = {}
      options[:parent] = self
      options[:image_path] = image_path
      options[:x] = @left_margin
      options[:y] = @top_margin
      options[:width] = content_width
      options[:height] = content_height
      Image.new(options)
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

    def create_header(info_hash)
      if page_number.even?
        erb = ERB.new(left_header_erb)
      else
        erb = ERB.new(right_header_erb)
      end
      @book_title = info_hash[:book_titile]
      @title = info_hash[:chapter_title]
      layout = erb.result(binding)
      @footer_object = eval(layout)
    end

    def left_header_erb
      s=<<~EOF
      @header_options  = "parent:self, x:#{@left_margin}, y:20, width: #{footer_width}, height: 12, fill_color: 'clear'"
      RLayout::Container.new(#{@header_options}) do
        text("<%= @page_number %>", font_size: 10, x: #{left_margin}, width: #{footer_width}, text_alignment: 'left')
      end
      EOF
    end

    def right_header_erb
      s=<<~EOF
      @header_options  = "parent:self, x:#{@left_margin}, y:20, width: #{footer_width}, height: 12, fill_color: 'clear'"
      RLayout::Container.new(#{@header_options}) do
        text("<%= @title %>  <%= @page_number %>", font_size: 9, from_right:0, y: 0, text_alignment: 'right')
      end
      EOF
    end

    # make header layout customizable
    # user should be able to edit header layout
    def create_header_with_layout(info_hash, left_footer_erb, right_headerer_erb)
      @book_title = info_hash[:book_titile]
      @title = info_hash[:chapter_title]
      if page_number.even?
        erb = ERB.new(left_header_erb)
      else
        erb = ERB.new(right_header_erb)
      end

      layout = erb.result(binding)
      @footer_object = eval(layout)
    end

    # support customizable footer layout 
    # user should be able to edit footer layout 
    # and load it at run time from chapter(document generator)
    # and pass it to page
    def create_footer_with_layout(info_hash, left_footer_erb, right_footer_erb)
      @book_title = info_hash[:book_titile] || "2022년 책만들기"
      @title = info_hash[:chapter_title]
      footer_options  = "parent:self, x:#{@left_margin}, y:#{@height - 50}, width: #{footer_width}, height: 12, fill_color: 'clear'"
      if page_number.even?
        erb = ERB.new(left_footer_erb)
      else
        erb = ERB.new(right_footer_erb)
        # binding.pry
      end
      layout = erb.result(binding)
      @footer_object = eval(layout)
    end

    def create_footer(info_hash)
      @book_title = info_hash[:book_titile] || "2022년 책만들기"
      @title = info_hash[:chapter_title]
      if page_number.even?
        erb = ERB.new(left_footer_erb)
      else
        erb = ERB.new(right_footer_erb)
        # binding.pry
      end
      layout = erb.result(binding)
      @footer_object = eval(layout)
    end

    def footer_width
      @width  - @left_margin - @right_margin
    end

    def left_footer_erb
      # footer_options  = "parent:self, x:#{@left_margin}, y:#{@height - @bottom_margin + 30}, width: #{footer_width}, height: 12, fill_color: 'clear'"
      footer_options  = "parent:self, x:#{@left_margin}, y:#{@height - 50}, width: #{footer_width}, height: 12, fill_color: 'clear'"
      s=<<~EOF
      RLayout::Container.new(#{footer_options}) do
        text("<%= @page_number %>  <%= @book_title %>", font_size: 10, x:0, y:0, width: #{footer_width}, text_alignment: 'left')
      end
      EOF
    end

    def right_footer_erb
      # footer_options  = "parent:self, x:#{@left_margin}, y:#{@height - @bottom_margin + 30}, width: #{footer_width}, height: 12, fill_color: 'clear'"
      # text("<%= @title %>  <%= @page_number %>", font_size: 9, from_right:0, y: 0, text_alignment: 'right')
      footer_options  = "parent:self, x:#{@left_margin}, y:#{@height - 50}, width: #{footer_width}, height: 12, fill_color: 'clear'"
      s=<<~EOF
      RLayout::Container.new(#{footer_options}) do
        text("<%= @title %>  <%= @page_number %>", font_size: 9, x:0, y: 0, width:#{footer_width}, text_alignment: 'right')
      end
      EOF
    end

    def side_bar(options={})
      SideBar.new(:parent=>self, :text_string=>options[:text_string], :is_fixture=>true)
    end

    def self.magazine_page(document)
      Page.new(:parent=>document, :header=>true, :footer=>true, :text_box=>true)
    end
    
    ############ pgscript ###############
    def column_text(text_string)
      h = {}
      h[:parent] = self
      h[:text_string] = text_string
      RLayout::ColumnText.new(h)
    end
  end


end
