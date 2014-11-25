# encoding: utf-8

require 'yaml'

SIZES = { "4A0" => [4767.87, 6740.79],
          "2A0" => [3370.39, 4767.87],
           "A0" => [2383.94, 3370.39],
           "A1" => [1683.78, 2383.94],
           "A2" => [1190.55, 1683.78],
           "A3" => [841.89, 1190.55],
           "A4" => [595.28, 841.89],
           "A5" => [419.53, 595.28],
           "A6" => [297.64, 419.53],
           "A7" => [209.76, 297.64],
           "A8" => [147.40, 209.76],
           "A9" => [104.88, 147.40],
          "A10" => [73.70, 104.88],
           "B0" => [2834.65, 4008.19],
           "B1" => [2004.09, 2834.65],
           "B2" => [1417.32, 2004.09],
           "B3" => [1000.63, 1417.32],
           "B4" => [708.66, 1000.63],
           "B5" => [498.90, 708.66],
           "B6" => [354.33, 498.90],
           "B7" => [249.45, 354.33],
           "B8" => [175.75, 249.45],
           "B9" => [124.72, 175.75],
          "B10" => [87.87, 124.72],
           "C0" => [2599.37, 3676.54],
           "C1" => [1836.85, 2599.37],
           "C2" => [1298.27, 1836.85],
           "C3" => [918.43, 1298.27],
           "C4" => [649.13, 918.43],
           "C5" => [459.21, 649.13],
           "C6" => [323.15, 459.21],
           "C7" => [229.61, 323.15],
           "C8" => [161.57, 229.61],
           "C9" => [113.39, 161.57],
          "C10" => [79.37, 113.39],
          "RA0" => [2437.80, 3458.27],
          "RA1" => [1729.13, 2437.80],
          "RA2" => [1218.90, 1729.13],
          "RA3" => [864.57, 1218.90],
          "RA4" => [609.45, 864.57],
         "SRA0" => [2551.18, 3628.35],
         "SRA1" => [1814.17, 2551.18],
         "SRA2" => [1275.59, 1814.17],
         "SRA3" => [907.09, 1275.59],
         "SRA4" => [637.80, 907.09],
    "EXECUTIVE" => [521.86, 756.00],
        "FOLIO" => [612.00, 936.00],
        "LEGAL" => [612.00, 1008.00],
       "LETTER" => [612.00, 792.00],
       "TABLOID" => [792.00, 1224.00],
       "NAMECARD"=> [260.79, 147.40],
       "PRODUCT"=> [300, 300]}


module RLayout
  BookNode = Struct.new(:category, :title, :starting_page, :page_count) do
    def next_node_starting_page
      @starting_page + @page_count
    end
  end
  
  TocNode = Struct.new(:markup, :text_string, :page_number)
    
  class Document
    attr_accessor :title, :path, :paper_size, :portrait, :margin, :width, :height, :starts_left, :double_side
    attr_accessor :left_margin, :top_margin, :right_margin, :bottom_margin
    attr_accessor :pages, :document_view, :starting_page_number
    attr_accessor :page_view_count, :toc_elements
    attr_accessor :current_style
    def initialize(options={}, &block)
      @pages      = []
      @title      = options.fetch(:title, "untitled")
      @path       = options.fetch(:path, nil)
      @paper_size = options.fetch(:paper_size, "A4")
      @portrait   = options.fetch(:portrait, defaults[:portrait])
      @double_side= options.fetch(:double_side, defaults[:double_side])
      @starts_left= options.fetch(:starts_left, defaults[:starts_left])
      @width      = options.fetch(:width, defaults[:width])
      @height     = options.fetch(:width, defaults[:height])
      @margin     = options.fetch(:margin, defaults[:margin])
      if options[:starting_page_number]
        @starting_page_number = options[:starting_page_number]
        if @starting_page_number.odd?
          @starts_left = false
        end
      elsif @starts_left
        @starting_page_number = 2
      else
        @starting_page_number = 1
      end
      
      if options[:pages]
        @pages = options[:pages]
      end
      @current_style = options.fetch(:current_style, DEFAULT_STYLES)
      
      if @toc_on
        # save_toc elements for this document
        @toc_elements = []
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
        margin: 100,
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
    
    def to_hash
      h = {}
      h[:title]   = @title
      h[:width]   = @width
      h[:height]  = @height
      if @pages.length > 0
        h[:pages]=[]
        @pages.each do |page|
          h[:pages] << page.to_hash
        end
      end
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
    
    def save_yml(path)
      File.open(path, 'w'){|f| f.write to_hash.to_yaml}
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
    
    def save_pdf(path)
      if RUBY_ENGINE == 'macruby'
        @ns_view = DocumentViewMac.new(self)
        @page_view_count = @ns_view.save_pdf(path)
      end
    end
    
    def save_toc(path)
      File.open(path, 'w'){|f| f.write toc_element.to_yaml}
    end
  end
  
end

