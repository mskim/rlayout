
# layout_content! 
# layout_content calls layout_content for each text_box, and table.
# 
module RLayout

  class Page < Container
    attr_accessor :page_number, :left_page, :no_fixture_page
    attr_accessor :main_box, :heading_object, :header_object, :footer_object, :side_bar_object
    attr_accessor :fixtures, :document, :column_count

    def initialize(options={}, &block)
      @parent_graphic = options[:parent] || options[:document]
      @document       = @parent_graphic
      @column_count   = 1 
      if @document
        @column_count   = @document.column_count 
      end
      @column_count  = options[:column_count] if options[:column_count]
      options[:left_margin]   = layout_default[:left_margin] unless options[:left_margin]
      options[:top_margin]    = layout_default[:top_margin] unless options[:top_margin]
      options[:right_margin]  = layout_default[:right_margin] unless options[:right_margin]
      options[:bottom_margin] = layout_default[:bottom_margin] unless options[:bottom_margin]
      if @document
        options[:width]         = @document.width
        options[:height]        = @document.height        
        options[:left_margin]   = @document.left_margin
        options[:top_margin]    = @document.top_margin 
        options[:right_margin]  = @document.right_margin 
        options[:bottom_margin] = @document.bottom_margin
      elsif options[:paper_size] && options[:paper_size] != "custom"
        options[:width]   = SIZES[options[:paper_size]][0]
        options[:height]  = SIZES[options[:paper_size]][1]
      else
        options[:width]   = options.fetch(:width, page_defaults[:width])
        options[:height]  = options.fetch(:height, page_defaults[:height])
      end
      
      if  @parent_graphic && !@parent_graphic.pages.include?(self)
        @parent_graphic.pages << self 
      end
      super
      if  @parent_graphic
        @page_number = @parent_graphic.pages.index(self) + @parent_graphic.starting_page_number
      else
        @page_number = 1
      end
      @page_number = options[:page_number] if options[:page_number]
      # if @parent_graphic && @parent_graphic.double_side
      @left_page  = @page_number.even?
      # else
      #   @left_page  = false
      # end      
      @fixtures = []
      @floats   = []
      
      main_box_options                = {}
      main_box_options[:x]            = @left_margin
      main_box_options[:y]            = @top_margin
      main_box_options[:width]        = @width - @left_margin - @right_margin
      main_box_options[:height]       = @height - @top_margin - @bottom_margin
      main_box_options[:column_count] = @column_count if @column_count
      main_box_options[:layout_space] = options.fetch(:layout_space, 10)
      main_box_options[:column_layout_space] = options.fetch(:column_layout_space, 10)
      main_box_options[:layout_space] = options.fetch(:gutter, main_box_options[:layout_space])
      main_box_options[:heading_columns]= options.fetch(:heading_columns, @column_count)
      main_box_options[:grid_base]    = options.fetch(:grid_base,"3x4")
      main_box_options[:parent] = self
      if options[:text_box_options]
        main_box_options.merge!(options[:text_box_options])
      end
      if options[:text_box]
        @main_box = TextBox.new(main_box_options) 
      elsif options[:toc_table]
        @main_box = TocTable.new(main_box_options) 
      elsif options[:grid_box]
        @main_box = GridBox.new(main_box_options)
      elsif options[:composite_box]
        @main_box = CompositeBox.new(main_box_options)
      end
      if block
        instance_eval(&block)
      end    
      self
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
    
    # layout_content! should be called to layout out content
    # after graphics positiona are settled from relayout!
    # text_box and table should respond and layout content
    def layout_content!
      return unless @graphics
      return if @graphics.length <= 0

      @graphics.each do |graphic|
        if graphic.respond_to?(:layout_content!)
          graphic.layout_content! 
        end
      end
    end
    
    def first_text_box
      @graphics.each do |graphic|
        if graphic.kind_of?(RLayout::TextBox)
          return graphic
        end
      end
      return nil
    end
    
    # does page include Heading in graphics
    def get_heading?
      @graphics.each do |graphic|
        return graphic if graphic.class == RLayout::Heading
      end
      nil
    end
    
    def main_text(options={}, &block)
      options[:parent_frame]  = true # fit to page's layout_frame
      options[:grid_base]     = "3x3" unless options[:grid_base]
      options[:gutter]        = 10    unless options[:gutter]
      options[:parent]        = self
      @main_box=TextBox.new(options, &block)
    end
    
    def document
      @parent_graphic
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
        layout_length:  1,
      }
    end
    
    def add_heading(heading_object)
      @heading_object = heading_object
      @heading_object.parent_graphic = self
      @graphics << @heading_object
    end
    # does current text_box include Heading in floats
    def has_heading?
      @graphics.each do |g|
        if g.class == RLayout::Heading || g.class == RLayout::HeadingContainer
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
    
    def update_header_and_footer(options={})
      return if @no_fixture_page # for pictures page
      options[:header][:font] = 8
      options[:footer][:font] = 8
      if first_page?
        if options[:header] && (header_rule[:first_page_only] || header_rule[:first_page])
          options[:header][:text_string] = options[:header][:first_page_text]
          @header_object = header(options[:header])
        end
        if options[:footer] && (footer_rule[:first_page_only] || footer_rule[:first_page])
          options[:footer][:text_string] = options[:footer][:first_page_text]
          @footer_object = footer(options[:footer])
        end
      elsif left_page?
        if options[:header] && header_rule[:left_page] && !header_rule[:first_page_only]
          options[:header][:text_string] = options[:header][:left_page_text]
          @header_object = header(options[:header])
        end
        if options[:footer] && footer_rule[:left_page] && !footer_rule[:first_page_only]
          options[:footer][:text_string] = options[:footer][:left_page_text]
          @footer_object = footer(options[:footer])
        end
        
      else
        if options[:header] && header_rule[:right_page] && !header_rule[:first_page_only]
          options[:header][:text_string] = options[:header][:right_page_text]
          @header_object = header(options[:header])
        end
        if options[:footer] && footer_rule[:right_page] && !footer_rule[:first_page_only]
          options[:footer][:text_string] = options[:footer][:right_page_text]
          @footer_object = footer(options[:footer])
        end
        
      end
    end

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
        next if a==@parent_graphic
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
      if @parent_graphic
        return @parent_graphic.pages.index(self) == 0
      end
      false
    end

    def left_page?
      @left_page == true
    end

    def header_rule
      return Hash.new unless @parent_graphic
      @parent_graphic.header_rule.dup
    end

    def footer_rule
      return Hash.new unless @parent_graphic
      @parent_graphic.footer_rule.dup
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


    ##########  sample ###########
    def self.sample_page

    end

    ########### PageScritp Verbs #############
    def text_box(options={}, &block)
      options[:parent] = self
      @main_box = TextBox.new(options) unless @main_box
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
      Header.new(:parent=>self, :text_string=>options[:text_string], :font_size=>options[:font], :is_fixture=>true)
    end

    def footer(options={})
      Footer.new(:parent=>self, :text_string=>options[:text_string], :font_size=>options[:font], :is_fixture=>true)
      
    end

    def side_bar(options={})
      SideBar.new(:paernt=>self, :text_string=>options[:text_string], :is_fixture=>true)
    end


    def self.magazine_page(document)
      Page.new(:parent=>document, :header=>true, :footer=>true, :text_box=>true)
    end
  end


end
