module RLayout
  # Page that starts the book.
  # With Title, author, publisher, logo
  # Replica of front cover image
  
  class Isbn < StyleGuide
    attr_reader :document_path, :info_text, :isbn_text

    def initialize(options={})
      options[:starting_page_side] = :left_side
      options[:page_type] = :column_text
      @document_path = options[:document_path]
      @isbn_text_path  = @document_path + "/story.md"

      super

      read_story
      layout_story
      self
    end

    def page_count
      @document.pages.length
    end

    def read_story
      if File.exist?(@isbn_text_path)
        @isbn_text = File.open(@isbn_text_path, 'r'){|f|  f.read}
      else
        @isbn_text = Isbn.sample_story
        File.open(@isbn_text_path, 'w'){|f| f.write @isbn_text}
      end
      @text_lines = @isbn_text.split("\n")
    end
    
    def layout_story
      # body
      @starting_y = 100
      line_height = 20
      @last_page = @document.pages.last

      @text_lines.each do |line_text|
        line_options = {}
        line_options[:x]  = 50
        line_options[:y]  = @starting_y
        line_options[:width]  = @last_page.width
        line_options[:height]  = line_height
        line_options[:text_string]    = line_text
        line_options[:parent] = @last_page
        line_options[:font_size] = 12
        Text.new(line_options)
        @starting_y += line_height
      end
    end

    def self.sample_story
      <<~EOF










      

      지은이: 홍길동
      책임편집: 임꺽정
      ISBN: 334-555-666
      출판사: 죽전출판

      EOF
    end

    def default_layout_rb
      s=<<~EOF
      RLayout::RDocument.new( width:#{@width}, height:#{@height}, top_inset: 5, left_inset: 5, right_inset: 10, body_line_height: 16)
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

  end
end