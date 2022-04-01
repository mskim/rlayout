module RLayout


  # The goal of BackWing is to allow designers to create re-usable BackWing, 
  # Instead of manually creating layout using Illusgtrator, designers should be able to "code" the design
  # so that developers do not have to hard coded the layout.
  # Designers should be able to design the layout with content set and corresponding layout.erb.

  # To accomplish this, we have two files, one for layout(layout.rb) and one for content(content.md), 
  # layout.rb and content.md is saved in BackWing project folder.
  # Designers should modify these two files to edit the layout.
  # layout.rb has layout information where and how the content should be placed.
  # content.md has text that goes in BackWing. It should be written in markdown format.
  # These two files are processed and PDF, jpg files are produced.
  
  # steps
  # 1. process is triggered by calling BackWing.new(project_path)
  # 2. layout.rb is read.
  # 3. content.md is read.
  # 4. contents  are layed-out.
  # 5. PDF,jpg is generated from layed-out 

  class BackWing
    attr_reader :project_path, :column, :content
    attr_reader :width, :height, :updated
    def initialize(options={})
      @project_path = options[:project_path]
      FileUtils.mkdir_p(@project_path) unless File.exist?(@project_path)
      @width = options[:width] || 225
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

    def content_path
      @project_path + "/content.md"
    end

    def source_cover_path
      File.dirname(@project_path)
    end

    def generate_pdf
      @updated = false
      if File.exist?(content_path)
      else
        File.open(content_path,'w'){|f| f.write default_content }
      end
      if File.exist?(layout_path)
        layout_text = File.open(layout_path,'r'){|f| f.read}
        @column = eval(layout_text)
      else
        File.open(layout_path,'w'){|f| f.write default_layout }
        @column = eval(default_layout)
      end

      return unless is_dirty?
      read_content
      layout_content
      # h = {parent:@column, x:0, y:0, width:10, height:10, fill_color:'red'}
      # RLayout::Rectangle.new(h)
      # h = {parent:@column, from_right:0, width:10, height:10, fill_color:'red'}
      # RLayout::Rectangle.new(h)
      @column.save_pdf(output_path, jpg:true)
      @updated = true
    end

    def is_dirty?
      return true unless File.exist?(output_path)
      return true if File.mtime(content_path) > File.mtime(output_path)
      return true if File.mtime(layout_path) > File.mtime(output_path)
      return false
    end

    def read_content

      @story  = Story.new(content_path).markdown2para_data
      @heading = @story[:heading] || {}
      @paragraphs =[]
      @story[:paragraphs].each do |para|
        para_options = {}
        para_options[:markup]         = para[:markup]
        para_options[:layout_expand]  = [:width]
        para_options[:para_string]    = para[:para_string]
        # para_options[:text_fit]       = FIT_FONT_SIZE
        para_options[:line_width]     = @column.column_width  if para_options[:create_para_lines]
        @paragraphs << RParagraph.new(para_options)
      end
    end
  
    def layout_content
      flowing_items = @paragraphs.dup
      current_line = @column.graphics.first
      while @item = flowing_items.shift do
        current_line = @item.layout_lines(current_line)
      end
      if  current_line
        @current_column  = current_line.column
      end
    end

    def default_layout
      layout =<<~EOF
      RLayout::RColumn.new(width:#{@width}, height:#{@height}, top_inset: 5, left_inset: 5, right_inset: 10, body_line_height: 16) do
      end

      EOF
    end

    def default_content
      h =<<~EOF
      <br>

      ## 홍길동의 전설

      <br>

      여기는 홍길동의 전설에 대한 이야기 입니다.  여기는 홍길동의 전설에 대한 이야기 입니다.  여기는 홍길동의 전설에 대한 이야기 입니다.  
      여기는 홍길동의 전설에 대한 이야기 입니다.  여기는 홍길동의 전설에 대한 이야기 입니다.  여기는 홍길동의 전설에 대한 이야기 입니다.  
      여기는 홍길동의 전설에 대한 이야기 입니다.  여기는 홍길동의 전설에 대한 이야기 입니다.  여기는 홍길동의 전설에 대한 이야기 입니다.  
      여기는 홍길동의 전설에 대한 이야기 입니다.  여기는 홍길동의 전설에 대한 이야기 입니다.  여기는 홍길동의 전설에 대한 이야기 입니다.  
      
      여기는 홍길동의 전설에 대한 이야기 입니다.  여기는 홍길동의 전설에 대한 이야기 입니다.  여기는 홍길동의 전설에 대한 이야기 입니다.  
      여기는 홍길동의 전설에 대한 이야기 입니다.  여기는 홍길동의 전설에 대한 이야기 입니다.  여기는 홍길동의 전설에 대한 이야기 입니다.  
      여기는 홍길동의 전설에 대한 이야기 입니다.  여기는 홍길동의 전설에 대한 이야기 입니다.  여기는 홍길동의 전설에 대한 이야기 입니다.  
      여기는 홍길동의 전설에 대한 이야기 입니다.  여기는 홍길동의 전설에 대한 이야기 입니다.  여기는 홍길동의 전설에 대한 이야기 입니다.  
      
      EOF
    end
  end

end