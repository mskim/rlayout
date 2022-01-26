module RLayout
  # Page that starts the book.
  # With Title, author, publisher, logo
  # Replica of front cover image
  
  class Isbn < RChapter
    attr_reader :section_path, :paper_size, :info_text

    def initialize(section_path, options={})
      @paper_size = options[:paper_size] || "A4"
      @width = SIZES[@paper_size][0]
      @height = SIZES[@paper_size][1]
      @section_path = section_path
      @isbn_text_path  = @section_path + "/isbn.md"
      if File.exist?(@isbn_text_path)
        @isbn_text = File.open(@isbn_text_path, 'r'){|f|  f.read}
      else
        @isbn_text = default_content
        File.open(@isbn_text_path, 'w'){|f| f.write @isbn_text}
      end
      layout =  eval(default_layout)
      pdf_path = @section_path  + "/output.pdf"
      layout.save_pdf(pdf_path, pdf_page: true)
      self
    end

    def default_layout
      # before rotating 90 
      # TODO: fix right_inset not working properly
      @box_width = 200
      @box_height = 300

      layout =<<~EOF
      RLayout::RColumn.new( width:#{@box_width}, height:#{@box_height}, top_inset: 5, left_inset: 5, right_inset: 10, body_line_height: 16)

      EOF
    end

    def default_content
      h =<<~EOF
      <br>

      ## 홍길동의 전설

      <br>
   
        죽전출판

        여기는 제목

        여기는 부제목
  
        초판 1쇄 발행/2021년 9월 15일
        <br>

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