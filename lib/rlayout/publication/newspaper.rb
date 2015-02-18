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
    def initialize(publication_path, options={})
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
    
  class NewspaperSection < Page
    attr_accessor :section_path, :issue_numner, :date, :section_name
    attr_accessor :section_template
    attr_accessor :heading_info, :output_path
    attr_accessor :heading_type, :is_template #top, side_box, none, 
    def initialize(parent_graphic, options={})
      puts "options:#{options}"
      @parent_graphic = parent_graphic
      @section_path   = options[:section_path] if options[:section_path]
      @output_path    = options[:output_path]   if options[:output_path]
      if options[:is_template]
        super
        @is_template = true
        return self
      end
      #TODO
      @heading_info   = options.fetch(:heading_info, {:layout_length=>1}) 
      # @heading_info[:image_fit_type] = IMAGE_FIT_TYPE_IGNORE_RATIO
      # @heading_info[:layout_expand] = [:width,:height]
      @main_info      = options.fetch(:main_info, {:layout_expand=>11})
      @articles_info  = options[:articles_info] if options[:articles_info]
      options         = options[:page_info]     if options[:page_info]
      super
      # create_folder
      # create_articles
      self
    end
    
    def create_articles
      @articles = []
      copy_template
    end
    
    def copy_template
      
    end
    
    def set_up
      
    end
    
    def self.sample_page(options={})
      options[:show_grid] = true
      options.merge!(Newspaper.default_publication_info)
      section_page = NewspaperSection.new(nil, options)
      if options[:output_path]
        section_page.save_pdf(options[:output_path])
      end
      section_page
    end
    
    def merge_pdf_articles(options={})
      puts __method__
      # heading = Image.new(self, @heading_info) if @heading_info
      # puts "heading:#{heading}"
      # puts "@main_info:#{@main_info}"
	    main = Container.new(self, @main_info) 
	    relayout!
	    @articles_info.each_with_index do |article_info, i|
	      puts "article_info:#{article_info}"
	      img = Image.new(main, article_info)
	      puts "img.layout_expand:#{img.layout_expand}"
	    end
	    
      if @output_path
        save_pdf(@output_path)
      else
        puts "No @output_path!!!"
      end
      self
    end
    
    def self.process_news_story_template(options={})
      puts __method__
      puts "options:#{options}"
      graphic = Graphic.new(nil, options)
      if options[:output_path]
        graphic.save_pdf(options[:output_path])
      else
        puts "No @output_path!!!"
        return false
      end
      true
    end
    
    def self.merge_news_section_story_templates(options={})
	    page = Page.new(nil, width: options[:width], height: options[:height]) 
	    options[:articles_info].each_with_index do |article_info, i|
	      Image.new(page, article_info)
	    end
	    
      if options[:output_path]
        page.save_pdf(options[:output_path])
      else
        puts "No @output_path!!!"
        return false
      end
      true
    end
    
    def process_news_article_markdown_files(file_list)
      file_list.each do |m|
        result = convert_markdown2pdf(m, options)
        options[:starting_page_number] = result.next_chapter_starting_page_number if result
      end
    end
    
    def convert_markdown2pdf(markdown_path, options={})
      pdf_path = markdown_path.gsub(".markdown", ".pdf")
      title = File.basename(markdown_path, ".markdown")
      article = NewsArticle.new(:title =>title, :story_path=>markdown_path)
      article.save_pdf(pdf_path)
      article
    end
    
    def txt2markdown
      Dir.glob("#{@section_path}/*.txt") do |m|
        convert_txt2markdown(m)
      end
    end
      
    def rtf2md(path)
      
    end
    
    def convert_txt2markdown(txt_path)
      txt_content = File.open(txt_path, 'r'){|f| f.read}
      title = File.basename(txt_path, ".txt")
      markdown_path = txt_path.gsub(".txt", ".markdown")
      yaml_header = <<EOF
---
title: #{title}
---

EOF
      with_yaml_header = yaml_header + "\n" + txt_content
      File.open(markdown_path, "w"){|f| f.write with_yaml_header}
      
    end
    
    def self.rtf2md(path)
      
    end
        
    #TODO
    # breaks for digit that are already 3 digits or more
    # breaks for filenames with space 
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
