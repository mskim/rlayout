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
      @book_text_style_name = "paperback"
      @body_doc_type = 'chapter'
      super
      self
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