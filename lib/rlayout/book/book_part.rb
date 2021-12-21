module RLayout

  # Book with parts
  # footer left foort has book_title, right_footer has part_title
  
  class BookPart
    attr_reader :project_path, :build_folder, :book_info, :page_width, :height, :body_doc_type, :order
    attr_reader :starting_page_number, :part_docs, :next_part_starting_page
    attr_reader :title, :order
    def initialize(part_project_path, options={})
      @project_path = part_project_path
      @page_size = options[:page_size] || 'A5'
      @title = options[:title] || "파트 제목은 여기에"
      @part_name = File.basename(@project_path)
      @order = options[:order] || @part_name.split("_").last
      @build_part_folder = File.dirname(@project_path) + "/_build/#{@part_name}"
      # TODO: save part_info.yml????
      @part_info_path = @project_path + "/part_info.yml"
      if File.exist?(@part_info_path)
        @part_info = YAML::load_file(@part_info_path)
        @part_info = Hash[@book_info.map{ |k, v| [k.to_sym, v] }]
        @title = @part_info[:title] #|| @part_info['title']
      end
      @page_width = SIZES[@page_size][0]
      @height = SIZES[@page_size][1]
      @starting_page_number = options[:starting_page_number] || 1
      @body_doc_type = options[:body_doc_type]  || 'chapter' # chapter, poem, essay
      FileUtils.mkdir_p(@build_part_folder) unless File.exist?(@build_part_folder)
      @part_docs = []
      create_part_cover
      process_part
      # generate_part_toc
    end

    def create_part_cover
      h = {}
      h[:project_path] = @build_part_folder + "/0_part_cover"
      h[:starting_page_number] = @starting_page_number
      h[:order] = @order
      h[:title] = @title
      @part_docs << @build_part_folder + "/0_part_cover"
      r = RLayout::PartCover.new(h)
      # r.page_count : make it a document kind
      # @starting_page_number += r.document.length
      # @starting_page_number += 1
      @starting_page_number += r.page_count
    end

    def process_part
      Dir.glob("#{@project_path}/*.md").sort.each_with_index do |file, i|
        # copy source to build 
        chapter_folder = @build_part_folder + "/chapter_#{i+1}"
        @part_docs << chapter_folder
        FileUtils.mkdir_p(chapter_folder) unless File.exist?(chapter_folder)
        FileUtils.cp file, "#{chapter_folder}/story.md"
        copy_page_floats(file, chapter_folder)
        h = {}
        h[:document_path] = chapter_folder
        h[:page_pdf] = true
        h[:toc] = true
        h[:starting_page] = @starting_page_number
        h[:belongs_to_part] = true

        # h[:header_erb] = header_erb
        # h[:footer_erb] = footer_erb
        if @body_doc_type == 'chapter'
          r = RLayout::RChapter.new(h)
        elsif @body_doc_type == 'poem'
          r = RLayout::Poem.new(h)
        elsif @body_doc_type == 'essay'
          h[:heeading_height] = 'quarter'
          r = RLayout::RChapter.new(h)
        end
        @starting_page_number += r.page_count
      end
      @next_part_starting_page = @starting_page_number
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

    def part_toc_path
      @build_part_folder + "/toc.yml"
    end

    def generate_part_toc
      @part_toc = []
      @part_docs.each do |chapter_folder|
        toc = chapter_folder + "/toc.yml"
        @part_toc << YAML::load_file(toc) if File.exist?(toc)
      end
      File.open(part_toc_path, 'w'){|f| f.write @part_toc.to_yaml}
    end
  end
end