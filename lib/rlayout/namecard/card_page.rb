module RLayout
  class CardPage < Container
    attr_reader :grid
    attr_accessor :text_style, :document_path
    attr_accessor :personal_info, :company_info, :logo_info, :picture_info, :qrcode_vcard, :en_qrcode_vcard
    attr_reader :personal_object, :company_object, :logo_object, :picture_object, :qrcode_object, :en_qrcode_object
    attr_accessor :picture_path, :qrcode_path, :en_qrcode_path

    def initialize(options={}, &block)
      options[:paper_size] = 'NAMECARD'
      @document_path = options[:document_path]
      # options[:fill_color] = 'yellow'
      options[:left_inset] = 10
      options[:top_inset] = 20
      options[:right_inset] = 10
      options[:bottom_inset] = 10
      @grid = options[:paper_size] || [6,12]

      super
      if self.class == RLayout::CardPage
        if block
          instance_eval(&block)
        end
      end
      self
    end

    def text_style_path
      @document_path + "/text_style"
    end

    def set_content
      if @text_style
        current_style = RLayout::StyleService.shared_style_service.current_style = @text_style
      else  
        current_style = RLayout::StyleService.shared_style_service.current_style = YAML::load(default_text_style)
      end

      if @personal_info
        @personal_object.set_content(@personal_info) 
      end

      if @company_info
        @company_object.set_content(@company_info) 
      end

      if @logo_info      
        @logo_object.set_content(@logo_info) 
      end

      if @picture_info
        @picture_object.set_content(@picture_info)
      end
    end

    def default_text_style
      s=<<~EOF
      ---
      name:
        font: KoPubDotumPM
        korean_name: 이름
        font_size: 11.0
        text_alignment: left
        first_line_indent: 11.0
        space_before: 10.0
        space_after: 5.0
      en_fullname:
        font: KoPubDotumPM
        korean_name: 이름
        font_size: 11.0
        text_alignment: left
        first_line_indent: 11.0
        space_before: 10.0
        space_after: 5.0
      cell:
        font: Shinmoon
        korean_name: 휴대전화
        font_size: 8.0
        text_alignment: left
        first_line_indent: 8.0
      email:
        font: Shinmoon
        korean_name: 이메일
        font_size: 8.0
        text_alignment: left
        first_line_indent: 8.0
      division:
        font: Shinmoon
        korean_name: 이름
        font_size: 8.0
        text_alignment: left
        first_line_indent: 8.0
      title:
        font: Shinmoon
        korean_name: 직책
        font_size: 8.0
        text_alignment: left
        first_line_indent: 8.0
      address:
        font: Shinmoon
        korean_name: 주소
        font_size: 8.0
        text_alignment: left
        first_line_indent: 8.0
      company:
        font: Shinmoon
        korean_name: 회사명
        font_size: 8.0
        text_alignment: left
        first_line_indent: 8.0
      company_name:
        font: KoPubDotumPM
        korean_name: 회사명
        font_size: 8.0
        text_alignment: left
        first_line_indent: 8.0
      en_company_name:
        font: KoPubDotumPM
        korean_name: 회사명
        font_size: 8.0
        text_alignment: left
        first_line_indent: 8.0
      phone:
        font: Shinmoon
        korean_name: 회사명
        font_size: 8.0
        text_alignment: left
        first_line_indent: 8.0
      address_1:
        font: Shinmoon
        korean_name: 회사명
        font_size: 8.0
        text_alignment: left
        first_line_indent: 8.0
      address_2:
        font: Shinmoon
        korean_name: 회사명
        font_size: 8.0
        text_alignment: left
        first_line_indent: 8.0
      state:
        font: Shinmoon
        korean_name: 회사명
        font_size: 8.0
        text_alignment: left
        first_line_indent: 8.0
      zip:
        font: Shinmoon
        korean_name: 회사명
        font_size: 8.0
        text_alignment: left
        first_line_indent: 8.0
      body:
        font: Shinmoon
        font_size: 8.0
        text_alignment: left
        first_line_indent: 8.0
      body_gothic:
        font: KoPubBatangPM
        font_size: 8.0
        text_alignment: left
        first_line_indent: 8.0
      subtitle:
        font: KoPubDotumPL
        font_size: 12.0
        text_color: 'DarkGray'
        text_alignment: center
        text_line_spacing: 5
        space_after: 30
      copy_1:
        font: KoPubDotumPM
        font_size: 12.0
        markup: "#"
        text_alignment: left
        space_before: 1
      copy_2:
        font: KoPubDotumPL
        font_size: 8.0
        markup: "##"
        text_alignment: middle
        space_before: 1
      caption:
        korean_name: 사진설명
        category:
        font_family: KoPub돋움체_Pro Light
        font: KoPubDotumPL
        font_size: 7.5
        text_color: CMYK=0,0,0,100
        text_alignment: justify
        tracking: -0.5
      EOF

    end

    # TODO make it customizable
    def personal(grid_frame, options={})
      h = {}
      h[:parent] = self
      h[:tag] = "personal"
      h[:grid_frame]  = grid_frame
      h[:content]  = @personal_info
      h[:fill_color]  = options[:fill_color] || 'clear'
      @personal_object = RLayout::Area.new(h)
    end

    # TODO make it customizable
    def company(grid_frame, options={})
      h = {}
      h[:parent] = self
      h[:grid_frame]  = grid_frame
      h[:tag] = "company"
      h[:content]  = @company_info
      h[:fill_color]  = options[:fill_color] || 'clear'
      @company_object =  RLayout::Area.new(h)
    end

    # TODO make it customizable
    def logo(grid_frame, options={})
      h = {}
      h[:parent] = self
      h[:grid_frame]  = grid_frame
      h[:tag] = "logo"
      h[:fill_color]  = options[:fill_color] || 'red'
      @logo_object = RLayout::Area.new(h)
    end

    # This places person picture
    def picture(grid_frame, options={})
      h = {}
      h[:parent] = self
      h[:grid_frame]  = grid_frame
      # TODO set frame rect
      h[:tag] = "picture"
      h[:image_path] = @picture_path
      @picture_object = RLayout::Image.new(h)
    end

    # This places person picture
    def qrcode(grid_frame, options={})
      h = {}
      h[:parent] = self
      h[:grid_frame]  = grid_frame
      # TODO set frame rect
      h[:tag] = "qrcode"
      h[:image_path] = @qrcode_path
      @qrcode_object = RLayout::Image.new(h)
    end

    def en_qrcode(grid_frame, options={})
      h = {}
      h[:parent] = self
      h[:grid_frame]  = grid_frame
      # TODO set frame rect
      h[:tag] = "qrcode"
      h[:image_path] = @qrcode_path
      @en_qrcode_object = RLayout::Image.new(h)
    end
    def copy_1(grid_frame, options={})
      h = {}
      h[:parent] = self
      h[:grid_frame]  = grid_frame
      h[:tag] = "copy_1"
      @copy_1_object = RLayout::Area.new(h)
    end
  end
end