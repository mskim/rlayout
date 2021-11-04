module RLayout

  PAPERBACK_STYLE = {
    'chapter':{

    },
    'book_cover':{

    },
    'front_matter':{

    }
  }

  
  class Paperback < Book

    def initialize(project_path, options={})
      @body_doc_type = 'chapter'
      @project_path = project_path
      @book_info_path = @project_path + "/book_info.yml"
      @book_info = YAML::load_file(@book_info_path)
      @title = @book_info[:title] || @book_info['title']
      @page_size = options[:page_size] || options['page_size'] || 'A5'
      @page_width = SIZES[@page_size][0]
      @height = SIZES[@page_size][1]
      @starting_page_number = 1
      create_book_cover
      # process_front_matter
      @front_matter = FrontMatter.new(@project_path)
      @body_matter = BodyMatter.new(@project_path, starting_page_number: @starting_page_number)
      # process_rear_matter
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

    def create_book_cover
      FileUtils.mkdir_p(build_folder) unless File.exist?(build_folder)
      RLayout::BookCover.new(project_path: build_book_cover_path, source_path: source_book_cover_path, book_info: @book_info)
    end
    
  end
end