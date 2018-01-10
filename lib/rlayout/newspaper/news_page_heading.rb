module RLayout

  class NewsPageHeading < Container
    attr_accessor :date, :section_name, :bg_image_path, :height_in_lines, :body_line_height

    def initialize(options={})
      @body_line_height = options.fetch(:body_line_height, 13)
      @height_in_lines  = options.fetch(:height_in_lines, 3)
      @date             = options[:date]
      @page_number      = options[:page_number]
      #code

      self
    end

  end

end
