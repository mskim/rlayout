require 'csv'
# require 'vcard_qrcode'
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
  #  company.yml
  #  copy_1.yml
  #  logo.pdf,  logo.svg,  logo.jpg
  #  qr_code.png, en_qr_code.png



  # item_string hash
  # personal_info = "{name: '#{@name}', title: '#{@divistion}/#{@title}', email:'#{@email}'}"
  # company_info = "{company_name: '#{@company_name}', address_1: '#{@address_1 #{@address_1}', address_2: '#{@city} #{@state} #{@zip}' }"

  class Namecard
    attr_reader :compnay_name, :member_data, :text_style
    attr_reader :cards_array
    attr_reader :imposition
    attr_reader :company_hash
    attr_reader :qr_code
    attr_reader :project_path
    attr_reader :logo_path

    def initialize(project_path, options={})
      @compnay_name = options[:compnay_name] || "our_company"
      @imposition = options[:imposition] || true
      @project_path  = project_path
      @logo_path = @project_path + "/logo.pdf"
      create_cards
      self
    end

    def self.namecard_template_path
      File.dirname(__FILE__) + "/namecard_template/paperback"
    end

    def self.create(project_path)
      member_csv_path = project_path + "/member.csv"
      if File.exist?(member_csv_path)
        puts "Namecard files alreay exists !!!"
        return
      end
      template_path = Namecard.namecard_template_path
      # copy contents of template_path to target folder
      FileUtils.cp_r "#{template_path}/.", project_path     
    end
    
    def text_style_path
      @project_path + "/text_style.yml"
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
      @project_path + "/front_layout.rb"
    end

    def back_layout_path
      @project_path + "/back_layout.rb"
    end

    def company_info_path
      @project_path + "/company.yml"
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
      if File.exist?(company_info_path)
        @company_info = File.open(company_info_path, 'r'){|f| f.read}
      else
        @company_info = default_company_info
        @back_layout_rb = File.open(company_info_path, 'w'){|f| f.write default_company_info.to_yaml}
      end    
    end

    def sample_member_csv(options={})
      require 'fake_korean'
      data = ""
      count = options[:count] || 20
      count.times do |i|
        card = FakeKorean::KoreanNameCard.new
        personal_info = card.personal_info
        @company_info = card.company_info
        if i == 0
          data += personal_info.keys.map{|k| k.to_s}.join(",")
          data += "\n"
        else
          data += personal_info.values.join(",")
          data += "\n"
        end
      end
      data
    end

    def default_company_info
      h = {}
      h[:company_name] = "????????????"
      h[:phone] = "02-135-5555"
      h[:address_1] = "??????????????? ?????? ?????????"
      h[:address_2] = "135-5"
      h[:en_company_name] = 'Hankook Trading'
      h[:en_address_1] = '135-5 UljeeRo'
      h[:en_address_2] = "Jung-GU Seoul, Korea 10033"
      h
    end

    def default_front_layout_rb
      s=<<~EOF
      RLayout::CardPage.new(paper_size:'NAMECARD') do
        logo(0,0,1.5,2)
        qrcode(0,2,2,2.5)
        personal(2.5,0,3,2)
        company(1.5,4.25,6,1)
      end

      EOF
    end

    def default_back_layout_rb
      s=<<~EOF
      RLayout::CardPage.new(paper_size:'NAMECARD') do
        logo(0,0,1.5,2)
        personal(2.5,0,3,2)
        company(1.5,4.25,6,1)
      end

      EOF
    end

    def default_text_style
      s=<<~EOF
      ---
      name:
        font: KoPubDotumPM
        korean_name: ??????
        font_size: 11.0
        text_alignment: left
        first_line_indent: 11.0
        space_before: 10.0
        space_after: 5.0
      en_fullname:
        font: KoPubDotumPM
        korean_name: ??????
        font_size: 11.0
        text_alignment: left
        first_line_indent: 11.0
        space_before: 10.0
        space_after: 5.0
      cell:
        font: Shinmoon
        korean_name: ????????????
        font_size: 8.0
        text_alignment: left
        first_line_indent: 8.0
      email:
        font: Shinmoon
        korean_name: ?????????
        font_size: 8.0
        text_alignment: left
        first_line_indent: 8.0
      division:
        font: Shinmoon
        korean_name: ??????
        font_size: 8.0
        text_alignment: left
        first_line_indent: 8.0
      title:
        font: Shinmoon
        korean_name: ??????
        font_size: 8.0
        text_alignment: left
        first_line_indent: 8.0
      address:
        font: Shinmoon
        korean_name: ??????
        font_size: 8.0
        text_alignment: left
        first_line_indent: 8.0
      company:
        font: Shinmoon
        korean_name: ?????????
        font_size: 8.0
        text_alignment: left
        first_line_indent: 8.0
      company_name:
        font: KoPubDotumPM
        korean_name: ?????????
        font_size: 8.0
        text_alignment: left
        first_line_indent: 8.0
      en_company_name:
        font: KoPubDotumPM
        korean_name: ?????????
        font_size: 8.0
        text_alignment: left
        first_line_indent: 8.0
      phone:
        font: Shinmoon
        korean_name: ?????????
        font_size: 8.0
        text_alignment: left
        first_line_indent: 8.0
      address_1:
        font: Shinmoon
        korean_name: ?????????
        font_size: 8.0
        text_alignment: left
        first_line_indent: 8.0
      address_2:
        font: Shinmoon
        korean_name: ?????????
        font_size: 8.0
        text_alignment: left
        first_line_indent: 8.0
      state:
        font: Shinmoon
        korean_name: ?????????
        font_size: 8.0
        text_alignment: left
        first_line_indent: 8.0
      zip:
        font: Shinmoon
        korean_name: ?????????
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
        korean_name: ????????????
        category:
        font_family: KoPub?????????_Pro Light
        font: KoPubDotumPL
        font_size: 7.5
        text_color: CMYK=0,0,0,100
        text_alignment: justify
        tracking: -0.5
      EOF

    end

    def card_layout_path
      @project_path + "/card_layout.rb"
    end

    def company_info_path
      @project_path + "/company_info.yml"
    end

    def csv_path
      @project_path + "/members.csv"
    end

    def members_path
      @project_path + "/members"
    end

    def qrcode_folder
      @project_path + "/members/qrcode"
    end

    def create_cards
      load_layout_rb
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
        File.open(company_info_path, 'w'){|f| f.write @company_info.to_yaml}
      end      
      FileUtils.mkdir_p(members_path) unless File.exist?(members_path)
      FileUtils.mkdir_p(qrcode_folder) unless File.exist?(qrcode_folder)
      @member_rows = CSV.parse(@member_data)
      keys  = @member_rows.shift
      keys.map!{|e| e.to_sym}
      @member_rows.each_with_index do |personal_info, i|
        @personal_info = Hash[keys.zip personal_info]
        h = {}
        h[:document_path] = @project_path
        h[:text_style]  = @text_style
        h[:personal_info] = @personal_info
        slug = @personal_info[:name].gsub(" ", "_")
        @member_pdf_path =  members_path + "/#{slug}.pdf"
        @member_card = RLayout::RDocument.new(paper_size: 'NAMECARD', page_count: 0)
        front_card = create_front_side(@personal_info, @company_info)
        @member_card.add_page(front_card)
        back_card = create_back_side(@personal_info, @company_info)
        @member_card.add_page(back_card)
        @member_card.save_pdf(@member_pdf_path)
        if @imposition
          make_imposition(@member_pdf_path)
        end
      end
    end

    def create_front_side(personal_info, company_info)      
      front_card = eval(@front_layout_rb)
      if front_card.qrcode_object
        vcard_info = {}
        vcard_info[:name] = personal_info[:name]
        slug = personal_info[:name].gsub(" ", "_")
        vcard_info[:email] = personal_info[:email]
        vcard_info[:tel] = personal_info[:cell]
        vcard_info[:org] = company_info[:company_name]
        vcard_info[:title] = personal_info[:title]
        vcard_info[:address] = "#{@company_info[:address_1]} #{@company_info[:address_2]}"
        qrcode_path = qrcode_folder + "/#{slug}.png"
        generarate_vcard_qrcode(vcard_info, qrcode_path)
        front_card.qrcode_object.image_path = qrcode_path
      end
      front_card.text_style = text_style
      personal_info_front = {}
      personal_info_front[:name]  = personal_info[:name]
      personal_info_front[:title]  = "#{personal_info[:division]}/#{personal_info[:title]}"
      personal_info_front[:email]  = personal_info[:email]
      personal_info_front[:cell]  = personal_info[:cell]
      front_card.personal_info = personal_info_front
      company_info_front =  {}
      company_info_front[:company_name] = company_info[:company_name]
      company_info_front[:address_1] = company_info[:address_1]
      company_info_front[:address_2] = company_info[:address_2]
      front_card.company_info = company_info_front
      front_card.picture_path = @project_path + "/images/#{slug}"
      front_card.logo_path = @logo_path
      front_card.set_content
      front_card
    end

    def create_back_side(personal_info, company_info)
      back_card = eval(@back_layout_rb)
      if back_card.en_qrcode_object
        en_vcard_info = {}
        en_vcard_info[:name] = personal_info[:en_name]
        slug = personal_info[:name].gsub(" ", "_")
        en_vcard_info[:email] = personal_info[:email]
        en_vcard_info[:tel] = personal_info[:cell]
        en_vcard_info[:org] = @company_info[:en_company_name]
        en_vcard_info[:title] = personal_info[:en_title]
        en_vcard_info[:address] = "#{@company_info[:en_address_1]} #{@company_info[:en_address_2]}"
        en_qrcode_path = qrcode_folder + "/#{slug}_en.png"
        generarate_vcard_qrcode(en_vcard_info, en_qrcode_path)
        back_card.qrcode_object.image_path = qrcode_path if back_card.qrcode_object
      end
      back_card.text_style = @text_style
      personal_info_back = {}
      personal_info_back[:en_fullname]  = personal_info[:en_fullname]
      personal_info_back[:en_title]  = "#{personal_info[:en_division]}/#{personal_info[:en_title]}"
      personal_info_back[:email]  = personal_info[:email]
      personal_info_back[:cell]  = personal_info[:cell]
      back_card.personal_info = personal_info_back
      company_info_back =  {}
      company_info_back[:en_company_name] = @company_info[:en_company_name]
      company_info_back[:en_address_1] = @company_info[:en_address_1]
      company_info_back[:en_address_2] = @company_info[:en_address_2]
      back_card.company_info = company_info_back
      back_card.picture_path = @project_path + "/images/#{slug}"
      back_card.logo_object.image_path = @logo_path if back_card.logo_object
      back_card.set_content
      back_card
    end

    def generarate_vcard_qrcode(vcard, output_path)
      RLayout::QrGenerator.generate(vcard, output_path)
    end

    def make_imposition(member_pdf_path)
      # puts member_pdf_path
    end

  end

end