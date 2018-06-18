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
    attr_accessor :page_headings, :document_view_pdf
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
      @column_count = options.fetch(:column_count, 1)
      @left_margin  = options.fetch(:left_margin, document_defaults[:left_margin])
      @top_margin    = options.fetch(:top_margin, document_defaults[:top_margin])
      @right_margin = options.fetch(:right_margin, document_defaults[:right_margin])
      @bottom_margin = options.fetch(:bottom_margin, document_defaults[:bottom_margin])
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
          page_hash[:parent]  = self
          Page.new(page_hash)
        end
      elsif options[:page_objects]
        @pages = options[:page_objects]
      elsif options[:page_count]
        options[:page_count].times do
          options[:parent]  = self
          Page.new(options)
        end
      else
        # create single page as default initial page
        options[:parent]  = self
        Page.new(options)
      end
      @page_headings = options.fetch(:page_headings,[])
      @column_count = options.fetch(:column_count, 1)
      if proposed_style = options[:current_style]
        if proposed_style.is_a?(Hash) && proposed_style != {}
          RLayout::StyleService.shared_style_service.current_style.merge! proposed_style
        end
      end

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
      options[:parent] = self
      options[:paper_size] = @paper_size
      Page.new(options, &block)
    end

    def add_page(page, options={})
      if page.class == Page
        page.parent_graphic = self
        @pages << page
      elsif page.class == Array
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
        @document_view_pdf = DocumentViewPdf.new(self)
        @document_view_pdf.save_pdf(path, options)
        @pages.length
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
