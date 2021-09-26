module RLayout


  class CoverSpread
    attr_reader :project_path, :spread, :art_type # band, #image, #random_art
    attr_reader :width, :height, :updated
    def initialize(options={})
      @project_path = options[:project_path]
      FileUtils.mkdir_p(@project_path) unless File.exist?(@project_path)
      @width = options[:width] || 1100
      @height = options[:height] || 400
      generate_pdf
      self
    end
    
    def layout_path
      @project_path + "/layout.rb"
    end

    def output_path
      @project_path + "/output.pdf"
    end

    def generate_pdf
      @update = false
      if File.exist?(layout_path)
        layout_text = File.open(layout_path,'r'){|f| f.read}
        @spread = eval(layout_text)
      else
        File.open(layout_path,'w'){|f| f.write default_layout }
        @spread = eval(default_layout)
      end
      return unless is_dirty?
      @spread.save_pdf_with_ruby(output_path, jpg:true)
      @updated = true
    end

    def is_dirty?
      return true unless File.exist?(output_path)
      return true if File.mtime(layout_path) > File.mtime(output_path)
      return false
    end

    def default_layout
      # before rotating 90 
      layout =<<~EOF
      RLayout::Container.new(width:#{@width}, height:#{@height}) do
        rect(fill_color: 'yellow', layout_length: 2)
        rect(fill_color: 'gray', layout_length: 1)
        relayout!
      end

      EOF
    end

  end

end