
module RLayout
    class Canvas
      attr_accessor :svg_string, :svg_hash

      def self.from_yml(yml_path, options={})
        @yml_path       = yml_path
        @svg_hash = YAML::load(File.open(@yml_path, 'r'){|f| f.read})
        Container.new(svg_graphics: @svg_hash)
      end

      def self.from_svg(yml_path, options={})
        @yml_path       = yml_path
        if options[:svg_string]
          @svg_string = options[:svg_string]
        elsif @yml_path && File.exist?(@yml_path)
          @svg_string = File.open(@yml_path, 'r'){|f| f.read}
        else
          puts "no svg string given!!!"
          return
        end
        @svg_hash = YAML::load(File.open(@yml_path, 'r'){|f| f.read})
        Container.new(svg_graphics: @svg_hash)
      end

    end

    class Graphic
      attr_reader :text_content, :attributes, :styles
      def self.from_svg(options={})
        @text_content   = options.delete('content')
        @attributes     = options
        @styles         = options
        # puts "class:#{self.class}"
        self
      end

      def style_to_svg
        style_string = ""
        return style_string unless @styles
        @styles.each do |key, value|
          style_string += "#{key}:#{value};"
        end
        style_string
      end

    end

end
