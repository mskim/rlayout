module RLayout
  
  class BoxArticle < Container
    attr_reader :column, :row
    attr_reader :article_type #story, table, list
    
    def initialize(options={})

      self
    end
  end



end