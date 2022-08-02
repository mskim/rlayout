module RLayout

  class NewsHeading
    attr_reader :heading_path, :page_path, :issue_path, :publication_path
    attr_reader :heading_height_in_lines
    attr_reader :page_number, :section_name, :issue_date, :issue_number
    attr_reader :document
    include Styleable

    def initialize(heading_path, options={})
      @heading_path = heading_path
      @page_path = File.dirname(@heading_path)
      @issue_number = options[:issue_number] || 1000
      @issue_path = File.dirname(@page_path)
      @issue_date =  File.basename(@issue_path)
      @publication_path = File.dirname(@issue_path)
      load_layout
      # load_text_style
      @document = eval(@heading_layout_rb)
      FileUtils.mkdir_p(@heading_path) unless File.exist?(@heading_path)
      File.open(heading_layout_path, 'w'){|f| f.write @heading_layout_rb}
      @document.save_pdf(heading_pdf_path)
      self
    end

    DAYS_IN_KOREAN = %w{(일) (월) (화) (수) (목) (금) (토)}

    def issue_week_day_in_korean(date)
      DAYS_IN_KOREAN[date.wday]
    end
  
    def date_string
      date = Date.parse(@issue_date)
      date.strftime("%Y%m%d")
    end
  
    def korean_date_string
      require 'date'
      date = Date.parse(@issue_date)
      # "#{date.year}년 #{date.month}월 #{date.day}일 #{issue_week_day_in_korean} (#{number}호)"
      "#{date.month}월 #{date.day}일 #{issue_week_day_in_korean(date)} #{@issue_number}호"
    end
    
    def default_text_style
      DE
      # section_name
      # date
      # page_number
      # issue_number
    end

    def heading_pdf_path
      @heading_path + "/output.pdf"
    end

    def heading_layout_path
      @heading_path + "/layout.rb"
    end

    def heading_bg_image_path
      @publication_path + "/heading_bg_image"
    end

    def front_page_heading_bg_path
      heading_bg_image_path + "/front_bg.pdf"
    end

    def odd_page_heading_bg_path
      heading_bg_image_path + "/odd_bg.pdf"
    end

    def even_page_heading_bg_path
      heading_bg_image_path + "/even_bg.pdf"
    end

    def page_config_path
      @page_path +  "/config.yml"
    end

    def load_layout
      @config_info =  YAML::load_file(page_config_path)
      @section_name = @config_info[:section_name]
      @page_number  = @config_info[:page_number]
      @issue_number = @config_info[:issue_number] || 1000
      if @page_number == 1
        @heading_layout_rb = front_page_heading_rb
      elsif @page_number.odd?
        @heading_layout_rb = odd_page_heading_rb
      else
        @heading_layout_rb = even_page_heading_rb
      end
    end

    def front_page_heading_rb
      <<~EOF
      RLayout::Container.new(width: 1028.9763779528, height: 139.0326207874, layout_direction: 'horinoztal') do
        image(image_path: '#{front_page_heading_bg_path}', x:0, y:0, width: 1028.9763779528, height: 139.0326207874)
        text('#{korean_date_string}', x: 828.00, y: 109.25, fill_color:'clear', width: 200, font: 'KoPubDotumPL', font_size: 9.5, text_color: "CMYK=0,0,0,100", text_alignment: 'right')
        image(image_path: 'heading_ad.pdf', x:809.137, y:13.043, width: 219.257, height: 71.2)
      end

      EOF
    end

    def odd_page_heading_rb
      <<~EOF
      RLayout::Container.new(width: 1028.9763779528, height: 41.70978623622, layout_direction: 'horinoztal') do
        image(image_path: '#{odd_page_heading_bg_path}', x: 0, y: 0, width: 1028.9763779528, height: 41.70978623622, fit_type: 0)
        t = text('#{@section_name}', style_name: 'section_name', font_size: 20.5, x: 464.0, y: 0, width: 100, font: 'KoPubBatangPM', text_color: "CMYK=0,0,0,100", fill_color:'clear', text_fit_type: 'fit_box_to_text', anchor_type: 'center')
        line(x: t.x, y:27.6, width: t.width, stroke_width: 1, height:0, storke_color:"CMYK=0,0,0,100")
        text('#{korean_date_string}', tracking: -0.7, x: 50, y: 12.16, width: 200, font: 'KoPubDotumPL', font_size: 10.5, text_color: "CMYK=0,0,0,100", text_alignment: 'left', fill_color: 'clear')
        text('#{@page_number}', style_name: 'page_number',  tracking: -0.2, x: 20, y: 0, font: 'KoPubDotumPL', font_size: 36, text_color: "CMYK=0,0,0,100", width: 50, height: 44, fill_color: 'clear')
      end

      EOF
    end

    def even_page_heading_rb
      <<~EOF
      RLayout::Container.new(width: 1028.9763779528, height: 41.70978623622, layout_direction: 'horinoztal') do
        image(image_path: '#{even_page_heading_bg_path}', width: 1028.9763779528, height: 41.70978623622, fit_type: 0)
        t = text('#{@section_name}', style_name: 'section_name', font_size: 20.5,x: 464.0, y: 0, width: 100, font: 'KoPubBatangPM', text_color: "CMYK=0,0,0,100", fill_color:'clear', text_fit_type: 'fit_box_to_text', anchor_type: 'center')
        line(x: t.x, y:27.6, width: t.width, stroke_width: 1, height:0, storke_color:"CMYK=0,0,0,100")
        text('#{korean_date_string}', tracking: -0.7, x: 779.213, y: 12.16,  width: 200, font: 'KoPubDotumPL', font_size: 10.5, text_color: "CMYK=0,0,0,100", text_alignment: 'right', fill_color:'clear')
        text('#{@page_number}', style_name: 'page_number', tracking: -0.2, x: 974.69, y: 0, font: 'KoPubDotumPL', font_size: 36, text_color: "CMYK=0,0,0,100", width: 50, height: 44, fill_color:'clear', text_alignment: 'right')
      end

      EOF
    end

  end

end