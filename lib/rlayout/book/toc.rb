# Toc is used as TOC document.
# It can have multiple pages
# Toc acts as Document. 
# It has TocPages, multipe pages if needed
# First TocPage strats with RHeading and LeadTable. Following pages contains only LeadTable
# LeadTable is table with leading ...... 
# some_text ............ 12

module RLayout
  class Toc < DocumentBase
    attr_reader :document_path
    attr_reader :document, :output_path, :column_count
    attr_reader :toc_content, :toc_title
    attr_reader :title, :paper_size, :page_count
    attr_reader :link_info, :max_page, :parts_count, :no_table_title
    attr_reader :toc_item_count, :paper_size, :custom_style

    def initialize(options={})
      @document_path  = options[:document_path]
      @style_guide_folder = options[:style_guide_folder] || @document_path
      @custom_style = options[:custom_style]
      @max_page = options[:max_page]
      @toc_item_count = options[:toc_item_count] || 20
      @parts_count = options[:parts_count]
      @no_table_title = options[:no_table_title]
      @paper_size      = options[:paper_size] || 'A5'
      @page_count     = options[:page_count] || 1
      @story_path     = @document_path + "/story.md"
      @output_path    = options[:output_path] || @document_path + "/toc.pdf"
      @layout_rb      = default_document
      @page_pdf       = options[:page_pdf]
      @document       = eval(@layout_rb)
      @link_info      = [] # array of page with toc link
      if @document.is_a?(SyntaxError)
        puts "SyntaxError in #{@document} !!!!"
        return
      end
      unless @document.kind_of?(RLayout::RDocument)
        puts "Not a @document kind created !!!"
        return
      end
      load_text_style
      read_toc
      layout_toc
      @link_info = update_link_info
      @document.save_pdf(@output_path, page_pdf:@page_pdf) unless options[:no_output]
      self
    end

    def read_toc
      @toc_content_path = @document_path + "/toc_content.yml"
      unless File.exist?(@toc_content_path)
        # puts "/toc_content.yml not found!!!"
        @toc_content = [
          ['차    례'],
          ['여기는 제목 1',  '4'],
          ['여기는 제목 2',  '12'],
          ['여기는 제목 3',  '30'],
          ['여기는 제목 4',  '40'],
          ['여기는 제목 5',  '55'],
          ['여기는 제목 7',  '65'],
          ['여기는 제목 8',  '79'],
          ['여기는 제목 9',  '84'],
          ['여기는 제목 10',  '102'],
        ]
        @toc_title = @toc_content.shift.first
      else
        @toc_content = YAML::load_file(@toc_content_path)
        if @toc_content.first.length == 1
          @toc_title = @toc_content.shift.first
        else
          @toc_title = '차    례'
        end
      end
    end

    def layout_toc
      first_page    = @document.pages.first
      unless @no_table_title
        h             = {}
        # h[:parent]    = first_page
        h[:text_string]     = @toc_title
        h[:heading_height_type] = "quarter"
        h[:style_name] = 'title' # toc_title
        h[:layout_length] = 2
        h[:layout_expand] = [:height]
        first_page.add_toc_title(h)
      end
      @toc_content.each_slice(@toc_item_count).each_with_index do |page_data, i|
        if @document.pages.length < i + 1
          @document.add_new_page
        end
        page = @document.pages[i]
        h                 = {}
        h[:parent]        = page
        h[:layout_length] = 10
        h[:layout_expand] = [:height]
        h[:table_data]    = page_data
        page.add_toc_table(h)
        page.relayout!
      end
    end

    def update_link_info
      @document.pages.map do |page|
        page.link_info
      end

    end

    def default_document
      case @paper_size
      when "A4"
        @left_margin    = 100
        @top_margin     = 100
        @right_margin   = 100
        @bottom_margin  = 100
      when "16절"
        @left_margin    = 80
        @top_margin     = 50
        @right_margin   = 80
        @bottom_margin  = 50
      when "A5"
        @left_margin    = 30
        @top_margin     = 50
        @right_margin   = 50
        @bottom_margin  = 50
      else 
        @left_margin    = 50
        @top_margin     = 50
        @right_margin   = 50
        @bottom_margin  = 50
      end


      layout =<<~EOF
        RLayout::RDocument.new(paper_size:"#{@paper_size}", page_count: 1, page_type: "toc_page")
      EOF
    end
  end


end

