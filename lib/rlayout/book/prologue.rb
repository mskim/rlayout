module RLayout
  # Page that starts the book.
  # With Title, author, publisher, logo
  class Prologue < RChapter
    attr_reader :book, :path, :layout_template_path

    def initialize(options={})
      # @path = path
      # @width = options[:width]
      # @height = options[:height]
      # @layout_template_path = options[:layout_template_path]
      # generate_pdf
      # self
      super
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
      FileUtils.mkdir_p(@path) unless File.exist?(@path)
      if @layout_template_path

      else
        save_default_layout
      end
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
      h[:document_path] = @path
      h[:heading_height_type] = "quarter"
      h[:width] = @width
      h[:height] = @height
      h[:page_pdf] = true
      h[:toc] = true
      h
    end

    def layout_rb
      s =<<~EOF
        RLayout::RDocument.new(#{layout_options})
      EOF
    end
  end
end