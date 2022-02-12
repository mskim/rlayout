
module RLayout
  class WingBookPromotion < Container
    attr_reader :publisher, :items
    def initialize(options={})
      super



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