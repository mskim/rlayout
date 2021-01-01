
# unless options[:text_box] == false
# RPage creates @main_box(RTextBox)
# main_box(RTextBox) is where body text will follow
#
module RLayout
  class RPage < Container
    attr_accessor :page_number, :left_page, :no_fixture_page
    attr_accessor :main_box, :heading_object, :header_object, :footer_object, :side_bar_object
    attr_accessor :fixtures, :floats, :document, :column_count, :first_page, :body_line_count, :body_line_height
    attr_accessor :body_lines, :gutter, :body_line_count
    def initialize(options={}, &block)
      super
      if options[:parent] || options[:document]
        @parent       = options[:parent] || options[:document]
        @document     = @parent
      end
      @first_page     = options[:first_page] || false
      @column_count   = 1
      @column_count   = options[:column_count] if options[:column_count]
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
      end
      if  @parent && !@parent.pages.include?(self)
        @parent.pages << self
      end
      @body_line_count    = 30 unless @document.body_line_count
      @body_line_height   = (@height - @top_margin - @bottom_margin)/ @body_line_count
      if  @parent
        @page_number = @parent.pages.index(self) + @parent.starting_page
      elsif options[:page_number]
        @page_number = options[:page_number]
      else
        @page_number = 1
      end
      # if @parent && @parent.double_side
      @left_page  = @page_number.even?
      @fixtures = []
      @floats   = []

      create_body_lines
      # relayout!
      if block
        instance_eval(&block)
      end
      self
    end

    # TODO
    def create_body_lines
      prev_line = nil
      @column_count.times do |column_index|
        @body_line_count.times do |line_index|
          h = {}
          h[:parent]  = self
          h[:x]       = self
          h[:y]       = self
          h[:width]   = @column_width
          h[:height]  = @body_line_height
          new_line = RLineFragment.new(h)
          # set next_line link
          prev_line.next_line = new_line if prev_line
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
      body_lines.first
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
      p = @parent.add_new_page
      p.first_text_line
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
      @left_page
    end

    def to_pgscript
pgscript =<<EOF
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

    def page_defaults
      {
        x: 0,
        y: 0,
        width: 600,
        height: 800,
      }
    end

    def to_hash
      h= super
      if @fixtures && @fixtures.length > 0
        h[:fixtures]=[]
        h[:fixtures] = @fixtures.map{|fixture| fixture.to_hash}
      end
      h
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
        if g.class == RLayout::RHeading || g.class == RLayout::HeadingContainer
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

    # def update_header_and_footer(options={})
    #   return if @no_fixture_page # for pictures page
    #   options[:header][:font] = 8
    #   options[:footer][:font] = 8
    #   if first_page?
    #     if options[:header] && (header_rule[:first_page_only] || header_rule[:first_page])
    #       options[:header][:text_string] = options[:header][:first_page_text]
    #       @header_object = header(options[:header])
    #     end
    #     if options[:footer] && (footer_rule[:first_page_only] || footer_rule[:first_page])
    #       options[:footer][:text_string] = options[:footer][:first_page_text]
    #       @footer_object = footer(options[:footer])
    #     end
    #   elsif left_page?
    #     if options[:header] && header_rule[:left_page] && !header_rule[:first_page_only]
    #       options[:header][:text_string] = options[:header][:left_page_text]
    #       @header_object = header(options[:header])
    #     end
    #     if options[:footer] && footer_rule[:left_page] && !footer_rule[:first_page_only]
    #       options[:footer][:text_string] = options[:footer][:left_page_text]
    #       @footer_object = footer(options[:footer])
    #     end

    #   else
    #     if options[:header] && header_rule[:right_page] && !header_rule[:first_page_only]
    #       options[:header][:text_string] = options[:header][:right_page_text]
    #       @header_object = header(options[:header])
    #     end
    #     if options[:footer] && footer_rule[:right_page] && !footer_rule[:first_page_only]
    #       options[:footer][:text_string] = options[:footer][:right_page_text]
    #       @footer_object = footer(options[:footer])
    #     end

    #   end
    # end

    # def create_column_grid_rects
    #   puts __method__
    #   @main_box.create_column_grid_rects
    # end
    #
    # def set_overlapping_grid_rect
    #   @main_box.set_overlapping_grid_rect
    # end
    #
    # def layout_items(paragraphs)
    #   @main_box.layout_items(paragraphs)
    # end

    def to_data
      h = {}
      instance_variables.each{|a|
        next if a==@parent
        next if a==@graphics
        next if a==@floats
        next if a==@fixtures
        next if a==@header_object
        next if a==@footer_object
        next if a==@side_bar_object
        next if a==@main_box
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
