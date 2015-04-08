# encoding: utf-8

NEWS_PAPER_INFO = {
  name: "Ourtown News",
  period: "daily",
  paper_size: "A2"
}

module RLayout

  class Newspaper
    attr_accessor :publication_path, :front_matter, :body_matter, :rear_matter
    attr_accessor :publication_info, :grid, :lines_in_grid, :gutter
    def initialize(publication_path, options={}, &block)
      # system("mkdir -p #{publication_path}") unless File.exists?(publication_path)
      @publication_path = publication_path
      @paper_size   = options.fetch(:paper_size,"A2")
      @width        = SIZES[@paper_size][0]
      @height       = SIZES[@paper_size][1]
      @grid         = options.fetch(:grid, [7, 12])
      @lines_in_grid= options.fetch(:lines_in_grid, 10)
      @gutter       = options.fetch(:gutter, 10)
      @v_gutter     = options.fetch(:v_gutter, 0)
      @left_margin  = options.fetch(:left_margin, 50)
      @top_margin   = options.fetch(:top_margin, 50)
      @right_margin = options.fetch(:right_margin, 50)
      @bottom_margin= options.fetch(:bottom_margin, 50)
      @grid_width   = (@width - @left_margin - @right_margin- (@grid[0]-1)*@gutter )/@grid[0]
      @grid_height  = (@height - @top_margin - @bottom_margin)/@grid[1]
      # info_path = publication_path + "/publication_info.yml"
      # File.open(info_path, 'w'){|f| f.write(NEWS_PAPER_INFO.to_yaml)} unless File.exists?(info_path)
      if block
        instance_eval(&block)
      end
      self
    end

    def publication_info
      {
        width:          @width,
        height:         @height,
        left_margin:    @left_margin,
        top_margin:     @top_margin,
        right_margin:   @right_margin,
        botoom_margin:  @bottom_margin,
        grid:           @grid,
        grid_width:     @grid_width,
        grid_height:    @grid_height,
        gutter:         @gutter,
        v_gutter:       @v_gutter,
        lines_in_grid:  @lines_in_grid,
      }
    end

    def default_publication_info
      Newspaper.default_publication_info
    end

    def self.default_publication_info
      {
        :width        => 1190.55,
        :height       => 1683.78,
        :grid         => [7, 12],
        :lines_in_grid=> 10,
        :gutter       => 10,
        :left_margin  => 50,
        :top_margin   => 50,
        :right_margin => 50,
        :bottom_margin=> 50,
      }
    end

    def page_lines
      @lines_in_grid * @grid[1]
    end

    def line_height
      (@height - @top_margin - @bottom_margin)/page_lines
    end

  end



  class NewspaperIssue
    attr_accessor :publication
    attr_accessor :issue_path, :issue_number, :issue_date
    def initialize(publication, options={})
      @publication = publication
      @issue_date  = options.fetch(:issue_date, Time.now)
      set_up
      self
    end

    def set_up
      # system("mkdir -p #{issue_path}") unless File.exists?(issue_path)
      create_sections
    end

    def create_sections

    end
  end

  # NewspaperSection is a sinlge page of a Newspaper
  # NewspaperSection can have many articles.
  # NewspaperSection can have heading part or none, depending on the setion type
  # Once the layout out of the section is set,
  # each article is layouted independently by the reporter who is working on the article.
  # each article is produced as PDF image and mergerd with rest of the articles.
  # If section layout is changed, each reporteds will have to adjust their articles to fit new new layout.

  class NewspaperSection < Page
    attr_accessor :section_path, :issue_numner, :date, :section_name
    attr_accessor :section_template
    attr_accessor :heading_info, :output_path
    attr_accessor :heading_type #none, top, left_top_box,
    attr_accessor :articles_info

    def initialize(parent_graphic, options={}, &block)
      @parent_graphic = parent_graphic
      @section_path   = options[:section_path] if options[:section_path]
      @output_path    = options[:output_path]   if options[:output_path]
      @heading_info   = options.fetch(:heading_info, {:layout_length=>1})
      @articles_info  = options[:articles_info] if options[:articles_info]
      options         = options[:page_info]     if options[:page_info]
      news_default = {:width        => 1190.55,
      :height       => 1683.78,
      :grid         => [7, 12],
      :lines_in_grid=> 10,
      :gutter       => 10,
      :left_margin  => 50,
      :top_margin   => 50,
      :right_margin => 50,
      :bottom_margin=> 50,}
      options.merge!(news_default)
      super
      # create_articles

      if block
        instance_eval(&block)
      end
      self
    end

    # def create_articles
    #   @articles = []
    #   @articles_info.each do |article_info|
    #     create_article_template(article_info)
    #   end
    # end

    # def self.generate(options={})
    #   options.merge!(Newspaper.default_publication_info)
    #   section_page = NewspaperSection.new(nil, options)
    #   section_page
    # end

    def merge_pdf_articles(options={})
      puts __method__
      # heading = Image.new(self, @heading_info) if @heading_info
      # puts "heading:#{heading}"
      @articles = Dir.glob("#{@section_path}/{*.md, *.markdown}")
      @articles.each do |article|
        @meta_data        = Story.read_metadata(article)
        frame_grid_x      = @meta_data['grid_frame'][0].to_i
        frame_grid_y      = @meta_data['grid_frame'][1].to_i
        frame_grid_width  = @meta_data['grid_frame'][2].to_i
        frame_grid_height = @meta_data['grid_frame'][3].to_i
        grid_width        = @meta_data['grid_size'][0].to_f
        grid_height       = @meta_data['grid_size'][1].to_f
        gutter            = @meta_data['gutter'].to_f || 10
        ext               = File.extname(article)
        article_info              = {}
        article_info[:image_path] = article.gsub("#{ext}", ".pdf")
        article_info[:x]          = frame_grid_x*(grid_width + gutter)
        article_info[:y]          = frame_grid_y*grid_height
        article_info[:width]      = frame_grid_width*grid_width + gutter*(frame_grid_width - 1)
        article_info[:height]     = frame_grid_height*grid_height
        article_info[:layout_expand] = nil
        # article_info[:image_fit_type] = IMAGE_FIT_TYPE_IGNORE_RATIO


	    # @articles_info.each_with_index do |article_info, i|
	      puts "article_info:#{article_info}"
	      img = Image.new(self, article_info)
	      puts "img.layout_expand:#{img.layout_expand}"
	    end

      if @output_path
        save_pdf(@output_path)
      else
        puts "No @output_path!!!"
      end
      self
    end

    # def self.process_news_story_template(options={})
    #   puts __method__
    #   puts "options:#{options}"
    #   graphic = Graphic.new(nil, options)
    #   if options[:output_path]
    #     graphic.save_pdf(options[:output_path])
    #   else
    #     puts "No @output_path!!!"
    #     return false
    #   end
    #   true
    # end

    # def self.merge_news_section_story_templates(options={})
	  #   page = Page.new(nil, width: options[:width], height: options[:height])
	  #   options[:articles_info].each_with_index do |article_info, i|
	  #     Image.new(page, article_info)
	  #   end
    #
    #   if options[:output_path]
    #     page.save_pdf(options[:output_path])
    #   else
    #     puts "No @output_path!!!"
    #     return false
    #   end
    #   true
    # end

    # def process_news_article_markdown_files(file_list)
    #   file_list.each do |m|
    #     result = convert_markdown2pdf(m, options)
    #     options[:starting_page_number] = result.next_chapter_starting_page_number if result
    #   end
    # end

    # def convert_markdown2pdf(markdown_path, options={})
    #   pdf_path = markdown_path.gsub(".markdown", ".pdf")
    #   title = File.basename(markdown_path, ".markdown")
    #   article = NewsArticle.new(:title =>title, :story_path=>markdown_path)
    #   article.save_pdf(pdf_path)
    #   article
    # end

    # def txt2markdown
    #   Dir.glob("#{@section_path}/*.txt") do |m|
    #     convert_txt2markdown(m)
    #   end
    # end

    def normalize_filenames
      new_names = []
      Dir.glob("#{@section_path}/*") do |m|
        basename = File.basename(m)
        if basename =~ /^\d+/
          r= /^\d*/
          matching_string = (basename.match r).to_s
          long_digit = make_long_ditit(matching_string, 3)
          new_base = basename.sub(matching_string, long_digit)
          new_path = @section_path + "/#{new_base}"
          puts m
          puts new_path
          # system("mv #{m} #{new_path}")
        end
      end
      new_names
    end
  end
end
