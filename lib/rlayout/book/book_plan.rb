module RLayout
  class BookPlan
    attr_reader :project_path
    def initialize(project_path)
      @project_path =  project_path
      File.open(book_info_path, 'w'){|f| f.write sample_book_info}
      File.open(book_plan_path, 'w'){|f| f.write sample_book_plan}
      self
    end

    def self.parse_book_plan(project_path)
      plan_path = project_path + "/book_plan.md"
      File.open(plan_path, 'r'){|f| f.read}

    end

    def book_plan_path
      @project_path + "/book_plan.md"
    end

    def book_info_path
      @project_path + "/book_info.yml"
    end

    def sample_book_info
      <<~EOF
      ---
      title: Docker Book
      subtitle: How Docker is used in BookCheeGo
      author: Min Soo Kim
      publisher: Tech Books for the Rest
      paper_size: A4
      ---
           
      EOF
    end

    def sample_book_plan
      <<~EOF
      ---
      title: Docker Book
      subtitle: How Docker is used in BookCheeGo
      author: Min Soo Kim
      publisher: Tech Books for the Rest
      paper_size: A4
      ---
            
      # front_wing: author_proflie
      
      # back_wing: book_promo
            
      # isbn:
      
      # inside_cover:
      
      # dedication: 이책을 사랑하는 아내와 가족글에게 바침니다.
      
      # thanks: 감사의 글
      
      # prologue: 이글을 쓰면서
            
      # What is Docker?
      
      # Installing Docker
      
      # Using BookCheeGo with Docker
      
      # Creating Paperback
      
      # Creating Poetry Book
      
      EOF
    end



  end
end