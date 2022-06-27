module RLayout

  class BlankPage < StyleableDoc
    attr_reader :page_count, :document_path
    def initialize(options={})
      @page_count = options[:page_count] || 1
      @page_pdf = options[:page_pdf] || true
      super
      @output_path = @document_path + "/output.pdf"
      @document.save_pdf(@output_path, page_pdf:@page_pdf)
    end

    def docum_path
      @document_path + "/output.pdf"
    end
  end



end