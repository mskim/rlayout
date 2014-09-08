module RLayout
  attr_accessor :title, :path, :paper_size, :portrait, :width, :height, :margin
  attr_accessor :pages, :document_view
  
  class Document
    
    def initialize(options={}, &block)
      @pages      = []
      @title      = options.fetch(:title, "untitled")
      @path       = options.fetch(:path, nil)
      @paper_size = options.fetch(:paper_size, "A4")
      @portrait   = options.fetch(:portrait, defaults[:portrait])
      @dobule_side= options.fetch(:dobule_side, defaults[:dobule_side])
      @starts_left= options.fetch(:dobule_side, defaults[:starts_left])
      @width      = options.fetch(:width, defaults[:width])
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
        portrait: true,
        double_side: false,
        starts_left: true,
        width: 600,
        height: 800,
        margin: 50,
      }
    end
    
    def page(options={}, &block)
      Page.new(self, options, &block)
    end
    
    def layout_page
      side_margin = 100
      top_margin = 50
      horizontal_gutter = 20
      
      if @double_side
        @document_width   = @width * 2 + side_margin*2
        page_pairs = @pages.length / 2
        page_pairs += 1 if @pages.length % 2 !=0
        @document_height  = @height*page_pairs + top_margin*2 + horizontal_gutter*(page_pairs-1)
        
        #TODO do it for double_side
        #TODO for starts_left
      
      else
        puts "single side"
        puts "@pages.length:#{@pages.length}"
        @document_width   = @width + side_margin*2
        @document_height  = @height*@pages.length + top_margin*2 + horizontal_gutter*(@pages.length-1)
        x = side_margin
        y = top_margin
        @pages.each do |page|
          page.x = x
          page.y = y
          y += page.height + horizontal_gutter
        end
      end
    end
        
    def to_data
      h = {}
      h[:title] = @title
      h[:width] = @width
      h[:pages] = @pages.map{|page| page.to_data}
      h
    end
    
    def to_svg
      # TODO
      # SVG 1.1 does not support multipe page svg, SVG 1.2 has <pageSet> for multiple page support
      # but it does not work in Safari
      # So, save each pages as separate files
      # layout_page
      
      # s = "<svg xmlns=\"http://www.w3.org/2000/svg\" xmlns:xlink=\"http://www.w3.org/1999/xlink\" x=\"0\" y=\"0\" width=\"#{@document_width}\" height=\"#{@document_height}\">\n"
      # @pages.each do |page|
      #   s += page.save_svg(page)
      # end
      # s += "</svg>"      
    end
    
    def save_svg(path)
      dir = File.dirname(path)
      ext = File.extname(path)
      base = File.basename(path, ".svg")
      @pages.each_with_index do |page, i|
        path = dir + "/#{base}" + i.to_s + "#{ext}"
        page.save_svg(path)
      end
    end
  end
  
end