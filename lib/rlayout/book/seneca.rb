module RLayout


  # The goal of Seneca is to allow designers to create re-usable Seneca, 
  # Instead of manually creating layout using Illusgtrator, designers should be able to "code" the design
  # so that developers do not have to hard coded the layout.
  # Designers should be able to design the layout with content set and corresponding layout.erb.

  # To accomplish this, we have two files, one for layout(layout.erb) and one for content(content.yml), 
  # layout.erb and content.yml is saved in seneca project folder.
  # Designers should modify these two files to edit the layout.
  # layout.erb has layout information where and how the content should be placed.
  # These two files should have matching layout and hash keys.
  # These two files are merged and PDF, jpg files are produced.
  
  # steps
  # 1. process is triggered by calling Seneca.new(project_path)
  # 2. layout.erb is read 
  # 3. content is read.
  # 4. two are merged into layout object
  # 5. PDF is generated frim merged layout 

  class Seneca
    attr_reader :project_path, :content, :updated


    def initialize(options={})
      @content = options[:content]
      @project_path = options[:project_path]
      @width = options[:width] || 500
      @height = options[:height] || 20
      save_sample unless File.exist?(layout_erb_path)
      generate_pdf
      self
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

    def generate_pdf
      @updated = false
      @content = YAML::load_file(content_path)
      template = File.open(layout_erb_path,'r'){|f| f.read }
      erb = ERB.new(template)
      mergerd = erb.result(binding)

      # check if  layout.rb file exists,
      # if so use it to generate pdf.
      # if not merge data and layout.erb and save new layout.rb file
      if File.exist?(layout_path)
        mergerd = File.open(layout_path,'r'){|f| f.read}
        layout = eval(mergerd)
      else
        layout = eval(mergerd)
        File.open(layout_path,'w'){|f| f.write mergerd }
      end
      return unless is_dirty?
      layout.save_pdf_with_ruby(output_path, jpg:true)
      @updated = true
    end

    def is_dirty?
      return true unless File.exist?(output_path)
      return true if File.mtime(content_path) > File.mtime(output_path)
      return true if File.mtime(layout_path) > File.mtime(output_path)
      return false
    end

    def default_layout_erb
      # before rotating 90 
      layout =<<~EOF
      RLayout::Container.new(fill_color:'clear', width:#{@width}, height:#{@height}, layout_direction: 'horizontal') do
        text("<%= @content[:title] %>", font_size: 16, layout_length:2, fill_color: 'yellow')
        text("<%= @content[:subtitle] %>", font_size: 10 , layout_length:2)
        text("<%= @content[:author] %>", font_size: 12)
        text("<%= @content[:publisher] %>", font_size: 9)
      end

      EOF
    end

    def default_content
      h = {}
      h[:title] = "소설을 쓰고 있네"
      h[:subtitle] = "정말로 소설을 쓰고 있네 그려"
      h[:author] = "홍길동"
      h[:publisher] = "활빈당출판"
      h
    end

    # generate layout from erb
    def save_layout_erb

    end

    def save_sample
      FileUtils.mkdir_p(@project_path) unless File.exist?(@project_path)
      File.open(layout_erb_path, 'w'){|f| f.write default_layout_erb}
      File.open(content_path, 'w'){|f| f.write default_content.to_yaml}
    end

    def self.sample_layout
      layout =<<~EOF
      RLayout::Container.new(fill_color:'clear',width:500, height:20, direction: 'horizontal') do
        text("소설을 쓰고 있네", font_size: 12)
        text("정말로 소설을 쓰고 있네", font_size: 12)
        text("홍길동", font_size: 12)
        text("활빈당출판", font_size: 12)
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