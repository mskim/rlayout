module RLayout

  PAPERBACK_STYLE = {
    'chapter':{

    },
    'book_cover':{

    },
    'front_matter':{

    }
  }

  class EssayBook < Book

    def initialize(project_path, options={})
      @book_text_style_name = "paperback"
      @body_doc_type = 'chapter'
      @has_part = true
      super
      self
    end

    def self.book_template_path
      File.dirname(__FILE__) + "/book_template/essay_book"
    end

    def self.create(project_path)
      template_path = PoetryBook.book_template_path
      FileUtils.copy(template_path,project_path)
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