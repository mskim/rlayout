module RLayout

  class FrontPage
    attr_reader :project_path, :content
    attr_reader :width, :height, :updated
    def initialize(options={})
      @content = options[:content] || default_content
      @project_path = options[:project_path]
      @paper_size = options[:paper_size] || 'A5'
      @width = SIZES[@paper_size][0] 
      @height = SIZES[@paper_size][1]
      @width = options[:width] if  options[:width]
      @height = options[:height] if  options[:height]
      @updated = false
      @spread_image_path = options[:spread_image_path]
      @front_page_spread_off_set = options[:front_page_spread_off_set]
      @cover_spread_width = options[:cover_spread_width]
      generate_pdf
      self
    end

    def generate_pdf
      FileUtils.mkdir_p(@project_path) unless File.exist?(@project_path)
      erb = ERB.new(layout_erb)
      mergerd = erb.result(binding)
      layout = eval(mergerd)
      File.open(layout_path,'w'){|f| f.write mergerd }
      layout.save_pdf_with_ruby(output_path, jpg:true)
      @updated = true
    end

    def is_dirty?
      return true unless File.exist?(output_path)
      return true if File.mtime(layout_path) > File.mtime(output_path)
      return false
    end



    def layout_erb
      # before rotating 90 
      # @content = eval(content)
      layout =<<~EOF
      RLayout::Container.new(fill_color:'clear', width:#{@width}, height:#{@height}) do
        image(image_path: "#{@spread_image_path}", x: #{-@front_page_spread_off_set}, width: #{@cover_spread_width}, height:#{@height}, layout_member:false)
        container(fill_color:'clear',layout_length:5) do
          filler(layout_length:10)        
          text("<%= @content[:title] %>",font:'KoPubDotumPB', font_size: 40, text_alignment:'center', layout_length:8, font_color: 'black', fill_color: 'clear', text_fit_type:'adjust_box_height')
          filler(layout_length:2)        
          text("<%= @content[:subtitle] %>", font:'KoPubDotumPM', font_size: 26 , text_alignment:'center', layout_length:5, fill_color: 'clear', text_fit_type:'adjust_box_height')
          filler(layout_length:2)        
          text("<%= @content[:author] %>", font:'KoPubBatangPB', font_size: 20, text_alignment:'center', fill_color: 'clear')
          filler(layout_length:40)        
          filler(layout_length:2)        
        end
        container fill_color:'clear' do
          text("<%= @content[:publisher] %>", font:'KoPubBatangPB',font_size: 16, text_alignment:'center', fill_color: 'clear')
        end
        relayout!
      end
  
      EOF
    end
  
    def layout_path
      @project_path + "/layout.rb"
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

    # def gothic_16_red
    #   {font:GOTHIC, font_size: 16, font_color: 'red'}
    # end

    def self.sample_layout
      layout =<<~EOF
      RLayout::Container.new(fill_color:'clear',width:500, height:20) do
        text("소설을 쓰고 있네", font_size: 40)
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