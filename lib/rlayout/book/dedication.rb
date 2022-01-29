module RLayout
  # Page that starts the book.
  # With Title, author, publisher, logo
  class Dedication  < RChapter
    attr_reader :document_path
    def initialize(options={})
      @page_count = 1
      super
      self
    end

    def self.sample_story
      <<~EOF
      ---
      layout:dedication
      title: 이글을 홍길동님에게 바침지다
      ---


      여기는 프로로그 본문입니다. 여기는 프로로그 본문입니다. 여기는 프로로그 본문입니다. 여기는 프로로그 본문입니다. 여기는 프로로그 본문입니다. 
      여기는 프로로그 본문입니다. 여기는 프로로그 본문입니다. 여기는 프로로그 본문입니다. 여기는 프로로그 본문입니다. 여기는 프로로그 본문입니다. 
      여기는 프로로그 본문입니다. 여기는 프로로그 본문입니다. 여기는 프로로그 본문입니다. 여기는 프로로그 본문입니다. 여기는 프로로그 본문입니다. 
      여기는 프로로그 본문입니다. 여기는 프로로그 본문입니다. 여기는 프로로그 본문입니다. 여기는 프로로그 본문입니다. 여기는 프로로그 본문입니다. 
      여기는 프로로그 본문입니다. 여기는 프로로그 본문입니다. 여기는 프로로그 본문입니다. 여기는 프로로그 본문입니다. 여기는 프로로그 본문입니다. 
      여기는 프로로그 본문입니다. 여기는 프로로그 본문입니다. 여기는 프로로그 본문입니다. 여기는 프로로그 본문입니다. 여기는 프로로그 본문입니다. 

      EOF
    end


  end
end