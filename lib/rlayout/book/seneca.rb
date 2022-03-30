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
  # 1. process is triggered by calling Seneca.new(document_path)
  # 2. layout.erb is read 
  # 3. content is read.
  # 4. two are merged into layout object
  # 5. PDF is generated frim merged layout 

  class Seneca < StyleableDoc
    attr_reader :content, :updated

    def initialize(options={}, &block)
      @document_path = options[:document_path]
      if File.exist?(content_path)
        @content = YAML::load_file(content_path)
      else
        @content = default_content
        File.open(content_path, 'w'){|f| f.write default_content}
      end
      super
      @width = options[:width] || 500
      @height = options[:height] || 20
      @document.save_pdf(output_path, jpg:true)
      self
    end

    # def layout_path
    #   @document_path + "/layout.rb"
    # end

    # def layout_erb_path
    #   @document_path + "/layout.erb"
    # end

    def output_path
      @document_path + "/output.pdf"
    end

    def content_path
      document_path + "/content.yml"
    end
    
    def default_layout_rb
      # before rotating 90 
      # TODO: change  it  to 
      #  title('#{@content[:title]}')
      #  subtitle('#{@content[:subtitle]}')
      #  author('#{@content[:author]}')
      #  publisher('#{@content[:author]}')
      layout =<<~EOF
      RLayout::Container.new(fill_color:'clear', width:#{@width}, height:#{@height}, layout_direction: 'horizontal') do
        text('#{@content[:title]}', font_size: 16, text_alignment: 'center', layout_length:2, fill_color: 'white')
        text('#{@content[:subtitle] }', font_size: 10, text_alignment: 'center', layout_length:2)
        text('#{@content[:author] }', font_size: 12)
        text('#{@content[:publisher] }', font_size: 9)
        relayout!
      end

      EOF
    end

    def default_text_style
      s=<<~EOF
      ---
      body:
        font: Shinmoon
        font_size: 11.0
        text_alignment: justify
        first_line_indent: 11.0
      body_gothic:
        font: KoPubBatangPM
        font_size: 11.0
        text_alignment: justify
        first_line_indent: 11.0
      title:
        font: KoPubBatangPB
        font_size: 16.0
        text_alignment: left
        text_line_spacing: 10
        space_before: 0
      subtitle:
        font: KoPubDotumPL
        font_size: 12.0
        text_color: 'DarkGray'
        text_alignment: center
        text_line_spacing: 5
        space_after: 30
      author:
        font: KoPubDotumPL
        font_size: 10.0
        text_color: 'DarkGray'
        text_alignment: center
        text_line_spacing: 5
        space_after: 30

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

    def save_sample
      FileUtils.mkdir_p(@document_path) unless File.exist?(@document_path)
      File.open(layout_erb_path, 'w'){|f| f.write default_layout_rb}
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

  end

end