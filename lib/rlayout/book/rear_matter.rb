module RLayout

  class RearMatter
    attr_reader :project_path, :book_info, :page_width, :height
    attr_reader :rear_matter_docs, :body_doc_type
    attr_reader :starting_page_number, :toc_doc_page_count, :toc_page_links
    attr_reader :page_count
    
    def initialize(project_path, options={})
      @project_path = project_path
      @book_info_path = @project_path + "/book_info.yml"
      @book_info = YAML::load_file(@book_info_path)
      @title = @book_info[:title]
      @page_size = options['paper_size'] || 'A5'
      @page_width = SIZES[@page_size][0]
      @height = SIZES[@page_size][1]
      @starting_page_number = options[:starting_page_number] || 1
      @page_count = 0
      process_rear_matter
      self
    end

    def process_rear_matter
      # puts __method__
      @rear_matter_docs = []
      generate_rear_matter_toc
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
  
    def rear_matter_docs_pdf
      []
    end

    def toc_content
      []
    end
  end
end