module RLayout

  # Book with parts
  # footer left foort has book_title, right_footer has part_title
  
  class BookWithParts < Book
    attr_reader :project_path, :book_info, :page_width, :height
    attr_reader :has_cover_inside_page, :has_wing, :has_toc
    attr_reader :book_toc, :body_matter_toc, :rear_matter_toc
    def initialize(project_path, options={})
      @project_path = project_path
      @book_info_path = @project_path + "/book_info.yml"
      @book_info = YAML::load_file(@book_info_path)
      @page_size = options[:page_size] || 'A5'
      @page_width = SIZES[@page_size][0]
      @height = SIZES[@page_size][1]
      @body_starting_page_number = 0
      create_book_cover
      process_front_matter
      process_body_matter_with_parts
      process_rear_matter
      generate_toc
      generate_inner_book
      generate_pdf_book 
    end
  end

  ########### body_matter ###########

  def process_body_matter_with_parts
    @body_matter_docs = []
    Dir.glob("#{@project_path}/part_*").sort.each_with_index do |part, i|
      r = RLayout::BookPart.new(part)
      @body_matter_docs += r.part_docs
    end
    generate_body_matter_toc
  end

  def generate_body_matter_toc
    @body_matter_toc = []
    @body_matter_docs.each do |chapter_folder|
      toc = chapter_folder + "/toc.yml"
      @body_matter_toc << YAML::load_file(toc) if File.exist?(toc)
    end
    @book_toc += @body_matter_toc
  end

  def save_toc_content
    flatten_toc = []
    @book_toc.each do |chapter_item|
      chapter_item.each do |toc_item|
        a = []
        a << toc_item[:para_string]
        a << toc_item[:page].to_s
        flatten_toc << a
      end
    end
    File.open(toc_yml_path, 'w'){|f| f.write flatten_toc.to_yaml}
  end

  def body_matter_docs_pdf
    pdf_files = []
    @body_matter_docs.each do |chapter|
      chapter_pdf_file = chapter + "/chapter.pdf"
      pdf_files << chapter_pdf_file if File.exist?(chapter_pdf_file)
    end
    pdf_files
  end
end