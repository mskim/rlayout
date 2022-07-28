module  RLayout
  # 1. PageByPage: parse page.txt into page folders
  # 2. FitPage: adjust text_style until page content fits page
  # 3. merge each page as print_page
  #     - put footer, print mark

  class PageByPage
    attr_reader :project_path, :book_info, :book_info_path
    attr_reader :source_path, :source
    attr_reader :starting_page
    def initialize(project_path)
      @project_path = project_path
      @book_info_path = @project_path + "/book_info.yml"
      @build_path = @project_path + "/_build"
      @book_info = YAML::load_file(@book_info_path)
      @source_path = @project_path + "/page_by_page.txt"
      @source = File.open(@source_path, 'r'){|f| f.read}
      book_txt2pages
      self
    end

    def book_txt2pages
      # indices = @source.to_enum(:scan, /^\[[^\^].+\]/i).map do |some|
      indices = @source.to_enum(:scan, /^<p(\d+?)>/i).map do |some|
          Regexp.last_match.begin(0)
      end
      # TODO parse @starting_page
      @starting_page = 6
      first_chunk = @source.slice(0, indices[0])
      # parse_first_chunk(first_chunk)
      end_indece =  @source.length
      book_page_contents = []
      indices.each_with_index do |indice, i|
        if i < indices.length - 1
          chunk_length = indices[i+1] - indice
          book_page_contents << @source.slice(indice, chunk_length)
        else
          # last chunk
          chunk_length = end_indece - indice
          book_page_contents << @source.slice(indice, chunk_length)
        end
      end
      book_page_contents.unshift(first_chunk)
      save_doc_content(book_page_contents)
    end

    def save_doc_content(book_page_contents)
      FileUtils.mkdir_p(@build_path) unless File.exist?(@build_path)
      book_page_contents.each_with_index do |page_content, i|
        page_number = i + @starting_page
        page_number = page_number.to_s.rjust(4,'0')
        page_path = @build_path  + "/#{page_number}"
        RLayout::FitPage.new(page_path, page_content)
      end
    end

    def self.generate_print(project_path)

      @width = 354.33075
      @height = 532.913448
      @left_margin = 56.69292
      @right_margin =  56.69292
      @@bottom_margin = 70.86615
      @binding_margin = 8.50393
      @gripper_margin = 10*2.834646
      @bleed_margin = 3*2.834646


      build_path = project_path + "/_build"
      print_path = project_path + "/_print"
      FileUtils.mkdir_p(print_path)  unless File.exist?(print_path)
      @print_pdf_doc  = HexaPDF::Document.new
      Dir.glob("#{build_path}/**/*").grep(/\d{1,3}.pdf$/).each do  |pdf_path|
        page_number = File.basename(pdf_path,'.pdf').to_i
        if page_number.odd?
          side = 'right'
        else
          side = 'left'
        end
        print_page_width = @width + @gripper_margin*2
        print_page_height = @height + @gripper_margin*2
        first_pdf_page = RLayout::PrintPage.new(page_path:pdf_path, side:side, width: print_page_width, height: print_page_height, gripper_margin: @gripper_margin, bleed_margin: @bleed_margin, binding_margin: @binding_margin).first_pdf_page
        @print_pdf_doc.pages << @print_pdf_doc.import(first_pdf_page)
      end
      print_pdf_path = print_path + "/pdf_without_cover.pdf"
      @print_pdf_doc.write(print_pdf_path)
    end
  end
end