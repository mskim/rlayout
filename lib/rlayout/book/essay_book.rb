module RLayout

  # Book with parts
  # footer left foort has book_title, right_footer has part_title
  
  class EssayBook < BookWithParts

    def initialize(project_path, options={})
      @body_doc_type = 'essay'
      super
    end
  end

end