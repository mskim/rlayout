module RLayout

  # BookCover
  # spread
  # Image that spreads across back_page seneca and front_page

  # back_wing
  # back_page
  # front_page
  # front_wing
  CENTI2POINT = 22.4
  class BookCover < Container
    attr_reader :project_path, :portrait, :spread_layout, :spread_width, :has_wing
    attr_reader :cover_spread, :front_page, :back_page, :seneca, :seneca_width, :seneca_width_in_cm, :front_wing, :back_wing
    attr_reader :page_size, :page_width, :wing_width, :updated

    def initialize(options={})
      super
      @project_path = options[:project_path]
      @portrait  = options[:portrait] || true
      @has_wing = options[:has_wing] || true
      unless File.exist?(@project_path)
        FileUtils.mkdir_p(@project_path)
      end
      @page_size = options[:page_size] || 'A4'
      @page_width = SIZES[@page_size][0]
      @height = SIZES[@page_size][1]
      @seneca_width_in_cm = options[:seneca_width_in_cm] || 1.5
      @seneca_width = @seneca_width_in_cm*CENTI2POINT
      @wing_width_in_cm = options[:wing_width_in_cm] || 10
      @wing_width = @wing_width_in_cm*CENTI2POINT
      @wing_width = 0 unless @has_wing
      @spread_width = @page_width*2 + @seneca_width
      @width = @page_width*2 + @seneca_width + @wing_width*2
      create_spread
      create_pages_and_wings
      generate_pdf
      self
    end

    def default_layout
      layout =<<~EOF
      RLayout::Container.new(width:#{@width}, height:#{@height}, layout_direction:'horizontal') do

        image(image_path: "#{cover_spread_pdf_path}" , x:#{@wing_width}, y:0, width:#{@spread_width}, height:#{@height}, layout_member: false)
        
        image(image_path: "#{back_wing_pdf_path}", layout_length: #{@wing_width}, fill_color: 'clear')
        image(image_path: "#{back_page_pdf_path}", layout_length: #{@page_width}, fill_color: 'clear')
        image(image_path: "#{seneca_pdf_path}", layout_length: #{@seneca_width}, fill_color: 'white', rotate_content: -90)
        image(image_path: "#{front_page_pdf_path}", layout_length: #{@page_width}, fill_color: 'clear')
        image(image_path: "#{front_wing_pdf_path}", layout_length: #{@wing_width}, fill_color: 'clear')
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

    def cover_spread_pdf_path
      @project_path + "/cover_spread/output.pdf"
    end

    def back_wing_pdf_path
      @project_path + "/back_wing/output.pdf"
    end

    def back_page_pdf_path
      @project_path + "/back_page/output.pdf"
    end

    def seneca_pdf_path
      @project_path + "/seneca/output.pdf"
    end

    def front_page_pdf_path
      @project_path + "/front_page/output.pdf"
    end

    def front_wing_pdf_path
      @project_path + "/front_wing/output.pdf"
    end

    def create_spread
      part_path = @project_path + "/cover_spread"
      @cover_spread = CoverSpread.new(project_path:part_path,  width:@spread_width, height: @height)
    end

    def create_pages_and_wings

      @current_x = 0
      create_back_wing if @has_wing
      create_back_page
      create_seneca
      create_front_page
      create_front_wing if @has_wing
    end

    def create_back_wing
      part_path = @project_path + "/back_wing"
      @back_wing = BackWing.new(project_path:part_path,  width:@wing_width, height: @height)
      @current_x += @wing_width
    end

    def create_back_page
      part_path = @project_path + "/back_page"
      @back_page = BackPage.new(project_path:part_path, width:@page_width, height: @height)
      @current_x += @page_width
    end

    def create_seneca
      part_path = @project_path + "/seneca"
      # @seneca = Seneca.new(project_path:part_path, width:@seneca_width, height: @seneca_width)
      @seneca = Seneca.new(project_path:part_path, width:@height, height: @seneca_width)
      # rotae PDF 90 degree
      @current_x += @seneca_width
    end
  
    def create_front_page
      part_path = @project_path + "/front_page"
      @front_page = FrontPage.new(project_path:part_path, width:@page_width, height: @height)
      @current_x += @page_width
    end

    def create_front_wing
      part_path = @project_path + "/front_wing"
      @front_wing = FrontWing.new(project_path:part_path, width:@wing_width, height: @height)
      @current_x += @wing_width
    end

    def generate_pdf
      @updated = false
      if File.exist?(layout_path)
        layout_text = File.open(layout_path,'r'){|f| f.read}
        @book_cover = eval(layout_text)
      else
        File.open(layout_path,'w'){|f| f.write default_layout }
        @book_cover = eval(default_layout)
      end
      return unless is_dirty?
      @book_cover.save_pdf_with_ruby(output_path, jpg:true)
      @updated = true
    end

    def is_dirty?
      return true unless File.exist?(output_path)

      return true if @cover_spread.updated
      return true if File.mtime(@cover_spread.output_path) > File.mtime(output_path)
      
      return true if @back_wing.updated
      return true if File.mtime(@back_wing.output_path) > File.mtime(output_path)

      return true if @back_page.updated
      return true if File.mtime(@back_page.output_path) > File.mtime(output_path)

      return true if @seneca.updated
      return true if File.mtime(@seneca.output_path) > File.mtime(output_path)

      return true if @front_page.updated
      return true if File.mtime(@front_page.output_path) > File.mtime(output_path)

      return true if @front_wing.updated
      return true if File.mtime(@front_wing.output_path) > File.mtime(output_path)

      return true unless File.exist?(output_path)
      return true if File.mtime(layout_path) > File.mtime(output_path)

      # check for spread
      false
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


  end

end