
# MagazineArticle
# given rlatyout_path
# template latyou.rb
# style.rb
# contenet.md
# images folder

module RLayout

  class MagazineArticle < Chapter
    def initialize(options={}, &block)
      options[:page_count]        = 1
      style_service               = RLayout::StyleService.shared_style_service
      style_service.current_style = MAGAZINE_STYLES
      @current_style              = MAGAZINE_STYLES
      super
      
      self
    end
  end

  def current_style
    MAGAZINE_STYLES
  end

end
