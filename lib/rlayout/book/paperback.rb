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

    def self.book_template_path
      File.dirname(__FILE__) + "/book_template/paperback"
    end

    def self.book_cover_template_path
      File.dirname(__FILE__) + "/book_template/book_cover"
    end

    def self.front_matter_template_path
      File.dirname(__FILE__) + "/book_template/front_matter"
    end

    def self.create(project_path)
      template_path = Paperback.book_template_path
      book_cover_template_path = Paperback.book_cover_template_path
      # copy contents of template_path to target folder
      FileUtils.cp_r "#{template_path}/.", project_path
      FileUtils.cp_r "#{book_cover_template_path}/.", project_path + "/book_cover"
      FileUtils.cp_r "#{front_matter_template_path}/.", project_path + "/front_matter"
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