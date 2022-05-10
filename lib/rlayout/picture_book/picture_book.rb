module RLayout
  # Solution PictureBook.
  # Layout information is stored in the folders with page name.
  # it is usually done by spread unit, rather than by page, so the folder name would be like
  # 02_03, 04_05, and so on. When single page is need it will have 10, 11. 
  # Folders should containing background picter_image and story for the spread.
  # Story can be place at 1:top_left, 2:top_right, 3:bottom_left, 4:bottom_right
  # layout.rb files are name with page_number_location, like 1_2.rb, 1_4.rb, 2_1.rb, 2_2.rb for various text story location.
  #

  class PictureBook < Book

    attr_reader :project_path, :paper_size
    attr_reader :book_cover, :body_matter
    attr_reader :book_info, :picture_folders
    attr_reader :toc_first_page_number
    attr_reader :body_type, :has_no_cover_inside_page
    def initialize(project_path, options={})
      @project_path = project_path
      @body_type = 'picture_book'
      @book_info_path = @project_path + "/book_info.yml"
      @book_info = YAML::load_file(@book_info_path)
      @book_info = Hash[@book_info.map{ |k, v| [k.to_sym, v] }]
      @title = @book_info[:title] || @book_info['title']
      @page_size = book_info[:paper_size] || book_info['paper_size'] || 'A5'
      @page_width = SIZES[@page_size][0]
      @height = SIZES[@page_size][1]
      @gripper_margin = options[:gripper_margin] || 1*28.34646
      @binding_margin = options[:binding_margin] || 20
      @bleed_margin = options[:bleed_margin] || 3*2.834646
      # @starting_page_number = 1
      @has_no_cover_inside_page = true
      create_book_cover
      @body_matter = BodyMatterWithPictureSpread.new(@project_path)
      generate_pdf_book
      generate_pdf_for_print
      @toc_first_page_number = 2
      generate_ebook unless options[:no_ebook]
      self
    end

    def book_title
      @tittle
    end

    def book_info_path
      @project_path + "/book_info.yml"
    end

    def build_book_cover_path
      build_folder + "/book_cover"
    end

    def create_book_cover
      FileUtils.mkdir_p(build_folder) unless File.exist?(build_folder)
      RLayout::BookCover.new(project_path: build_book_cover_path, source_path: source_book_cover_path, has_no_wing: true, has_no_cover_inside_page: true,  book_info: @book_info )
    end

    def pdf_docs_for_inner_book
      pdf_docs = []
      pdf_docs += @body_matter.pdf_docs
      pdf_docs
    end

  end

end