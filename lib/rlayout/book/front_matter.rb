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
    attr_reader :starting_page_number, :toc_page_count, :toc_page_links
    attr_reader :page_count, :toc_content, :document_folders
    attr_reader :toc_first_page_number, :jpg, :doc_options

    # def initialize(project_path, options={})
    def initialize(project_path, starting_page_number, options={})
      @project_path = project_path
      @doc_options = options.dup
      @book_info_path = @project_path + "/book_info.yml"
      @starting_page_number = starting_page_number
      @jpg = options[:jpg]
      # @book_info = YAML::load_file(@book_info_path)
      # @book_info = Hash[@book_info.map{ |k, v| [k.to_sym, v] }]
      # @width = @book_info[:width]
      # @height = @book_info[:height]
      # @title = @book_info[:title]
      # @toc_page_count = @book_info[:toc_page_count] || 1
      # @paper_size = @book_info[:paper_size] || 'A5'
      # @page_width = @book_info[:width]
      # @width = @page_width
      # @height = @book_info[:height]
      @toc_page_count = options[:toc_page_count] || 1
      # @page_count = 0
      process_front_matter(options)
      puts "after process_front_matter"

      self
    end

    def build_folder
      @project_path + "/_build"
    end
    # create prolog, forward, isbn
    def process_front_matter(options)
      @document_folders = []
      Dir.glob("#{build_front_matter_path}/*").sort.each do |file|
        h = options.dup
        h[:page_pdf] = true
        h[:toc] = true
        h[:starting_page_number] = @starting_page_number
        if file =~ /title_page$/
          puts "title_page"
          h[:document_path] = file
          h[:toc] = false
          h[:has_footer] = false
          h[:has_header] = false
          h[:style_guide_folder] = style_guide_folder + "/title_page"
          # binding.pry

          r = RLayout::TitlePage.new(h)
          @starting_page_number += r.page_count
          @document_folders << file
        elsif file =~ /blank_page$/
          puts "blank_page"
          h[:document_path] = file
          h[:toc] = false
          h[:has_footer] = false
          h[:has_header] = false
          h[:style_guide_folder] = style_guide_folder + "/blank_page"
          # binding.pry
          r = RLayout::BlankPage.new(h)
          # binding.pry
          @starting_page_number += r.page_count
          @document_folders << file
        elsif file =~ /isbn$/
          puts "isbn"
          h[:document_path] = file
          h[:toc] = false
          h[:has_footer] = false
          h[:has_header] = false
          h[:style_guide_folder] = style_guide_folder + "/isbn"
          r = RLayout::Isbn.new(h)
          @starting_page_number += r.page_count
          @document_folders << file
        elsif file =~ /inside_cover$/
          puts "inside_cover"
          h[:document_path] = file
          h[:front_page_pdf] = @project_path + "/_build/book_cover/front_page/output.pdf"
          h[:toc] = false
          h[:has_footer] = false
          h[:has_header] = false
          h[:style_guide_folder] = style_guide_folder + "/inside_cover"
          r = RLayout::InsideCover.new(h)
          # binding.pry
          @starting_page_number += r.page_count
          @document_folders << file
        elsif  file =~/dedication$/
          puts "dedication"
          h[:document_path] = file
          h[:style_guide_folder] = style_guide_folder + "/dedication"
          r = RLayout::Dedication.new(h)
          @starting_page_number += r.page_count
          @document_folders << file
        elsif  file =~/thanks$/
          puts "thanks"
          h[:document_path] = file
          h[:style_guide_folder] = style_guide_folder + "/thanks"
          r = RLayout::Thanks.new(h)
          @starting_page_number += r.page_count
          @document_folders << file
        elsif file =~/prologue$/
          puts "prologue"
          # binding.pry
          h[:document_path] = file
          h[:style_guide_folder] = style_guide_folder + "/prologue"
          r = RLayout::Prologue.new(h)
          @starting_page_number += r.page_count
          @document_folders << file
        elsif file =~ /help$/
          puts "help"
          h[:document_path] = file
          h[:style_guide_folder] = style_guide_folder + "/help"
          r = RLayout::Help.new(h)
          @starting_page_number += r.page_count
          @document_folders << file
        elsif file =~ /toc$/
          puts "toc"
          @has_toc = true
          @document_folders << file
          @toc_first_page_number = @starting_page_number + 1 unless @toc_first_page_number
          @starting_page_number += @toc_page_count
          @book_toc = []
        else
          puts "#{file}"
        end
      end
      unless @has_toc
        @has_toc = true
        @document_folders << 'toc' 
        @toc_first_page_number = @starting_page_number + 1 unless @toc_first_page_number
        @starting_page_number += @toc_page_count
        @book_toc = []
      end
      generate_front_matter_toc

    end

    def style_guide_folder
      @project_path + "/style_guide"
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
        toc =  "/#{doc_name}/toc.yml"
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
        if doc_folder =~ /toc$/
          doc_pdf_file = "#{doc_folder}/toc.pdf"
        else
          doc_pdf_file = "/#{doc_folder}/chapter.pdf"
        end
        pdf_files << doc_pdf_file
      end
      pdf_files
    end

    def pdf_pages
      pdf_pages = []
      @document_folders.each do |doc_folder|
        doc_pdf_pages = Dir.glob("#{doc_folder}/????/page.pdf")
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

    def source_body_md_path
      @project_path + "/body.md"
    end
    
    # front.md file contains front_matter_docs content
    # front_matter_docs content can also be written in side of body.md file
    # it depsend on how the write want to orgazined  the content
    def source_front_md_path
      @project_path + "/front.md"
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