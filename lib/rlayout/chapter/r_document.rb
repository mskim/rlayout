# encoding: utf-8


# story is parsed as series of paragraph
# paragraph
# document has story
# page has column_box
# column_box has lines
# r_text_text_box has story
# single_column_text_box has story
# heading has single_column_text_box
#     - TitleText < TextBox
#     - SubtitleText < TextBox
#     - QuoteText < TextBox
#     -
#
# StoryContainer
#   story
#   paragraph
# Document
#   pages
# TextBox < Container
#   column_box
#   column_count


module RLayout

  class RDocument
    attr_accessor :title, :path, :paper_size, :portrait, :width, :height, :starts_left, :double_side
    attr_accessor :left_margin, :top_margin, :right_margin, :bottom_margin
    attr_accessor :pages, :document_view, :starting_page
    attr_accessor :page_view_count, :toc_elements
    attr_accessor :header_rule, :footer_rule, :gim
    attr_accessor :left_margin, :top_margin, :right_margin, :bottom_margin
    attr_accessor :pdf_path, :jpg, :preview, :column_count, :layout_style
    attr_accessor :page_headings, :document_view_pdf, :heading_type, :body_line_count, :body_line_height
    def initialize(options={}, &block)
      @pages            = []
      @title            = "untitled"
      @title            = options[:title] if options[:title]
      @path             = options[:path]  if options[:path]
      @heading_type     = options[:heading_type] || "fixed_height"
      @body_line_height = document_defaults[:body_line_height]

      if options[:doc_info]
        @paper_size       = options[:doc_info].fetch(:paper_size, "A4")
        @body_line_count  = options[:doc_info].fetch(:body_line_count, 30)
        @portrait         = options[:doc_info].fetch(:portrait, document_defaults[:portrait])
        @double_side      = options[:doc_info].fetch(:double_side, document_defaults[:double_side])
        @starts_left      = options[:doc_info].fetch(:starts_left, document_defaults[:starts_left])
        @body_line_height = options[:doc_info][:body_line_height] if options[:doc_info][:body_line_height]
      else
        @paper_size       = options.fetch(:paper_size, "A4")
        @body_line_count  = options.fetch(:body_line_count, 30)
        @portrait         = options.fetch(:portrait, document_defaults[:portrait])
        @double_side      = options.fetch(:double_side, document_defaults[:double_side])
        @starts_left      = options.fetch(:starts_left, document_defaults[:starts_left])
      end

      if options[:current_style]
        RLayout::StyleService.shared_style_service.current_style = options[:current_style]
      else
        RLayout::StyleService.shared_style_service.set_chapter_style
      end

      @left_margin      =  document_defaults[:left_margin]
      @left_inset       =  document_defaults[:left_inset]
      @top_margin       =  document_defaults[:top_margin]
      @top_inset        =  document_defaults[:top_margin]
      @right_margin     =  document_defaults[:right_margin]
      @right_inset      =  document_defaults[:right_inset]
      @bottom_margin    =  document_defaults[:bottom_margin]
      @bottom_inset     =  document_defaults[:bottom_inset]

      if @paper_size && @paper_size != "custom"
        @width   = SIZES[@paper_size][0]
        @height  = SIZES[@paper_size][1]
      else
        @paper_size = document_defaults[:paper_size]
        @width   = SIZES[@paper_size][0]
        @height  = SIZES[@paper_size][1]
      end
      if @portrait == false
        temp    = @width
        @width  = @height
        @height = temp
      end
      @body_line_count   = ((@height - @top_margin - @top_inset - @bottom_margin - @bottom_inset)/@body_line_height).to_i

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
      @column_count   = options.fetch(:column_count, 1)
      @left_margin    = options.fetch(:left_margin, document_defaults[:left_margin])
      @top_margin     = options.fetch(:top_margin, document_defaults[:top_margin])
      @right_margin   = options.fetch(:right_margin, document_defaults[:right_margin])
      @bottom_margin  = options.fetch(:bottom_margin, document_defaults[:bottom_margin])
      if options[:starting_page]
        @starting_page = options[:starting_page]
        if @starting_page.odd?
          @starts_left = false
        end
      elsif @starts_left
        @starting_page = 2
      else
        @starting_page = 1
      end
      if options[:initial_page] == false
        # do not create any page
      elsif options[:pages]
        options[:pages].each do |page_hash|
          page_hash[:parent]        = self
          page_hash[:first_page]    = true
          RPage.new(page_hash)
        end
      elsif options[:page_objects]
        @pages = options[:page_objects]
      elsif options[:page_count]
        options[:page_count].times do |i|
          h = {}
          h[:parent]  = self
          h[:first_page] = true if i == 0
          RPage.new(options)
        end
      else
        # create single page as default initial page
        options[:parent]                  = self
        options[:first_page]              = true
        options[:fixed_height]            = true
        options[:page_number]             = 1
        options[:page_number]             = @starting_page if @starting_page
        RPage.new(options)
      end
      @page_headings = options.fetch(:page_headings,[])
      @column_count = options.fetch(:column_count, 1)
 

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
        starts_left: false,
        paper_size: "A4",
        width: 595.28,
        height: 841.89,
        left_margin: 50,
        left_inset: 0,
        top_margin: 50,
        top_inset: 0,
        right_margin: 50,
        right_inset: 0,
        bottom_margin: 50,
        bottom_inset: 0,
        heading_type: 'fixed_height',
        body_line_height: 18
      }
    end

    def first_line
      @main_box.graphics.first.graphics.first
    end

    def layout_rect
      [@left_margin, @top_margin, @width - @left_margin - @right_margin, @height - @top_margin - @bottom_margin]
    end

    def add_new_page
      options[:parent]        = self
      options[:paper_size]    = @paper_size
      options[:page_numver]   = @pages.length
      options[:page_numver]   += @starting_page
      new_page =RPage.new(options, &block)
      new_page.first_line
    end

    def page(options={}, &block)
      options[:parent] = self
      options[:paper_size] = @paper_size
      RPage.new(options, &block)
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
        page[:klass] = "RPage"
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

    def pdf_document
      @document_view ||= DocumentViewMac.new(self)
      @document_view.pdf_document
    end

    def save_svg(path, options={})
      puts "++++++++++++ save_svg"
      "path:#{path}"
      s= path
      "some string"
    end

    def save_pdf(path, options={})
      if RUBY_ENGINE == 'rubymotion'
        @ns_view = DocumentViewMac.new(self)
        @page_view_count = @ns_view.save_pdf(path, options)
      else
        save_pdf_in_ruby(path, options={})
      end
    end

    def save_toc(path)
      File.open(path, 'w'){|f| f.write toc_element.to_yaml}
    end

    def to_pgscript
      layout = ""
      @pages.each do |page|
        layout +=page.to_pgscript
      end
      layout
    end

    def save_document_layout(options={})
      doc_variables = "width: #{@width}, height: #{@height}"
      # doc_variables += ", "
      doc_layout_file= "RLayout::Document.new(#{doc_variables}) do\n"
      doc_layout_file+= to_pgscript
      doc_layout_file+= "end"
      if options[:output_path]
        File.open(options[:output_path], 'w'){|f| f.write doc_layout_file}
      end
    end
  end

end
