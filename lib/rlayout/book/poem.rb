module RLayout
  # Page that starts the book.
  # With Title, author, publisher, logo
  class Poem
    attr_reader :book, :path, :title, :body

    def initialize(path, options={})
      @path = path
      @width = options[:width] || 400
      @height = options[:height] || 500
      @layout_template_path = options[:layout_template_path]
      read_story
      generate_pdf
      self
    end

    def story_md_path
      @path + "/story.md"
    end

    def layout_path
      @path + "/layout.rb"
    end

    def output_path
      @path + "/chapter.pdf"
    end

    def save_layout
      if @layout_template_path

      else
        save_default_layout
      end
    end

    def read_story
      # poem = File.open(story_md_path, 'r'){|f| f.read}

      @title = "여기는 시집 제목"

      @body =<<~EOF


      여기는 시집 내용
      여기는 둘째줄 입니다.
      여기는 새째줄 입니다.

      여기는 시집 내용
      여기는 둘째줄 입니다.
      여기는 새째줄 입니다.

      여기는 시집 내용
      여기는 둘째줄 입니다.
      여기는 새째줄 입니다.

      여기는 시집 내용
      여기는 둘째줄 입니다.
      여기는 새째줄 입니다.

      EOF

    end

    def generate_pdf
      save_layout
      d = eval(layout_rb)
      d.save_pdf_with_ruby(output_path, jpg:true)
    end

    def save_default_layout
      File.open(layout_path, 'w'){|f| f.write layout_rb}
    end

    def layout_options
      h = {}
      h[:heading_height_type] = "quarter"
      h[:width] = @width
      h[:height] = @height
      h[:page_pdf] = true
      h[:toc] = true
      h
    end

    def layout_rb
      s =<<~EOF
        RLayout::Container.new(#{layout_options}) do
        title_text("#{@title}", x: 50, y: 50, width: 400, font_size: 16)
        title_text("#{@body}", x: 50, y: 100, width: 400, height: 400, font_size: 12)
        end
      EOF
    end
  end
end