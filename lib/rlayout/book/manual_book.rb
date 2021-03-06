module RLayout

  class ManualBook < Book

    def initialize(project_path, options={})
      @body_doc_type = 'chapter'
      @project_path = project_path
      @book_info_path = @project_path + "/book_info.yml"
      @book_info = YAML::load_file(@book_info_path)
      @book_info = Hash[@book_info.map{ |k, v| [k.to_sym, v] }]
      @title = @book_info[:title]
      @paper_size = options[:paper_size] || 'A5'
      @paper_size = options[:paper_size]  if options[:paper_size]
      @page_width = SIZES[@paper_size][0]
      @height = SIZES[@paper_size][1]
      @starting_page_number = 1
      create_book_cover
      @front_matter = FrontMatter.new(@project_path)
      @starting_page_number += @front_matter.page_count
      @body_matter = BodyMatter.new(@project_path, starting_page_number: @starting_page_number, paper_size: @paper_size)
      @rear_matter = RearMatter.new(@project_path)
      generate_toc
      generate_pdf_for_print
      generate_pdf_book       
      generate_ebook unless options[:no_ebook]      # merge cover with inner_book
      # generate_ebook unless options[:no_ebook]
      # push_to_git_repo if options[:push_to_git_repo]
    end

    def build_folder
      @project_path + "/_build"
    end

    def source_book_cover_path
      @project_path + "/book_cover"
    end
  
    def build_book_cover_path
      build_folder + "/book_cover"
    end
    
  end
end