
module RLayout
  
  class MagazineArticle < Chapter
    attr_accessor :story_path
    def initialize(options={})
      super  
      @chapter_kind = "news_article"
      self
    end    
  end
  
end

