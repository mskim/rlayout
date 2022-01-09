module RLayout

  class FrontMatter
    attr_reader :project_path, :book_info, :page_width, :height
    attr_reader :starting_page_number, :toc_doc_page_count, :toc_page_links
    attr_reader :page_count, :toc_content, :document_folders
    attr_reader :toc_first_page_number
    def initialize(project_path, options={})
      @project_path = project_path
      @book_info_path = @project_path + "/book_info.yml"
      @book_info = YAML::load_file(@book_info_path)
      @book_info = Hash[@book_info.map{ |k, v| [k.to_sym, v] }]
      @title = @book_info[:title]
      @paper_size = @book_info[:paper_size] || 'A5'
      @page_width = SIZES[@paper_size][0]
      @height = SIZES[@paper_size][1]
      @starting_page_number = options[:starting_page_number] || 1
      @page_count = 0
      process_front_matter
      self
    end

    def build_folder
      @project_path + "/_build"
    end
    # create prolog, forward, isbn
    def process_front_matter
      @document_folders = []
      FileUtils.mkdir_p(build_front_matter_path) unless File.exist?(build_front_matter_path)
      Dir.glob("#{source_front_matter_path}/*.md").sort.each do |md|
        case File.basename(md)
        # when 'book_info.md'
        # when 'title.md'
        # when 'dedication.md'
        # when 'thankyou.md'
        when 'prologue.md'
          prologue_path = build_front_matter_path + "/prologue"
          story_md_path = prologue_path + "/story.md"
          FileUtils.mkdir_p(prologue_path) unless File.exist?(prologue_path)
          system("cp #{md} #{story_md_path}")
          h = {}
          h[:paper_size] = @paper_size
          h[:document_path] = prologue_path
          h[:page_pdf] = true
          h[:toc] = true
          h[:starting_page] = @starting_page_number
          # h[:header_erb] = header_erb
          # h[:footer_erb] = footer_erb
          r = RLayout::RChapter.new(h)
          @page_count += r.page_count
          @starting_page_number += page_count
          @document_folders << 'prologue'
        when 'toc.md'
          @has_toc = true
          @document_folders << 'toc' 
          # TODO fix this
          @page_count += 1
          @toc_first_page_number = @starting_page_number + 1
          @starting_page_number += 1
          @book_toc = []
        end
      end
      generate_front_matter_toc
    end

    def generate_front_matter_toc
      @doc_generated_toc_info = []
      # doc_info [document_kind, page_count]
      @document_folders.each do |doc_name|
        toc = build_front_matter_path + "/#{doc_name}/toc.yml"
        @doc_generated_toc_info << YAML::load_file(toc) if File.exist?(toc)
      end
      @front_matter_toc = []
      @doc_generated_toc_info.each do |chapter_item|
        chapter_item.each do |toc_item|
          a = []
          a << toc_item[:para_string]
          a << toc_item[:page].to_s
          @front_matter_toc << a
        end
      end
      @toc_content = @front_matter_toc
    end

    def pdf_docs
      pdf_files = []
      @document_folders.each do |doc_folder|
        if doc_folder == 'toc'
          doc_pdf_file = build_front_matter_path + "/#{doc_folder}/toc.pdf"
        else
          doc_pdf_file = build_front_matter_path + "/#{doc_folder}/chapter.pdf"
        end
        pdf_files << doc_pdf_file
      end
      pdf_files
    end

    def pdf_pages
      pdf_pages = []
      @document_folders.each do |doc_folder|
        full_path = build_front_matter_path + "/#{doc_folder}"
        doc_pdf_pages = Dir.glob("#{full_path}/????/page.pdf")
        pdf_pages << doc_pdf_pages
      end
      pdf_pages.flatten
      pdf_pages
    end

    def build_front_matter_path
      build_folder + "/front_matter"
    end

    def source_front_matter_path
      @project_path + "/front_matter"
    end

    def book_title
      @book_info['title'] || 'untitled'
    end

    def width
      @page_width
    end

    def left_margin
      50
    end
    
    def right_margin
      50
    end

    def top_margin
      50
    end

    def bottom_margin
      50
    end

    def header_options
      "parent:self, x:#{left_margin}, y:#{top_margin - 10}, width: #{width}, fill_color: 'clear'"
    end

    def header_erb
      nil
    end

    def footer_width
      width - left_margin - right_margin
    end

    def footer_options
      "parent:self, x:#{left_margin}, y:#{height - bottom_margin - 40}, width: #{footer_width}, height: 12, fill_color: 'clear'"
    end

    def left_footer_erb
      # put book title on the left side 
      s=<<~EOF
      RLayout::Container.new(#{footer_options}) do
        text("<%= @page_number %>  #{book_title} ", font_size: 9, x: 0, width: #{footer_width}, text_alignment: 'left')
      end
      EOF
    end

    def right_footer_erb
      # put chapter title on the right side 
      # chapter title and page_number is place by the layout 
      s=<<~EOF
      RLayout::Container.new(#{footer_options}) do
        text("<%= title %>  <%= @page_number %>", font_size: 9, from_right:0, y: 0, text_alignment: 'right')
      end
      EOF
    end

    def footer_erb
      info = {}
      info[:left_footer] = left_footer_erb
      info[:right_footer] = right_footer_erb
      info
    end  
  end
end