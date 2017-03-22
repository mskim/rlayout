# encoding: utf-8

# NewsArticleMaker.
# NewsArticleMaker works with given folder with story.md, layout.rb, and images
# layout.rb defines the layout of the article.
# if layout.rb doesn't exist in article folder,
# default layout is used, "/Users/Shared/SoftwareLab/article_template/news_article.rb" is used.

NEWS_PAPER_DEFAULTS = {
  name: "Ourtown News",
  period: 'daily',
  skip_day: ['Saturday', 'Sunday'],
  paper_size: 'A2'
}


NEW_SECTION_DEFAULTS = {
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

HEADING_COLUMNS_TABLE = {
  1 => 1,
  2 => 2,
  3 => 2,
  4 => 2,
  5 => 3,
  6 => 3,
  7 => 3
}
#
# body          = '본문명조'
# body_gothic   = '본문고딕'
# heading       = '본문중제'
# quote         = '발문'
# related_story = '관력기사'
# name_tag      = '문패'
# caption_title = '사진제목'
# caption       = '사진설명'
# reporter      = '기자명'
# email         = 'email'
# top_title     = '탑제목'
# title_4_5     = '4-5단제목'
# title_3       = '3단제목'
# title_2       = '2단제목'
# title_1       = '1단제목'
# subtitle_15   = '부제15'
# subtitle_13   = '부제13'
# newsline_title = '뉴스라인제목'
# image_source   = '사진출처'

NEWSPAPER_STYLE = {
  '본문명조'  => {font: 'Times', text_size: 9.2, text_alignment: 'justified' },
  '본문고딕'  => {font: 'Helvetica', text_size: 9.2, text_alignment: 'justified' },
  '본문중제'  => {font: 'Helvetica', text_size: 9.2, text_alignment: 'left' },
  '발문'     => {font: 'Helvetica', text_size: 9.2, text_alignment: 'left' },
  '관련기사'  => {font: 'Helvetica', text_size: 9.5, text_alignment: 'left' },
  '문패'     => {font: 'Helvetica', text_size: 12, text_alignment: 'left' },
  '사진제목'  => {font: 'Helvetica', text_size: 12, text_alignment: 'left' },
  '사진설명'  => {font: 'Helvetica', text_size: 12, text_alignment: 'left' },
  '기자명'   => {font: 'Helvetica', text_size: 7, text_alignment: 'left' },
  '이메일'   => {font: 'Helvetica', text_size: 7, text_alignment: 'left' },
  '탑제목'   => {font: 'Helvetica', text_size: 46, text_alignment: 'left', space_before_in_lines: 2, text_height_in_lines: 4, space_after_in_lines: 2},
  '4-5단제목' => {font: 'Helvetica', text_size: 36, text_alignment: 'left', space_before_in_lines: 2,  text_height_in_lines: 4, space_after_in_lines: 2},
  '3단제목'  => {font: 'Helvetica', text_size: 28, text_alignment: 'left', space_before_in_lines: 2, text_height_in_lines: 4, space_after_in_lines: 2},
  '2단제목'  => {font: 'Helvetica', text_size: 26, text_alignment: 'left', space_before_in_lines: 1, text_height_in_lines: 3, space_after_in_lines: 2 },
  '1단제목'  => {font: 'Helvetica', text_size: 15, text_alignment: 'left', space_before_in_lines: 1, text_height_in_lines: 3, space_after_in_lines: 2 },
  '부제13'  => {font: 'Helvetica', text_size: 13, text_alignment: 'left', space_before_in_lines: 1, text_height_in_lines: 2, space_after_in_lines: 1 },
  '부제15'  => {font: 'Helvetica', text_size: 15, text_alignment: 'left', space_before_in_lines: 1, text_height_in_lines: 2, space_after_in_lines: 1 },
  '뉴스라인제목'  => {font: 'Helvetica', text_size: 12, text_alignment: 'left' },
  '사진출처'  => {font: 'Helvetica', text_size: 7, text_alignment: 'left' },
}


module RLayout

  class NewsArticleMaker
    attr_accessor :article_path, :template, :story_path, :image_path
    attr_accessor :news_article_box, :style, :output_path, :project_path

    def initialize(options={} ,&block)
      @story_path = options[:story_path]
      if options[:story_path]
        @story_path = options[:story_path]
        unless File.exist?(@story_path)
          puts "No story_path doen't exist !!!"
          return
        end
        @article_path = File.dirname(@story_path)
      elsif options[:article_path]
        @article_path = options[:article_path]
        unless File.directory?(@article_path)
          puts "article_path doesn't exit !!!"
          return
        end
        @story_path = Dir.glob("#{@article_path}/*[.md, .markdown]").first
        unless File.exist?(@story_path)
          puts "story_path doesn't exit !!!"
          return
        end
      end

      $ProjectPath  = @article_path
      if options[:image_path]
        @image_path = options[:image_path]
      else
        @image_path = @article_path + "/images"
      end

      if options[:output_path]
        @output_path = options[:output_path]
      else
        @output_path  = @article_path + "/output.pdf"
      end
      @svg_path  = @article_path + "/output.svg"
      if options[:template_path] && File.exist?(options[:template_path])
        @template_path = options[:template_path]
      else
        @template_path = Dir.glob("#{@article_path}/*.{rb,script,pgscript}").first
      end
      unless @template_path
        @template_path = options.fetch(:template_path, "/Users/Shared/SoftwareLab/article_template/news_style.rb")
      end
      template = File.open(@template_path,'r'){|f| f.read}
      @news_article_box       = eval(template)
      if @news_article_box.is_a?(SyntaxError)
        puts "SyntaxError in #{@template_path} !!!!"
        return
      end
      read_story
      layout_story

      if RUBY_ENGINE =="rubymotion"
        @news_article_box.save_pdf(@output_path, :jpg=>true)
      else
        @news_article_box.save_svg(@svg_path)
      end
      self
    end

    def read_story
      @story      = Story.new(@story_path).markdown2para_data
      @heading    = @story[:heading] || {}
      @title      = @heading[:title] || "Untitled"

      if @heading
        box_heading = nil
        box_heading = @news_article_box.get_heading
        if  box_heading.class == RLayout::NewsArticleHeading
          box_heading.set_heading_content(@heading)
        else
          @heading[:is_float] = true
          @news_article_box.heading(@heading)
        end
        if @heading['top_story'] || @heading['subtitle_in_head']
          # include subtitle in heading
          @news_article_box.top_story         = @heading['top_story']
          @news_article_box.subtitle_in_head  = @heading['subtitle_in_head']
        else
          @news_article_box.make_floats(@heading)
        end
      end

      @paragraphs =[]
      @story[:paragraphs].each do |para|
        para_options = {}
        para_options[:markup]         = para[:markup]
        para_options[:layout_expand]  = [:width]
        para_options[:para_string]    = para[:para_string]
        para_options[:article_type]   = "news_article"
        para_options[:text_fit]       = FIT_FONT_SIZE
        para_options[:layout_lines]   = false
        @paragraphs << NewsParagraph.new(para_options)
      end
    end

    def layout_story
      @news_article_box.adjust_overlapping_columns
      @news_article_box.layout_items(@paragraphs)
    end

    def draw_line_grids
      @graphics.each do |column|
        column.draw_line_rect
      end
    end
  end
end
