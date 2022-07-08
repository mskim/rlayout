module RLayout

  class RearMatter
    attr_reader :project_path, :book_info, :page_width, :height
    attr_reader :rear_matter_docs, :body_doc_type
    attr_reader :starting_page_number, :toc_page_count, :toc_page_links
    attr_reader :page_count
    attr_reader :document_folders

    def initialize(project_path, starting_page_number, options={})
      @project_path = project_path
      @book_info_path = @project_path + "/book_info.yml"
      @book_info = YAML::load_file(@book_info_path)
      @book_info = Hash[@book_info.map{ |k, v| [k.to_sym, v] }]
      @title = @book_info[:title]
      @page_size = options['paper_size'] || 'A5'
      @page_width = SIZES[@page_size][0]
      @height = SIZES[@page_size][1]
      @starting_page_number = options[:starting_page_number] || 1
      @page_count = 0
      process_rear_matter(options)
      self
    end

    def build_rear_matter_path
      @project_path + "/_build/rear_matter"
    end

    def style_guide_folder
      @project_path + "/style_guide"
    end
    # def process_rear_matter
    #   @rear_matter_docs = []
    #   generate_rear_matter_toc
    # end

    # create prolog, forward, isbn
    def process_rear_matter(options)
      @document_folders = []
      Dir.glob("#{build_rear_matter_path}/*").sort.each do |file|
        h = options.dup
        h[:page_pdf] = true
        h[:toc] = true
        h[:starting_page_number] = @starting_page_number
        if file =~ /isbn$/
          h[:document_path] = file
          h[:toc] = false
          h[:has_footer] = false
          h[:has_header] = false
          h[:style_guide_folder] = style_guide_folder + "/isbn"
          r = RLayout::Isbn.new(h)
          @starting_page_number += r.page_count
          @document_folders << file
        elsif file =~ /blank_page$/
          h[:document_path] = file
          h[:toc] = false
          h[:has_footer] = false
          h[:has_header] = false
          h[:style_guide_folder] = style_guide_folder + "/blank_page"
          r = RLayout::BlankPage.new(h)
          @starting_page_number += r.page_count
          @document_folders << file
        else
          puts "#{file}"
        end
      end
    end

    def pdf_pages
      pdf_pages = []
      @document_folders.each do |doc_folder|
        doc_pdf_pages = Dir.glob("#{doc_folder}/????/page.pdf")
        pdf_pages << doc_pdf_pages
      end
      pdf_pages.flatten
      pdf_pages
    end

    def generate_rear_matter_toc
      @rear_matter_toc = []
      # doc_info [document_kind, page_count]
      @rear_matter_docs.each do |doc_name|
        toc = build_front_matter_path + "/#{doc_name}/toc.yml"
        @rear_matter_toc << YAML::load_file(toc) if File.exist?(toc)
      end
      @rear_matter_toc
    end
  
    # def rear_matter_docs_pdf
    #   []
    # end

    def toc_content
      []
    end
  end
end