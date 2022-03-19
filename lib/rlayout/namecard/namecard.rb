require 'csv'
module RLayout
  # Namecard Naming Convention
  # text_style name and csv head should match
  # define text_style stylename of each csv head
  #   name, cell, email, title, etc ...

  # Area 
  # Area serves as place holder.
  #   person(3,0,9,3)

  # item_hash
  # item_hash is used for grouping and ordering csv items into a layout group
  # person_info.erb =  "{name: #{@name},  title: #{@division}/#{@title}, email: #{@email}, cell: #{@cell}"
  # for  example, title item is combination if division and title    title: #{@division}/#{@title}
  # Area name and item_hash should match by adding _info 
  #  area_name: personal, company, logo, copy_1, copy_1, etc ...
  #  item_hash: personal_info, company_info, logo_info, copy_1_inf0, copy_2_info, etc ...

  # data_source and area_name should match
  #  personal.csv
  #  compant.yml
  #  copy_1.yml
  #  logo.pdf,  logo.svg,  logo.jpg 



  # item_string hash
  # personal_info = "{name: '#{@name}', title: '#{@divistion}/#{@title}', email:'#{@email}'}"
  # company_info = "{company_name: '#{@company_name}', address_1: '#{@address_1 #{@address_1}', address_2: '#{@city} #{@state} #{@zip}' }"

  class Namecard < StyleGuide
    attr_reader :compnay_name, :member_data, :text_style
    attr_reader :cards_array
    attr_reader :imposition

    def initialize(options={})
      @compnay_name = options[:compnay_name]
      @imposition = options[:imposition] || true
      super
      create_cards
      self
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

    def front_layout_path
      @document_path + "/front_layout.rb"
    end

    def back_layout_path
      @document_path + "/back_layout.rb"
    end

    def load_layout_rb
      if File.exist?(front_layout_path)
        @front_layout_rb = File.open(front_layout_path, 'r'){|f| f.read}
      else
        @front_layout_rb = default_front_layout_rb
        @front_layout_rb = File.open(front_layout_path, 'w'){|f| f.write default_front_layout_rb}
      end
      if File.exist?(back_layout_path)
        @back_layout_rb = File.open(back_layout_path, 'r'){|f| f.read}
      else
        @back_layout_rb = default_back_layout_rb
        @back_layout_rb = File.open(back_layout_path, 'w'){|f| f.write default_back_layout_rb}
      end
    end

    # def sample_member_csv
    #   # s =<<~EOF
    #   # name,title,email,cell
    #   # 홍길동,영업부/부장,honggitdong@gmail.com,010-111-4444
    #   # 김길동,영업부/부장,honggitdong@gmail.com,010-111-4444
    #   # 강길동,영업부/부장,honggitdong@gmail.com,010-111-4444
    #   # 나길동,영업부/부장,honggitdong@gmail.com,010-111-4444
    #   # 노길동,영업부/부장,honggitdong@gmail.com,010-111-4444
    #   # 오길동,영업부/부장,honggitdong@gmail.com,010-111-4444
    #   # EOF
    # end

    def sample_member_csv(options={})
      require 'fake_korean'
      data = ""
      count = options[:count] || 20
      count.times do |i|
        card = FakeKorean::KoreanNameCard.new
        card_hash = card.to_hash
        if i == 0
          data += card_hash.keys.map{|k| k.to_s}.join(",")
          data += "\n"
        else
          data += card_hash.values.join(",")
          data += "\n"
        end
      end
      data
    end



    def default_personal_info_erb
      "{name:'<%= @name %>', title: '<%= @title %>', cell: '010-7468-8222', email: 'mskimsid@gmail.com'}"
    end

    def default_company_info_erb
      @company_info  = {company_name:"SoftwareLab", address_1:"401-206 Woomi-inosvill " , address_2: 'YounginSi, GyungGiDO. 11359'}

    end

    def default_company_info
      h = {}
      h[:company_name] = "한국상사"
      h[:phone] = "02-135-5555"
      h[:address_1] = "서을특별시 중구 을지로"
      h[:address_2] = "135-5"
      h
    end



    def default_front_layout_rb
      s=<<~EOF
      RLayout::CardFront.new(paper_size:'NAMECARD') do
        logo([1,1,1,1])
        personal([5,0,7,3])
        company([2,3,10,3])
      end

      EOF
    end

    def default_personal_layout_rb

    end

    def default_company_layout_rb
      
    end

    def default_logo_layout_rb

    end

    def default_copy_1_layout_rb

    end

    def default_back_layout_rb
      s=<<~EOF
      RLayout::CardBack.new(paper_size:'NAMECARD') do
        logo([0,0,1,1])
        en_personal([2,0,4,3])
        en_company([2,3,4,3])
      end

      EOF
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

    def card_layout_path
      @document_path + "/card_layout.rb"
    end

    def company_info_path
      @document_path + "/company_info.yml"
    end

    def csv_path
      @document_path + "/members.csv"
    end

    def members_path
      @document_path + "/members"
    end

    def create_cards
      @cards_array = []
      if File.exist?(csv_path)
        @member_data = File.open(csv_path, 'r'){|f| f.read}
      else
        @member_data = sample_member_csv
        File.open(csv_path, 'w'){|f| f.write sample_member_csv}
      end
      if File.exist?(company_info_path)
        @company_info = YAML::load_file(company_info_path)
      else
        @company_info = default_company_info
        File.open(company_info_path, 'w'){|f| f.write default_company_info.to_yaml}
      end      
      FileUtils.mkdir_p(members_path) unless File.exist?(members_path)
      @member_rows = CSV.parse(@member_data)
      keys  = @member_rows.shift
      keys.map!{|e| e.to_sym}
      # for first card create @member_card from scratch 
      # and the rest of following cards replace the conent on that card and save pdf.
      @member_rows.each_with_index do |personal_info, i|
        @personal_info = Hash[keys.zip personal_info]
        h = {}
        h[:document_path] = @document_path
        h[:text_style]  = @text_style
        h[:personal_info] = @personal_info
        slug = @personal_info[:name].gsub(" ", "_")
        @member_pdf_path =  members_path + "/#{slug}.pdf"
        @member_card = RLayout::RDocument.new(paper_size: 'NAMECARD', page_count: 0)
        front_card = eval(@front_layout_rb)
        front_card.text_style = text_style
        front_card.personal_info = @personal_info
        front_card.company_info = @company_info
        front_card.set_content
        @member_card.add_page(front_card)
        back_card = eval(@back_layout_rb)
        back_card.text_style = @text_style
        back_card.personal_info = @personal_info
        back_card.company_info = @company_info
        back_card.set_content
        @member_card.add_page(back_card)

        @member_card.save_pdf(@member_pdf_path)

        if @imposition
          make_imposition(@member_pdf_path)
        end
      end

    end

    def make_imposition(member_pdf_path)
      # puts member_pdf_path
    end

  end

end