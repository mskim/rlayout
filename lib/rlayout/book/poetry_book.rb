module RLayout

  # Book with parts
  # footer left foort has book_title, right_footer has part_title
  
  class PoetryBook < Book

    def initialize(project_path, options={})
      @body_doc_type = 'poem'
      @has_part = true
      super
    end

    def self.book_template_path
      File.dirname(__FILE__) + "/book_template/potry_book"
    end

    def self.create(project_path)
      template_path = PoetryBook.book_template_path
      # copy contents of template_path to target folder
      FileUtils.cp_r "#{template_path}/.", project_path
    end

  end

end