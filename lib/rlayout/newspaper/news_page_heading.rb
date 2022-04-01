module RLayout

  class NewsPageHeading < Container
    attr_reader :width, :height, :date, :page_number, :section_name, :bg_image_path, :height_in_lines, :body_line_height
    attr_reader :heading_path
    def initialize(options={})
      @heading_path     = options[:heading_path]
      heading_layout    = layout
      output_path       = @heading_path + "/ouput.pdf"
      heading_layout.save_pdf(output_path: output_path)
      self
    end

    def heading_erb_path
      @heading_path + "/layout.erb"
    end

    def heading_yaml_path
      @heading_path + "/heading.yml"
    end

    def layout
      @body_line_height = heading_data[:body_line_height] || 13
      @height_in_lines  = heading_data[:height_in_lines] || 3
      @date             = heading_data[:date]
      @page_number      = heading_data[:page_number]
      template = File.open(heading_erb_path, 'r'){|f| f.read}
      erb = ERB.new(template)
      heading = erb.result(binding)
      eval(heading)
    end
  end

end
