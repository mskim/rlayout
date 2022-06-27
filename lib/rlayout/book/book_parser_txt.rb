module RLayout
  
  # parse book.txt file
  # instruction area
  # [책정보],  [book_info]
  # [대도비라], [inside_cover]
  # [백 1p], [blank]
  # [소도비라], [inside_cover2]
  # [차례], [toc]
  # [일러두기], [info]

  # [본문시작], [body]

  # [파트_1], [part_1]
  # [제1장]
  # [제2장]
  # [제3장]

  # # 장 제목
  # ## 중간제목
  # ### 우즉정렬 고딕

  # ![image](1.jpg)
  # {caption: "image cation", position: 7, size: "3x3", bleed:true}

  # ![table_1]](table_1.jpg)
  # {caption: "image cation", position: 7, size: "3x3"}

  # **bold**
  # *italic*
  # footnote [^1]
  # [^1]  footnote content

  BODY_START = /^(본문시작|body_start|BODY_START)/
  DOC_START = /^\[.*\]/i
  FRONT_MATTER_DOC_START = /^(\[.*대도비라\]|\[.*소도비라\]|\[.* 차례.*\]|\[.*머리말\])/m
  CHAPTER_START = /^(제\d*장|\d*장|chapter_\d*|Chapter_\d*)/
  PART_START = /PART|part|파트/
  # DOC_START  start of chapter or new pdf_document
  # DOC_START = /^#\s/
  # FRONT_MATTER_TYPE = /prologue|thanks|dedication/
  # REAR_MATTER_TYPE = /appendix|index/

  class BookParserTxt
    attr_reader :book_txt_path
    # attr_reader :docs, :md_file
    attr_reader :part_titles
    def initialize(book_txt_path)
      @book_txt_path = book_txt_path
      @project_path = File.dirname(@book_txt_path)
      book_txt2docs
      self
    end
    
    def build_folder
      @project_path + "/_build"
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

    def book_txt2docs
      source = File.open(@book_txt_path, 'r'){|f| f.read}
      indices = source.to_enum(:scan, /^\[.+\]/i).map do |some|
        Regexp.last_match.begin(0)
      end
      end_indece =  source.length
      book_document_contents = []
      indices.each_with_index do |indice, i|
        if i < indices.length - 1
          chunk_length = indices[i+1] - indice
          book_document_contents << source.slice(indice, chunk_length)
        else
          chunk_length = end_indece - indice
          book_document_contents << source.slice(indice, chunk_length)
        end
      end
      book_md_array = book_document_contents.map do |doc_content|
        convert_tech_media_text(doc_content)
      end
      book_md =  book_md_array.join("\n")

      File.open(book_md_path, 'w'){|f| f.write book_md}
    end

    def convert_tech_media_text(text)
      text = convert_tech_media_gotic(text)
      text = convert_tech_media_quoted(text)
      text = convert_tech_media_footnote(text)
      text
    end

    # @@ -> 주석
    # ## -> 인용 스타일
    # $$ -> 오른쪽 정렬
    # ^^ -> 고딕

    # @@text@@ -> text[^#{number}]
    def convert_tech_media_footnote(text)
      text = text.dup
      # .*? is non-greedy version of .*
      # .* will parse upto end of string. 
      footnotes = text.scan(/@@.*?@@/)
      puts footnotes
      footnotes.each_with_index  do |footnote,i|
        new_string = footnote.gsub("@@", "")
        text.gsub!(footnote, "#{new_string}[^#{i + 1}]")
      end
      text
    end

    # ##text## -> ### text\n\n
    def convert_tech_media_quoted(text)
      # .*? is non-greedy version of .*
      quotes = text.scan(/\^\^.*?\^\^/)
      quotes.each  do |quote|
        new_form = quote.gsub("##", "")
        text.gsub!(quote, "### #{new_form}\n\n")
      end
      text
    end

    # ^^text^^ -> ## text\n\n
    def convert_tech_media_gotic(text)
      # .*? is non-greedy version of .*
      gothics = text.scan(/\^\^.*?\^\^/)
      gothics.each  do |gothic|
        new_form = gothic.gsub("^^", "")
        text.gsub!(gothic, "## #{new_form}\n\n")
      end  
      text
    end

    def parse_front_matter_from_book_txt(front_matter_content)

      # filtered_front_matter_contents = RubyPants.new(front_matter_content).to_html if front_matter_content
      reader = RLayout::Reader.new front_matter_content.to_s, nil
      text_blocks = reader.text_blocks.dup
      front_matter_doc_content = []
      while lines_block = text_blocks.shift do
        first_line = lines_block[0]
        if first_line =~ FRONT_MATTER_DOC_START
          if first_line.include?('책정보')
            save_book_info(lines_block)
          elsif first_line.include?('대도비라')
            doc_content = ['대도비라', lines_block]
            front_matter_doc_content << doc_content
          elsif first_line.include?('소도비라')
            doc_content = ['소도비라', lines_block]
            front_matter_doc_content << doc_content          
          elsif first_line.include?('차례')
            doc_content = ['차례', lines_block]
            front_matter_doc_content << doc_content          
          elsif first_line.include?('일러두기')
            doc_content = ['일러두기', lines_block]
            front_matter_doc_content << doc_content          
          elsif first_line.include?('머리말')
            doc_content = ['머리말', lines_block]
            front_matter_doc_content << doc_content  
          elsif first_line.include?('백')
            # doc_content = ['백', lines_block]
            # front_matter_doc_content << doc_content 
          else 
          end
        end
      end
      create_front_matter_docs(front_matter_doc_content)

    end
    
    def save_book_info(book_info_text)
      book_info_content = book_info_text.dup
      book_info_content.shift
      book_info_content.unshift("---")
      book_info_yml  = book_info_content.join("\n")
      File.open( book_into_path , 'w'){|f| f.write book_info_yml}
    end

    def create_front_matter_docs(front_matter_doc_content)
      front_matter_doc_content.each_with_index do |marker, i|
        # name, starting_page, page_count, order
        h = {}
        order = i + 1
        name  = marker[0]
        first_line =  marker[1][0]
        first_line.sub!("[", "")
        first_line.sub!("]","")
        page_string = first_line =~/^(\d*)~?(\d?)p/
        starging_page = $1.to_i if $1 && $1 != ""
        ending_page = $2.to_i if $2 != ""
        page_count = 1
        if starging_page && ending_page
          page_count = ending_page - starging_page
        else
          ending_page = starging_page + 1
        end
        # remove first line
        content = marker.flatten.last
        # @front_matter_path = @project_path + "/front_matter"
        # FileUtils.mkdir_p(@front_matter_path) unless File.exist?(@front_matter_path)
        front_matter_doc_body = content
        case name
        when "대도비라", "inside_cover"
          front_matter_doc_folder_path = build_front_matter_folder  + "/#{order}_#{name}"
          FileUtils.mkdir_p(front_matter_doc_folder_path) unless File.exist?(front_matter_doc_folder_path)
          front_matter_doc_path = front_matter_doc_folder_path + "/story.md"
          File.open(front_matter_doc_path, 'w'){|f| f.write front_matter_doc_body}
        when "소도비라", "inside_cover_2"
          front_matter_doc_folder_path = build_front_matter_folder  + "/#{order}_#{name}"
          FileUtils.mkdir_p(front_matter_doc_folder_path) unless File.exist?(front_matter_doc_folder_path)
          front_matter_doc_path = front_matter_doc_folder_path + "/story.md"
          File.open(front_matter_doc_path, 'w'){|f| f.write front_matter_doc_body}
        when "차례", "toc"
          front_matter_doc_folder_path = build_front_matter_folder  + "/#{order}_#{name}"
          FileUtils.mkdir_p(front_matter_doc_folder_path) unless File.exist?(front_matter_doc_folder_path)
          front_matter_doc_path = front_matter_doc_folder_path + "/story.md"
          File.open(front_matter_doc_path, 'w'){|f| f.write front_matter_doc_body}
        when "백", "blank"
          front_matter_doc_folder_path = build_front_matter_folder  + "/#{order}_#{name}"
          FileUtils.mkdir_p(front_matter_doc_folder_path) unless File.exist?(front_matter_doc_folder_path)
          front_matter_doc_path = front_matter_doc_folder_path + "/story.md"
          File.open(front_matter_doc_path, 'w'){|f| f.write front_matter_doc_body}
        when "머릿말",  "prologue"
          front_matter_doc_folder_path = build_front_matter_folder  + "/#{order}_#{name}"
          FileUtils.mkdir_p(front_matter_doc_folder_path) unless File.exist?(front_matter_doc_folder_path)
          front_matter_doc_path = front_matter_doc_folder_path + "/story.md"
          File.open(front_matter_doc_path, 'w'){|f| f.write front_matter_doc_body}
        when "일러두기",  "info"
          front_matter_doc_folder_path = build_front_matter_folder  + "/#{order}_#{name}"
          FileUtils.mkdir_p(front_matter_doc_folder_path) unless File.exist?(front_matter_doc_folder_path)
          front_matter_doc_path = front_matter_doc_folder_path + "/story.md"
          File.open(front_matter_doc_path, 'w'){|f| f.write front_matter_doc_body}
        end
      end
    end

    def parse_body_matter_from_book_txt(body_matter_content)
        filtered_body_matter_contents = RubyPants.new(body_matter_content).to_html if body_matter_content
        reader = RLayout::Reader.new filtered_body_matter_contents, nil
        text_blocks = reader.text_blocks.dup
        @part_titles = []
        @front_matter_order = 1
        @part_order = 1
        @chapter_order = 1
        @rear_matter_order = 0
        @current_doc_foler = build_folder
        while lines_block = text_blocks.shift do
          first_line = lines_block[0]
          if first_line =~PART_START
            @current_part_folder = build_folder + "/part_#{@part_order.to_s.rjust(2,'0')}"
            FileUtils.mkdir_p(@current_part_folder) unless File.exist?(@current_part_folder)
            @current_doc_foler = @current_part_folder
            part_cover_foler = @current_doc_foler + "/00_part_cover"
            FileUtils.mkdir_p(part_cover_foler) unless File.exist?(part_cover_foler)
            @part_order += 1
            part_title = first_line.split(":")[1] || ""
            @part_titles << part_title
            @chapter_order = 1
          elsif first_line=~CHAPTER_START
            @doc_type = 'chapter'
            # @title = first_line.split(":")[1]
            # save current doc
            # chapter_doc =<<~EOF
            # ---
            # doc_type: chapter
            # title: #{@title}
            # ---
  
            # EOF
            chapter_doc = ""

            while lines_block = text_blocks.shift do
              first_line = lines_block[0]
              if first_line =~PART_START || first_line =~CHAPTER_START
                build_chapter_folder =  build_folder + "/#{@chapter_order.to_s.rjust(2,'0')}_chapter"
                FileUtils.mkdir_p(build_chapter_folder) unless File.exist?(build_chapter_folder)
                chapter_story_path = build_chapter_folder + "/story.md"
                dobue_spaced_chapter_doc = chapter_doc.gsub("\s\n", "\n")
                dobue_spaced_chapter_doc = chapter_doc.gsub(".\n", ".\n\n")
                File.open(chapter_story_path, 'w'){|f| f.write dobue_spaced_chapter_doc}
                @chapter_order += 1
                # text_blocks.unshift(lines_block)

                break
              else
                chapter_doc += "\n\n" + lines_block.join("\n")
              end
            end
            if chapter_doc != ""
              build_chapter_folder =  build_folder + "/#{@chapter_order.to_s.rjust(2,'0')}_chapter"
              FileUtils.mkdir_p(build_chapter_folder) unless File.exist?(build_chapter_folder)
              chapter_story_path = build_chapter_folder + "/story.md"
              dobue_spaced_chapter_doc = chapter_doc.gsub(".\n", ".\n\n")
              File.open(chapter_story_path, 'w'){|f| f.write dobue_spaced_chapter_doc}
              @chapter_order += 1
            end
          end
  
        end
        update_part_titles if @part_titles.length > 0
    end
    
    def single_new_line2docunle_new_line(single_line_text)
      single_line_text.gub(".\n", ".\n\n")
    end
    
  end


end
