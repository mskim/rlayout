module RLayout

  # PillarPage
  # BoxArticles flow as vertival direction

  # RowPage
  # BoxArticles flow as horizontal direction

  class RowPage
    attr_reader :level_count, :story_count
    
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