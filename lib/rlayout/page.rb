require File.dirname(__FILE__) + '/page/page_fixtures'

module RLayout
  
  class Page < Container
    attr_accessor :page_number, :header, :footer, :side_bar, :fixtures
    attr_accessor :heading, :body, :side_box, :images, :quotes, :left_page
    def initialize(parent_graphic, options={}, &block)
      @parent_graphic = parent_graphic
      @parent_graphic.pages << self if  @parent_graphic && @parent_graphic.pages && !@parent_graphic.pages.include?(self)       
      @klass = "Page"
      @graphics = []
      @fixtures = []
      @x = 0
      @y = 0
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
      
      @left_page = options.fetch(:left_page, true)
      @page_number = options.fetch(:page_number, '1')
      
      if options[:header]
        header
      end
      if options[:footer]
        footer
      end
      if options[:story_box]
        story_box
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
    def article_layout(options={:column=>2, :images=>0, side_box=>0})
      @heading  = Heading.new(self)
      @body     = Body.new(self, options)      
    end
    
    def story_box(options={}, &block)
      
    end
    
    def heading(options={}, &block)
      @heading = Heading.new(self, options={}, &block)
    end
    
    def header(options={})
      @header = Header.new(self, :text_string=>"This is header text", :font_size=>9, :is_fixture=>true)
    end
    
    def footer(options={})
      @footer = Footer.new(self, :text_string=>"This is header text", :is_fixture=>true)
    end
    
    def side_bar(options={})
      @side_bar = SideBar.new(self, :text_string=>"This is side_bar text", :is_fixture=>true)
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

