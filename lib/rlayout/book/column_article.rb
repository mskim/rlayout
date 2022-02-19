# super class of
# WingAuthor, WingBookPromo, WingArticle
# A single column text or item

module RLayout
  class ColumnArticle
    attr_reader :document_path
    attr_reader :width, :height, :left_margin, :top_margin, :right_margin,  :bottom_margin
    attr_reader :custom_style, :column
    attr_reader :save_rakefile

    include Styleable

    def initialize(document_path, options={})
      @document_path = document_path
      @paper_size = options[:paper_size] || 'A4'
      @width = options[:width] || SIZES[@paper_size][0]
      @height = options[:height] || SIZES[@paper_size][1]
      @left_margin  = options[:left_margin] || 30
      @top_margin  = options[:top_margin] || 30
      @right_margin  = options[:right_margin] || 30
      @bottom_margin  = options[:bottom_margin] || 30
      @custom_style = options[:custom_style]
      @save_rakefile = options[:save_rakefile]
      if File.exist?(story_path)
      else
        File.open(story_path,'w'){|f| f.write default_story }
      end
      if File.exist?(layout_path)
        layout_text = File.open(layout_path,'r'){|f| f.read}
        @column = eval(layout_text)
      else
        File.open(layout_path,'w'){|f| f.write default_layout }
        @column = eval(default_layout)
        # TODO check for valid evaled object!!!
      end
      load_text_style
      read_story
      layout_story
      @column.save_pdf(pdf_path)
      save_text_style if @custom_style
      save_rakefile if @save_rakefile
      self
    end

    def layout_path
      @document_path + "/layout.rb"
    end

    def output_path
      @document_path + "/output.pdf"
    end

    def story_path
      @document_path + "/story.md"
    end

    #  use custom_style if @book_info[:custome_sylte] is true
    # def load_text_style
    #   if @custom_style
    #     if File.exist?(text_style_path)
    #       RLayout::StyleService.shared_style_service.current_style = YAML::load_file(text_style_path)
    #     else
    #       text_style_hash  = StyleService.shared_style_service.set_book_style("paperback","#{@paper_size}")
    #       FileUtils.mkdir_p(style_folder) unless File.exist?(style_folder)
    #       File.open(text_style_path, 'w'){|f| f.write text_style_hash.to_yaml}
    #     end
    #   end
    # end

    def read_story
      @story  = Story.new(story_path).markdown2para_data
      @heading = @story[:heading] || {}
      if @heading != {}
        @heading[:parent] = @column
        @heading[:x]      = @column.left_inset # left_margin + binding_margin
        @heading[:y]      = @column.top_inset
        @heading[:width]  = @column.width - @column.left_inset - @column.right_inset
        @heading[:heading_height_type] = 'natural'
        @heading[:is_float] = true
        RHeading.new(@heading)
        @column.layout_floats
        @column.adjust_overlapping_lines_with_floats
      end
      @paragraphs =[]
      @story[:paragraphs].each do |para|
        para_options = {}
        para_options[:markup]         = para[:markup]
        para_options[:layout_expand]  = [:width]
        para_options[:para_string]    = para[:para_string]
        para_options[:line_width]     = @column.column_width  if para_options[:create_para_lines]
        @paragraphs << RParagraph.new(para_options)
      end
    end
  
    def layout_story
      flowing_items = @paragraphs.dup
      current_line = @column.graphics.first
      while @item = flowing_items.shift do
        current_line = @item.layout_lines(current_line)
      end
      if  current_line
        @current_column  = current_line.column
      end
    end

    def pdf_path
      @document_path + "/output.pdf"
    end
  
    def default_story
      h =<<~EOF
      ---
      title : 홍길동의 전설

      ---

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

    def default_layout
      layout =<<~EOF
      RLayout::RColumn.new(width:#{@width}, height:#{@height}, left_inset: #{@left_margin}, top_inset: #{@top_margin}, right_inset: #{@right_margin}, bottom_inset: #{@bottom_margin}, body_line_height: 16) do
      end

      EOF
    end

    def layout_path
      @document_path + "/layout.rb"
    end
    
    def save_layout
      File.open(layout_path, 'w'){|f| f.write default_layout} unless File.exist?(layout_path)
    end

    # def rakefile_path
    #   @document_path + "/Rakefile"
    # end

    # def rakefile
    #   s=<<~EOF
    #   require 'rlayout'
      
    #   task :default => [:generate_pdf]
      
    #   desc 'generate pdf'
    #   task :generate_pdf do
    #     document_path = File.dirname(__FILE__)
    #     #{self.class}.new(document_path)
    #   end
    #   EOF
    # end

    # def save_rakefile
    #   File.open(rakefile_path, 'w'){|f| f.write rakefile} unless File.exist?(rakefile_path)
    # end
    
    # def text_style_path
    #   @document_path + "/text_style.yml"
    # end

    # def save_text_style
    #   File.open(text_style_path, 'w'){|f| f.write default_text_style.to_yaml} unless File.exist?(text_style_path)
    # end

    # def default_text_style
    #   {
    #     'body'=> {
    #       'font'=>  'Shinmoon',
    #       'font_size'=>  11.0,
    #       'text_alignment'=>  'justify',
    #       'first_line_indent'=>  11.0,
    #     },
    #     'title'=>  {
    #       'font'=>  MYUNGJO_B,
    #       'font_size'=>  16.0,
    #       'text_alignment'=>  'left',
    #       # line_space: 'single' # half, single, double
    #     },
    #     'subtitle'=>  {
    #       'font'=>  GOTHIC_L,
    #       'font_size'=>  12.0,
    #       'text_alignment'=>  'left',
    #     },
    #     'running_head'=>  {
    #       'font'=>  GOTHIC_M,
    #       'font_size'=>  12.0,
    #       'markup'=>  '#',
    #       'text_alignment'=>  'left',
    #       'space_before'=>  1,
    #     },
    #     'running_head_2'=>  {
    #       'font'=>  GOTHIC_L,
    #       'font_size'=>  11.0,
    #       'markup'=>  '##',
    #       'text_alignment'=>  'middle',
    #       'space_before'=>  1,
    #     },
    #     'footer'=>  {
    #       'font'=>  MYUNGJO_M,
    #       'font_size'=>  7.0, 
    #     },
    #   }
    # end
    
  end

 
end