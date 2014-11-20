
module RLayout
  
  class MagazineArticle < Chapter
    def initialize(options={})
      options[:chapter_kind] = "magazine_article"
      options[:page_count] = 1
      super  
      self
    end        
  end
  
end