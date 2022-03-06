require 'csv'
module RLayout

  class Namecard <  StyleGuide
    attr_reader :compnay_name, :member_data, :text_style
    def initialize(options={})
      @compnay_name = options[:compnay_name]
      super
      # @text_style = || default_text_style
      parse_csv
      create_cards
      self
    end

    def company_info_path
      @document_path + "/company_info.yml"
    end

    def csv_path
      @document_path + "/members.csv"
    end

    def text_style_path
      @document_path + "/text_style.yml"
    end

    def load_text_style
      if File.exist?(text_style_path)
        @text_style = YAML::load_file(text_style_path)
      else
        @text_style = default_text_style
        File.open(text_style_path, 'w'){|f| f.write @text_style}
      end
    end

    def parse_csv
      if File.exist?(csv_path)
        @member_data = File.open(csv_path, 'r'){|f| f.read}
        @company_info = YAML::load_file(company_info_path)
      else
        @member_data = sampel_member_csv
        File.open(csv_path, 'w'){|f| f.write sampel_member_csv}
      end
    end

    def sampel_member_csv
      s =<<~EOF
      name,division,title,email,cell
      홍길동,영업부,부장,honggitdong@gmail.com,010-111-4444
      김길동,영업부,부장,honggitdong@gmail.com,010-111-4444
      강길동,영업부,부장,honggitdong@gmail.com,010-111-4444
      나길동,영업부,부장,honggitdong@gmail.com,010-111-4444
      노길동,영업부,부장,honggitdong@gmail.com,010-111-4444
      오길동,영업부,부장,honggitdong@gmail.com,010-111-4444
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
      copy_1:
        font: KoPubDotumPM
        font_size: 12.0
        markup: "#"
        text_alignment: left
        space_before: 1
        copy_2:
        font: KoPubDotumPL
        font_size: 11.0
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
    
    def front_side
      s =<<~EOF
      card do
        logo(x:0,y:0)
        personal(x:300, y:0)
        company(x:0, y:400, width:400, height:200)
      end
      EOF
    end

    def back_side
      s =<<~EOF
      card do
        logo(x:0,y:0)
        en_personal(x:300, y:0)
        en_company(x:0, y:400, width:400, height:200)
      end
      EOF
    end

    def default_layout_rb
      s =<<~EOF
      RLayout::Namecard.new() do
        #{front_side}
        #{back_side}
      end

      EOF

    end

    def create_cards
      @member_data.each do |member|
        h = {}
        h[:document_path] = @document_path
        h[:company] = @company_info
        h[:member] = @member
        h[:text_style] = @text_style
        Namecard.new(h)
      end
    end
  end

end