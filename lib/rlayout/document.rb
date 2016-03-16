# encoding: utf-8

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
       "IDCARD"=> [147.40, 260.79],
       "PRODUCT"=> [300, 300]}

# gim: Grouped Image Manager
# Image layout pattern

module RLayout
  BookNode = Struct.new(:category, :title, :starting_page, :page_count) do
    def next_node_starting_page
      @starting_page + @page_count
    end
  end

  TocNode = Struct.new(:markup, :text_string, :page_number)

  class Document
    attr_accessor :title, :path, :paper_size, :portrait, :width, :height, :starts_left, :double_side
    attr_accessor :left_margin, :top_margin, :right_margin, :bottom_margin
    attr_accessor :pages, :document_view, :starting_page_number
    attr_accessor :page_view_count, :toc_elements
    attr_accessor :header_rule, :footer_rule, :gim
    attr_accessor :left_margin, :top_margin, :right_margin, :bottom_margin
    attr_accessor :pdf_path, :jpg, :preview, :column_count, :layout_style
    def initialize(options={}, &block)
      @pages      = []
      @title      = "untitled"
      @title      = options[:title] if options[:title]
      @path       = options[:path]  if options[:path]
      if options[:doc_info]
        @paper_size = options[:doc_info].fetch(:paper_size, "A4")
        @portrait   = options[:doc_info].fetch(:portrait, document_defaults[:portrait])
        @double_side= options[:doc_info].fetch(:double_side, document_defaults[:double_side])
        @starts_left= options[:doc_info].fetch(:starts_left, document_defaults[:starts_left])
      elsif options[:layout_style]
        @paper_size = options[:layout_style].fetch(:paper_size, "A4")
        @portrait   = options[:layout_style].fetch(:portrait, document_defaults[:portrait])
        @double_side= options[:layout_style].fetch(:double_side, document_defaults[:double_side])
        @starts_left= options[:layout_style].fetch(:starts_left, document_defaults[:starts_left])
      else        
        @paper_size = options.fetch(:paper_size, "A4")
        @portrait   = options.fetch(:portrait, document_defaults[:portrait])
        @double_side= options.fetch(:double_side, document_defaults[:double_side])
        @starts_left= options.fetch(:starts_left, document_defaults[:starts_left])
      end
      
      if @paper_size && @paper_size == "custom"
        @width  = options.fetch(:width, document_defaults[:width])
        @height = options.fetch(:height, document_defaults[:height])
      else
        @width  = SIZES[@paper_size][0]
        @height = SIZES[@paper_size][1]
      end
      
      if @portrait == false
        temp    = @width
        @width  = @height
        @height = temp
      end
      # for printing 
      if options[:pdf_path]
        @pdf_path = options[:pdf_path]
      end
      
      if options[:jpg]
        @jpg = options[:jpg]
      end
      if options[:preview]
        @preview = options[:preview]
      end
      
      @left_margin= options.fetch(:left_margin, document_defaults[:left_margin])
      @top_margin = options.fetch(:top_margin, document_defaults[:top_margin])
      @right_margin = options.fetch(:right_margin, document_defaults[:right_margin])
      @bottom_margin= options.fetch(:bottom_margin, document_defaults[:bottom_margin])
      if options[:starting_page_number]
        @starting_page_number = options[:starting_page_number]
        if @starting_page_number.odd?
          @starts_left = false
        end
      elsif @starts_left
        @starting_page_number = 1
      else
        @starting_page_number = 2
      end
      if options[:initial_page] == false        
        # do not create any page
      elsif options[:pages]
        options[:pages].each do |page_hash|
          Page.new(self, page_hash)
        end
      elsif options[:page_objects]
        @pages = options[:pages]
      elsif options[:page_count]
        options[:page_count].times do
          Page.new(self, options)
        end
      else
        # create single page as default initial page
        Page.new(self, options)
      end
      
      @column_count = options.fetch(:column_count, 1)
      RLayout::StyleService.shared_style_service.current_style = options.fetch(:current_style, DEFAULT_STYLES)
      if @toc_on
        # save_toc elements for this document
        @toc_elements = []
      end

      if block
        instance_eval(&block)
      end
      self
    end

    def document_defaults
      {
        portrait: true,
        double_side: false,
        starts_left: true,
        paper_size: "A4",
        width: 595.28,
        height: 841.89,
        left_margin: 50,
        top_margin: 50,
        right_margin: 50,
        bottom_margin: 50,
      }
    end
    
    def layout_rect
      [@left_margin, @top_margin, @width - @left_margin - @right_margin, @height - @top_margin - @bottom_margin]
    end
    
    def page(options={}, &block)
      Page.new(self, options, &block)
    end

    def add_page(page, options={})
      if page.class == Page
        page.parent_graphic = self
        @pages << page
      elsif page.class == Array
        puts "adding Array of pages" 
        page.each do |p|
          add_page(p)
        end
      end
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
      h[:title]       = @title
      h[:paper_size]  = @paper_size
      if @paper_size == 'custom'
        h[:width]       = @width
        h[:height]      = @height
      end
      if @pages.length > 0
        h[:pages] =@pages.map {|page| page.to_hash}
      end
      h
    end
    
    def self.upgrade_format(old_hash)
      new_hash = old_hash.dup
      new_pages = []
      new_hash[:pages].each do |page|
        page = Graphic.upgrade_format(page)
        page[:klass] = "Page"
        new_pages << page
      end
      new_hash[:version]  = "1.1"
      new_hash[:pages]    = new_pages
      new_hash
    end
    
    def self.open(path, options={})
      rlayout_yaml_path= path + "/layout.yml"
      hash = {}
      unless File.exists?(rlayout_yaml_path)
        puts "template #{rlayout_yaml_path} not found ..."
        hash = {}
      else
        hash=YAML::load(File.open(rlayout_yaml_path, 'r'){|f| f.read})
        if hash[:version] == '1.0'
          puts "hash:#{hash[:version]}"
          hash = upgrade_format(hash)
        end
      end
      hash=hash.merge(options)
      hash[:path] = path
      doc=Document.new(hash)
      doc
    end

    def self.rlayout(path, options={},&block)
      options[:path]=path
      doc=Document.new(options,&block)
      doc.rlayout(path)      
      doc
    end

    def save_yml(path)
      File.open(path, 'w'){|f| f.write to_hash.to_yaml}
    end
    
    # def save_pdf_doc(options={})
    #   @ns_view = DocumentViewMac.new(self)
    #   options[:jpg] = @jpg if @jpg
    #   @page_view_count = @ns_view.save_pdf(@pdf_path, options)
    # end
    
    def save_pdf(path, options={})
      if RUBY_ENGINE == 'rubymotion'
        @ns_view = DocumentViewMac.new(self)
        @page_view_count = @ns_view.save_pdf(path, options)
      else
        puts "RUBY_ENGINE:#{RUBY_ENGINE}"
      end
    end

    def save_toc(path)
      File.open(path, 'w'){|f| f.write toc_element.to_yaml}
    end
    
    def pages_layout_file
      ""
    end
    
    def save_document_layout(options={})
      doc_layout_file= "RLayout::Document.new(paper_size: #{@paper_size})\n"
      doc_layout_file+= pages_layout_file
      doc_layout_file+= "end"
    end
  end

end
