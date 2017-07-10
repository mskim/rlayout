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

GRID_LINE_COUNT                                          = 7
NEWS_ARTICLE_FRONT_PAGE_EXTRA_HEADING_SPACE_IN_LINES     = 3
# NEWS_ARTICLE_FRONT_PAGE_EXTRA_HEADING_SPACE_IN_LINES   = 3

NEWS_ARTICLE_HEADING_SPACE_IN_LINES                      = 3
NEWS_ARTICLE_BOTTOM_SPACE_IN_LINES                       = 2
NEWS_ARTICLE_LINE_THICKNESS                              = 0.3

NEWS_ARTICLE_FRONT_PAGE_HEADING_PDF_HEIGHT               = 8 # height of pdf image 7 + 3 lines tall wtih some space at the bottom
NEWS_ARTICLE_HEADING_PDF_HEIGHT                          = 4 # height of pdf image 4 lines tall wtih some space at the bottom


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


NEWSPAPER_STYLE = {"body"=>{"name"=>"본문명조", "font_family"=>"윤신문명조", "font"=>"YDVYSinStd", "font_size"=>9.6, "text_color"=>"blacl", "alignment"=>"justified", "tracking"=>-0.5, "space_width"=>5.0, "scale"=>100.0, "text_line_spacing"=>nil, "space_before_in_lines"=>0, "space_after_in_lines"=>0, "text_height_in_lines"=>1, "box_attributes"=>nil, "publication_id"=>1},
"body_gothic"=>{"name"=>"본문고딕", "font_family"=>"윤고딕120", "font"=>"YDVYGOStd12", "font_size"=>9.4, "text_color"=>"blacl", "alignment"=>"justified", "tracking"=>-0.5, "space_width"=>5.0, "scale"=>100.0, "text_line_spacing"=>nil, "space_before_in_lines"=>0, "space_after_in_lines"=>0, "text_height_in_lines"=>1, "box_attributes"=>nil, "publication_id"=>1},
"running_head"=>{"name"=>"본문중제", "font_family"=>"윤고딕130", "font"=>"YDVYGOStd13", "font_size"=>9.6, "text_color"=>"blacl", "alignment"=>"left", "tracking"=>-0.5, "space_width"=>5.0, "scale"=>100.0, "text_line_spacing"=>nil, "space_before_in_lines"=>0, "space_after_in_lines"=>0, "text_height_in_lines"=>1, "box_attributes"=>nil, "publication_id"=>1},
"quote"=>{"name"=>"발문", "font_family"=>"윤명조130", "font"=>"YDVYMjOStd13", "font_size"=>12.0, "text_color"=>"blacl", "alignment"=>"center", "tracking"=>-0.5, "space_width"=>6.0, "scale"=>100.0, "text_line_spacing"=>nil, "space_before_in_lines"=>0, "space_after_in_lines"=>0, "text_height_in_lines"=>1, "box_attributes"=>nil, "publication_id"=>1},
"related_story"=>{"name"=>"관련기사", "font_family"=>"윤고딕120", "font"=>"YDVYGOStd12", "font_size"=>9.4, "text_color"=>"blacl", "alignment"=>"right", "tracking"=>-0.5, "space_width"=>5.0, "scale"=>100.0, "text_line_spacing"=>nil, "space_before_in_lines"=>0, "space_after_in_lines"=>0, "text_height_in_lines"=>1, "box_attributes"=>nil, "publication_id"=>1},
"caption_title"=>{"name"=>"사진제목", "font_family"=>"윤고딕140", "font"=>"YDVYGOStd14", "font_size"=>8.0, "text_color"=>"blacl", "alignment"=>"left", "tracking"=>-0.5, "space_width"=>4.0, "scale"=>100.0, "text_line_spacing"=>nil, "space_before_in_lines"=>0, "space_after_in_lines"=>0, "text_height_in_lines"=>1, "box_attributes"=>nil, "publication_id"=>1},
"caption"=>{"name"=>"사진설명", "font_family"=>"윤고딕120", "font"=>"YDVYGOStd12", "font_size"=>8.0, "text_color"=>"blacl", "alignment"=>"left", "tracking"=>-0.5, "space_width"=>4.0, "scale"=>100.0, "text_line_spacing"=>nil, "space_before_in_lines"=>0, "space_after_in_lines"=>0, "text_height_in_lines"=>1, "box_attributes"=>nil, "publication_id"=>1},
"source"=>{"name"=>"사진출처", "font_family"=>"윤고딕120", "font"=>"YDVYGOStd12", "font_size"=>7.0, "text_color"=>"blacl", "alignment"=>"right", "tracking"=>-0.5, "space_width"=>4.0, "scale"=>80.0, "text_line_spacing"=>nil, "space_before_in_lines"=>0, "space_after_in_lines"=>0, "text_height_in_lines"=>1, "box_attributes"=>nil, "publication_id"=>1},
"reporter"=>{"name"=>"기자명", "font_family"=>"윤고딕120", "font"=>"YDVYGOStd12", "font_size"=>8.0, "text_color"=>"blacl", "alignment"=>"right", "tracking"=>-0.5, "space_width"=>5.0, "scale"=>100.0, "text_line_spacing"=>nil, "space_before_in_lines"=>0, "space_after_in_lines"=>0, "text_height_in_lines"=>1, "box_attributes"=>nil, "publication_id"=>1},
"title_main"=>{"name"=>"제목_메인", "font_family"=>"윤명조140", "font"=>"YDVYMjOStd14", "font_size"=>42.0, "text_color"=>"blacl", "alignment"=>"left", "tracking"=>-0.5, "space_width"=>21.0, "scale"=>100.0, "text_line_spacing"=>nil, "space_before_in_lines"=>2, "space_after_in_lines"=>1, "text_height_in_lines"=>3, "box_attributes"=>nil, "publication_id"=>1},
"title_4_5"=>{"name"=>"제목_4-5단", "font_family"=>"윤명조140", "font"=>"YDVYMjOStd14", "font_size"=>32.0, "text_color"=>"blacl", "alignment"=>"left", "tracking"=>-0.5, "space_width"=>18.0, "scale"=>100.0, "text_line_spacing"=>nil, "space_before_in_lines"=>2, "space_after_in_lines"=>2, "text_height_in_lines"=>3, "box_attributes"=>nil, "publication_id"=>1},
"title_3"=>{"name"=>"제목_3단", "font_family"=>"윤명조140", "font"=>"YDVYMjOStd14", "font_size"=>26.0, "text_color"=>"blacl", "alignment"=>"left", "tracking"=>-0.5, "space_width"=>13.0, "scale"=>100.0, "text_line_spacing"=>nil, "space_before_in_lines"=>2, "space_after_in_lines"=>1, "text_height_in_lines"=>2, "box_attributes"=>nil, "publication_id"=>1},
"title_2"=>{"name"=>"제목_2단", "font_family"=>"윤명조140", "font"=>"YDVYMjOStd14", "font_size"=>22.0, "text_color"=>"blacl", "alignment"=>"left", "tracking"=>-0.5, "space_width"=>11.0, "scale"=>100.0, "text_line_spacing"=>nil, "space_before_in_lines"=>2, "space_after_in_lines"=>1, "text_height_in_lines"=>2, "box_attributes"=>nil, "publication_id"=>1},
"title_1"=>{"name"=>"제목_1단", "font_family"=>"윤명조140", "font"=>"YDVYMjOStd14", "font_size"=>15.0, "text_color"=>"blacl", "alignment"=>"left", "tracking"=>-0.5, "space_width"=>7.0, "scale"=>100.0, "text_line_spacing"=>nil, "space_before_in_lines"=>2, "space_after_in_lines"=>1, "text_height_in_lines"=>2, "box_attributes"=>nil, "publication_id"=>1},
"subtitle_main"=>{"name"=>"부제_메인", "font_family"=>"윤명조140", "font"=>"YDVYMjOStd14", "font_size"=>18.0, "text_color"=>"blacl", "alignment"=>"left", "tracking"=>-0.5, "space_width"=>9.0, "scale"=>100.0, "text_line_spacing"=>6.0, "space_before_in_lines"=>1, "space_after_in_lines"=>1, "text_height_in_lines"=>2, "box_attributes"=>nil, "publication_id"=>1},
"subtitle_M"=>{"name"=>"부제_14", "font_family"=>"윤명조140", "font"=>"YDVYMjOStd14", "font_size"=>14.0, "text_color"=>"blacl", "alignment"=>"left", "tracking"=>-0.5, "space_width"=>7.0, "scale"=>100.0, "text_line_spacing"=>7.0, "space_before_in_lines"=>1, "space_after_in_lines"=>1, "text_height_in_lines"=>2, "box_attributes"=>nil, "publication_id"=>1},
"subtitle_S"=>{"name"=>"부제_12", "font_family"=>"윤명조140", "font"=>"YDVYMjOStd14", "font_size"=>12.0, "text_color"=>"blacl", "alignment"=>"left", "tracking"=>-0.5, "space_width"=>6.0, "scale"=>100.0, "text_line_spacing"=>nil, "space_before_in_lines"=>0, "space_after_in_lines"=>0, "text_height_in_lines"=>1, "box_attributes"=>nil, "publication_id"=>1},
"news_line_title"=>{"name"=>"뉴스라인_제목", "font_family"=>"윤고딕120", "font"=>"YDVYGOStd12", "font_size"=>13.0, "text_color"=>"blacl", "alignment"=>"left", "tracking"=>-0.5, "space_width"=>6.0, "scale"=>nil, "text_line_spacing"=>nil, "space_before_in_lines"=>0, "space_after_in_lines"=>0, "text_height_in_lines"=>1, "box_attributes"=>nil, "publication_id"=>1},
"brand_name"=>{"name"=>"애드_브랜드명", "font_family"=>"윤고딕130", "font"=>"YDVYMjOStd13", "font_size"=>13.0, "text_color"=>"blacl", "alignment"=>"center", "tracking"=>-0.5, "space_width"=>6.0, "scale"=>nil, "text_line_spacing"=>nil, "space_before_in_lines"=>0, "space_after_in_lines"=>0, "text_height_in_lines"=>1, "box_attributes"=>nil, "publication_id"=>1},
"name_tag-18"=>{"name"=>"문패_18", "font_family"=>"윤고딕140", "font"=>"YDVYGOStd14", "font_size"=>18.0, "color"=>"CMYK=100,60,0,0", "alignment"=>"left", "tracking"=>-0.5, "space_width"=>9.0, "scale"=>nil, "text_line_spacing"=>nil, "space_before_in_lines"=>0, "space_after_in_lines"=>0, "text_height_in_lines"=>1, "box_attributes"=>nil, "publication_id"=>1},
"name_tag-14"=>{"name"=>"문패_14", "font_family"=>"윤고딕140", "font"=>"YDVYGOStd14", "font_size"=>14.0, "text_color"=>"blacl", "alignment"=>"left", "tracking"=>-0.5, "space_width"=>7.0, "scale"=>100.0, "text_line_spacing"=>nil, "space_before_in_lines"=>0, "space_after_in_lines"=>0, "text_height_in_lines"=>1, "box_attributes"=>nil, "publication_id"=>1},
"name_tag-12"=>{"name"=>"문패_12", "font_family"=>"윤고딕140", "font"=>"YDVYGOStd14", "font_size"=>12.0, "text_color"=>"blacl", "alignment"=>"left", "tracking"=>-0.5, "space_width"=>6.0, "scale"=>nil, "text_line_spacing"=>nil, "space_before_in_lines"=>0, "space_after_in_lines"=>0, "text_height_in_lines"=>1, "box_attributes"=>nil, "publication_id"=>1},
"editor_note"=>{"name"=>"편집자주", "font_family"=>"윤고딕130", "font"=>"YDVYGOStd13", "font_size"=>8.8, "color"=>"CMYK=0,0,0,80", "alignment"=>"left", "tracking"=>-0.5, "space_width"=>5.0, "scale"=>nil, "text_line_spacing"=>nil, "space_before_in_lines"=>0, "space_after_in_lines"=>0, "text_height_in_lines"=>1, "box_attributes"=>nil, "publication_id"=>1}}



module RLayout

  class NewsArticleMaker
    attr_accessor :article_path, :template, :story_path, :image_path
    attr_accessor :news_article_box, :style, :output_path, :project_path
    attr_reader :article_info_path, :paragraphs_copy, :fill_up_enpty_lines
    attr_accessor :custom_style, :publication_name

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
        @story_path = Dir.glob("#{@article_path}/*{.md, .markdown}").first
        if !@story_path || !File.exist?(@story_path)
          puts "story_path doesn't exit !!!"
          # return
        end
      end

      $ProjectPath      = @article_path
      @custom_style     = options[:custom_style] if options[:custom_style]
      @publication_name = options[:publication_name] if options[:publication_name]
      puts "@custom_style:#{@custom_style}"
      puts "@publication_name:#{@publication_name}"
      if @custom_style && @publication_name
        # @custom_style_path = @article_path + "/custom_style.yml"
        @custom_style_path = "/Users/Shared/SoftwareLab/newspaper_text_style" + "/#{@publication_name}.yml"
        if File.exist?(@custom_style_path)
          custom_style_yaml = File.open(@custom_style_path, 'r'){|f| f.read}
          @custom_style = YAML::load(custom_style_yaml)
          RLayout::StyleService.shared_style_service.custom_style = @custom_style
          # @custom_style_output_path = @article_path + "/custom_style.pdf"
        else
          puts "No custom style file :#{@custom_style_path} found !!!"
          return
        end
      end

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
      if @news_article_box.is_a?(NewsArticleBox)
        puts "@news_article_box is NewsArticleBox..."
        read_story
        layout_story
      elsif @news_article_box.is_a?(NewsAdBox)
        puts "@news_article_box is ad_box..."
      elsif @news_article_box.is_a?(Container)
        puts "@news_article_box is container..."
      else
        puts "@news_article_box is Graphic..."
      end

      if RUBY_ENGINE =="rubymotion"
        @news_article_box.save_pdf(@output_path, :jpg=>true)
      else
        @news_article_box.save_svg(@svg_path)
      end
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
      @news_article_box.layout_floats!
      @news_article_box.adjust_overlapping_columns
      @news_article_box.layout_items(@paragraphs)
      # @news_article_box.floats.each do |float|
      #   puts "++++++++ "
      #   puts "float.class:#{float.class}"
      #   float.puts_frame
      # end
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



#
# NEWSPAPER_STYLE = {
#   '본문명조'  => {font: 'YDVYSinStd', font_size: 9.6, alignment: 'justified', tracking: -0.5, space_width: 5.0},
#   '본문고딕'  => {font: 'YDVYGOStd12', font_size: 9.4, alignment: 'justified', space_before_in_lines: 0, text_height_in_lines: 1, space_after_in_lines: 0 },
#   '본문중제'  => {font: 'YDVYGOStd13', font_size: 9.6, alignment: 'left', space_before_in_lines: 0, text_height_in_lines: 1, space_after_in_lines: 0 },
#   '발문'     => {font: 'YDVYMjOStd12', font_size: 12.0, alignment: 'left', space_before_in_lines: 0, text_height_in_lines: 1, space_after_in_lines: 0 },
#   '관련기사'  => {font: 'YDVYGOStd12', font_size: 9.4, alignment: 'left', space_before_in_lines: 0, text_height_in_lines: 1, space_after_in_lines: 0 },
#   '문패_18'  => {font: 'YDVYGOStd14', font_size: 18.0, alignment: 'left', tracking: -0.5, space_width: 9.0, space_before_in_lines: 0, text_height_in_lines: 1, space_after_in_lines: 0 },
#   '문패_14'  => {font: 'YDVYGOStd14', font_size: 14.0, alignment: 'left', tracking: -0.5, space_width: 7.0, space_before_in_lines: 0, text_height_in_lines: 1, space_after_in_lines: 0 },
#   '문패_12'  => {font: 'YDVYGOStd14', font_size: 12.0, alignment: 'left', tracking: -0.5, space_width: 5.0, space_before_in_lines: 0, text_height_in_lines: 1, space_after_in_lines: 0 },
#   '사진제목'  => {font: 'YDVYGOStd14', font_size: 8.0, alignment: 'left', space_before_in_lines: 0, text_height_in_lines: 1, space_after_in_lines: 0},
#   '사진설명'  => {font: 'YDVYGOStd12', font_size: 8.0, alignment: 'left', space_before_in_lines: 0, text_height_in_lines: 1, space_after_in_lines: 0},
#   '기자명'   => {font: 'YDVYGOStd12', font_size: 7.0, alignment: 'right', space_before_in_lines: 0, text_height_in_lines: 1, space_after_in_lines: 0, v_offset: 3.5},
#   '이메일'   => {font: 'YDVYGOStd12', font_size: 7.0, alignment: 'left', space_before_in_lines: 0, text_height_in_lines: 1, space_after_in_lines: 0 },
#   '제목_메인'   => {font: 'YDVYMjOStd14', font_size: 46.0, alignment: 'left', space_before_in_lines: 2, text_height_in_lines: 3, space_after_in_lines: 1},
#   '제목_4-5단' => {font: 'YDVYMjOStd14', font_size: 42.0, alignment: 'left', space_before_in_lines: 2,  text_height_in_lines: 3, space_after_in_lines: 1},
#   '제목_3단'  => {font: 'YDVYMjOStd13', font_size: 28.0, alignment: 'left', space_before_in_lines: 2, text_height_in_lines: 2, space_after_in_lines: 1},
#   '제목_2단'  => {font: 'YDVYMjOStd13', font_size: 24.0, alignment: 'left', space_before_in_lines: 2, text_height_in_lines: 2, space_after_in_lines: 1},
#   '제목_1단'  => {font: 'YDVYMjOStd13', font_size: 15.0, alignment: 'left', space_before_in_lines: 2, text_height_in_lines: 2, space_after_in_lines: 1},
#   '부제_메인'   => {font: 'YDVYMjOStd14', font_size: 24.0, alignment: 'left', space_before_in_lines: 0, text_height_in_lines: 2, space_after_in_lines: 2},
#   '부제_13'  => {font: 'YDVYMjOStd12', font_size: 13.0, text_line_spacing: 6, alignment: 'left', space_before_in_lines: 0, text_height_in_lines: 2, space_after_in_lines: 1},
#   '부제_15'  => {font: 'YDVYMjOStd12', font_size: 15.0, text_line_spacing: 7, alignment: 'left', space_before_in_lines: 0, text_height_in_lines: 2, space_after_in_lines: 1},
#   '뉴스라인제목'  => {font: 'Helvetica', font_size: 13.0, alignment: 'left', space_before_in_lines: 0, text_height_in_lines: 1, space_after_in_lines: 0 },
#   '사진출처'  => {font: 'Helvetica', font_size: 7.0, alignment: 'left', space_before_in_lines: 0, text_height_in_lines: 1, space_after_in_lines: 0 },
#   "애드_브랜드명"=>{:english=>"brand_name", :font_family=>"윤고딕130", :font=>"YDVYMjOStd13", :font_size=>13.0, :color=>"", :alignment=>"center", :tracking=>-0.5, :space_width=>6.0, :scale=>nil, :text_line_spacing=>nil, :space_before_in_lines=>nil, :text_height_in_lines=>nil, :space_after_in_lines=>nil, :custom_font=>nil, :publication_id=>1},
#   "편집자주"=>{:english=>"editor_note", :font_family=>"윤고딕130", :font=>"YDVYGOStd13", :font_size=>8.8, :color=>"CMYK=0,0,0,80", :alignment=>"left", :tracking=>-0.5, :space_width=>5.0, :scale=>nil, :text_line_spacing=>nil, :space_before_in_lines=>nil, :text_height_in_lines=>nil, :space_after_in_lines=>nil, :custom_font=>nil, :publication_id=>1}
# }
#
#
# NEWSPAPER_STYLE = {
#   'body'  => {font: 'YDVYSinStd', font_size: 9.6, alignment: 'justified', tracking: -0.5, space_width: 5.0},
#   'body_gothic'  => {font: 'YDVYGOStd12', font_size: 9.4, alignment: 'justified', space_before_in_lines: 0, text_height_in_lines: 1, space_after_in_lines: 0 },
#   'running_head'  => {font: 'YDVYGOStd13', font_size: 9.6, alignment: 'left', space_before_in_lines: 0, text_height_in_lines: 1, space_after_in_lines: 0 },
#   'quote'     => {font: 'YDVYMjOStd12', font_size: 12.0, alignment: 'left', space_before_in_lines: 0, text_height_in_lines: 1, space_after_in_lines: 0 },
#   'related_story'  => {font: 'YDVYGOStd12', font_size: 9.4, alignment: 'left', space_before_in_lines: 0, text_height_in_lines: 1, space_after_in_lines: 0 },
#   'subject_head_L'  => {font: 'YDVYGOStd14', font_size: 18.0, alignment: 'left', tracking: -0.5, space_width: 9.0, space_before_in_lines: 0, text_height_in_lines: 1, space_after_in_lines: 0 },
#   'subject_head_M'  => {font: 'YDVYGOStd14', font_size: 14.0, alignment: 'left', tracking: -0.5, space_width: 7.0, space_before_in_lines: 0, text_height_in_lines: 1, space_after_in_lines: 0 },
#   'subject_head_S'  => {font: 'YDVYGOStd14', font_size: 12.0, alignment: 'left', tracking: -0.5, space_width: 5.0, space_before_in_lines: 0, text_height_in_lines: 1, space_after_in_lines: 0 },
#   'caption_title'  => {font: 'YDVYGOStd14', font_size: 8.0, alignment: 'left', space_before_in_lines: 0, text_height_in_lines: 1, space_after_in_lines: 0},
#   'caption'  => {font: 'YDVYGOStd12', font_size: 8.0, alignment: 'left', space_before_in_lines: 0, text_height_in_lines: 1, space_after_in_lines: 0},
#   'reporter'   => {font: 'YDVYGOStd12', font_size: 7.0, alignment: 'right', space_before_in_lines: 0, text_height_in_lines: 1, space_after_in_lines: 0, v_offset: 3.5},
#   'email'   => {font: 'YDVYGOStd12', font_size: 7.0, alignment: 'left', space_before_in_lines: 0, text_height_in_lines: 1, space_after_in_lines: 0 },
#   'title_main'   => {font: 'YDVYMjOStd14', font_size: 46.0, alignment: 'left', space_before_in_lines: 2, text_height_in_lines: 3, space_after_in_lines: 1},
#   'title_4_5' => {font: 'YDVYMjOStd14', font_size: 42.0, alignment: 'left', space_before_in_lines: 2,  text_height_in_lines: 3, space_after_in_lines: 1},
#   'title_3'  => {font: 'YDVYMjOStd13', font_size: 28.0, alignment: 'left', space_before_in_lines: 2, text_height_in_lines: 2, space_after_in_lines: 1},
#   'title_2'  => {font: 'YDVYMjOStd13', font_size: 24.0, alignment: 'left', space_before_in_lines: 2, text_height_in_lines: 2, space_after_in_lines: 1},
#   'title_1'  => {font: 'YDVYMjOStd13', font_size: 15.0, alignment: 'left', space_before_in_lines: 2, text_height_in_lines: 2, space_after_in_lines: 1},
#   'subtitle_main'   => {font: 'YDVYMjOStd14', font_size: 24.0, alignment: 'left', space_before_in_lines: 0, text_height_in_lines: 2, space_after_in_lines: 2},
#   'subtitle_M'  => {font: 'YDVYMjOStd12', font_size: 15.0, text_line_spacing: 7, alignment: 'left', space_before_in_lines: 0, text_height_in_lines: 2, space_after_in_lines: 1},
#   'subtitle_S'  => {font: 'YDVYMjOStd12', font_size: 13.0, text_line_spacing: 6, alignment: 'left', space_before_in_lines: 0, text_height_in_lines: 2, space_after_in_lines: 1},
#   'news_line_title'  => {font: 'Helvetica', font_size: 13.0, alignment: 'left', space_before_in_lines: 0, text_height_in_lines: 1, space_after_in_lines: 0 },
#   'source'  => {font: 'Helvetica', font_size: 7.0, alignment: 'left', space_before_in_lines: 0, text_height_in_lines: 1, space_after_in_lines: 0 },
#   "brand_name"=>{:english=>"brand_name", :font_family=>"윤고딕130", :font=>"YDVYMjOStd13", :font_size=>13.0, :color=>"", :alignment=>"center", :tracking=>-0.5, :space_width=>6.0, :scale=>nil, :text_line_spacing=>nil, :space_before_in_lines=>nil, :text_height_in_lines=>nil, :space_after_in_lines=>nil, :custom_font=>nil, :publication_id=>1},
#   "editor_note"=>{:english=>"editor_note", :font_family=>"윤고딕130", :font=>"YDVYGOStd13", :font_size=>8.8, :color=>"CMYK=0,0,0,80", :alignment=>"left", :tracking=>-0.5, :space_width=>5.0, :scale=>nil, :text_line_spacing=>nil, :space_before_in_lines=>nil, :text_height_in_lines=>nil, :space_after_in_lines=>nil, :custom_font=>nil, :publication_id=>1}
# }
#
