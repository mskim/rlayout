
module RLayout
  
  class Page < Container
    attr_accessor :heading, :body, :header, :footer, :side_box, :images, :quotes
    
    def initialize(parent_graphic, options={}, &block)
      @parent_graphic = parent_graphic
      @parent_graphic.pages << self if  @parent_graphic && @parent_graphic.pages && !@parent_graphic.pages.include?(self)       
      @graphics = []
      @klass = "Page"
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
        @margin  = @parent_graphic.margin 
      else
        @margin  = defaults[:margin]
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
    
    def to_svg
      s = "<svg xmlns=\"http://www.w3.org/2000/svg\" xmlns:xlink=\"http://www.w3.org/1999/xlink\" x=\"#{@x}\" y=\"#{@y}\" width=\"#{@width}\" height=\"#{@height}\">\n"
      @graphics.each do |graphic|
        s += graphic.to_svg
      end
      s += "</svg>"      
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
    

    
    def save_svg(path)
      File.open(path, 'w'){|f| f.write to_svg}
    end
    
    ##########  sample ###########
    def self.sample_page
      
    end
    
    ########### PageScritp Verbs #############
    def article_layout(options={:column=>2, :images=>0, side_box=>0})
      @heading  = Heading.new(self)
      @body     = Body.new(self, options)
      @graphics << @heading
      @graphics << @body
      
    end
    
    def container(options={}, &block)
      c = Container.new(self, options, &block)
      @graphics << c
      # puts "@graphics.lenth:#{@graphics.length}"
    end
    
    def heading(options={}, &block)
      @graphics << Heading.new(self, options={}, &block)
    end
    
    # def header(options={})
    #   
    # end
    # 
    # def footer(options={})
    #   
    # end
    # 
    # def image
    #   
    # end
    
  end
  
  
end