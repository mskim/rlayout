module RLayout

  class NewsPageHeading < Container
    attr_reader :width, :height, :date, :page_number, :section_name, :bg_image_path, :height_in_lines, :body_line_height
    attr_reader :heading_path
    def initialize(options={})
      @body_line_height = options.fetch(:body_line_height, 13)
      @height_in_lines  = options.fetch(:height_in_lines, 3)
      @date             = options[:date]
      @page_number      = options[:page_number]
      #code
      save_pdf_with_ruby()
      self
    end

    def save_pdf

    end
  end

end
