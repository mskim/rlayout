
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

module RLayout

  class NewsPublication

    attr_reader :publication_path, :name, :publication_path
    attr_reader :paper_size, :period, :page_count

    def initialize(publication_path,  options={})
      @publication_path = options[:publication_path]
      @name = options[:name]
      @paper_size = options[:paper_size] || "NEWSPAPER"
      @period = options[:period] || 'weekly' # daily, monthly weekly, sesonal, yearly
      @page_count = options[:page_count] || 4
      load_text_styles
      save_publication_info
      save_page_heading_rb
      self
    end

    def publication_info_path
      @publication_path + "/publication_info.yml"
    end

    def save_publication_info
      @publication_info_path = @publication_path + "/#{slug}"
      FileUtils.mkdir_p(@publication_path) unless File.exist?(@publication_path)
      unless File.exist?(publication_info_path)
        File.open(publication_info_path, 'w'){|f| f.write default_publication_info}
      end
    end

    def default_publication_info
      =<<~EOF
      ---
      :name: OurNews
      :period: weekly
      :page_count: 4
      :page_heading_margin_in_lines: 3
      :lines_per_grid: 7
      :body_line_height: 13.903
      :width: 1114.015
      :height: 1544.881
      :left_margin: 42.519
      :top_margin: 42.519
      :right_margin: 42.519
      :bottom_margin: 42.519
      :column_count: 6
      :grid_width: 171.49616666666668
      :grid_height: 97.322
      :article_line_draw_sides:
      - 0
      - 1
      - 0
      - 1
      :article_bottom_space_in_lines: 2
      :article_line_thickness: 0.3
      :draw_divider: false
      
      EOF
    end

    def page_heading_rb_path
      @publication_path + "/style_guide/page_heading"
    end

    def save_publication_info

    end

    def slug
      @name.gsub(" ", "_")
    end
  end



end