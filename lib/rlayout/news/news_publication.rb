module RLayout

  class NewsPublication

    attr_reader :project_path, :name, :publication_path
    attr_reader :paper_size, :period, :page_count

    def initialize(options={})
      @project_path = options[:project_path]
      @name = options[:name]
      @paper_size = options[:paper_size] || "NEWSPAPER"
      @period = options[:period] || 'weekly' # daily, monthly weekly, sesonal, yearly
      @page_count = options[:page_count] || 4
      load_text_styles
      load_layout
      save_publication_info
      save_page_heading_rb
      self
    end

    def publication_info_path
      @project_path + "/publication_info.yml"
    end

    def save_publication_info
      @publication_path = @project_path + "/#{slug}"
      FileUtils.mkdir_p(@publication_path) unless File.exist?(@publication_path)
      if File.exist?(publication_info_path)
        
      else

      end
    end

    def page_heading_rb_path
      @project_path + "/_style_guide/page_heading"
    end

    def front_page_heading_rb
      <<~EOF
      RLayout::Container.new(width: 1028.9763779528, height: 139.0326207874, layout_direction: 'horinoztal') do
        image(local_image: '1_bg.pdf', x:0, y:0, width: 1028.9763779528, height: 139.0326207874)
        text('<%= @date %>', x: 828.00, y: 109.25, fill_color:'clear', width: 200, font: 'KoPubDotumPL', font_size: 9.5, text_color: "CMYK=0,0,0,100", text_alignment: 'right')
        image(local_image: 'heading_ad.pdf', x:809.137, y:13.043, width: 219.257, height: 71.2)
      end

      EOF
    end

    def odd_page_heading_rb
      <<~EOF
      RLayout::Container.new(width: 1028.9763779528, height: 41.70978623622, layout_direction: 'horinoztal') do
        image(local_image: 'even.pdf', x: 0, y: 0, width: 1028.9763779528, height: 41.70978623622, fit_type: 0)
        t = text('<%= @section_name %>', font_size: 20.5, x: 464.0, y: 0.5, width: 100, font: 'KoPubBatangPM', text_color: "CMYK=0,0,0,100", fill_color:'clear', text_fit_type: 'fit_box_to_text', anchor_type: 'center')
        line(x: t.x, y:27.6, width: t.width, stroke_width: 1, height:0, storke_color:"CMYK=0,0,0,100")
        text('<%= @page_number %>', tracking: -0.2, x: 0, y: -6.47, font: 'Helvetica-Light', font_size: 36, text_color: "CMYK=0,0,0,100", width: 50, height: 44, fill_color: 'clear')
        text('<%= @date %>', tracking: -0.7, x: 50, y: 12.16, width: 200, font: 'KoPubDotumPL', font_size: 10.5, text_color: "CMYK=0,0,0,100", text_alignment: 'left', fill_color: 'clear')
      end

      EOF
    end

    def even_page_heading_rb
      <<~EOF
      RLayout::Container.new(width: 1028.9763779528, height: 41.70978623622, layout_direction: 'horinoztal') do
        image(local_image: 'odd.pdf', width: 1028.9763779528, height: 41.70978623622, fit_type: 0)
        t = text('<%= @section_name %>', font_size: 20.5,x: 464.0, y: 0.5, width: 100, font: 'KoPubBatangPM', text_color: "CMYK=0,0,0,100", fill_color:'clear', text_fit_type: 'fit_box_to_text', anchor_type: 'center')
        line(x: t.x, y:27.6, width: t.width, stroke_width: 1, height:0, storke_color:"CMYK=0,0,0,100")
        text('<%= @date %>', tracking: -0.7, x: 779.213, y: 12.16,  width: 200, font: 'KoPubDotumPL', font_size: 10.5, text_color: "CMYK=0,0,0,100", text_alignment: 'right', fill_color:'clear')
        text('<%= @page_number %>', tracking: -0.2, x: 974.69, y: -6.47, font: 'Helvetica-Light', font_size: 36, text_color: "CMYK=0,0,0,100", width: 50, height: 44, fill_color:'clear', text_alignment: 'right')
      end

      EOF
    end

    def save_page_heading_rb
      FileUtils.mkdir_p(page_heading_rb_path) unless File.exist?(page_heading_rb_path)
      front_path =  page_heading_rb_path + "/front_page_heading.rb"
      File.open(front_path, 'w'){|f| f.write front_page_heading_rb}
      odd_path =  page_heading_rb_path + "/odd_page_heading.rb"
      File.open(odd_path, 'w'){|f| f.write odd_page_heading_rb}
      even_path =  page_heading_rb_path + "/even_page_heading.rb"
      File.open(even_path, 'w'){|f| f.write even_page_heading_rb}
    end

    def save_publication_info

    end


    def slug
      @name.gsub(" ", "_")
    end

    def load_text_styles

    end
    
    def load_layout

    end

    def default_text_style

    end

    def default_layout_rb
      
    end

    NEWS_AD_SIZES =<<~EOF
    ---
    5단통:
      column: 6
      row: 5
    9단21:
      column: 21cm
      row: 9
    4단통:
      column: 6
      row: 4
    전면광고:
      column: 6
      row: 15
    EOF

  end



end