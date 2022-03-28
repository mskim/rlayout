module RLayout
  class HtmlDoc

    attr_reader :document_path, :html_path
    attr_reader :front_matter_mds, :body_matter_mds

    def initialize(document_path, options={})
      @document_path = document_path
      @html_path = options[:html_path]
      convert_to_html
      self
    end

    def convert_to_html
      html = Kramedown::html.new(@document_path)
      File.open(@html_path, 'w'){|f| f.write html}
    end


  end


end