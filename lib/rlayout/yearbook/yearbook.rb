module RLayout
  class Yearbook
    attr_reader :category, :school, :year, :project_path
    attr_reader :template_path, :page_size

    def initialize(options={})
      @project_path  = options[:project_path]
      @category      = options[:category]
      @template_path = template_path_for_category(@category)
      @page_size     = options[:page_size] || "A4"
      layout_pages
      self
    end

    def template_path_for_category(category)
      @project_path + "/#{category}"
    end

    def layout_pages

      
    end
  end
  

end