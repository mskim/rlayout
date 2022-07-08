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

  class BookParserMd

    def convert_txt2md
      @source  = filter_chapter_markers(@source)

      indices = @source.to_enum(:scan, /^\[[^\^].+\]/i).map do |some|
        Regexp.last_match.begin(0)
      end
      first_chunk = @source.slice(0, indices[0])
      parse_local_markup(first_chunk)
      source = filter_content(source)
      source
    end

    # parse local markup of book.txt
    # by parsing front part(first_chunk) of book.txt
    def parse_local_markup(first_chunk)
      first_chunk_line_array = first_chunk.split("\n")
      first_chunk_line_array.each do |line_string|
        if line_string.include?("->")
          local_markup_array = line_string.split("->")
          if local_markup_array[1].include?("각주")
            @footnote_markup = local_markup_array[0].gsub(" ","")
          elsif local_markup_array[1].include?("볼드")
            @h2_markup = local_markup_array[0].gsub(" ","")
          elsif local_markup_array[1].include?("오른쪽")
            @h3_markup = local_markup_array[0].gsub(" ","")
          elsif local_markup_array[1].include?("인용")
            @quote_markup = local_markup_array[0].gsub(" ","")
          end
        end
      end
    end

    def filter_content(content)
      # \r\n => \n\n, \n => \n\n, 
      # content = filter_double_newline(content)
      content = filter_chapter_markers(content)
      # footnote_marker
      content = filter_footnote(content) if @footnote_markup
      # gothic left align
      content = filter_h2(content) if @h2_marku
      # gothic quote left and right indent
      content = filter_h4(content) if @h3_markup
      # gothic quote left and right indent
      content = filter_quote(content) if @quote_markup
      content
    end

    # 10장 => [10장]
    # 제10장 => [제10장]
    # chapter_10 => [chapter_10]
    # Chapter_10 => [Chapter_10]
    def filter_chapter_markers(source)
      source = source.dup
      chapter_start_arrays  = source.scan(CHAPTER_START)
      chapter_start_arrays.each do |chapter_start|
        source.sub!(chapter_start)
      end
      source
    end

    def filter_footnote(content)
      content = content.dup
      matching_array = content.scan(/#{@footnote_markup}.*?#{@footnote_markup}/)
      matching_array.each_with_index do |matching_string, i|
        replacement = matching_string.match(/#{@footnote_markup}(.*?)#{@footnote_markup}/)        
        new_string = $1 + "[^#{i + 1}]"
        content.sub!(matching_string, new_string)
      end
      content
    end


    # @@ -> 주석
    # ## -> 인용 스타일
    # $$ -> 오른쪽 정렬
    # ^^ -> 고딕
    
    # @@text@@ -> text[^#{number}]
    # def convert_tech_media_footnote(text)
    #   text = text.dup
    #   # .*? is non-greedy version of .*
    #   # .* will parse upto end of string. 
    #   footnotes = text.scan(/@@.*?@@/)
    #   puts footnotes
    #   footnotes.each_with_index  do |footnote,i|
    #     new_string = footnote.gsub("@@", "")
    #     text.gsub!(footnote, "#{new_string}[^#{i + 1}]")
    #   end
    #   text
    # end

    def filter_quote(content)
      matching_array = content.scan(/#{@quote_markup}.*?#{@quote_markup}/)
      matching_array.each_with_index do |matching_string, i| 
        replacement = matching_string.match(/#{@quote_markup}(.*?)#{@quote_markup}/)
        new_string = "\n\n" + "> " +  $1 + "\n\n" 
        content.sub!(matching_string, new_string)
      end
      content
    end

    def filter_h2(content)
      matching_array = content.scan(/#{@h2_markup}.*?#{@h2_markup}/)
      matching_array.each_with_index do |matching_string, i| 
        replacement = matching_string.match(/#{@h2_markup}(.*?)#{@h2_markup}/)
        new_string = "\n\n" + "## " +  $1 + "\n\n" 
        content.sub!(matching_string, new_string)
      end
      content
    end

    def filter_h3(content)
      matching_array = content.scan(/#{@h3_markup}.*?#{@h3_markup}/)
      matching_array.each_with_index do |matching_string, i| 
        replacement = matching_string.match(/#{@h3_markup}(.*?)#{@h3_markup}/)
        new_string = "\n\n" + "### " +  $1 + "\n\n" 
        content.sub!(matching_string, new_string)
      end
      content
    end

    def filter_h4(content)
      matching_array = content.scan(/#{@h4_markup}.*?#{@h4_markup}/)
      matching_array.each_with_index do |matching_string, i| 
        replacement = matching_string.match(/#{@h4_markup}(.*?)#{@h4_markup}/)
        new_string = "\n\n" + "#### " +  $1 + "\n\n" 
        content.sub!(matching_string, new_string)
      end
      content
    end
    
    # def convert_tech_media_text(text)
    #   text = convert_tech_media_gotic(text)
    #   text = convert_tech_media_quoted(text)
    #   text = convert_tech_media_footnote(text)
    #   text
    # end

    # # ##text## -> ### text\n\n
    # def convert_tech_media_quoted(text)
    #   # .*? is non-greedy version of .*
    #   quotes = text.scan(/\^\^.*?\^\^/)
    #   quotes.each  do |quote|
    #     new_form = quote.gsub("##", "")
    #     text.gsub!(quote, "### #{new_form}\n\n")
    #   end
    #   text
    # end

    # # ^^text^^ -> ## text\n\n
    # def convert_tech_media_gotic(text)
    #   # .*? is non-greedy version of .*
    #   gothics = text.scan(/\^\^.*?\^\^/)
    #   gothics.each  do |gothic|
    #     new_form = gothic.gsub("^^", "")
    #     text.gsub!(gothic, "## #{new_form}\n\n")
    #   end  
    #   text
    # end

    def self.save_sample_book_txt(book_txt_path)
      File.open(book_txt_path, 'w'){|f| f.write self.sample_book_txt}
    end

    def self.sample_book_txt
      <<~EOF

      @@ -> 주석
      ## -> 인용 스타일
      $$ -> 오른쪽 정렬
      ^^ -> 고딕

      [book_info]
      ---
      paper_size: 125mmx188mm
      width: 125mm
      height: 188mm
      left_margin: 20mm
      top_margi: 14mm
      right_margin: 20mm
      bottom_margin: 25mm
      binding_margin: 3mm
      body_line_count: 23
      toc_page_count: 2
      title: 2022년에 책만들기
      subtitle: 새로운 솔류션을 이용하자
      author: 김민수
      
      [1p-대도비라]
      
      title: 2020년에 책만들기
      
      [2p-백]
      
      [3p-소도비라]
      
      title: 2020년에 책만들기
      author: 김민수
      
      [4p-백]
      
      [5p-차례]
      
      
      [7p- 서문] : 서문 
      
      
      [1장]: 지난 35년을 둘러보며
      
      
      여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 

      여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 

      여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 

      여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 

      여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 

      여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 여기에 내용물 입력. 


      [2장]: 앞으로 35년을 상상해 보며
    
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
