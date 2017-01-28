
# How does styles work?
# StyleService is a singleton class object that stays around be be accessed globally by and graphics.
# StyleService has current_style instance_variable which can be set for differnt publications,
# such as chapter, magazine_article, newspaper, or default.
# We can set current_style of StyleService with custom styles at load time. This allows us to apply custom styles for different job. current_style Hash is merge with custom style.

# Style should be defined as constants
# DEFAULT_STYLES
# custom styles should be defined in CUSTOM_STYLE and merged with DEFAULT_STYLES of its kind
# Style are defined in following keys
#  doc_info
#  heading
#  main
#  fixtures
#  text_styles


# Stylea are predefined Hash tables
# They can be merged with custom styles at run time,
# making them very flexible components.
# We can define default component and override only what we need at run time.
# We can override content as well as styles.
# Operations can be achieved simply by using Hadh#merge,
# changing only those that are specified in merging Hash(custom element).

# NAMECARD_1 = {
#   doc_type: "NAMECARD",
#   page_front:{
#     image_logo: {
#       grid: [0,0,1,1],
#       image: '1.jpg'
#     },
#     stack_personal: {
#       grid: [0,0,1,1],
#       name: 'Min Soo Kim'
#       email: 'Min Soo Kim'
#     },
#     stack_company: {
#       grid: [0,0,1,1],
#       address1: '10 Some Stree',
#       address2: 'Seoul, Korea'
#     }
#   },
#
#   page_back: {
#     image_logo: {
#       grid: [0,0,1,1],
#       image: '1.jpg'
#     },
#
#     stack_personal: {
#       grid: [0,0,1,1],
#       name: 'Min Soo Kim'
#       email: 'Min Soo Kim'
#     },
#
#     stack_company: {
#       grid: [0,0,1,1],
#       address1: '10 Some Stree',
#       address2: 'Seoul, Korea'
#     }
#   },
#
#

# my_personal = {
#   name: "Jeeyoon Kim".
#   email: "some_name@gmail.com"
# }
# replace
# my_namecard = NAMECARD_1[:page_front][:stack_personal] = my_personal
# merge
# my_namecard = NAMECARD_1[:page_front][:stack_personal].merge(my_personal)



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


DEFAULT_STYLES={
  "doc_info" => {
    paper_size: "A4",
    portrait: true,
    double_side: false,
    starts_left: true,
    width: 600,
    height: 800,
    left_margin: 50,
    top_margin: 50,
    right_margin: 50,
    bottom_margin: 50,},
  "heading" => {
    "heading_columns" => [1,2,3,4,5,6,7],
    "heading_layout_length" => 1,
  },
  "main"=> {
    :column_count=>2,
  },
  "title"   =>{:font => 'Times',     :text_size=>24.0, :text_color => 'black', :text_alignment=>'center'},
  "subtitle"=>{:font => 'Times',     :text_size=>20.0, :text_color => 'black'},
  "author"  =>{:font => 'Helvetica', :text_size=>12.0, :text_color => 'black', :text_alignment=>'right'},
  "lead"    =>{:font => 'Helvetica', :text_size=>18.0, :text_color => 'gray'},
  "leading" =>{:font => 'Times',     :text_size=>18.0, :text_color => 'gray'},
  "h1"      =>{:font => 'Helvetica', :text_size=>70.0, :text_color => 'black'},
  "h2"      =>{:font => 'Helvetica', :text_size=>36.0, :text_color => 'black'},
  "h3"      =>{:font => 'Helvetica', :text_size=>24.0, :text_color => 'black'},
  "h4"      =>{:font => 'Helvetica', :text_size=>16.0, :text_color => 'darkGray'},
  "h5"      =>{:font => 'Helvetica', :text_size=>16.0, :text_color => 'darkGray'},
  "Head"    =>{:font => 'Helvetica', :text_size=>12.0, :text_color => 'black'},
  "head"    =>{:font => 'Helvetica', :text_size=>12.0, :text_color => 'black'},
  "h6"      =>{:font => 'Helvetica', :text_size=>12.0, :text_color => 'black'},
  "p"       =>{:font => 'Times',     :text_size=>10.0, :text_line_spacing=>5, :text_alignment=>'left', :text_first_line_head_indent=>10},
  "body"    =>{:font => 'Times',     :text_size=>10.0, :text_line_spacing=>5, :text_alignment=>'left', :text_first_line_head_indent=>10},
  "caption" =>{:font => 'Times',     :text_size=>8.0, :text_color => 'black', :text_alignment=>'center'},
  "header"  =>{:font => 'Times', :text_size=>8.0, :text_color => 'black'},
  "footer"  =>{:font => 'Times', :text_size=>8.0, :text_color => 'black'},
  "page_number" =>{:font => 'Times', :text_size=>10.0, :text_color => 'black'},
  "ordered_list"      =>"h5",
  "unordered_list"    =>"h5",
  "ordered_section"   =>"h5",
  "upper_alpha_list"  =>"h5",
  "ordered_list_item" => "p",
  "unordered_list_item" => "p",

}


MAGAZINE_STYLES={
  "heading_columns" => [1,2,2,2,3,4,4],
  "title"   =>{:font => 'Times',     :text_size=>24.0, :text_color => 'black', :text_alignment=>'center'},
  "subtitle"=>{:font => 'Times',     :text_size=>20.0, :text_color => 'black'},
  "author"  =>{:font => 'Helvetica', :text_size=>12.0, :text_color => 'green', :text_alignment=>'right'},
  "lead"    =>{:font => 'Helvetica', :text_size=>24.0, :text_color => 'black'},
  "leading" =>{:font => 'Times',     :text_size=>24.0, :text_color => 'black'},
  "h1"      =>{:font => 'Helvetica', :text_size=>70.0, :text_color => 'black'},
  "h2"      =>{:font => 'Helvetica', :text_size=>36.0, :text_color => 'black'},
  "h3"      =>{:font => 'Helvetica', :text_size=>24.0, :text_color => 'black'},
  "h4"      =>{:font => 'Helvetica', :text_size=>16.0, :text_color => 'darkGray'},
  "h5"      =>{:font => 'Helvetica', :text_size=>16.0, :text_color => 'darkGray'},
  "Head"    =>{:font => 'Helvetica', :text_size=>12.0, :text_color => 'black'},
  "head"    =>{:font => 'Helvetica', :text_size=>12.0, :text_color => 'black'},
  "h6"      =>{:font => 'Helvetica', :text_size=>12.0, :text_color => 'black'},
  "p"       =>{:font => 'Times',     :text_size=>10.0, :text_line_spacing=>5, :text_alignment=>'justified', :text_first_line_head_indent=>10},
  "body"    =>{:font => 'Times',     :text_size=>10.0, :text_line_spacing=>5, :text_alignment=>'justified', :text_first_line_head_indent=>10},
  "caption" =>{:font => 'Times',     :text_size=>8.0, :text_color => 'black', :text_alignment=>'center'},
  "header"  =>{:font => 'Times', :text_size=>8.0, :text_color => 'black'},
  "footer"  =>{:font => 'Times', :text_size=>8.0, :text_color => 'black', :footer_margin=>30},
  "page_number" =>{:font => 'Times', :text_size=>10.0, :text_color => 'black'},
}

CHAPTER_STYLES={
  "doc_info" => {
    paper_size:   "A5",
    portrait:     true,
    double_side:  false,
    starts_left:  true,
    width:        600,
    height:       800,
    left_margin:  50,
    top_margin:   50,
    right_margin: 50,
    bottom_margin:100,
    },
  "heading_columns" => [1,2,3,4,4,4,4],
  "title"   =>{:font => 'Times',     :text_size=>18.0, :text_color => 'red', :text_alignment=>'center'},
  "subtitle"=>{:font => 'Times',     :text_size=>16.0, :text_color => 'black'},
  "author"  =>{:font => 'Helvetica', :text_size=>12.0, :text_color => 'green', :text_alignment=>'right'},
  "Lead"    =>{:font => 'Helvetica', :text_size=>14.0, :text_color => 'black'},
  "lead"    =>{:font => 'Helvetica', :text_size=>14.0, :text_color => 'black'},
  "leading" =>{:font => 'Times',     :text_size=>18.0, :text_color => 'black'},
  "h1"      =>{:font => 'Helvetica', :text_size=>18.0, :text_color => 'black'},
  "h2"      =>{:font => 'Helvetica', :text_size=>18.0, :text_color => 'black'},
  "h3"      =>{:font => 'Helvetica', :text_size=>16.0, :text_color => 'black'},
  "h4"      =>{:font => 'Helvetica', :text_size=>14.0, :text_color => 'black'},
  "h5"      =>{:font => 'Helvetica', :text_size=>12.0, :text_color => 'black', :text_line_spacing=>6, :text_alignment=>'justified', :fill_color=>"lightGray"},
  "head"    =>{:font => 'Helvetica', :text_size=>12.0, :text_color => 'black', :text_line_spacing=>6, :text_alignment=>'justified', :fill_color=>"lightGray"},
  "h6"      =>{:font => 'Helvetica', :text_size=>12.0, :text_color => 'black', :text_line_spacing=>6, :text_alignment=>'justified', :fill_color=>"lightGray", :text_head_indent=>0, :text_tail_indent=>0},
  # "p"       =>{:font => 'SDMyoungjo',     :text_size=>10.0, :text_line_spacing=>10, :text_alignment=>'justified', :text_first_line_head_indent=>10},
  "p"       =>{:font => 'smSSMyungjoP-W30',     :text_size=>10.0, :text_line_spacing=>10, :text_alignment=>'justified', :text_first_line_head_indent=>10},
  "body"    =>{:font => 'Times',     :text_size=>10.0, :text_line_spacing=>10, :text_alignment=>'justified', :text_first_line_head_indent=>10},
  "caption" =>{:font => 'Times',     :text_size=>8.0, :text_color => 'black', :text_alignment=>'center'},
  "header"  =>{:font => 'Times',     :text_size=>8.0, :text_color => 'black'},
  "footer"  =>{:font => 'Times',     :text_size=>8.0, :text_color => 'black', :footer_margin=>30},
  "page_number" =>{:font => 'Times', :text_size=>10.0, :text_color => 'black'},
  "ordered_list"      =>"h5",
  "unordered_list"    =>"h5",
  "ordered_section"   =>"h5",
  "upper_alpha_list"  =>"h5",
  "ordered_list_item" => "p",
  "unordered_list_item" => "p",
}

NEWS_STYLES={
  "heading_columns" => [1,2,2,2,3,4,4],
  "title"   =>{:font => 'Times',     :text_size=>36.0, :text_color => 'black', :text_alignment=>'center',:text_line_spacing=>10 },
  "subtitle"=>{:font => 'Times',     :text_size=>36.0, :text_color => 'black'},
  "author"  =>{:font => 'Helvetica', :text_size=>10.0, :text_color => 'black', :text_alignment=>'center'},
  "lead"    =>{:font => 'Helvetica', :text_size=>24.0, :text_color => 'black', :text_alignment=>'right'},
  "Leading" =>{:font => 'Times',     :text_size=>24.0, :text_color => 'black'},
  "leading" =>{:font => 'Times',     :text_size=>24.0, :text_color => 'black'},
  "h1"      =>{:font => 'Helvetica', :text_size=>24.0, :text_color => 'black'},
  "h2"      =>{:font => 'Helvetica', :text_size=>20.0, :text_color => 'black'},
  "h3"      =>{:font => 'Helvetica', :text_size=>18.0, :text_color => 'black'},
  "h4"      =>{:font => 'Helvetica', :text_size=>12.0, :text_color => 'black'},
  "h5"      =>{:font => 'Helvetica', :text_size=>12.0, :text_line_spacing=>5, :text_color => 'black'},
  "head"    =>{:font => 'Helvetica', :text_size=>12.0, :text_line_spacing=>5, :text_color => 'black'},
  "h6"      =>{:font => 'Helvetica', :text_size=>10.0, :text_line_spacing=>5, :text_color => 'black'},
  "p"       =>{:font => 'Times',     :text_size=>10.0, :text_line_spacing=>5, :text_alignment=>'justified', :text_color => 'black'},
  "body"    =>{:font => 'Times',     :text_size=>10.0, :text_line_spacing=>5, :text_alignment=>'justified', :text_color => 'black'},
  "caption" =>{:font => 'Times',     :text_size=>8.0, :text_color => 'black', :text_alignment=>'center'},
  "header"  =>{:font => 'Times', :text_size=>8.0, :text_color => 'black'},
  "footer"  =>{:font => 'Times', :text_size=>8.0, :text_color => 'black'},
  "page_number" =>{:font => 'Times', :text_size=>10.0, :text_color => 'black'},
  "ordered_list"  =>{:font => 'Helvetica', :text_size=>12.0, :text_line_spacing=>5, :text_color => 'black'},
  "unordered_list"=>{:font => 'Helvetica', :text_size=>12.0, :text_line_spacing=>5, :text_color => 'black'},
  "ordered_section" =>{:font => 'Helvetica', :text_size=>12.0, :text_line_spacing=>5, :text_color => 'black'},
  "upper_alpha_list"=>{:font => 'Helvetica', :text_size=>12.0, :text_line_spacing=>5, :text_color => 'black'},
  "ordered_list_item"=>{:font => 'Helvetica', :text_size=>0.0, :text_line_spacing=>5, :text_color => 'black'},
  "unordered_list_item"=>{:font => 'Helvetica', :text_size=>0.0, :text_line_spacing=>5, :text_color => 'black'},
}

HEADING_KIND  = %w[h1 h2 h3 h4 title subtitle author lead]
BODY_KIND     = %w[h5 h6 p heading1 heading2 heading3 body]
LIST_KIND     = %w[ordered_list ordered_list_item unordered_list unordered_list_item ordered_section upper_alpha_list]

module RLayout
  class StyleService
    attr_accessor :current_style, :default_style, :chapter_style, :news_style, :magazine_style, :quiz_item_style
    def initialize
      @current_style  = DEFAULT_STYLES
      @chapter_style  = CHAPTER_STYLES
      @chapter_style_path = "/Users/Shared/SoftwareLab/article_template/chapter_style.rb"
      if File.exist?(@chapter_style_path)
        @chapter_style = eval(File.open(@chapter_style_path,'r'){|f| f.read})
      end
      @news_style     = NEWS_STYLES
      @news_style_path = "/Users/Shared/SoftwareLab/article_template/news_style.rb"
      if File.exist?(@news_style_path)
        @news_style = eval(File.open(@news_style_path,'r'){|f| f.read})
      end
      @magazine_style = MAGAZINE_STYLES
      @magazine_style_path = "/Users/Shared/SoftwareLab/article_template/magazine_style.rb"
      if File.exist?(@magazine_style_path)
        @magazine_style = eval(File.open(@magazine_style_path,'r'){|f| f.read})
      end
      @quiz_style_path = "/Users/Shared/SoftwareLab/article_template/quiz_style.rb"
      if File.exist?(@quiz_style_path)
        @quiz_item_style = eval(File.open(@quiz_style_path,'r'){|f| f.read})
      end
      self
    end

    # get the height of body text by calling size method with sample text
    #
    def current_style_body_height

    end
    # read style file from project, and update style
    def update_style_with_custom_sytle(category, path)
      unless File.exist?(path)
        puts "#{path} doesn't exist!!!"
      end
      style = YAML::load(File.open(path, 'r'){|f| f.read})
      case category
      when 'chaper'
        @chapter_style.merge!(style)
      when 'news'
        @news_style.merge!(style)
      when 'magazine'
        @magazine_style.merge!(style)
      else
        @default_style.merge!(style)
      end
    end

    @@current_style_service = nil
    def self.shared_style_service
      if !@@current_style_service
        @@current_style_service = StyleService.new
      end
      @@current_style_service
    end
  end
end
