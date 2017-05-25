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

NEWS_ARTICLE_FRONT_PAGE_EXTRA_HEADING_SPACE_IN_LINES     = 3
NEWS_ARTICLE_FRONT_PAGE_EXTRA_HEADING_HEIGHT_IN_LINES    = 2
NEWS_ARTICLE_HEADING_SPACE_IN_LINES                      = 3
GRID_LINE_COUNT                                          = 7
NEWS_ARTICLE_BOTTOM_SPACE_IN_LINES                       = 2
NEWS_ARTICLE_LINE_THICKNESS                              = 0.3

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
  '본문고딕'  => {font: 'YDVYGOStd125', text_size: 9.4, text_alignment: 'justified', space_before_in_lines: 0, text_height_in_lines: 1, space_after_in_lines: 0 },
  '본문중제'  => {font: 'YDVYGOStd135', text_size: 9.6, text_alignment: 'left', space_before_in_lines: 0, text_height_in_lines: 1, space_after_in_lines: 0 },
  '발문'     => {font: 'YDVYMjOStd125', text_size: 12.0, text_alignment: 'left', space_before_in_lines: 0, text_height_in_lines: 1, space_after_in_lines: 0 },
  '관련기사'  => {font: 'YDVYGOStd125', text_size: 9.4, text_alignment: 'left', space_before_in_lines: 0, text_height_in_lines: 1, space_after_in_lines: 0 },
  '문패'     => {font: 'YDVYGOStd145', text_size: 12.0, text_alignment: 'left', space_before_in_lines: 0, text_height_in_lines: 1, space_after_in_lines: 0 },
  '사진제목'  => {font: 'YDVYGOStd145', text_size: 8.0, text_alignment: 'left', space_before_in_lines: 0, text_height_in_lines: 1, space_after_in_lines: 0},
  '사진설명'  => {font: 'YDVYGOStd125', text_size: 8.0, text_alignment: 'left', space_before_in_lines: 0, text_height_in_lines: 1, space_after_in_lines: 0},
  '기자명'   => {font: 'YDVYGOStd125', text_size: 7.0, text_alignment: 'right', space_before_in_lines: 0, text_height_in_lines: 1, space_after_in_lines: 0, v_offset: 3.5},
  '이메일'   => {font: 'YDVYGOStd125', text_size: 7.0, text_alignment: 'left', space_before_in_lines: 0, text_height_in_lines: 1, space_after_in_lines: 0 },
  '탑제목'   => {font: 'YDVYMjOStd145', text_size: 46.0, text_alignment: 'left', space_before_in_lines: 2, text_height_in_lines: 3, space_after_in_lines: 1},
  '탑부제'   => {font: 'YDVYMjOStd145', text_size: 24.0, text_alignment: 'left', space_before_in_lines: 0, text_height_in_lines: 2, space_after_in_lines: 2},
  '4-5단제목' => {font: 'YDVYMjOStd145', text_size: 42.0, text_alignment: 'left', space_before_in_lines: 2,  text_height_in_lines: 3, space_after_in_lines: 2},
  '3단제목'  => {font: 'YDVYMjOStd135', text_size: 28.0, text_alignment: 'left', space_before_in_lines: 2, text_height_in_lines: 2, space_after_in_lines: 1},
  '2단제목'  => {font: 'YDVYMjOStd135', text_size: 24.0, text_alignment: 'left', space_before_in_lines: 2, text_height_in_lines: 2, space_after_in_lines: 1},
  '1단제목'  => {font: 'YDVYMjOStd135', text_size: 15.0, text_alignment: 'left', space_before_in_lines: 2, text_height_in_lines: 2, space_after_in_lines: 1},
  '부제13'  => {font: 'YDVYMjOStd125', text_size: 13.0, text_line_spacing: 6, text_alignment: 'left', space_before_in_lines: 0, text_height_in_lines: 2, space_after_in_lines: 1},
  '부제15'  => {font: 'YDVYMjOStd125', text_size: 15.0, text_line_spacing: 7, text_alignment: 'left', space_before_in_lines: 0, text_height_in_lines: 2, space_after_in_lines: 1},
  '뉴스라인제목'  => {font: 'Helvetica', text_size: 13.0, text_alignment: 'left', space_before_in_lines: 0, text_height_in_lines: 1, space_after_in_lines: 0 },
  '사진출처'  => {font: 'Helvetica', text_size: 7.0, text_alignment: 'left', space_before_in_lines: 0, text_height_in_lines: 1, space_after_in_lines: 0 },
  #기자사진_설명
}

module RLayout

  class NewsArticleMaker
    attr_accessor :article_path, :template, :story_path, :image_path
    attr_accessor :news_article_box, :style, :output_path, :project_path
    attr_reader :article_info_path, :paragraphs_copy, :fill_up_enpty_lines

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
        if options[:fill_up_enpty_lines]
          @paragraphs_copy = @paragraphs.dup
        end
        layout_story
        puts "@news_article_box.underflow:#{@news_article_box.underflow}"
        if options[:fill_up_enpty_lines]
          if @news_article_box.underflow
            fill_with_paragraphs
            @news_article_box.save_appened_story
          end
        end
      end
      if RUBY_ENGINE =="rubymotion"
        @news_article_box.save_pdf(@output_path, :jpg=>true)
      else
        @news_article_box.save_svg(@svg_path)
      end
      # end
      self
    end

    def read_story
      @story                  = Story.new(@story_path).markdown2para_data
      @heading                = @story[:heading] || {}
      @title                  = @heading[:title] || "Untitled"
      @heading[:is_front_page]= @news_article_box.is_front_page
      @heading[:top_story]    = @news_article_box.top_story
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

    # copy current_;pargraphs until qwh hAVE 1 line for reposter
    def fill_with_paragraphs
      puts __method__
      puts "@paragraphs_copy.length:#{@paragraphs_copy.length}"

      # story_path          = "#{$ProjectPath}/story.md"
      # need_chars          = average_characters_per_line*(@empty_lines - 1)
      # base_string         = "여기는 본문이 입니다. "
      # string_half_length  = base_string.length/2
      # target_chart_count  = need_chars - string_half_length
      # puts "target_chart_count:#{target_chart_count}"
      # sample_string       = "\n\n" + base_string
      # count = 0
      # while  sample_string.length < target_chart_count && count < 100 do
      #   sample_string += base_string
      #   count +=1
      #   mutiples = count % 20
      #   if mutiples == 0
      #     sample_string +="\n\n"
      #   end
      # end
      # sample_string += "\n\n\# 홍깅돌 기자 gdhong@naver.com"
      # story = File.open(story_path, 'r'){|f| f.read}
      # story += sample_string
      # File.open(story_path, 'w'){|f| f.write story}
    end

    def draw_line_grids
      @graphics.each do |column|
        column.draw_line_rect
      end
    end
  end
end
