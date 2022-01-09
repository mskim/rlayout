module RLayout

  # Book with parts
  # footer left foort has book_title, right_footer has part_title
  
  class BookWithParts < Book
    attr_reader :project_path, :book_info, :page_width, :height
    attr_reader :has_cover_inside_page, :has_wing, :has_toc
    attr_reader :book_toc, :rear_matter_toc
    def initialize(project_path, options={})
      @project_path = project_path
      @book_info_path = @project_path + "/book_info.yml"
      @book_info = YAML::load_file(@book_info_path)
      @book_info = Hash[@book_info.map{ |k, v| [k.to_sym, v] }]   
      @paper_size = @book_info[:paper_size]  || "A5"
      @paper_size = options[:paper_size] if options[:paper_size]
      @page_width = SIZES[@paper_size][0]
      @height = SIZES[@paper_size][1]
      @starting_page_number = 1
      create_book_cover
      @front_matter = FrontMatter.new(@project_path)
      @starting_page_number += @front_matter.page_count
      @body_matter = BodyMatterWithPart.new(@project_path, body_doc_type: @body_doc_type, starting_page_number: @starting_page_number, paper_size:@paper_size)
      @rear_matter = RearMatter.new(@project_path)
      generate_toc
      generate_pdf_for_print
      generate_pdf_book
      generate_ebook unless options[:no_ebook]
    end
  end

  def generate_toc
    FileUtils.mkdir_p(toc_folder) unless File.exist?(toc_folder)
    save_book_toc
    h = {}
    h[:document_path] = toc_folder
    h[:page_pdf]      = true
    h[:max_page]      = 1
    h[:toc_item_count] = 20
    # h[:parts_count]   = @parts_count
    h[:no_table_title] = true # tells not to creat toc title
    r = RLayout::Toc.new(h)
    new_page_count = r.page_count
    @toc_doc_page_count = new_page_count
    @toc_page_links = r.link_info
  end

  def toc_folder
    build_folder + "/front_matter/toc"
  end

  def toc_yml_path
    build_folder + "/front_matter/toc/toc_content.yml"
  end

  def save_book_toc
    book_toc = []
    book_toc += @front_matter.toc_content
    book_toc += @body_matter.toc_content
    # book_toc += @rear_matter.toc_content
    File.open(toc_yml_path, 'w'){|f| f.write book_toc.to_yaml}
  end

end