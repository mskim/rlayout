module RLayout

  class BodyMatterWithPart
    attr_reader :project_path, :book_info, :page_width, :height
    attr_reader :document_folders, :body_matter_toc, :body_doc_type
    attr_reader :starting_page_number, :toc_page_count, :toc_page_links
    attr_reader :toc_content
    def initialize(project_path, options={})
      @project_path = project_path
      @book_info_path = @project_path + "/book_info.yml"
      @book_info = YAML::load_file(@book_info_path)
      @book_info = Hash[@book_info.map{ |k, v| [k.to_sym, v] }]
      @title = @book_info[:title]
      @paper_size = @book_info[:paper_size] || "A4"
      @paper_size = options[:paper_size] if options[:paper_size]
      @page_width = SIZES[@paper_size][0]
      @height = SIZES[@paper_size][1]
      @body_doc_type = options[:body_doc_type]
      @starting_page_number = options[:starting_page_number] || 1
      process_body_matter_with_parts
      self
    end

    def process_body_matter_with_parts
      @document_folders = []
      parts_info = @book_info[:parts] || @book_info['parts'] || @book_info[:파트] || @book_info['파트']
      # we should have a part folder name part_1,part_2, part_3
      # or Korean named folder 1부, 2부, 3부, 4부
      @part_folder_found = false
      Dir.glob("#{@project_path}/part_*").sort.each_with_index do |part, i|
        @part_folder_found = true
        part_title = "파트 제목은 여기"
        if parts_info
          part_title = parts_info[i]
        end
        r = RLayout::BookPart.new(part, paper_size: @paper_size, title:part_title, body_doc_type: @body_doc_type, starting_page_number: @starting_page_number, order: i + 1)
        @document_folders += r.part_docs
        @starting_page_number = r.next_part_starting_page
      end
      unless @part_folder_found
        Dir.glob("#{@project_path}/파트_*").sort.each_with_index do |part, i|
          @part_folder_found = true
          part_title = "파트 제목은 여기"
          if parts_info
            part_title = parts_info[i]
          end
          r = RLayout::BookPart.new(part, paper_size: @paper_size, title:part_title, body_doc_type: @body_doc_type, starting_page_number: @starting_page_number, order: i + 1)
          @document_folders += r.part_docs
          @starting_page_number = r.next_part_starting_page
        end
      end
      generate_body_matter_toc
    end
  
    def generate_body_matter_toc
      @body_matter_toc = []
      @document_folders.each do |chapter_folder|
        toc = chapter_folder + "/toc.yml"
        @body_matter_toc << YAML::load_file(toc) if File.exist?(toc)
      end
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
        chapter_pdf_file = Dir.glob("#{chapter}/????/page.pdf")
        pdf_pages << chapter_pdf_file
      end
      pdf_pages
    end

  end
end