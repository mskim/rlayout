module RLayout
  # Page that starts the book.
  # With Title, author, publisher, logo
  # Replica of front cover image
  
  class InsideCover < Chapter
    attr_reader :project_path, :document_path, :cover_image_path, :starting_page_number
    # def initialize(options={})
    #   @starting_page_number = options[:starting_page_number]
    #   @front_page_pdf = options[:front_page_pdf]
    #   #TODO : get it from @document_path
    #   @cover_image_path = options[:cover_image_path]
    #   if @starting_page_number.even?
    #     @page_count = 2
    #   else
    #     @page_count = 1
    #   end
    #   super
    #   page = @document.pages.last
    #   page.add_image(@front_page_pdf)
    #   self
    # end

    
    def initialize(options={} ,&block)
      @document_path  = options[:document_path]
      @front_page_pdf = options[:front_page_pdf]

      if options[:book_info]
        @book_info      = options[:book_info]
        @paper_size     = @book_info[:paper_size] || "A5"
      else
        @paper_size     = options[:paper_size] || "A5"
      end
      @story_path     = @document_path + "/story.md"
      @output_path    = options[:output_path] || @document_path + "/chapter.pdf"
      @story_md       = options[:story_md]
      @layout_rb      = options[:layout_rb]
      @has_footer    =  options[:has_footer] || true
      @has_header    =  options[:has_header] || false
      @layout_rb = default_document_layout
      @starting_page_number  = options[:starting_page_number] || 1
      @page_pdf       = options[:page_pdf]
      @document       = eval(@layout_rb)
      if @document.is_a?(SyntaxError)
        puts "SyntaxError in #{@document} !!!!"
        return
      end
      unless @document.kind_of?(RLayout::RDocument)
        puts "Not a @document kind created !!!"
        return
      end
      @document.document_path = @document_path
      @document.starting_page_number = @starting_page_number
      page = @document.pages.last
      page.add_image(@front_page_pdf)
      @document.save_pdf(@output_path, page_pdf:@page_pdf) unless options[:no_output]
      @document.save_svg(@document_path) if @svg
      self
    end


    def default_document_layout
      @top_margin = 50
      @left_margin = 50
      @right_margin = 50
      @bottom_margin = 50
      doc_options= {}
      doc_options[:paper_size] = @paper_size
      doc_options[:left_margin] = @left_margin
      doc_options[:top_margin] = @top_margin
      doc_options[:right_margin] = @right_margin
      doc_options[:bottom_margin] = @bottom_margin
      layout =<<~EOF
        RLayout::RDocument.new(#{doc_options})
      EOF
    end

    def self.sample_story
      <<~EOF
      ---
      layout: inside_cover
      title: 이글을 홍길동님에게 바침지다
      ---

      여기는 프로로그 본문입니다. 여기는 프로로그 본문입니다. 여기는 프로로그 본문입니다. 여기는 프로로그 본문입니다. 여기는 프로로그 본문입니다. 
      여기는 프로로그 본문입니다. 여기는 프로로그 본문입니다. 여기는 프로로그 본문입니다. 여기는 프로로그 본문입니다. 여기는 프로로그 본문입니다. 
      여기는 프로로그 본문입니다. 여기는 프로로그 본문입니다. 여기는 프로로그 본문입니다. 여기는 프로로그 본문입니다. 여기는 프로로그 본문입니다. 
      여기는 프로로그 본문입니다. 여기는 프로로그 본문입니다. 여기는 프로로그 본문입니다. 여기는 프로로그 본문입니다. 여기는 프로로그 본문입니다. 
      여기는 프로로그 본문입니다. 여기는 프로로그 본문입니다. 여기는 프로로그 본문입니다. 여기는 프로로그 본문입니다. 여기는 프로로그 본문입니다. 
      여기는 프로로그 본문입니다. 여기는 프로로그 본문입니다. 여기는 프로로그 본문입니다. 여기는 프로로그 본문입니다. 여기는 프로로그 본문입니다. 

      EOF
    end
  end

end