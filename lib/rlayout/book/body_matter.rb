module RLayout

  class BodyMatter
    attr_reader :project_path, :book_info, :page_width, :height
    attr_reader :body_matter_docs, :body_matter_toc, :body_doc_type
    attr_reader :starting_page_number, :toc_doc_page_count, :toc_page_links
    attr_reader :toc_content

    def initialize(project_path, options={})
      @project_path = project_path
      @book_info_path = @project_path + "/book_info.yml"
      @book_info = YAML::load_file(@book_info_path)
      @title = @book_info[:title]
      @page_size = options['paper_size'] || 'A5'
      @page_width = SIZES[@page_size][0]
      @height = SIZES[@page_size][1]
      @starting_page_number = options[:starting_page_number] || 1
      process_body_matter
      self
    end

    def build_folder
      @project_path + "/_build"
    end

    def build_folder
      @project_path + "/_build"
    end
    
    def process_body_matter
      @body_matter_docs = []
      Dir.glob("#{@project_path}/*.md").sort.each_with_index do |file, i|
        # copy source to build 
        chapter_folder = build_folder + "/chapter_#{i+1}"
        @body_matter_docs << chapter_folder
        FileUtils.mkdir_p(chapter_folder) unless File.exist?(chapter_folder)
        FileUtils.cp file, "#{chapter_folder}/story.md"
        copy_page_floats(file, chapter_folder)
        h = {}
        h[:document_path] = chapter_folder
        h[:page_pdf] = true
        h[:toc] = true
        h[:starting_page] = @starting_page_number
        # h[:header_erb] = header_erb
        h[:footer_erb] = footer_erb
        r = RLayout::RChapter.new(h)
        @starting_page_number += r.page_count
      end
      generate_body_matter_toc
    end

    def generate_body_matter_toc
      @body_matter_toc = []
      @body_matter_docs.each do |chapter_folder|
        toc = chapter_folder + "/toc.yml"
        @body_matter_toc << YAML::load_file(toc) if File.exist?(toc)
      end
      @body_matter_toc
      save_toc_content
    end

    def save_toc_content
      flatten_toc = []
      @body_matter_toc.each do |chapter_item|
        chapter_item.each do |toc_item|
          a = []
          if toc_item[:markup] == 'h2'
            a << "   #{toc_item[:para_string]}"
          else
            a << toc_item[:para_string]
          end
          a << toc_item[:page].to_s
          flatten_toc << a
        end
      end
      @toc_content = flatten_toc
      # File.open(toc_yml_path, 'w'){|f| f.write flatten_toc.to_yaml}
    end
  

    def pdf_docs
      pdf_files = []
      @body_matter_docs.each do |chapter|
        chapter_pdf_file = chapter + "/chapter.pdf"
        pdf_files << chapter_pdf_file if File.exist?(chapter_pdf_file)
      end
      pdf_files
    end


    def book_title
      @book_info['title'] || 'untitled'
    end

    def width
      @page_width
    end

    def left_margin
      50
    end
    
    def right_margin
      50
    end

    def top_margin
      50
    end

    def bottom_margin
      50
    end

    def header_options
      "parent:self, x:#{left_margin}, y:#{top_margin - 10}, width: #{width}, fill_color: 'clear'"
    end

    def header_erb
      nil
    end

    def footer_width
      width - left_margin - right_margin
    end

    def footer_options
      "parent:self, x:#{left_margin}, y:#{height - bottom_margin - 40}, width: #{footer_width}, height: 12, fill_color: 'clear'"
    end

    def left_footer_erb
      # put book title on the left side 
      s=<<~EOF
      RLayout::Container.new(#{footer_options}) do
        text("<%= @page_number %>  #{book_title} ", font_size: 9, x: 0, width: #{footer_width}, text_alignment: 'left')
      end
      EOF
    end

    def right_footer_erb
      # put chapter title on the right side 
      # chapter title and page_number is place by the layout 
      s=<<~EOF
      RLayout::Container.new(#{footer_options}) do
        text("<%= title %>  <%= @page_number %>", font_size: 9, from_right:0, y: 0, text_alignment: 'right')
      end
      EOF
    end

    def footer_erb
      info = {}
      info[:left_footer] = left_footer_erb
      info[:right_footer] = right_footer_erb
      info
    end  


    # placing images for the chapter
    # images for the chapter should be plced in the folder with same name as chpater md file
    # this folder should have page_floats.yml and images folder.
    # page_floats.yml file containers image placement information, and images folder contanins images.
    # check if there folder with same same as md file
    # if so, copy it to build chapter folder along with md file
    def copy_page_floats(md_file, chapter_folder)
      page_floats_yml_path = md_file.gsub(/.md$/, "")
      if File.exist?(page_floats_yml_path)
        FileUtils.cp("#{page_floats_yml_path}/**.*", "#{chapter_folder}")
      end
    end
      


  end
end