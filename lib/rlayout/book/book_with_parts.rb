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
      @page_size = options[:page_size] || 'A5'
      @page_width = SIZES[@page_size][0]
      @height = SIZES[@page_size][1]
      @starting_page_number = 1
      create_book_cover
      @front_matter = FrontMatter.new(@project_path)
      @starting_page_number += @front_matter.page_count
      @body_matter = BodyMatterWithPart.new(@project_path, body_doc_type: @body_doc_type, starting_page_number: @starting_page_number)
      @rear_matter = RearMatter.new(@project_path)
      generate_toc
      generate_pdf_for_print
      generate_pdf_book
      generate_ebook unless options[:no_ebook]
    end
  end

  def generate_toc
    FileUtils.mkdir_p(toc_folder) unless File.exist?(toc_folder)
    # save_toc_content
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
    # create_toc_page_links_for_ebook
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
    flatten_toc += @body_matter.toc_content
    File.open(toc_yml_path, 'w'){|f| f.write flatten_toc.to_yaml}
  end


  # def copy_page_images_to_ebook
  #   @ebook_page_contents = ""
  #   target_folder = ebook_page_images_folder
  #   FileUtils.mkdir_p(target_folder) unless File.exist?(target_folder)
  #   @page_number = 1
  #   # front_cover
  #   Dir.glob("#{build_front_cover_path}/00**").sort.each do |page_folder|
  #     page_image = page_folder + "/page.jpg"
  #     target_image = target_folder + "/#{r_justed_number @page_number}.jpg"
  #     FileUtils.cp(page_image, target_image)
  #     @ebook_page_contents += page_html_for_ebook(@page_number)
  #     @page_number += 1
  #   end
  #   # front_matter_pages
  #   @front_matter.front_matter_docs.each do |doc|
  #     toc_page_index = 0
  #     Dir.glob("#{build_front_matter_path}/#{doc}/00**").sort.each do |page_folder|
  #       page_image = page_folder + "/page.jpg"
  #       target_image = target_folder + "/#{r_justed_number @page_number}.jpg"
  #       FileUtils.cp(page_image, target_image)
  #       if doc == 'toc'
  #         # this page is toc page
  #         @ebook_page_contents += page_html_for_ebook(@page_number, toc_page:true, toc_page_index:toc_page_index)
  #         toc_page_index += 1
  #       else
  #         @ebook_page_contents += page_html_for_ebook(@page_number)
  #       end
  #       @page_number += 1
  #     end
  #   end
  #   # body_matter_pages
  #   binding.pry
  #   @body_matter.body_matter_docs.each do |chapter|
  #     Dir.glob("#{chapter}/00**").sort.each do |page_folder|
  #       page_image = page_folder + "/page.jpg"
  #       target_image = target_folder + "/#{r_justed_number @page_number}.jpg"
  #       FileUtils.cp(page_image, target_image)
  #       @ebook_page_contents += page_html_for_ebook(@page_number)
  #       @page_number += 1      
  #     end
  #   end
  #   # rear_matter_pages
  #   if @rear_matter
  #     @rear_matter.rear_matter_docs.each do |doc|
  #       Dir.glob("#{build_rear_matter_path}/#{doc}/00**").each do |page_folder|
  #         page_image = page_folder + "/page.jpg"
  #         target_image = target_folder + "/#{r_justed_number @page_number}.jpg"
  #         FileUtils.cp(page_image, target_image)
  #         @ebook_page_contents += page_html_for_ebook(@page_number)
  #         @page_number += 1       
  #       end
  #     end
  #   end
  #   # back_cover
  #   Dir.glob("#{build_back_cover_path}/00**").sort.each do |page_folder|
  #     page_image = page_folder + "/page.jpg"
  #     target_image = target_folder + "/#{r_justed_number @page_number}.jpg"
  #     FileUtils.cp(page_image, target_image)
  #     @ebook_page_contents += page_html_for_ebook(@page_number)
  #     @page_number += 1
  #   end

  #   # copy cover image as loading image
  #   cover_page_image = target_folder + "/0001.jpg"
  #   loading_image = target_folder + "/loading.jpg"
  #   FileUtils.cp(cover_page_image, loading_image)
  # end

end