module RLayout

  # parse section.md file
  # comments and instructions
  # [section_info
  # [aricle]
  # [ad]

  class NewsPageParserMd
    attr_reader :project_path, :book_md_path, :book_info_path
    attr_reader :part_titles, :has_parts, :toc_folder
    attr_reader :footnote_markup,  :h2_markup, :h3_markup, :h4_markup

    def initialize(project_path, options={})
      @project_path = project_path
      @section_md_path = @project_path + "/section.md"
      @book_info_path = @project_path + "/book_info.yml"
      if File.exist?(@section_md_path)
        # section.md is given
        @source = File.open(@book_md_path, 'r'){|f| f.read}
      else
        # therer is no section content
        save_sample_book_md
        @source = sample_book_md
      end
      section_md2docs
      self
    end

    def build_folder
      @project_path + "/_build"
    end

    def build_front_matter_folder
      build_folder + "/front_matter"
    end

    def build_rear_matter_folder
      build_folder + "/rear_matter"
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

    def filter_double_newline(content)
      content = content.dup
      content.gsub!("\r\n", "\n")
      content.gsub!(/\n/,"\n\n")
      content
    end

    def section_md2docs
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
          book_document_contents << @source.slice(indice, chunk_length)
        end
      end
      save_section_content(book_document_contents)
    end


    def save_section_content(book_document_contents)
      FileUtils.mkdir_p(build_front_matter_folder) unless File.exist?(build_front_matter_folder)
      # PART_START = /PART|part|파트/
      part_index = 1
      body_matter_index = 1
      rear_matter_index = 1
      @part_titles = []
      book_document_contents.each_with_index do |doc_chunk, i|
        starting_page = nil
        ending_page = nil
        page_count = nil

        # if doc_string = doc_chunk.match(/^\[\d.*?.*?\]|^\[.*?\]/)
        # this is [1p 도비라] or [책정보]
        if doc_string = doc_chunk.match(/^#\s\[\d.*?.*?\]|^#\s\[.*?\]/)
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
            # strip off []
            doc_string = doc_string.sub("# [", "").sub("]","")
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
            first_line = doc_chunk_in_array[0]
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
            if doc_class == 'toc' || doc_class == 'title_page' || doc_class == 'blank_page' || doc_class == 'inside_cover' 
            else
              doc_content = filter_double_newline(doc_content)
            end

            File.open(doc_path, 'w'){|f| f.write doc_content}
          elsif doc_name = is_body_matter_item?(doc_string)
            # handle body_matter docs
            doc_chunk_in_array = doc_chunk.split("\n")
            first_line = doc_chunk_in_array[0]
            if first_line.include?(":")
              # [chapter]: this is title
              chapter_title = first_line.split("]:")[1].strip
            elsif first_line.strip.split("\] ").length > 1
              chapter_title = first_line.split("\]")[1].strip
              # [chapter] this is title
            else
              chapter_title = doc_string.sub("# \[", "").sub("\]","")
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
            doc_content = filter_double_newline(doc_content)
            
            File.open(story_path, 'w'){|f| f.write doc_content}
            body_matter_index += 1
          elsif doc_name = is_rear_matter_item?(doc_string)
            doc_chunk_in_array = doc_chunk.split("\n")
            first_line = doc_chunk_in_array[0..0][0]
            doc_chunk_without_first_line = doc_chunk_in_array[1..-1].join("\n")
            doc_content = doc_chunk_without_first_line
            doc_class = doc_tyle2class_name(doc_name)
            doc_folder = build_rear_matter_folder + "/#{rear_matter_index}_#{doc_class}"
            FileUtils.mkdir_p(doc_folder) unless File.exist?(doc_folder)
            story_path = doc_folder + "/story.md"
            File.open(story_path, 'w'){|f| f.write doc_content}
            rear_matter_index += 1
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
      front_matter_items =%w[책정보 대도비라 소도비라 앞정보 차례 머리말 백 서문 일러두기 안내 title_page inside_cover blank prologue toc isbn]
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

    def is_rear_matter_item?(doc_type)
      rear_matter_items =%w[뒷정보 back_isbn]
      rear_matter_items.each do |rear_item|
        return rear_item if doc_type.include?(rear_item)
      end
      false
    end

    def save_book_info(path, book_info_content)
      # convert local markups to markdown markups
      File.open(path , 'w'){|f| f.write book_info_content}
    end


    # front_matter_items =%[ 대도비라 소도비라 차례 머리말 백 일러두기
    def doc_tyle2class_name(doc_type)
      case doc_type
      when '대도비라', 'title_page'
        'title_page'
      when '소도비라', 'inside_cover'
        'inside_cover' 
      when '백', 'blank_page', 'blank'
        'blank_page' 
      when '일러두기', 'help'
        'help' 
      when '머리말', 'prologue','서문'
        'prologue'
      when '차례','toc'
        'toc'
      when '장','chapter','Chapter', '부록'
        'chapter'
      when '앞정보','뒷정보', 'isbn'
        'isbn'
      end
    end
    # update book_info part
    def update_part_titles
      book_info = YAML::load_file(@book_into_path)
      book_info['part'] = @part_titles
      File.open(@book_into_path, 'w'){|f| f.write book_info.to_yaml}
    end

    def save_sample_section_md
      File.open(@book_md_path, 'w'){|f| f.write sample_section_md}
    end

    def sample_section_md
      <<~EOF


      [section_info]
      ---
      paper_size: 'NEWSPAPER'
      page_number:1
      column_count: 6
      pillars: [4,2]
      left_margin: 20mm
      top_margi: 14mm
      right_margin: 20mm
      bottom_margin: 25mm
      binding_margin: 3mm
      body_line_count: 7
      grid: [6,15]

      
  
      # [1-1]
      ---
      title: 여기는 제목 입니다.
      subtitle: 여기는 부제목 입니다.
      author: 홍길동

      ---
      
      여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력.
      여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 
      여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력.
      여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 
      여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 
      여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 

            
      여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력.
      여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 
      여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력.
      여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 
      여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 
      여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 


            
      여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력.
      여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 
      여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력.
      여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 
      여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 
      여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 

      # [1-2]
      ---
      title: 여기는 제목 입니다.
      subtitle: 여기는 부제목 입니다.
      author: 홍길동

      ---
       
      여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력.
      여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 
      여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력.
      여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 
      여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 
      여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 


      # [2-1]
      ---
      title: 여기는 제목 입니다.
      subtitle: 여기는 부제목 입니다.
      author: 홍길동

      ---
       
      여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력.
      여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 
      여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력.
      여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 
      여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 
      여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 


      # [2-1]
      ---
      title: 여기는 제목 입니다.
      subtitle: 여기는 부제목 입니다.
      author: 홍길동

      ---
       
      여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력.
      여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 
      여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력.
      여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 
      여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 
      여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 


      # [2-2]
      ---
      title: 여기는 제목 입니다.
      subtitle: 여기는 부제목 입니다.
      author: 홍길동

      ---
       
      여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력.
      여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 
      여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력.
      여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 
      여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 
      여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 


      # [2-3]
      ---
      title: 여기는 제목 입니다.
      subtitle: 여기는 부제목 입니다.
      author: 홍길동

      ---
       
      여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력.
      여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 
      여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력.
      여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 
      여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 
      여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 


      EOF
    end
  end

end