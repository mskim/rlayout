module RLayout

  # Book with parts
  # footer left foort has book_title, right_footer has part_title
  
  class PoetryBook < BookWithParts

    def initialize(project_path, options={})
      @body_doc_type = 'poem'
      super
    end
  end

end