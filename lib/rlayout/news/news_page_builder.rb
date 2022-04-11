module RLayout
  # NewsPageBuilder
  # NewsPageBuilder processes given page folder.
  # Page folder can have multiple pillars or single pillar.
  # pillar_01
  #   article_01
  #   article_02
  # pillar_02
  #   article_01
  #   article_02


  class NewsPageBuilder
    attr_reader :project_path, :pillars, :articles

    def initialize(options={})
      @project_path = options[:project_path]
      @pillars = Dir.glob("#{@project_path}/pillar_*")
      if pillars.length > 0
        process_pillars_in_folder
      else
        process_articles_in_folder
      end      
      self
    end

    # page has mutilpe pillars
    def process_pillars_in_folder
      
    end

    # page has single pillar
    def process_articles_in_folder
      @articles = Dir.glob("#{@project_path}/pillar_*")

    end

  end



end