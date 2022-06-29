module RLayout
  # Page that starts the book.
  # With Title, author, publisher, logo
  # Replica of front cover image
  
  # class InsideCover < StyleableDoc
  class InsideCover
    include Styleable
    attr_reader :cover_image_path
    attr_reader :document_path
    attr_reader :width, :height, :left_margin, :top_margin, :right_margin, :bottom_margin
    
    def initialize(options={} ,&block)
      @document_path = options[:document_path]
      @style_guide_folder = options[:style_guide_folder] || @document_path
      @output_path = @document_path + "/output.pdf"
      @starting_page_number = options[:starting_page_number] || 1
      @page_pdf = options[:page_pdf] || true
      @width = options[:width]
      @height = options[:height]
      @left_margin = options[:left_margin]
      @top_margin = options[:top_margin] 
      @right_margin = options[:right_margin]
      @bottom_margin = options[:bottom_margin]
      # use image that was created for BookCover front_page image
      @front_page_pdf = options[:front_page_pdf]
      @jpg = options[:jpg] || false
      load_text_style
      load_layout_rb
      load_document
      @document.add_image(@front_page_pdf)
      @document.save_pdf(@output_path, page_pdf:@page_pdf, jpg:@jpg)
      self
    end

    def page_count
      if @starting_page_number.even?
        2
      else
        1
      end
    end

    def default_layout_r
      doc_options= {}
      doc_options[:paper_size] = @paper_size
      doc_options[:width] = @width
      doc_options[:height] = @height
      doc_options[:left_margin] = @left_margin
      doc_options[:top_margin] = @top_margin
      doc_options[:right_margin] = @right_margin
      doc_options[:bottom_margin] = @bottom_margin
      layout =<<~EOF
        RLayout::CoverPage.new(#{doc_options})
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