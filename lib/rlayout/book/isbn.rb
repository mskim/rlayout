module RLayout
  # Page that contains information about the book.
  # With Title, author, publisher, logo, ISBN
  
  class Isbn
    attr_reader :document_path, :isbn_text
    attr_reader :width, :height, :left_margin, :top_margin, :right_margin, :bottom_margin
    attr_reader :book_info
    include Styleable

    def initialize(options={})
      options[:starting_page_side] = :left_side
      options[:page_type] = :column_text
      @book_info = options[:book_info]
      @document_path = options[:document_path]
      @style_guide_folder = options[:style_guide_folder] || @document_path
      # @output_path = @document_path + "/output.pdf"
      @output_path = @document_path + "/chapter.pdf"
      @starting_page_number = options[:starting_page_number] || 1
      @page_pdf = options[:page_pdf] || true
      @width = options[:width]
      @height = options[:height]
      @left_margin = options[:left_margin]
      @top_margin = options[:top_margin] 
      @right_margin = options[:right_margin]
      @bottom_margin = options[:bottom_margin]
      @isbn_text_path  = @document_path + "/story.md"
      @jpg = options[:jpg] || false
      load_text_style
      load_layout_rb
      load_document
      read_story
      layout_story
      @document.save_pdf(@output_path, page_pdf: @page_pdf, jpg: @jpg)
      self
    end

    def page_count
      1
    end

    def read_story
      if File.exist?(@isbn_text_path)
        @isbn_text = File.open(@isbn_text_path, 'r'){|f|  f.read}
      else
        @isbn_text = default_content
        File.open(@isbn_text_path, 'w'){|f| f.write @isbn_text}
      end
      @text_lines = @isbn_text.split("\n")
    end
    
    def layout_story
      # body
      @starting_y = 100
      line_height = 12

      @text_lines.each do |line_text|
        line_options = {}
        line_options[:x]  = 50
        line_options[:y]  = @starting_y
        line_options[:width]  = @document.width
        line_options[:height]  = line_height
        line_options[:parent] = @document
        line_options[:font_size] = 12
        line_options[:text_fit_type] = 'fit_box_to_text'

        if line_text =~/{}$/
          line_options[:stroke_sides] = [0,1,0,1]
          line_options[:stroke_width] = 0.3
          line_options[:text_string]    = line_text.sub("{}","")
        else
          line_options[:text_string]    = line_text
        end
        Text.new(line_options)
        @starting_y += line_height
      end
    end

    def self.sample_story
      <<~EOF

      지은이: 홍길동
      책임편집: 임꺽정
      ISBN: 978-89-364-4444-6 03300

      출판사: 죽전출판

      EOF
    end

    def default_layout_rb
      s=<<~EOF
      RLayout::CoverPage.new( width:#{@width}, height:#{@height}, left_margin:  #{@left_margin}, top_margin: #{@top_margin},   right_margin:  #{@right_margin}, bottom_margin:  #{@bottom_margin}) do
        info_area(0,0,6,12)
      end
      EOF
    end

    def default_content
      <<~EOF

      제목: 홍길동의 전설
      지은이: 홍길동
      책임편집: 임꺽정
      ISBN: 978-89-364-4444-6 03300

      출판사: 죽전출판
        
      EOF
    end

  end
end