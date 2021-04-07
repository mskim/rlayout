
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
    attr_accessor :fixtures, :floats, :document, :column_count, :first_page, :body_line_count, :body_line_height
    attr_accessor :body_lines, :gutter, :body_line_count
    attr_reader :float_layout, :page_by_page

    def initialize(options={}, &block)
      super
      if options[:parent] || options[:document]
        @parent       = options[:parent] || options[:document]
        @document     = @parent
      end
      @float_layout   = options[:float_layout] || []
      @first_page     = options[:first_page] || false
      @column_count   = 1
      @column_count   = options[:column_count] if options[:column_count]
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
        @heading_type      = @document.heading_type
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
      create_body_lines
      add_floats
      # relayout!
      if block
        instance_eval(&block)
      end
      self
    end

    # TODO
    def create_body_lines
      prev_line = nil
      current_x = @left_margin
      @column_count.times do |column_index|
        current_y = @top_margin
        @body_line_count.times do |line_index|
          h = {}
          h[:parent]  = self
          h[:x]       = current_x
          h[:y]       = current_y
          h[:width]   = @column_width
          h[:height]  = @body_line_height
          new_line    = RLineFragment.new(h)
          current_y += @body_line_height
          # set next_line link
          prev_line.next_line = new_line if prev_line
          prev_line = new_line
        end
        current_x += @column_width + @gutter
      end
    end

    def add_floats
      @float_layout.each do |float|
        float[:parent] = self
        float[:is_float] = true
        if float[:kind] == 'image'
          NewsImage.new(float)
        else
          NewsFloat.new(float)
        end
      end
      adjust_overlapping_body_lines
    end

    # adjust text_area of body_lines with overlapping floats
    def adjust_overlapping_body_lines
      @floats.each do |float|
        float_rect = float.frame_rect
        @graphics.each do |line|
          line.adjust_text_area_away_from(float_rect)
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
      @graphics.first
    end

    def body_lines
      @graphics
    end

    def text_lines
      body_lines.select{|l| l.text_line?}
    end

    def first_text_line
      body_lines.select{|l| l.text_line?}.first
    end

    def add_new_page
      @parent.add_new_page
      # retruns first_text_line
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

    def layout_items(paragraphs, options={})
      current_line = first_text_line
      while @item = paragraphs.shift do
        current_line = @item.layout_lines(current_line)
      end
      if  current_line
        @current_column  = current_line.column
      end
      @overflow  = true if @overflow_column.graphics.first && @overflow_column.graphics.first.layed_out_line?

      if @overflow && !@adjustable_height
        last_line_of_box.fill.color = 'red'
      else
        @empty_lines    = article_box_unoccupied_lines_count
        @underflow = true if @empty_lines > 0
      end
      # TODO:
      save_page_info if  @page_by_page
    end

    # TODO:
    def save_page_info

    end

    # TODO:
    def layout_floats

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
