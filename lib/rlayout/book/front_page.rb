module RLayout

  # The goad is to create a design system where designers can create flexable book cover design using scrpt,
  # And allow others to reuse them, instead of manually creating designing each and every time with Illustrator.
  
  # front_page
  # CoverPage is used to set place holder for TextAreas.
  # With CoverPage, place holder for heading, qrcode, box_1, box_2, box3, box_4, and box_5 can ne set using &block syntex.
  # An instances of TextAreas are created by &block like following

  # RLayout::CoverPage.new(paper_size: 'A4') do
  #   heading(1,1,6,10)
  #   box_1(1,10,1,1)
  #   qrcode(10,10, 1,1)
  # end
  # The numbers represents grid_x, grid_y, grid_width, grid_height

  # Contents of these TextArea are set by calling @document.set_contents_for_area(front_page_data)
  #  where front_page_data is nested hash for each TextAreas
  #  ---
  # :heading:
  #   :title: cover title goes here
  #   :subtitle: cover subtitle goes here
  #   :author: author name goes here
  # :box_1:
  #   :title: box title goes here
  #   :subtitle: box subtitle goes here
  #   :body: box body goes here
  # :qrcode:
  #   :image_path: /some/qrcode/image_path.jpg

  class FrontPage < StyleableDoc
    attr_reader :book_cover_folder, :book_info, :pdf_page

    def initialize(options={})
      options[:starting_page_side] = :left_side
      super

      @pdf_page = options[:pdf_page]
      @book_cover_folder = options[:book_cover_folder] || @document_path
      FileUtils.mkdir_p(@book_cover_folder) unless File.exist?(@book_cover_folder)
      FileUtils.mkdir_p(@document_path) unless File.exist?(@document_path)
      @book_info = options[:book_info]
      read_content
      # @document.set_content(@content)
      @document.set_contents_for_area(@content)
      @document.save_pdf(output_path, pdf_page: @pdf_page, jpg:true)
      self
    end

    def page_count
      1
    end

    def source_content_path
      @book_cover_folder + "/#{style_klass_name}_content.yml"
    end

    def output_path
      @document_path + "/output.pdf"
    end

    def read_content
      if File.exist?(source_content_path)
        @content = YAML::load_file(source_content_path)
      else
        @content = front_page_content
        File.open(source_content_path, 'w'){|f| f.write @content.to_yaml}
      end
    end
    
    def front_page_content
      heading = {}
      heading[:title] = @book_info[:title]
      heading[:subtitle] = @book_info[:subtitle]
      heading[:author] = @book_info[:author]
      heading[:publisher] = @book_info[:publisher] if @book_info[:publisher]
      
      box_1 = {}
      box_1[:subtitle] = "some text"
      box_1[:body] = "some body text. "*5
      
      h = {}
      h[:heading] = heading
      front_page_content = h
    end

    def cover_spread_pdf_path
      File.dirname(@document_path) + "/cover_spread/output.pdf"
    end

    def default_layout_rb
      layout =<<~EOF
      RLayout::CoverPage.new(fill_color:'clear',width:#{@width}, height:#{@height}) do
        image(image_path: '#{cover_spread_pdf_path}',  x: -#{@width}, y: 0,  width: #{@width}*2,  height: #{@height} )
        heading(1,0,4,10)
      end
      EOF
    end

    def default_text_style
      s=<<~EOF
      ---

      title:
        font: KoPubBatangPB
        font_size: 24.0
        text_alignment: center
        text_line_spacing: 10
        space_before: 100
      subtitle:
        font: KoPubDotumPL
        font_size: 18.0
        text_alignment: center
        text_line_spacing: 5
        space_before: 50
        space_after: 30
      author:
        font: KoPubDotumPL
        font_size: 14.0
        text_color: 'DarkGray'
        text_alignment: center
        text_line_spacing: 5
        space_after: 30
      running_head:
        font: KoPubDotumPM
        font_size: 12.0
        markup: "#"
        text_alignment: left
        space_before: 1
      logo:
        from_bottom: 50
        width: 50
        height: 50
        position: 8
        image_path: local.pdf      
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
      EOF

    end
    
  end
end