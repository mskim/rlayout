module RLayout

  # chapter folder names should start with at least two digits followed by any
  # 01,02,03,04, 01_chpater, 02_chpater, 02_장, are all valid chapter folder format
  
  # Each chapter folder contains **.md file, images and page_floats.yml
  # story.md, 1.md some_name.md are all valid .md file format

  # They are copied to _build foler as chapter_01, chapter_02
  # amd *.md files are copied as story.md under _build/chapter_01/story.md
  class BodyMatter
    attr_reader :project_path, :book_info, :page_width, :height
    attr_reader :document_folders, :body_matter_toc, :body_doc_type
    attr_reader :starting_page_number, :toc_doc_page_count, :toc_page_links
    attr_reader :toc_content, :paper_size

    def initialize(project_path, options={})
      @project_path = project_path
      @book_info_path = @project_path + "/book_info.yml"
      @book_info = YAML::load_file(@book_info_path)
      @book_info = Hash[@book_info.map{ |k, v| [k.to_sym, v] }]
      @title = @book_info[:title]
      # @custom_style = @book_info[:custom_style]
      @paper_size = @book_info[:paper_size]  || "A5"
      @paper_size = options[:paper_size] if options[:paper_size]
      @page_width = SIZES[@paper_size][0]
      @height = SIZES[@paper_size][1]
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
    
    # support folder as well as .md file as chapter source
    def process_body_matter
      @document_folders = []
      # Dir.glob("#{@project_path}/*.md").sort.each_with_index do |file, i|
      chapter_order = 1
      Dir.entries(@project_path).sort.each do |file|
        # copy source to build 
        if file =~/^\d\d/
          chapter_folder = build_folder + "/chapter_#{chapter_order}"
          FileUtils.mkdir_p(chapter_folder) unless File.exist?(chapter_folder)
          source_path = @project_path + "/#{file}"
          if File.directory?(source_path)
            # look for .md file and copy it as story.md in build
            Dir.glob("#{source_path}/*").each do |souce_folder_file|
              if File.directory?(souce_folder_file)
                # copy images folder to build chpater folder
                FileUtils.cp_r souce_folder_file, chapter_folder
              elsif souce_folder_file =~/.md$/
                # if a file is .md file, rename it as story.md in build chapter folder
                FileUtils.cp souce_folder_file, "#{chapter_folder}/story.md"
              else
                FileUtils.cp souce_folder_file, "#{chapter_folder}"
              end
            end
            @document_folders << chapter_folder
          elsif source_path =~/[.md,.markdown]$/
            FileUtils.cp source_path, "#{chapter_folder}/story.md"
            @document_folders << chapter_folder
          else
            # this is case when a file starts with \d\d but not a .md file nor folder
            next
          end
          h = {}
          h[:book_info]  = @book_info
          h[:document_path] = chapter_folder
          h[:paper_size] = @paper_size
          h[:page_pdf] = true
          h[:toc] = true
          h[:starting_page_number] = @starting_page_number
          h[:chapter_order] = chapter_order
          h[:style_guide_folder] = style_guide_folder
          r = RLayout::Chapter.new(h)
          @starting_page_number += r.page_count
          chapter_order += 1
        else
          next
        end
      end
      generate_body_matter_toc
    end

    def style_guide_folder
      @project_path + "/_style_guide/chapter"
    end

    def generate_body_matter_toc
      @body_matter_toc = []
      @document_folders.each do |chapter_folder|
        toc = chapter_folder + "/toc.yml"
        @body_matter_toc << YAML::load_file(toc) if File.exist?(toc)
      end
      @body_matter_toc
      generate_toc_content
    end

    def generate_toc_content
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
    end
  

    def pdf_docs
      pdf_files = []
      @document_folders.each do |chapter|
        chapter_pdf_file = chapter + "/chapter.pdf"
        pdf_files << chapter_pdf_file if File.exist?(chapter_pdf_file)
      end
      pdf_files
    end

    def pdf_pages
      pdf_pages = []
      @document_folders.each do |chapter|
        chapter_pdf_pages = Dir.glob("#{chapter}/????/page.pdf").sort
        pdf_pages << chapter_pdf_pages #if File.exist?(chapter_pdf_file)
      end
      pdf_pages
    end

    def book_title
      @book_info['title'] || @book_info[:title] || 'untitled'
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