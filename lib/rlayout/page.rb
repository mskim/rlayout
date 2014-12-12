require File.dirname(__FILE__) + '/page/page_fixtures'

module RLayout
  
  class Page < Container
    attr_accessor :page_number, :left_page, :no_fixture_page
    attr_accessor :main_box, :header_object, :footer_object, :side_bar_object
    attr_accessor :fixtures
     
    def initialize(parent_graphic, options={}, &block)
      @parent_graphic = parent_graphic
      if options[:width]
      elsif @parent_graphic && @parent_graphic.width
        puts 
        options[:width]  = @parent_graphic.width 
      else
        options[:width]  = defaults[:width]
      end

      if options[:height]
      elsif @parent_graphic && @parent_graphic.height
        options[:height]  = @parent_graphic.height 
      else
        options[:height]  = defaults[:height]
      end
      
      if options[:margin]
      elsif @parent_graphic && @parent_graphic.margin
        options[:margin]  = @parent_graphic.margin        
      else
        options[:margin]  = defaults[:margin]
      end
      
      if options[:left_margin]
      elsif @parent_graphic && @parent_graphic.left_margin
        options[:left_margin]  = @parent_graphic.left_margin        
      else
        options[:left_margin]  = defaults[:margin]
      end
      
      if options[:right_margin]
      elsif @parent_graphic && @parent_graphic.right_margin
        options[:right_margin]  = @parent_graphic.right_margin        
      else
        options[:right_margin]  = defaults[:margin]
      end
      
      if options[:top_margin]
      elsif @parent_graphic && @parent_graphic.top_margin
        options[:top_margin]  = @parent_graphic.top_margin        
      else
        options[:top_margin]  = defaults[:margin]
      end
      
      if options[:bottom_margin]
      elsif @parent_graphic && @parent_graphic.bottom_margin
        options[:bottom_margin]  = @parent_graphic.bottom_margin        
      else
        options[:bottom_margin]  = defaults[:margin]
      end
      
      # if options[:left_inset]
      # elsif @parent_graphic && @parent_graphic.left_inset
      #   options[:left_inset]  = @parent_graphic.left_inset        
      # else
      #   options[:left_inset]  = defaults[:inset]
      # end
      # 
      # if options[:right_inset]
      # elsif @parent_graphic && @parent_graphic.right_inset
      #   options[:right_inset]  = @parent_graphic.right_inset        
      # else
      #   options[:right_inset]  = defaults[:inset]
      # end
      # 
      # if options[:top_inset]
      # elsif @parent_graphic && @parent_graphic.top_inset
      #   options[:top_inset]  = @parent_graphic.top_inset        
      # else
      #   options[:top_inset]  = defaults[:inset]
      # end
      # 
      # if options[:bottom_inset]
      # elsif @parent_graphic && @parent_graphic.bottom_inset
      #   options[:bottom_inset]  = @parent_graphic.bottom_inset        
      # else
      #   options[:bottom_inset]  = defaults[:inset]
      # end
      super
      @parent_graphic.pages << self if  @parent_graphic && @parent_graphic.pages && !@parent_graphic.pages.include?(self)       
      @klass = "Page"
      @page_number = options.fetch(:page_number, '1')
      if @parent_graphic && @parent_graphic.double_side
        @left_page  = @page_number.even?
      else
        @left_page  = true
      end
      @fixtures = []
      @floats = []
      @x = 0
      @y = 0
      
      main_box_options = {}
      main_box_options[:x]            = @left_margin
      main_box_options[:y]            = @top_margin
      main_box_options[:width]        = @width - @left_margin - @right_margin
      main_box_options[:height]       = @height - @top_margin - @bottom_margin
      main_box_options[:column_count] = options.fetch(:column_count, 1)
      main_box_options[:layout_space] = options.fetch(:column_layout_space, 10)
      main_box_options[:item_space]   = options.fetch(:item_space, 3)
      main_box_options[:heading_columns]= options.fetch(:heading_columns, main_box_options[:column_count])          
      if options[:text_box]
        @main_box = text_box(main_box_options)
      elsif options[:object_box]
        @main_box = object_box(main_box_options)
      end
            
      if block
        instance_eval(&block)
      end
      
      self
    end
    
    def document
      @parent_graphic
    end
    
    def defaults
      {
        x: 0,
        y: 0,
        width: 600,
        height: 800,
        margin: 50,
        inset: 0,
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
      require 'json'
      # my_json = { :array => [1, 2, 3, { :sample => "hash"} ], :foo => "bar" }
      
      h = to_hash
      File.open(path, 'w'){|f| f.write JSON.pretty_generate(h)}
    end
    
    
    ##########  sample ###########
    def self.sample_page
      
    end
    
    ########### PageScritp Verbs #############    
    def text_box(options={}, &block)
      @main_box     = TextBox.new(self, options)      
    end
    
    def object_box(options={}, &block)
      @main_box     = ObjectBox.new(self, options)      
    end
    
    def header(options={})
      #TODO      
      @header_object = Header.new(self, :text_string=>options[:text_string], :font_size=>options[:font], :is_fixture=>true)
    end
    
    def footer(options={})
      #TODO
      @footer_object = Footer.new(self, :text_string=>options[:text_string], :font_size=>options[:font], :is_fixture=>true)
      # @footer_object = Footer.new(self, :text_string=>"This is header text", :is_fixture=>true)
    end
    
    def side_bar(options={})
      # @side_bar_object = SideBar.new(self, :text_string=>"This is side_bar text", :is_fixture=>true)
      @side_bar_object = SideBar.new(self, :text_string=>options[:text_string], :is_fixture=>true)
    end
    
    # 
    # def image(options={})
    #   
    # end
    
    
    def self.magazine_page(document)
      Page.new(document, :header=>true, :footer=>true, :text_box=>true)
    end
  end
  
  
end

