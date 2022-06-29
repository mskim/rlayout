module RLayout

  # parse book.md file
  # comments and instructions
  # [책정보]
  # 판형:
  # 접지마진:
  # 제목:
  # 부제목:
  # 저자:
  # 출판사:
  # [대도비라]
  # [백]
  # [소도비라]
  # [백]
  # [일러두기]
  # [머리말]
  # [차례]
  # [제1장]: 1장 제목
  # [제2장]: 2장 제목
  # [제3장]: 3장 제목

  # BODY_START = /^(본문시작|body_start|BODY_START)/
  # DOC_START = /^\[.*\]/i
  # FRONT_MATTER_DOC_START = /^(\[.*대도비라\]|\[.*소도비라\]|\[.* 차례.*\]|\[.*머리말\])/m
  # CHAPTER_START = /^(제\d*장|\d*장|chapter_\d*|Chapter_\d*)/

  class BookParserMd
    attr_reader :project_path, :book_txt_path, :book_md_path, :book_info_path
    attr_reader :part_titles, :has_parts, :toc_folder
    def initialize(project_path, options={})
      @project_path = project_path
      @book_md_path = @project_path + "/book.md"
      @book_txt_path = @project_path + "/book.txt"
      @book_info_path = @project_path + "/book_info.yml"

      if File.exist?(@book_md_path)
      else File.exist?(@book_txt_path)
        convert_txt2md
      end
      book_md2docs
      self
    end

    def build_folder
      @project_path + "/_build"
    end

    def build_front_matter_folder
      build_folder + "/front_matter"
    end

    def book_cover_folder
      build_folder + "/book_cover"
    end

    def self.push_to_github
      BookPlan.create_github_repo(project_path)
    end

    def book_md_path
      @project_path + "/book.md"
    end

    def convert_txt2md(book_txt_path)

    end

    def book_md2docs
      @each_with_index
      source = File.open(@book_md_path, 'r'){|f| f.read}
      indices = source.to_enum(:scan, /^\[[^\^].+\]/i).map do |some|
        Regexp.last_match.begin(0)
      end
      end_indece =  source.length
      book_document_contents = []
      indices.each_with_index do |indice, i|
        if i < indices.length - 1
          chunk_length = indices[i+1] - indice
          book_document_contents << source.slice(indice, chunk_length)
        else
          # last chunk
          chunk_length = end_indece - indice
          book_document_contents << source.slice(indice, chunk_length)
        end
      end

      save_doc_content(book_document_contents)
    end

    def save_doc_content(book_document_contents)
      FileUtils.mkdir_p(build_front_matter_folder) unless File.exist?(build_front_matter_folder)
      # PART_START = /PART|part|파트/
      part_index = 1
      body_matter_index = 1
      @part_titles = []
      book_document_contents.each_with_index do |doc_chunk, i|
        starting_page = nil
        ending_page = nil
        page_count = nil
        if doc_string = doc_chunk.match(/^\[\d.*?.*?\]|^\[.*?\]/)
          doc_string = doc_string.to_s
          if doc_string.include?("책정보") || doc_string.include?("book_info")
            book_info_yaml_mark = "---\n"
            book_info_yaml_mark_with_r = "---\r\n"
            if doc_chunk.include?(book_info_yaml_mark)
              book_info_without_marker = doc_chunk.split(book_info_yaml_mark)[1]
              book_info_content = book_info_yaml_mark + "\n" + book_info_without_marker

            elsif doc_chunk.include?(book_info_yaml_mark_with_r)
              book_info_without_marker = doc_chunk.split(book_info_yaml_mark_with_r)[1]
              book_info_content = book_info_yaml_mark + "\n" + book_info_without_marker
            else
              book_info_content = book_info_yaml_mark + "\n" + book_info_content
            end
            save_book_info(@book_info_path, book_info_content)
          elsif doc_string =~ PART_START
            # TODO
            # [part_1]: 파드1 제목
            @has_parts = true
            part_title = doc_chunk.split(":")[1]
            @part_titles << part_title
          elsif doc_name = is_front_matter_item?(doc_string)
            # binding.pry
            # strip off []
            doc_string = doc_string.sub("[", "").sub("]","")
            doc_string_array =  doc_string.split("p")
            if doc_string_array.length == 1
              # no page info is present
              # 대도비라
            elsif doc_string_array.length == 2
              # we have page info
              # 1p 대도비라
              # 7~8p 차례
              # check if the page info has ending page number
              doc_page_string = doc_string_array[0]
              if doc_page_string.include?("~")
                # 7~8p
                page_array = doc_page_string.split("~")
                starting_page = page_array[0].to_i
                ending_page = page_array[1].to_i
                page_count = ending_page - starting_page
              else
                # 7p
                starting_page = doc_page_string.to_i
              end
            end
            # handle front_matter docs
            # front_matter_item = true
            # save front_matter_doc to _build/front_matter
            doc_chunk_in_array = doc_chunk.split("\n")
            first_line = doc_chunk_in_array[0..0][0]
            if first_line.include?(":")
              chapter_title = first_line.split(":")[1].strip
            else
              chapter_title = doc_string.sub("[", "").sub("]","")
            end
            doc_class = doc_tyle2class_name(doc_name)
            h = {}
            h['doc_type'] = doc_class
            h['starting_page'] = starting_page if starting_page
            h['page_count'] = page_count if page_count
            h['title'] = chapter_title
            
            doc_content = h.to_yaml
            doc_content += "---\n\n"
            doc_chunk_without_first_line = doc_chunk.split("\n")[1..-1].join("\n")
            doc_content += doc_chunk_without_first_line
            doc_folder = build_front_matter_folder + "/#{i}_#{doc_class}"
            FileUtils.mkdir_p(doc_folder) unless File.exist?(doc_folder)
            if doc_class == 'toc'
              @toc_folder = doc_folder
            end

            doc_path = doc_folder + "/story.md"
            File.open(doc_path, 'w'){|f| f.write doc_content}
          elsif doc_name = is_body_matter_item?(doc_string)
            # handle body_matter docs
            doc_chunk_in_array = doc_chunk.split("\n")
            first_line = doc_chunk_in_array[0..0][0]
            if first_line.include?(":")
              chapter_title = first_line.split(":")[1].strip
            else
              chapter_title = doc_string.sub("[", "").sub("]","")
            end
            h = {}
            h['doc_type'] = doc_tyle2class_name(doc_name)
            h['title'] = chapter_title
            doc_content = h.to_yaml
            doc_content += "---\n\n"
            # doc_content += doc_chunk  
            doc_chunk_without_first_line = doc_chunk_in_array[1..-1].join("\n")
            doc_content += doc_chunk_without_first_line
            chapter_folder = build_folder + "/chapter_#{body_matter_index.to_s.rjust(2,"0")}"
            FileUtils.mkdir_p(chapter_folder) unless File.exist?(chapter_folder)
            story_path = chapter_folder + "/story.md"
            File.open(story_path, 'w'){|f| f.write doc_content}
            body_matter_index += 1
          else
            # handle unknown type docs
            puts "Unsopported doc_type: #{doc_string} found!!!"  
            next
          end
        end
      end
      update_part_titles if @part_titles.length > 0
    end

    def is_front_matter_item?(doc_type)
      front_matter_items =%w[책정보 대도비라 소도비라 차례 머리말 백 서문 일러두기 안내]
      front_matter_items.each do |front_item|
        return front_item if doc_type.include?(front_item)
      end
      false
    end

    def is_body_matter_item?(doc_type)
      body_matter_items =%w[장 chapter Chapter 부록]
      body_matter_items.each do |body_item|
        return body_item if doc_type.include?(body_item)
      end
      false
    end

    def save_book_info(path, book_info_content)
      File.open(path , 'w'){|f| f.write book_info_content}
    end
    # front_matter_items =%[ 대도비라 소도비라 차례 머리말 백 일러두기]

    def doc_tyle2class_name(doc_type)
      case doc_type
      when '대도비라', 'title_page'
        'title_page'
      when '소도비라', 'inside_cover'
        'inside_cover' 
      when '백', 'blank_page'
        'blank_page' 
      when '일러두기', 'help'
        'help' 
      when '머리말', 'prologue','서문'
        'prologue'
      when '차례','toc'
        'toc'
      when '장','chapter','Chapter', '부록'
        'chapter'
      end
    end
    # update book_info part
    def update_part_titles
      book_info = YAML::load_file(@book_into_path)
      book_info['part'] = @part_titles
      File.open(@book_into_path, 'w'){|f| f.write book_info.to_yaml}
    end
  end

end