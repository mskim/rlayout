module RLayout

  # PillarPage
  # BoxArticles flow as vertival direction
  class PillarPage < StyleableDoc

    def initialize(options={})
      super
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