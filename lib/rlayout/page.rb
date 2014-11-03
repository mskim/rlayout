require File.dirname(__FILE__) + '/page/page_fixtures'

module RLayout
  
  class Page < Container
    attr_accessor :page_number, :left_page, :no_fixture_page
    attr_accessor :header_object, :footer_object, :story_box_object, :side_bar_object
    attr_accessor :fixtures
     
    def initialize(parent_graphic, options={}, &block)
      super
      @parent_graphic.pages << self if  @parent_graphic && @parent_graphic.pages && !@parent_graphic.pages.include?(self)       
      @klass = "Page"
      
      @page_number = options.fetch(:page_number, '1')
      
      if @parent_graphic && @parent_graphic.double_side
        @left_page  = @page_number.even?
      else
        @left_page  = true
      end
      
      @graphics = []
      @fixtures = []
      @floats = []
      
      @x = 0
      @y = 0
      
      #TODO refactore this
      if @parent_graphic && @parent_graphic.width
        @width  = @parent_graphic.width 
      else
        @width  = defaults[:width]
      end
      
      if @parent_graphic && @parent_graphic.height
        @height  = @parent_graphic.height 
      else
        @height  = defaults[:height]
      end
      
      if @parent_graphic && @parent_graphic.margin
        @margin         = @parent_graphic.margin        
      else
        @margin  = defaults[:margin]
      end
      @left_margin    = @margin
      @right_margin   = @margin
      @top_margin     = @margin
      @bottom_margin  = @margin
      @left_inset     = 0
      @right_inset    = 0
      @top_inset      = 0
      @bottom_inset   = 0
                  
      if options[:story_box]
        options[:x] = @left_margin
        options[:y] = @top_margin
        options[:width] = @width - @left_margin - @right_margin
        options[:height] = @height - @top_margin - @bottom_margin
        options[:column_count] = 1
        
        # #####
        # options[:line_width] = 2
        # options[:line_color] = 'black'
        
        @story_box_object = story_box(options)
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
        next if a==@story_box_object
        next if a==@style_service
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
    
    def save_hash(path)
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
    def story_box(options={}, &block)
      @story_box_object     = StoryBox.new(self, options)      
      
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
      Page.new(document, :header=>true, :footer=>true, :story_box=>true)
    end
  end
  
  
end

