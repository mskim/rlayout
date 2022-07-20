module RLayout
  attr_reader :section_path, :issue_path, :@issue_info
  attr_reader :source
  class NewsPageMdParer
    def initialize(page_source_path, options={})
      @section_path = page_source_path
      @issue_path = File.dirname(@section_path)
      @issue_info_path = @issue_path + "/issue_info.yml"
      @source = File.open(page_source_path, 'r'){|f| f.read}

      if File.exist?(@issue_info_path)
        @issue_info = YAML::load_file(@issue_info_path)
      else
        @issue_info = default_issue_info
        File.open(@issue_info, 'w'){|f| f.write default_issue_info}
      end
      newspage_md2docs
      self
    end

    def newspage_md2docs
      # indices = @source.to_enum(:scan, /^\[[^\^].+\]/i).map do |some|
      indices = @source.to_enum(:scan, /^#\s\[.+?\]/i).map do |some|
          Regexp.last_match.begin(0)
      end
      # first_chunk = @source.slice(0, indices[0])
      # parse_first_chunk(first_chunk)
      end_indece =  @source.length
      book_document_contents = []
      indices.each_with_index do |indice, i|
        if i < indices.length - 1
          chunk_length = indices[i+1] - indice
          book_document_contents << @source.slice(indice, chunk_length)
        else
          # last chunk
          chunk_length = end_indece - indice
          page_article_contents << @source.slice(indice, chunk_length)
        end
      end
      save_article_content(page_article_contents)
    end

    def save_article_content(page_article_contents)

      
    end

    def default_issue_info
      <<~EOF
      ---
      paper_size: 'NEWSPAPER'
      date: 2020-04-01
      columns: 6
      pillars: [4,2]
      ad_type: '6x5'

      EOF
    end
  end




end