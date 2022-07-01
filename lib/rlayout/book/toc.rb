# Toc is used as TOC document.
# It can have multiple pages
# Toc acts as Document. 
# It has TocPages, multipe pages if needed
# First TocPage strats with RHeading and LeadTable. Following pages contains only LeadTable
# LeadTable is table with leading ...... 
# some_text ............ 12

module RLayout
  class Toc
    attr_reader :document_path
    attr_reader :document, :output_path, :column_count
    attr_reader :toc_content, :toc_title
    attr_reader :title, :paper_size, :page_count
    attr_reader :link_info, :max_page, :no_table_title
    attr_reader :toc_item_count, :paper_size, :custom_style
    attr_reader :document_path
    attr_reader :width, :height, :left_margin, :top_margin, :right_margin, :bottom_margin
    # attr_reader :document
    include Styleable
    def initialize(options={})
      @document_path = options[:document_path]
      @style_guide_folder = options[:style_guide_folder] || @document_path
      @output_path = options[:output_path] || @document_path + "/chapter.pdf"
      @width = options[:width]
      @height = options[:height]
      @left_margin = options[:left_margin]
      @top_margin = options[:top_margin]
      @right_margin = options[:right_margin]
      @bottom_margin = options[:bottom_margin]
      @page_pdf =  options[:page_pdf] || false
      
      @page_count = options[:page_count]
      @max_page = options[:max_page] || 1
      @toc_item_count = options[:toc_item_count] || 20
      @output_path    = options[:output_path] || @document_path + "/toc.pdf"
      @no_table_title = options[:no_table_title]
      @page_pdf = options[:page_pdf] || true
      @jpg = options[:jpg] || false
      load_doc_style
      read_toc
      layout_toc
      # @link_info = update_link_info
      @document.save_pdf(@output_path, page_pdf:@page_pdf, jpg: @jpg) unless options[:no_output]
      self
    end

    def read_toc
      @toc_content_path = @document_path + "/toc_content.yml"
      unless File.exist?(@toc_content_path)
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
      if @page_count 
        page_item_count = (@toc_content.length / @page_count.to_f).ceil
        @toc_content_for_page = @toc_content.each_slice(page_item_count).to_a
      elsif @toc_item_count
        #TODO: how about first page with title, it should be less than the rest???
        @toc_content_for_page = @toc_content.each_slice(@toc_item_count).to_a
      else
        @toc_content_for_page = @toc_content.each_slice(20).to_a
      end

      if @document.pages.length < @toc_content_for_page.length
        needed_page_count = @toc_content_for_page.length - @document.pages.length
        needed_page_count.times do
          @document.add_new_page
        end
      end

      @toc_content_for_page.each_with_index do |page_data, i|
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
        if page
          page.link_info
        else
          nil
        end
      end

    end

    def default_layout_rb
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
        RLayout::RDocument.new(width:#{@width}, height:#{@height} , page_count: #{@max_page}, page_type: "toc_page")
      EOF
    end

    def default_header_footer_yml
      <<~EOF
      ---
      has_hearder: false
      has_footer: false
      ---

      EOF
    end
  end


end

