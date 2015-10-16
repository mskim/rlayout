
# layout_content! 
# layout_content calls layout_content for each text_box, and table.
# 
module RLayout

  class Page < Container
    attr_accessor :page_number, :left_page, :no_fixture_page
    attr_accessor :main_box, :heading_object, :header_object, :footer_object, :side_bar_object
    attr_accessor :fixtures, :document

    def initialize(parent_graphic, options={}, &block)
      @parent_graphic = parent_graphic
      @document       = parent_graphic
      if options[:paper_size] && options[:paper_size] != "custom"
        options[:width] = SIZES[options[:paper_size]][0]
        options[:height] = SIZES[options[:paper_size]][1]
      else
        if options[:width]
        elsif !@parent_graphic.nil? && @parent_graphic.width
            options[:width]  = @parent_graphic.width
        else
          options[:width]  = page_defaults[:width]
        end
        if options[:height]
        elsif @parent_graphic && @parent_graphic.height
          options[:height]  = @parent_graphic.height
        else
          options[:height]  = page_defaults[:height]
        end
      end
      
      if options[:left_margin]
      elsif @parent_graphic && @parent_graphic.left_margin
        options[:left_margin]  = @parent_graphic.left_margin
      else
        options[:left_margin]  = layout_default[:left_margin]
      end
      if options[:right_margin]
      elsif @parent_graphic && @parent_graphic.right_margin
        options[:right_margin] = @parent_graphic.right_margin
      else
        options[:right_margin] = layout_default[:right_margin]
      end

      if options[:top_margin]
      elsif @parent_graphic && @parent_graphic.top_margin
        options[:top_margin] = @parent_graphic.top_margin
      else
        options[:top_margin] = layout_default[:top_margin]
      end
      if options[:bottom_margin]
      elsif @parent_graphic && @parent_graphic.bottom_margin
        options[:bottom_margin] = @parent_graphic.bottom_margin
      else
        options[:bottom_margin] = layout_default[:bottom_margin]
      end
            
      @parent_graphic.pages << self if  @parent_graphic && !@parent_graphic.pages.include?(self)
      super
      @klass = "Page"
      @page_number = options.fetch(:page_number, 1)
      if @parent_graphic && @parent_graphic.double_side
        @left_page  = @page_number.even?
      else
        @left_page  = true
      end      
      @fixtures = []
      @floats   = []
      main_box_options                = {}
      main_box_options[:width]        = @width - @left_margin - @right_margin
      main_box_options[:height]       = @height - @top_margin - @bottom_margin
      main_box_options[:column_count] = options.fetch(:column_count, 1)
      main_box_options[:layout_space] = options.fetch(:layout_space, 10)
      main_box_options[:column_layout_space] = options.fetch(:column_layout_space, 10)
      main_box_options[:layout_space] = options.fetch(:gutter, main_box_options[:layout_space])
      main_box_options[:heading_columns]= options.fetch(:heading_columns, main_box_options[:column_count])
      main_box_options[:grid_base]    = options.fetch(:grid_base,"3x4")
      if options[:text_box_options]
        main_box_options.merge!(options[:text_box_options])
      end
      if options[:text_box]
        @main_box = TextBox.new(self, main_box_options)    
      end
      if block
        instance_eval(&block)
      end     
      
      self
    end
    
    def is_first_page?
      return true unless @document
      return true if @document.pages.first == self
      false
    end
    
    def is_left_page?
      @left_page
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
      @main_box=TextBox.new(self, options, &block)
      # readjust float after they are inserted
      @main_box.layout_floats!  
      # mark overlapping grid_rects with floats 
      @main_box.set_overlapping_grid_rect    
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

    def first_page?
      if @parent_graphic
        @parent_graphic.pages.index(self) == 0
      else
        true
      end
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
      TextBox.new(self, options)
    end

    def table(options={}, &block)
      Table.new(self, options, &block)
    end

    def object_box(options={}, &block)
      ObjectBox.new(self, options)
    end

    def header(options={})
      #TODO
      Header.new(self, :text_string=>options[:text_string], :font_size=>options[:font], :is_fixture=>true)
    end

    def footer(options={})
      #TODO
      Footer.new(self, :text_string=>options[:text_string], :font_size=>options[:font], :is_fixture=>true)
      # @footer_object = Footer.new(self, :text_string=>"This is header text", :is_fixture=>true)
    end

    def side_bar(options={})
      # @side_bar_object = SideBar.new(self, :text_string=>"This is side_bar text", :is_fixture=>true)
      SideBar.new(self, :text_string=>options[:text_string], :is_fixture=>true)
    end


    def self.magazine_page(document)
      Page.new(document, :header=>true, :footer=>true, :text_box=>true)
    end
  end


end
