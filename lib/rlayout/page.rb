require File.dirname(__FILE__) + '/page/page_fixtures'

module RLayout
  
  class Page < Container
    attr_accessor :page_number, :left_page
    attr_accessor :header_object, :footer_object, :story_box_object, :side_bar_object
    attr_accessor :fixtures
     
    def initialize(parent_graphic, options={}, &block)
      super
      @parent_graphic.pages << self if  @parent_graphic && @parent_graphic.pages && !@parent_graphic.pages.include?(self)       
      @klass = "Page"
      
      @page_number = options.fetch(:page_number, '1')
      
      if @parent_graphic && @parent_graphic.double_side
        if @parent_graphic.starts_left
          @left_page  = @page_number.even?
        else
          @left_page  = @page_number.odd?
        end
      else
        @left_page  = true
      end
      
      @graphics = []
      @fixtures = []
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
            
      if options[:header]
        @header_object = header(options[:header])
      end
      
      if options[:footer]
        @footer_object = footer(options[:footer])
      end
      
      if options[:story_box]
        options[:x] = @left_margin
        options[:y] = @top_margin
        options[:width] = @width - @left_margin - @right_margin
        options[:height] = @height - @top_margin - @bottom_margin
        options[:column_count] = 1
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
    
    def to_data
      h = {}
      instance_variables.each{|a|
        s = a.to_s
        next if s=="@parent_graphic"
        next if s=="@graphics"
        next if s=="@floats"
        next if s=="@fixtures"
        next if s=="@header_object"
        next if s=="@footer_object"
        next if s=="@side_bar_object"
        next if s=="@story_box_object"
        n = s[1..s.size] # get rid of @
        v = instance_variable_get a
        h[n.to_sym] = v if !v.nil?
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
      @header_object = Header.new(self, :text_string=>"This is header text", :font_size=>9, :is_fixture=>true)
    end
    
    def footer(options={})
      #TODO
      @footer_object = Footer.new(self, :text_string=>"This is header text", :is_fixture=>true)
    end
    
    def side_bar(options={})
      @side_bar_object = SideBar.new(self, :text_string=>"This is side_bar text", :is_fixture=>true)
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

