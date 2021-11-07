module RLayout

  class BodyMatterWithPictureSpread
    attr_reader :project_path, :book_info, :page_width, :height
    attr_reader :document_folders, :body_matter_toc, :body_doc_type
    attr_reader :starting_page_number, :toc_doc_page_count, :toc_page_links
    attr_reader :toc_content
    def initialize(project_path, options={})
      @project_path = project_path
      @book_info_path = @project_path + "/book_info.yml"
      @book_info = YAML::load_file(@book_info_path)
      @title = @book_info[:title] || @book_info['title']
      @page_size = options['paper_size'] || 'A5'
      @page_width = SIZES[@page_size][0]
      @height = SIZES[@page_size][1]
      @body_doc_type = options[:body_doc_type] || 'picture_spread'
      @starting_page_number = options[:starting_page_number] || 2
      process_body_matter_with_picture_spread
      self
    end

    def process_body_matter_with_picture_spread
      @document_folders = []
      Dir.glob("#{@project_path}/**_**").sort.each_with_index do |spread_path, i|
        if File.basename(spread_path) =~/^\d\d/
          r = RLayout::PictureSpread.new(spread_path, starting_page_number: @starting_page_number, order: i + 1)
          @document_folders << spread_path
          @starting_page_number += 2
        end
      end
      # generate_body_matter_toc
    end
  
    def pdf_docs
      pdf_files = []
      @document_folders.each do |spread|
        spread_pdf_file = spread + "/spread.pdf"
        pdf_files << spread_pdf_file if File.exist?(spread_pdf_file)
      end
      pdf_files
    end

  end
end