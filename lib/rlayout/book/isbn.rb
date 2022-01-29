module RLayout
  # Page that starts the book.
  # With Title, author, publisher, logo
  # Replica of front cover image
  
  class Isbn < RChapter
    attr_reader :document_path, :info_text

    def initialize(options={})
      options[:starting_page_side] = :left_side
      options[:page_type] = :column_text
      super
      @isbn_text_path  = @document_path + "/isbn.md"
      if File.exist?(@isbn_text_path)
        @isbn_text = File.open(@isbn_text_path, 'r'){|f|  f.read}
      else
        @isbn_text = Isbn.sample_story
        File.open(@isbn_text_path, 'w'){|f| f.write @isbn_text}
      end
      
      self
    end

    def self.sample_story
      <<~EOF
      ---
      layout:isbn
      
      ---

      지은이: 홍길동
      책임편집: 임꺽정
      ISBN: 334-555-666
      출판사: 죽전출판

      EOF
    end

    def default_page_layout
      <<~EOF
      RLayout::RPage.new( width:#{@width}, height:#{@height}, top_inset: 5, left_inset: 5, right_inset: 10, body_line_height: 16)
        column_text(#{@isbn_text})
      EOF
      EOF
    end

    def default_content
      h =<<~EOF

      ## 홍길동의 전설
   
        죽전출판

        여기는 제목

        여기는 부제목
  
        초판 1쇄 발행/2021년 9월 15일

        지은이/홍길동

        펴낸이/임꺽정

        책입편집/김개똥

        ISBN 978-89-364-4444-6 03300
  
      EOF
    end

    # def default_info_text
    #   s =<<~EOF

    #   죽전출판
    #   여기는 제목
    #   여기는 부제목

    #   초판 1쇄 발행/2021년 9월 15일

    #   지은이/홍길동
    #   펴낸이/임꺽정
    #   책입편집/김개똥
    #   ISBN 978-89-364-4444-6 03300

    #   EOF 
    # end
  end
end