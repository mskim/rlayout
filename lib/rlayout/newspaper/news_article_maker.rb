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

NEWS_ARTICLE_BOTTOM_SPACE_IN_LINES  = 2
NEWS_ARTICLE_TOP_SPACE_IN_LINES     = 1
NEWS_ARTICLE_LINE_THICKNESS         = 0.3
GRID_LINE_COUNT                     = 7

NEW_SECTION_DEFAULTS = {
  :width        => 1116.85, # 393 x 2.834646 = 1116.85
  :height       => 1539.21, # 545 x 2.834646 = 1539.21
  :grid         => [7, 12],
  :lines_in_grid=> 7,
  :gutter       => 10,
  :divider      => 20,
  :left_margin  => 42.52,      # 15 x 2.834646 = 42.52
  :top_margin   => 42.52,
  :right_margin => 42.52,
  :bottom_margin=> 42.52,
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

REGULAR_ARTICLE                       = 0
REGULAR_ARTICLE_AT_TOP_ROW            = 1
REGULAR_ARTICLE_AT_TOP_ROW_FRONT_PAGE = 2
MAIN_ARTICLE                          = 3
MAIN_ARTICLE_FRONT_PAGE               = 4

#
# body          = '본문명조'
# body_gothic   = '본문고딕'
# heading       = '본문중제'
# quote         = '발문'
# related_story = '관력기사'
# subject_head   = '문패'
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
  '본문명조'  => {font: 'YDVYSinStd', text_size: 9.6, text_alignment: 'justified', text_tracking: -0.5 },
  '본문고딕'  => {font: 'Helvetica', text_size: 9.2, text_alignment: 'justified', space_before_in_lines: 0, text_height_in_lines: 1, space_after_in_lines: 0 },
  '본문중제'  => {font: 'Helvetica', text_size: 9.2, text_alignment: 'left', space_before_in_lines: 0, text_height_in_lines: 1, space_after_in_lines: 0 },
  '발문'     => {font: 'Helvetica', text_size: 9.2, text_alignment: 'left', space_before_in_lines: 0, text_height_in_lines: 1, space_after_in_lines: 0 },
  '관련기사'  => {font: 'Helvetica', text_size: 9.5, text_alignment: 'left', space_before_in_lines: 0, text_height_in_lines: 1, space_after_in_lines: 0 },
  '문패'     => {font: 'Helvetica', text_size: 12, text_alignment: 'left', space_before_in_lines: 0, text_height_in_lines: 1, space_after_in_lines: 0 },
  '사진제목'  => {font: 'Helvetica', text_size: 12, text_alignment: 'left', space_before_in_lines: 0, text_height_in_lines: 1, space_after_in_lines: 0},
  '사진설명'  => {font: 'Helvetica', text_size: 12, text_alignment: 'left', space_before_in_lines: 0, text_height_in_lines: 1, space_after_in_lines: 0},
  '기자명'   => {font: 'Helvetica', text_size: 7, text_alignment: 'left', space_before_in_lines: 0, text_height_in_lines: 1, space_after_in_lines: 0 },
  '이메일'   => {font: 'Helvetica', text_size: 7, text_alignment: 'left', space_before_in_lines: 0, text_height_in_lines: 1, space_after_in_lines: 0 },
  '탑제목'   => {font: 'YDVYMjOStd145', text_size: 42.0, text_alignment: 'left', space_before_in_lines: 2, text_height_in_lines: 3, space_after_in_lines: 1},
  '탑부제'   => {font: 'YDVYMjOStd145', text_size: 24, text_alignment: 'left', space_before_in_lines: 0, text_height_in_lines: 2, space_after_in_lines: 2},
  '4-5단제목' => {font: 'YDVYMjOStd145', text_size: 42.0, text_alignment: 'left', space_before_in_lines: 2,  text_height_in_lines: 3, space_after_in_lines: 2},
  '3단제목'  => {font: 'YDVYMjOStd135', text_size: 28.0, text_alignment: 'left', space_before_in_lines: 2, text_height_in_lines: 2, space_after_in_lines: 1},
  '2단제목'  => {font: 'YDVYMjOStd135', text_size: 24.0, text_alignment: 'left', space_before_in_lines: 2, text_height_in_lines: 2, space_after_in_lines: 1},
  '1단제목'  => {font: 'YDVYMjOStd135', text_size: 15.0, text_alignment: 'left', space_before_in_lines: 2, text_height_in_lines: 2, space_after_in_lines: 1},
  '부제13'  => {font: 'YDVYMjOStd125', text_size: 13.0, text_line_spacing: 6, text_alignment: 'left', space_before_in_lines: 0, text_height_in_lines: 2, space_after_in_lines: 1},
  '부제15'  => {font: 'YDVYMjOStd125', text_size: 15.0, text_line_spacing: 7, text_alignment: 'left', space_before_in_lines: 0, text_height_in_lines: 2, space_after_in_lines: 1},
  '뉴스라인제목'  => {font: 'Helvetica', text_size: 12, text_alignment: 'left', space_before_in_lines: 0, text_height_in_lines: 1, space_after_in_lines: 0 },
  '사진출처'  => {font: 'Helvetica', text_size: 7, text_alignment: 'left', space_before_in_lines: 0, text_height_in_lines: 1, space_after_in_lines: 0 },
  #기자사진_설명
}

module RLayout

  class NewsArticleMaker
    attr_accessor :article_path, :template, :story_path, :image_path
    attr_accessor :news_article_box, :style, :output_path, :project_path
    attr_reader :article_info_path

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
        if !@story_path || !File.exist?(@story_path)
          puts "story_path doesn't exit !!!"
          # return
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
      @svg_path           = @article_path + "/output.svg"
      @article_info_path  = @article_path + "/article_info.yml"
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
      if @news_article_box.is_ad_box
        # @news_article_box is ad box
        puts "@news_article_box is ad_box..."
      else
        read_story
        layout_story
      end
      if RUBY_ENGINE =="rubymotion"
        @news_article_box.save_pdf(@output_path, :jpg=>true)
      else
        @news_article_box.save_svg(@svg_path)
      end
      # if @save_article_info
        @news_article_box.save_article_info(@article_info_path)
      # end
      self
    end

    def read_story
      @story      = Story.new(@story_path).markdown2para_data
      @heading    = @story[:heading] || {}
      @title      = @heading[:title] || "Untitled"
      @heading[:top_story] = @news_article_box.top_story
      @heading[:top_position] = @news_article_box.top_position
      if @heading
        @news_article_box.make_article_heading(@heading)
        @news_article_box.make_floats(@heading)
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
