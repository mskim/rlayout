module RLayout
  attr_accessor :title, :path, :paper_size, :portrait, :width, :height, :margin
  attr_accessor :pages
  
  class Document
    
    def initialize(options={}, &block)
      @pages      = []
      @title      = options.fetch(:title, "untitled")
      @path       = options.fetch(:path, nil)
      @paper_size = options.fetch(:paper_size, "A4")
      @portrait   = options.fetch(:portrait, true)
      @width      = options.fetch(:portrai, defaults[:width])
      @height     = options.fetch(:width, defaults[:height])
      @margin     = options.fetch(:margin, defaults[:margin])
      if options[:pages]
        @pages = options[:pages]
      end
      if block
        instance_eval(&block)
      end
      self
    end
    
    def defaults
      {
        width: 600,
        height: 800,
        margin: 50,
      }
    end
    
    def page(options={}, &block)
      @pages << Page.new(self, options, &block)
    end
    
    def save_svg(path)
      s = ""
      @pages.each do |page|
        s = "<document heading>\n"
        s += page.to_svg
        s += "</document ending>\n"
      end
      svg_path = path 
      File.opne(svg_path, 'w'){|f| f.write s}
    end
  end
  
end