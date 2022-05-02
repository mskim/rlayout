module RLayout

  class BookPlan
    attr_reader :project_path, :plan

    def initialize(options={})




      self
    end

    def self.paperback(options={})

    end

    def self.poetry_book(options={})

    end

    def self.essay(options={})

    end

    def self.report(options={})

    end

    def default_book_plan
      h = {}
      h[:title] = "This is title"
      h[:subtitle] = "This is subtitle"
      h[:author] = "This is author"
      h[:paper_size] = "A4"
      h[:wings] = ['author_profile', 'book_promo'] #
      h[:front_matter] = ['inside_cover', 'isbn', 'prologue' 'toc'] #
      h[:parts] =  0 
      h[:chapters] = 4
      h[:chapter_type] = 'chapter' # poem
      h[:rear_matter] = [] # appendix,  index
      h
    end
  end


end