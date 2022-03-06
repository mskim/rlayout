module RLayout
  
  # 00_blank_page
  # 01_title_page
  # 02_some_graphic_page
  # 03_book_info
  # 04_dedication
  # 05_prologue
  # 06_toc

  class FrontMatter
    attr_reader :project_path, :book_info, :page_width, :height
    attr_reader :starting_page_number, :toc_doc_page_count, :toc_page_links
    attr_reader :page_count, :toc_content, :document_folders
    attr_reader :toc_first_page_number
    def initialize(project_path, options={})
      @project_path = project_path
      @book_info_path = @project_path + "/book_info.yml"
      @book_info = YAML::load_file(@book_info_path)
      @book_info = Hash[@book_info.map{ |k, v| [k.to_sym, v] }]
      @title = @book_info[:title]
      @paper_size = @book_info[:paper_size] || 'A5'
      @page_width = SIZES[@paper_size][0]
      @height = SIZES[@paper_size][1]
      @starting_page_number = options[:starting_page_number] || 1
      @page_count = 0
      process_front_matter
      self
    end

    def build_folder
      @project_path + "/_build"
    end
    # create prolog, forward, isbn
    def process_front_matter
      @document_folders = []
      FileUtils.mkdir_p(build_front_matter_path) unless File.exist?(build_front_matter_path)
      # Dir.glob("#{source_front_matter_path}/*.md").sort.each do |md|
      Dir.entries(source_front_matter_path).sort.each do |file|
        # copy source to build 

        if file =~/^\d\d/
          basename = File.basename(file)
          h = {}
          h[:paper_size] = @paper_size
          h[:book_info]  = @book_info
          h[:page_pdf] = true
          h[:toc] = true
          h[:starting_page_number] = @starting_page_number
          h[:style_guide_folder] = style_guide_folder

          case basename
          when /isbn/
            isbn_path = build_front_matter_path + "/isbn"
            copy_source_to_build(file, isbn_path)
            h[:document_path] = isbn_path
            h[:toc] = false
            h[:has_footer] = false
            h[:has_header] = false
            r = RLayout::Isbn.new(h)
            @page_count += r.page_count
            @starting_page_number += page_count
            @document_folders << 'isbn'
          when /inside_cover/
            inside_cover_path = build_front_matter_path + "/inside_cover"
            copy_source_to_build(file, inside_cover_path,)
            h[:document_path] = inside_cover_path
            h[:front_page_pdf] = @project_path + "/_build/book_cover/front_page/output.pdf"
            h[:toc] = false
            h[:has_footer] = false
            h[:has_header] = false
            r = RLayout::InsideCover.new(h)
            @page_count += r.page_count
            @starting_page_number += page_count
            @document_folders << 'inside_cover'
          when /dedication/, /헌정사/
            dedication_path = build_front_matter_path + "/dedication"
            copy_source_to_build(file, dedication_path,)
            h[:document_path] = dedication_path
            r = RLayout::Dedication.new(h)
            @page_count += r.page_count
            @starting_page_number += page_count
            @document_folders << 'dedication'
          when /thanks/, /감사/
            thanks_path = build_front_matter_path + "/thanks"
            copy_source_to_build(file, thanks_path,)
            h[:document_path] = thanks_path
            r = RLayout::Thanks.new(h)
            @page_count += r.page_count
            @starting_page_number += page_count
            @document_folders << 'thanks'
          when /prologue/, /머릿글/
            prologue_path = build_front_matter_path + "/prologue"
            copy_source_to_build(file, prologue_path,)
            h[:document_path] = prologue_path
            r = RLayout::Prologue.new(h)
            @page_count += r.page_count
            @starting_page_number += page_count
            @document_folders << 'prologue'
          when /toc/, /목차/ , /차례/
            toc_path = build_front_matter_path + "/toc"
            copy_source_to_build(file, toc_path,)
            @has_toc = true
            @document_folders << 'toc' 
            # TODO fix this
            @page_count += 1
            @toc_first_page_number = @starting_page_number + 1
            @starting_page_number += 1
            @book_toc = []
          end
        end
      end
      generate_front_matter_toc
    end

    def style_guide_folder
      @project_path + "/_style_guide"
    end

    # copy front_matter source file or folder to _build
    def copy_source_to_build(source_path, destination_path)
      FileUtils.mkdir_p(destination_path) unless File.exist?(destination_path)
      source_full_path = source_front_matter_path + "/#{source_path}"
      story_md_destination_path = destination_path + "/story.md"
      if File.directory?(source_full_path)
        if Dir.glob("#{source_full_path}/*.md").length == 0
          # handle case when there is no .md file
          # save sample story.md file
          sample_story  = sample_front_matter_story(source_path)
          source_full_story_path = source_full_path + "/story.md"
          File.open(source_full_story_path, 'w'){|f| f.write sample_story}
          File.open(story_md_destination_path, 'w'){|f| f.write sample_story}
        end

        # copy folder to build area
        system("cp -r #{source_full_path}/ #{destination_path}/")
      else
        # source is a file
        system("cp #{source_full_path} #{story_md_destination_path}")
      end
    end

    def sample_front_matter_story(source_path)
      case source_path
      when /isbn/
        Isbn.sample_story
      when /thanks/
        Thanks.sample_story
      when /dedication/
        Dedication.sample_story
      when /prologue/
        Prologue.sample_story
      end
    end

    def generate_front_matter_toc
      @doc_generated_toc_info = []
      # doc_info [document_kind, page_count]
      @document_folders.each do |doc_name|
        toc = build_front_matter_path + "/#{doc_name}/toc.yml"
        @doc_generated_toc_info << YAML::load_file(toc) if File.exist?(toc)
      end
      @front_matter_toc = []
      @doc_generated_toc_info.each do |chapter_item|
        chapter_item.each do |toc_item|
          a = []
          a << toc_item[:para_string]
          a << toc_item[:page].to_s
          @front_matter_toc << a
        end
      end
      @toc_content = @front_matter_toc
    end

    def pdf_docs
      pdf_files = []
      @document_folders.each do |doc_folder|
        if doc_folder == 'toc'
          doc_pdf_file = build_front_matter_path + "/#{doc_folder}/toc.pdf"
        else
          doc_pdf_file = build_front_matter_path + "/#{doc_folder}/chapter.pdf"
        end
        pdf_files << doc_pdf_file
      end
      pdf_files
    end

    def pdf_pages
      pdf_pages = []
      @document_folders.each do |doc_folder|
        full_path = build_front_matter_path + "/#{doc_folder}"
        doc_pdf_pages = Dir.glob("#{full_path}/????/page.pdf")
        pdf_pages << doc_pdf_pages
      end
      pdf_pages.flatten
      pdf_pages
    end

    def build_front_matter_path
      build_folder + "/front_matter"
    end

    def source_front_matter_path
      @project_path + "/front_matter"
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
  end

end