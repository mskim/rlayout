module RLayout
  # Page that starts the book.
  # With Title, author, publisher, logo
  # Replica of front cover image
  
  # class InsideCover < StyleableDoc
  class InsideCover < StyleablePage
      attr_reader :cover_image_path
    
    def initialize(options={} ,&block)
      @starting_page_number = options[:starting_page_number] || 1
      @page_pdf = options[:page_pdf] || true
      super
      @front_page_pdf = options[:front_page_pdf]
      page = @document.pages.last
      page.add_image(@front_page_pdf)
      @document.save_pdf(@output_path, page_pdf:@page_pdf)
      self
    end

    def page_count
      if @starting_page_number.even?
        2
      else
        1
      end
    end

    def default_layout_rb
      @top_margin = 50
      @left_margin = 50
      @right_margin = 50
      @bottom_margin = 50
      doc_options= {}
      doc_options[:paper_size] = @paper_size
      doc_options[:width] = @width
      doc_options[:height] = @height
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