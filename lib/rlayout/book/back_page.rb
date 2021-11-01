module RLayout

  class BackPage
    attr_reader :project_path, :content
    attr_reader :width, :height, :updated
    def initialize(options={})
      @content = options[:content]
      @project_path = options[:project_path]
      @page_size = options[:page_size] || 'A5'
      @width = SIZES[@page_size][0]
      @height = SIZES[@page_size][1]
      @spread_image_path = options[:spread_image_path]
      @cover_spread_width = options[:cover_spread_width]
      generate_pdf
      self
    end

    def generate_pdf
      @updated = false
      # check if  layout.rb file exists,
      # if so use it to generate pdf.
      # if not merge data and layout.erb and save new layout.rb file
      if File.exist?(layout_path)
        mergerd = File.open(layout_path,'r'){|f| f.read}
        layout = eval(mergerd)
      else
        FileUtils.mkdir_p(@project_path) unless File.exist?(@project_path)
        erb = ERB.new(default_layout_erb)
        @content = default_content
        mergerd = erb.result(binding)
        layout = eval(mergerd)
        File.open(layout_path,'w'){|f| f.write mergerd }
      end
      # return unless is_dirty?
      layout.save_pdf_with_ruby(output_path, jpg:true)
      @updated = true
    end

    def is_dirty?
      return true unless File.exist?(output_path)
      return true if File.mtime(layout_path) > File.mtime(output_path)
      return false
    end

    def default_layout_erb
      # before rotating 90 
      layout =<<~EOF
      RLayout::Container.new(width:#{@width}, height:#{@height}, fill_color: 'clear') do
        image(image_path: "#{@spread_image_path}", x: 0, width: #{@cover_spread_width}, height:#{@height}, layout_member:false)
      end

      EOF
    end


    def layout_path
      @project_path + "/layout.rb"
    end

    def layout_erb_path
      @project_path + "/layout.erb"
    end

    def output_path
      @project_path + "/output.pdf"
    end

    def content_path
      project_path + "/content.yml"
    end

    def default_content
      h = {}
      h[:title] = "소설을 쓰고 있네"
      h[:subtitle] = "정말로 소설을 쓰고 있네 그려"
      h[:author] = "홍길동"
      h[:publisher] = "활빈당출판"
      h
    end

    def self.sample_layout
      layout =<<~EOF
      RLayout::Container.new(fill_color:'clear',width:500, height:20, direction: 'horizontal') do

      end
      EOF
    end

    def self.default_content
      h = {}
      h[:title] = "소설을 쓰고 있네"
      h[:subtitle] = "정말로 소설을 쓰고 있네 그려"
      h[:author] = "홍길동"
      h[:publisher] = "활빈당출판"
      h
    end

    def self.save_sample(project_path)
      layout_path = project_path + "/layout.rb"
      content_path = project_path + "/content.yml"
      File.open(layout_path, 'w'){|f| f.write Senca.default_layout}
      File.open(content_path, 'w'){|f| f.write Senca.default_content.to_yaml}
    end
  end

end