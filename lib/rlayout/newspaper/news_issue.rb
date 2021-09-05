module RLayout
  attr_reader :issue_path, :data
  attr_reader :publication_path, :publication_config_path

  class NewsIssue
    def initialize(options={})
      @issue_path = options[:issue_path]
      @publication_path = File.dirname(@issue_path) + "/config,yml"
      @page_size = options[:page_size] || 'A3'
      @page_count = options[:page_count]
      @sections = options[:sections] || default_sections
      self
    end

    def update_page_pdf
      pages_path = Dir.glob("#{@issue_path}/**").each do |page_path|
        h = {}
        h[:update_if_changed] = true
        h[:page_path] = page_path
        RLayout::NewsPage.new(h)
      end
    end
  end
end
