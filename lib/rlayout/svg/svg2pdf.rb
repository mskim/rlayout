module RLayout
  class Svg2pdf
    attr_accessor :yml_path, :svg_path, :svg_directory_path, :svg_directory_path, :output_directory_path, :output_file_path

    def initialize(options={})
      @yml_path = options[:yml_path]
      @svg_path = options[:svg_path]
      @svg_directory_path = options[:svg_directory_path]
      if @yml_path
        convert_yml_path(@yml_path)

      elsif @svg_path
        convert_svg_path(@svg_path)
      elsif @svg_directory_path
        convert_svg_directory(@svg_directory_path)
      end

      self
    end

    def convert_yml_path
      svg = RLayout::Canvas.from_yml(yml_path)

    end

    def convert_svg_path(svg_path)
      svg = RLayout::Canvas.from_svg(svg_path)
    end

    def convert_svg_directory(svg_directory_path)
      puts __method__
    end

  end
end
