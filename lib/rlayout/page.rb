
module RLayout
  
  class Page < Container
    attr_accessor :heading, :body, :header, :footer, :side_box, :images, :quotes
    
    def initialize(parent_graphic, options={}, &block)
      super
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
        width: 600,
        height: 800,
        margin: 50,
      }
    end
    
    def to_svg
      s = "<svg xmlns=\"http://www.w3.org/2000/svg\" xmlns:xlink=\"http://www.w3.org/1999/xlink\" width=\"#{width}\" height=\"#{height}\">\n"
      @graphics.each do |graphics|
        s += graphics.to_svg
      end
      s += "</svg>"      
    end
    
    def save_svg(path)
      File.open(path, 'w'){|f| f.write to_svg}
    end
    
    ########### PageScritp Verbs #############
    def article_layout(options={:column=>2, :images=>0, side_box=>0})
      @heading  = Heading.new(self)
      @body     = Body.new(self, options)
      @graphics << @heading
      @graphics << @body
      
    end
    
    # def heading(options={})
    #   
    # end
    
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