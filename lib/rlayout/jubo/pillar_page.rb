module RLayout

  # PillarPage
  # BoxArticles flow as vertival direction
  class PillarPage
    include Styleable
    def initialize(options={})

      
      self
    end

    def default_layout_rb
      s =<<~EOF
      RLayout::ServicePage.new(width: #{@width}, height: #{@height})
        
      EOF
    end

    # def default_text_style
    #   s =<<~EOF
    #   ---


    #   EOF
    # end

  end



end