
module RLayout
  class WingBookPromotion
    attr_reader :publisher, :items
    attr_reader :document_path, :info_text, :isbn_text
    attr_reader :width, :height, :left_margin, :top_margin, :right_margin, :bottom_margin
    
    include Styleable
    
    def initialize(options={})
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
      @jpg = options[:jpg] || false
      load_style
      @document.save_pdf(@output_path, jpg: @jpg)
      self

      self
    end

    def default_content
      =<<~EOF
      ---
      title: 죽전출판 신간들
      
      ---

      # 사람 사는 세상

      ![사람사는_세상](사람사는세상.jpg)

      ## 사람들 살아가는 이야기를

      ### 김상욱저   i

      홍길동 최고의 걸작, 이시대의 걸작소설




      # 홍길동의 인생

      ![홍길동의 인생](홍길동.jpg)

      ## 사람들 살아가는 이야생를

      ### 김상욱저   i

      홍길동 최고의 걸작, 이시대의 걸작소설



      # 임꺽정의 인생

      ![임꺽정의 인생](임꺽정.jpg)

      ## 사람들 살아가는 이야생를

      ### 김상욱저   i

      홍길동 최고의 걸작, 이시대의 걸작소설




      EOF






    end
    
  end

  class BookPromotionItem < Container
    def initialize(options={})
      

      self
    end
    
  end

end