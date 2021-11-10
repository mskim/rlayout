module RLayout

  # spread
  # Image that spreads across back_page seneca and front_page
  
  # front_page
  # front_wing

  # back_wing
  # back_page

  CENTI2POINT = 22.4

  class BookCover < Container
    attr_reader :book_info, :project_path, :source_path,  :portrait, :spread_layout, :spread_width, :has_no_cover_inside_page, :has_wing
    attr_reader :cover_spread, :front_page, :back_page, :seneca, :seneca_width, :seneca_width_in_cm, :front_wing, :back_wing
    attr_reader :page_size, :page_width, :wing_width, :updated
    attr_reader :gripper_width_in_cm, :gripper_width
    def initialize(options={})
      super
      @book_info = options[:book_info]
      @project_path = options[:project_path]
      @source_path = options[:source_path]
      @portrait  = options[:portrait] || true
      @has_no_cover_inside_page = options[:has_no_cover_inside_page]
      @has_no_wing = options[:has_no_wing]
      unless File.exist?(@project_path)
        FileUtils.mkdir_p(@project_path)
      end
      @book_info = options[:book_info]
      @page_size = @book_info['paper_size'] || @book_info['page_size'] || 'A4'
      @page_width = SIZES[@page_size][0]
      @height = SIZES[@page_size][1]
      @seneca_width_in_cm = options[:seneca_width_in_cm] || 1.5
      @seneca_width = @seneca_width_in_cm*CENTI2POINT
      @gripper_width_in_cm = options[:seneca_width_in_cm] || 1.0
      @gripper_width = @gripper_width_in_cm*CENTI2POINT      
      @gripper_height_in_cm = options[:gripper_height_in_cm] || 1.0
      @gripper_height = @gripper_height_in_cm*CENTI2POINT      
      @wing_width_in_cm = options[:wing_width_in_cm] || 10
      @wing_width = @wing_width_in_cm*CENTI2POINT
      @wing_width = 225 unless @has_wing
      @spread_width = @page_width*2 + @seneca_width
      @width = @page_width*2 + @seneca_width + @wing_width*2
      create_spread
      create_pages_and_wings
      create_empty_page
      create_front_cover
      create_back_cover
      generate_pdf
      self
    end

    def default_layout
      layout =<<~EOF
      RLayout::Container.new(width:#{@width + @gripper_width*2}, height:#{@height + @gripper_width*2}, layout_direction:'horizontal') do
        vertical_line_positio = []
        x_position = #{@gripper_width}
        vertical_line_positio << x_position
        image(image_path: "#{back_wing_pdf_path}", x: x_position, width: #{@wing_width}, height:#{@height}, fill_color: 'clear')
        x_position += #{@wing_width}
        vertical_line_positio << x_position
        image(image_path: "#{cover_spread_pdf_path}" , x: x_position, y:#{@gripper_height}, width:#{@spread_width}, height:#{@height}, layout_member: false)
        image(image_path: "#{back_page_pdf_path}", x: x_position, y:#{@gripper_height},  width: #{@page_width}, height:#{@height}, fill_color: 'clear')
        x_position += #{@page_width}
        vertical_line_positio << x_position
        image(image_path: "#{seneca_pdf_path}", x: x_position, y:#{@gripper_height}, width: #{@seneca_width},  height:#{@height}, fill_color: 'white', rotate_content: -90)
        x_position += #{@seneca_width}
        vertical_line_positio << x_position
        image(image_path: "#{front_page_pdf_path}", x: x_position, y:#{@gripper_height}, width: #{@page_width}, height:#{@height}, fill_color: 'clear')
        x_position += #{@page_width}
        vertical_line_positio << x_position
        image(image_path: "#{front_wing_pdf_path}", x: x_position, y:#{@gripper_height}, width: #{@wing_width}, height:#{@height}, fill_color: 'clear')
        x_position += #{@wing_width}
        vertical_line_positio << x_position
        vertical_line_positio.each do |x_position|
          line(x:x_position,y:0, width:1, height: #{@gripper_height})
          line(x:x_position,y:#{@gripper_height + @height}, width:1, height: #{@gripper_height})
        end
        horozontal_line_positio = [#{@gripper_height}, #{@gripper_height + @height}]
        horozontal_line_positio.each do |y_position|
          line(x:0, y:y_position, width:#{@gripper_width}, height: 1)
          line(x:#{@width + @gripper_width}, y:y_position, width:#{@gripper_width}, height: 1)
        end
      
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

    def build_cover_spread_folder
      @project_path + "/cover_spread"
    end

    def create_spread
      copy_cover_image
      @cover_spread = CoverSpread.new(project_path:build_cover_spread_folder,  width:@spread_width, height: @height)
    end

    def copy_cover_image
      FileUtils.mkdir_p(build_cover_spread_folder) unless File.exist?(build_cover_spread_folder)
      Dir.glob("#{@source_path}/*.{png,jpg}").each do |file|
        system("cp #{file} #{build_cover_spread_folder}/")
      end
      # TODO get error message if no jpg
      # system("cp #{@source_path}/*.jpg #{build_cover_spread_folder}/")    
    end

    def build_front_wing_folder
      @project_path + "/front_wing"
    end

    def build_back_wing_folder
      @project_path + "/back_wing"
    end

    def source_front_wing_text
      @source_path + "/front_wing.md"
    end

    def source_back_wing_text
      @source_path + "/back_wing.md"
    end

    def copy_wing_contents
      FileUtils.mkdir_p(build_front_wing_folder) unless File.exist?(build_front_wing_folder)
      FileUtils.mkdir_p(build_back_wing_folder) unless File.exist?(build_back_wing_folder)
      system("cp #{source_front_wing_text} #{build_front_wing_folder}/content.md")
      system("cp #{source_back_wing_text} #{build_back_wing_folder}/content.md")    
    end

    def create_pages_and_wings
      copy_wing_contents if !@has_no_wing
      @current_x = 0
      create_back_wing if !@has_no_wing
      create_back_page
      create_seneca
      create_front_page
      create_front_wing if !@has_no_wing
    end

    def create_back_wing
      @back_wing = RLayout::BackWing.new(project_path:build_back_wing_folder,  width:@wing_width, height: @height)
      @current_x += @wing_width
    end

    def create_back_page
      # part_path = @project_path + "/back_page"
      h = {}
      h[:project_path] = @project_path + "/back_page"
      h[:width] = @page_width
      h[:height] = @height
      h[:cover_spread_width] = cover_spread_width
      h[:front_page_spread_off_set] = 0
      h[:spread_image_path] = @cover_spread.output_path
      h[:content] = @book_info
      @back_page = RLayout::BackPage.new(h)
      @current_x += @page_width
    end

    def create_seneca
      part_path = @project_path + "/seneca"
      @seneca = RLayout::Seneca.new(project_path:part_path, width:@height, height: @seneca_width)
      # rotae PDF 90 degree
      @current_x += @seneca_width
    end

    def cover_spread_width
      @page_width*2 + @seneca_width #+ @wing_width*2
    end
  
    def create_front_page
      # part_path = @project_path + "/front_page"
      h = {}
      h[:project_path] = @project_path + "/front_page"
      h[:width] = @page_width
      h[:height] = @height
      h[:cover_spread_width] = cover_spread_width
      h[:front_page_spread_off_set] = @page_width + @seneca_width
      h[:spread_image_path] = @cover_spread.output_path
      h[:content] = @book_info
      # @front_page = RLayout::FrontPage.new(project_path:part_path, width:@page_width, height: @height)
      @front_page = RLayout::FrontPage.new(h)
      @current_x += @page_width
    end

    def create_front_wing
      # part_path = @project_path + "/front_wing"
      @front_wing = RLayout::FrontWing.new(project_path:build_front_wing_folder, width:@wing_width, height: @height)
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
      # return unless is_dirty?
      @book_cover.save_pdf_with_ruby(output_path, jpg:true)
      @updated = true
    end

    def empty_page_layout
      layout =<<~EOF
      RLayout::Container.new(fill_color:'clear', width:#{@page_width}, height:#{@height}) do
      end
      EOF
    end
  
    def empty_page_pdf_path
      @project_path + "/empty_page.pdf"
    end
  
    def empty_page_jpg_path
      @project_path + "/empty_page.jpg"
    end
  
    def create_empty_page
      page_with_empty = eval(empty_page_layout)
      page_with_empty.save_pdf_with_ruby(empty_page_pdf_path, jpg:true)
    end
  
    def build_front_cover_path
      @project_path + "/front_cover"
    end
  
    def create_front_cover
      FileUtils.mkdir_p(build_front_cover_path) unless File.exist?(build_front_cover_path)
      page1_path = build_front_cover_path + "/0001"
      FileUtils.mkdir_p(page1_path) unless File.exist?(page1_path)
      page1_pdf_path = page1_path + "/page.pdf"
      page1_jpg_path = page1_path + "/page.jpg"
      # copy pdf
      pdf_source_1 = @project_path + "/front_page/output.pdf"
      system(" cp #{pdf_source_1} #{page1_pdf_path}")
      # copy jpg
      jpg_source_1 = @project_path + "/front_page/output.jpg"
      system(" cp #{jpg_source_1} #{page1_jpg_path}")
      if @has_no_cover_inside_page
      else
        page2_path = build_front_cover_path + "/0002"
        FileUtils.mkdir_p(page2_path) unless File.exist?(page2_path)
        page2_pdf_path = page2_path + "/page.pdf"
        page2_jpg_path = page2_path + "/page.jpg"
        system(" cp #{empty_page_pdf_path} #{page2_pdf_path}")
        system(" cp #{empty_page_jpg_path} #{page2_jpg_path}")
      end
    end
  
    def build_back_cover_path
      @project_path + "/back_cover"
    end
  
    def create_back_cover
      FileUtils.mkdir_p(build_back_cover_path) unless File.exist?(build_back_cover_path)
      page1_path = build_back_cover_path + "/0001"
      page1_pdf_path = page1_path + "/page.pdf"
      page1_jpg_path = page1_path + "/page.jpg"
      FileUtils.mkdir_p(page1_path) unless File.exist?(page1_path)
      # copy pdf
      pdf_source_1 = @project_path + "/back_page/output.pdf"
      system(" cp #{pdf_source_1} #{page1_pdf_path}")
      # copy jpg
      jpg_source_1 = @project_path + "/back_page/output.jpg"
      system(" cp #{jpg_source_1} #{page1_jpg_path}")
      if @has_no_cover_inside_page
      else
        page2_path = build_back_cover_path + "/0002"
        FileUtils.mkdir_p(page2_path) unless File.exist?(page2_path)
        page2_pdf_path = page2_path + "/page.pdf"
        page2_jpg_path = page2_path + "/page.jpg"
        system(" cp #{empty_page_pdf_path} #{page2_pdf_path}")
        system(" cp #{empty_page_jpg_path} #{page2_jpg_path}")
      end
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