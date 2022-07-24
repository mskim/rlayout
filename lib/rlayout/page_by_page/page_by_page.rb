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
  end
end