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
    attr_reader :page_number, :date, :issue_number

    def initialize(page_path, options={})
      @page_path = page_path
      @basename = File.basename(@page_path)
      @page_number = @basename.split("_")[1].to_i
      @date = File.basename(issue_path)
      load_publication_info
      load_issue_plan
      create_pillar_map
      generate_article_pdf
      generate_page_heading
      merge_page_pdf
      self
    end

    def issue_path
      File.dirname(@page_path)
    end

    def issue_plan_path
      issue_path + "/issue_plan.yml"
    end   

    def publication_path
      File.dirname(issue_path)
    end

    def publication_info_path
      publication_path + "/publication_info.yml"
    end    

    def default_publication_info
      h = {}
      h[:page_heading_margin_in_lines] = 3
      h[:lines_per_grid] = 7
      h[:body_line_height] = 13.903 # ???
      h[:width] = 1114.015
      h[:height] = 1544.881
      h[:left_margin] = 42.519
      h[:top_margin] = 42.519
      h[:right_margin] = 42.519
      h[:bottom_margin] = 42.519
      h[:column_count] = 6
      h[:grid_width] = (h[:width] - h[:left_margin] - h[:right_margin])/h[:column_count]
      h[:grid_height] = (h[:height] - h[:top_margin] - h[:bottom_margin])/15 
      # h[:grid_width] = 146.996
      # h[:grid_height] = 97.322
      h[:article_line_draw_sides] = [0, 1, 0, 1]
      h[:article_bottom_space_in_lines] = 2
      h[:article_line_thickness] = 0.3
      h[:draw_divider] = false
      h
    end

    def default_issue_plan
      <<~EOF

      ---
      date: #{@date}
      pages:
      - page_number: 1
        section_name: 1면
        pillars: [[4,2], [2,3]]
        ad_type: 5단통
        advertiser: 삼성전자
      - page_number: 2
        section_name: 소식
        pillars: [[2,3], [2,3], [2,3]]
      - page_number: 3
        section_name: 소식
        pillars: [[2,3], [2,3], [2,3]]
      - page_number: 4
        section_name: 전면광고
        ad_type: 15단통
        advertiser: LG전자

      EOF
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

    def load_issue_plan
      if File.exist?(issue_plan_path)
        @issue_plan = YAML::load_file(issue_plan_path)
      else
        @issue_plan = default_issue_plan
        File.open(issue_plan_path, 'w'){|f| f.write default_issue_plan.to_yaml}
      end
      @issue_number = @issue_plan[:issue_number] || @issue_plan['issue_number'] 
    end
    # create_pillar_map and save it in page config.yml
    # update layout_rb for each article by pillar

    # select article folders, do not include heading folder
    # filter out heading folder using grep
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
      page_info = @issue_plan['pages'][@page_number-1]
      pillar_width = page_info['pillars'].map{|p| p[0]} if page_info['pillars']
      h = {}
      h[:section_name] = page_info['section_name']
      h[:page_number] = @page_number || 1
      h[:pillar_width] = pillar_width
      h[:page_heading_margin_in_lines] = 3
      h[:page_heading_margin_in_lines] = 10 if h[:page_number] == 1
      h[:pillar_map] = @pillar_map
      h[:ad_type] = '5단통'
      h
    end

    def style_guide_folder
      publication_path + "/style_guide"
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

    def heading_bg_image_path
      publication_path + "/heading_bg_image"
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

    def generate_page_heading
      RLayout::NewsHeading.new(heading_path, page_number: @page_number, date:@date, issue_number: @issue_number)
    end

    # generate layout.rb for articles
    # and generate pdf for page articles
    def generate_article_pdf
      @pillar_map.each_with_index do |pillar, pillar_index|
        next if pillar == []
        #TODO fix this pillar[:rows] || 10
        # for front_page with 5단통 광고
        pillar_height_in_grid = 9 
        article_count = pillar.length
        binding.pry if  article_count == 0
        article_rows = (pillar_height_in_grid/article_count).to_i
        remainder = pillar_height_in_grid % article_count
        layout_options = article_base_info.dup
        layout_options[:column] = page_config[:pillar_width][pillar_index] # @pillar_width[pillar_index
        binding.b unless layout_options[:column]
        layout_options[:on_left_edge] = true if pillar_index == 0
        layout_options[:on_right_edge] = true if pillar_index + 1 == @pillar_map.length
        pillar.each_with_index do |article, article_index|
          # filtere heading folder
          next unless article=~/\d\d$/
          # layout_path = article + "/layout.yml"
          layout_rb_path = article + "/layout.rb"
          article_info = layout_options
          article_info[:pillar_order] = pillar_index + 1
          article_info[:order] = article_index + 1
          article_info[:row] = article_rows
          article_info[:row] += 1 if article_index < remainder 
          article_info[:top_story] = true if @page_number == 1 && article_index == 0 && pillar_index ==0
          article_info[:top_position] = true if article_index == 0
          article_info[:article_bottom_space_in_lines] = 2
          article_info[:gutter] = 12.759
          article_info[:page_heading_margin_in_lines] = 3
          article_info[:article_line_draw_sides] = '[0, 0, 0, 1]'
          layout_rb = layout_tempalte(article_info)
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

    # RLayout::NewsArticleBox.new({:kind=>"기고", :reporter=>"홍길동", :column=>4, :row=>5, :grid_width=>171.49606299212363, :grid_height=>97.32283464566795, :gutter=>12.755905511810848, :on_left_edge=>true, :on_right_edge=>false, :is_front_page=>false, :top_story=>true, :top_position=>true, :bottom_article=>false, :page_heading_margin_in_lines=>4, :article_bottom_spaces_in_lines=>2, :article_line_draw_sides=>"[0, 0, 0, 1]", :article_line_thickness=>0.3, :draw_divider=>nil}) do
    #   news_image({:image_path=>"/Users/mskim/Development/style_guide/public/1/opinion/홍길동.pdf", :column=>1, :row=>1, :extra_height_in_lines=>5, :stroke_width=>0, :position=>1, :is_float=>true, :fit_type=>4, :before_title=>true, :layout_expand=>nil})
    # end
    def layout_tempalte(layout_options)
      <<~EOF
      RLayout::NewsArticleBox.new(#{layout_options})

      EOF
    end


  end

end