module RLayout
  class PdfBook
    attr_reader :project_path, :pdf_files
    def initialize(project_path, options={})
      @project_path = project_path
      process_pdf_book

      self
    end

    def book_info_path
      @project_path + "/book_info.yml"
    end

    def build_path
      @project_path + "/_build"
    end

    def process_pdf_book
      book_info = YAML::load_file(book_info_path)
      parse_pdf_files
      create_pages_from_pdf
    end

    def parse_pdf_files
      @pdf_files = Dir.glob("#{@project_path}/*.pdf")
    end

    def create_pages_from_pdf
      starting_page_number = 1
      @pdf_files.each do |pdf|
        starting_page_number += split_pdf(pdf, starting_page_number)
      end
    end

  end
end