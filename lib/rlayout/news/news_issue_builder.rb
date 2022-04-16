module RLayout

  class NewsIssueBuilder

    attr_reader :publication_path, :date
    def initialize(options={})
      @publication_path  = options[:publication_path]
      @date = options[:date]
      build_issue_pages
      self
    end

    def build_issue_pages
      Dir.glob("#{@publication_path}/#{@date}_*.md").each do |page_md|
        RLayout::NewsPageParser.new(page_md)
        date_folder = page_md.gsub(/(\d\d).md$/, "")
        page_build_path = date_folder + "/#{$1}"
        RLayout::NewsPageBuilder.new(page_build_path)
      end
    end
  end
end