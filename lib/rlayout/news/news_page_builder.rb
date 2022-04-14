module RLayout
  # NewsPageBuilder
  # NewsPageBuilder processes given page folder.
  # Page folder can have multiple pillars or single pillar.
  # pillar_01
  #   article_01
  #   article_02
  # pillar_02
  #   article_01
  #   article_02


  class NewsPageBuilder
    attr_reader :page_path, :pillars, :articles
    attr_reader :page_number, :date

    def initialize(options={})
      @page_path = options[:page_path]
      @page_number = File.basename(@page_path).to_i
      @date = '2022년 4월 29일 금요일 (00100호)'
      load_publication_info
      generate_page_heading
      create_pillar_map
      generate_article_pdf
      merge_page_pdf
      self
    end

    def publication_path
      File.dirname(@page_path)
    end

    def publication_info_path
      publication_path + "/publication_info.yml"
    end    

    def default_publication_info
      h = {}
      h[:page_heading_margin_in_lines] = 3
      h[:lines_per_grid] = 7
      h[:body_line_height] = 14.1222 # ???
      h[:width] = 1114.015
      h[:height] = 1544.881
      h[:grid_width] = 146.996
      h[:grid_height] = 97.322
      h[:left_margin] = 42.519
      h[:top_margin] = 42.519
      h[:right_margin] = 42.519
      h[:bottom_margin] = 42.519
      h[:gutter] = 12.755
      h[:article_line_draw_sides] = [0, 1, 0, 1]
      h[:article_bottom_space_in_lines] = 2
      h[:article_line_thickness] = 0.3
      h[:draw_divider] = false
      h
    end

    def article_base_info
      h = {}
      h[:grid_width] = @publication_info[:grid_width]
      h[:grid_height] = @publication_info[:grid_height]
      h[:gutter] = @publication_info[:gutter]
      h[:article_line_draw_sides] = @publication_info[:article_line_draw_sides]
      h[:article_bottom_space_in_lines] = @publication_info[:article_bottom_space_in_lines]
      h[:article_line_thickness] = @publication_info[:article_line_thickness]
      h[:draw_divider] = @publication_info[:draw_divider]
      h
    end

    def load_publication_info
      if File.exist?(publication_info_path)
        @publication_info = YAML::load_file(publication_info_path)
      else
        @publication_info = default_publication_info
        File.open(publication_info_path, 'w'){|f| f.write default_publication_info.to_yaml}
      end
      FileUtils.mkdir_p(style_guide_folder) unless File.exist?(style_guide_folder)      
    end

    # page has single pillar
    def process_articles_in_folder
      @articles = Dir.glob("#{@page_path}/pillar_*")

    end

    # create_pillar_map and save it in page config.yml
    # update layout_rb for each article by pillar
    # filtere heading folder
    # use Dir.glob('/usr/lib/*').grep(/\d\d$/)
    # instead of   
    # Dir.glob("#{@page_path}/*").each_with_index do |pillar_folder, i|
    #   next unless pillar_folder=~/\d\d$/
    def create_pillar_map
      @pillar_map = []
      Dir.glob("#{@page_path}/*").grep(/\d\d$/).each_with_index do |pillar_folder, i|
        articles = Dir.glob("#{pillar_folder}/*")
        @pillar_map << articles if articles != []
      end
      save_page_config
    end

    def page_config_path
      @page_path + "/config.yml"
    end

    def save_page_config
      @page_config  = page_config
      File.open(page_config_path, 'w'){|f| f.write page_config.to_yaml}
    end

    def page_config
      h = {}
      h[:section_name] = @section_name
      h[:page_number] = @page_number || 1
      h[:pillar_width] = [4,2] #@pillar_width_array
      h[:pillar_map] = @pillar_map
      h[:ad_type] = '5단통'
      h
    end

    def style_guide_folder
      publication_path + "/_style_guide"
    end

    def heading_path
      @page_path + "/heading"
    end

    def heading_pdf_path
      heading_path + "/output.pdf"
    end

    def heading_layout_path
      heading_path + "/layout.rb"
    end

    def front_page_heading_bg_path
      heading_path + "/images/1_bg.pdf"
    end

    def generate_page_heading
      if @page_number == 1
        page_heading = front_page_heading_rb
      elsif @page_number.odd?
        page_heading = front_page_heading_rb
      else
        page_heading = front_page_heading_rb
      end
      heading = eval(page_heading)
      FileUtils.mkdir_p(heading_path) unless File.exist?(heading_path)
      File.open(heading_layout_path, 'w'){|f| f.write page_heading}
      heading.save_pdf(heading_pdf_path, jpg:true)
    end

    # generate layout.rb for articles
    # and generate pdf for page articles
    def generate_article_pdf
      @pillar_map.each_with_index do |pillar, pillar_index|
        next if pillar == []
        pillar_height_in_grid = 10 # pillar[:rows] || 10
        article_count = pillar.length
        binding.pry if  article_count == 0
        article_rows = (pillar_height_in_grid/article_count).to_i
        remainder = pillar_height_in_grid % article_count
        layout_options = article_base_info.dup
        layout_options[:column] = page_config[:pillar_width][pillar_index]# @pillar_width[pillar_index
        layout_options[:on_left_edge] = true if pillar_index == 0
        layout_options[:on_right_edge] = true if pillar_index + 1 == layout_options[:columns]
        pillar.each_with_index do |article, article_index|
          # filtere heading folder
          next unless article=~/\d\d$/
          layout_path = article + "/layout.yml"
          layout_rb_path = article + "/layout.rb"

          article_info = layout_options
          article_info[:pillar_order] = pillar_index + 1
          article_info[:order] = article_index + 1
          article_info[:row] = article_rows
          article_info[:row] += 1 if article_index < remainder 
          article_info[:top_story] = true if article_index == 0 && pillar_index ==0
          article_info[:top_position] = true if article_index == 0
          article_info[:article_bottom_space_in_lines] = 2          
          article_info[:width] = layout_options[:grid_width]*layout_options[:column]
          article_info[:height] = layout_options[:grid_height]*article_info[:row]
          
          layout_rb = layout_tempalte(layout_options)
          File.open(layout_rb_path, 'w'){|f| f.write layout_rb}
          story_path = article + "/story.md"
          # TODO
          # should use diffence classes for different article_type
          # NewsEditorial, NewsOpinion, NewsBookReview, NewsObituary, NewsSpecialReport etc...
          RLayout::NewsArticle.new(document_path: article, style_guide_folder: style_guide_folder)
          
        end
      end
    end

    def merge_page_pdf
      RLayout::NewsPagePdfMerger.new(page_path: @page_path)
    end

    def layout_tempalte(layout_options)
      <<~EOF
      RLayout::NewsArticleBox.new(#{layout_options})

      EOF
    end


    def front_page_heading_rb
      <<~EOF
      RLayout::Container.new(width: 1028.9763779528, height: 139.0326207874, layout_direction: 'horinoztal') do
        image(image_path: '#{front_page_heading_bg_path}', x:0, y:0, width: 1028.9763779528, height: 139.0326207874)
        text('#{@date}', x: 828.00, y: 109.25, fill_color:'clear', width: 200, font: 'KoPubDotumPL', font_size: 9.5, text_color: "CMYK=0,0,0,100", text_alignment: 'right')
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

  end

end