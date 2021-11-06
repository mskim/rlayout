module RLayout

  class BodyMatterWithPart
    attr_reader :project_path, :book_info, :page_width, :height
    attr_reader :document_folders, :body_matter_toc, :body_doc_type
    attr_reader :starting_page_number, :toc_doc_page_count, :toc_page_links
    attr_reader :toc_content
    def initialize(project_path, options={})
      @project_path = project_path
      @book_info_path = @project_path + "/book_info.yml"
      @book_info = YAML::load_file(@book_info_path)
      @title = @book_info[:title]
      @page_size = options['paper_size'] || 'A5'
      @page_width = SIZES[@page_size][0]
      @height = SIZES[@page_size][1]
      @body_doc_type = options[:body_doc_type]
      @starting_page_number = options[:starting_page_number] || 1
      process_body_matter_with_parts
      self
    end

    def process_body_matter_with_parts
      @document_folders = []
      Dir.glob("#{@project_path}/part_*").sort.each_with_index do |part, i|
        r = RLayout::BookPart.new(part, body_doc_type: @body_doc_type, starting_page_number: @starting_page_number, order: i + 1)
        @document_folders += r.part_docs
        @starting_page_number = r.next_part_starting_page
      end
      generate_body_matter_toc
    end
  
    def generate_body_matter_toc
      @body_matter_toc = []
      @document_folders.each do |chapter_folder|
        toc = chapter_folder + "/toc.yml"
        @body_matter_toc << YAML::load_file(toc) if File.exist?(toc)
      end
      save_toc_content
    end
  
    def save_toc_content
      flatten_toc = []
      @body_matter_toc.each do |chapter_item|
        chapter_item.each do |toc_item|
          a = []
          if toc_item[:markup] == 'h2'
            a << "   #{toc_item[:para_string]}"
          else
            a << toc_item[:para_string]
          end
          a << toc_item[:page].to_s
          flatten_toc << a
        end
      end
      @toc_content = flatten_toc
      # File.open(toc_yml_path, 'w'){|f| f.write flatten_toc.to_yaml}
    end
  
    def pdf_docs
      pdf_files = []
      @document_folders.each do |chapter|
        chapter_pdf_file = chapter + "/chapter.pdf"
        pdf_files << chapter_pdf_file if File.exist?(chapter_pdf_file)
      end
      pdf_files
    end

  end
end