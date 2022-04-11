module RLayout

  class NewsPublication

    attr_reader :project_path, :name, :publication_path
    attr_reader :paper_size, :period, :page_count

    def initialize(options={})
      @project_path = options[:project_path]
      @name = options[:name]
      @paper_size = options[:paper_size] || A2
      @period = options[:period] || 'weekly' # daily, monthly weekly, sesonal, yearly
      @page_count = options[:page_count] || 4
      load_text_styles
      load_layout
      create_news_project
      self
    end

    def create_news_project
      @publication_path = @project_path + "/#{slug}"
      FileUtils.mkdir_p(@publication_path) unless File.exist?(@publication_path)
    end

    def publication_path
    end

    def slug
      @name.gsub(" ", "_")
    end

    def load_text_styles

    end
    
    def load_layout

    end

    def default_text_style

    end

    def default_layout_rb
      
    end
  end



end