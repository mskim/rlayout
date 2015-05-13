
# Style should be defined as constants
# DEFAULT_STYLES
# custom styles should be defined in CUSTOM_STYLE and merged with DEFAULT_STYLES of its kind
# Style are defined in following keys 
#  doc_info
#  heading
#  main
#  fixtures
#  text_styles

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
  "Title"   =>{:font => 'Times',     :text_size=>24.0, :text_color => 'black', :text_alignment=>'center'},
  "title"   =>{:font => 'Times',     :text_size=>24.0, :text_color => 'black', :text_alignment=>'center'},
  "SubTitle"=>{:font => 'Times',     :text_size=>20.0, :text_color => 'black'},
  "subtitle"=>{:font => 'Times',     :text_size=>20.0, :text_color => 'black'},
  "Author"  =>{:font => 'Helvetica', :text_size=>12.0, :text_color => 'green', :text_alignment=>'right'},
  "author"  =>{:font => 'Helvetica', :text_size=>12.0, :text_color => 'green', :text_alignment=>'right'},
  "Lead"    =>{:font => 'Helvetica', :text_size=>24.0, :text_color => 'black'},
  "lead"    =>{:font => 'Helvetica', :text_size=>24.0, :text_color => 'black'},
  "Leading" =>{:font => 'Times',     :text_size=>24.0, :text_color => 'black'},
  "leading" =>{:font => 'Times',     :text_size=>24.0, :text_color => 'black'},
  "h1"      =>{:font => 'Helvetica', :text_size=>70.0, :text_color => 'black'},
  "h2"      =>{:font => 'Helvetica', :text_size=>36.0, :text_color => 'black'},
  "h3"      =>{:font => 'Helvetica', :text_size=>24.0, :text_color => 'black'},
  "h4"      =>{:font => 'Helvetica', :text_size=>16.0, :text_color => 'black'},
  "h5"      =>{:font => 'Helvetica', :text_size=>16.0, :text_color => 'black'},
  "Head"    =>{:font => 'Helvetica', :text_size=>12.0, :text_color => 'black'},
  "head"    =>{:font => 'Helvetica', :text_size=>12.0, :text_color => 'black'},
  "h6"      =>{:font => 'Helvetica', :text_size=>12.0, :text_color => 'black'},
  "p"       =>{:font => 'Times',     :text_size=>10.0, :text_line_spacing=>5, :text_alignment=>'left', :text_first_line_head_indent=>10},
  "body"    =>{:font => 'Times',     :text_size=>10.0, :text_line_spacing=>10, :text_color => 'black'},
  "caption" =>{:font => 'Times',     :text_size=>8.0, :text_color => 'black', :text_alignment=>'center'},
  "header"  =>{:font => 'Times', :text_size=>8.0, :text_color => 'black'},
  "footer"  =>{:font => 'Times', :text_size=>8.0, :text_color => 'black'},
  "page_number" =>{:font => 'Times', :text_size=>10.0, :text_color => 'black'},
}

MAGAZINE_STYLES={
  "heading_columns" => [1,2,2,2,3,4,4],
  "Title"   =>{:font => 'Times',     :text_size=>24.0, :text_color => 'yellow', :text_alignment=>'center'},
  "title"   =>{:font => 'Times',     :text_size=>24.0, :text_color => 'black', :text_alignment=>'center'},
  "SubTitle"=>{:font => 'Times',     :text_size=>20.0, :text_color => 'black'},
  "subtitle"=>{:font => 'Times',     :text_size=>20.0, :text_color => 'black'},
  "Author"  =>{:font => 'Helvetica', :text_size=>12.0, :text_color => 'green', :text_alignment=>'right'},
  "author"  =>{:font => 'Helvetica', :text_size=>12.0, :text_color => 'green', :text_alignment=>'right'},
  "Lead"    =>{:font => 'Helvetica', :text_size=>24.0, :text_color => 'black'},
  "lead"    =>{:font => 'Helvetica', :text_size=>24.0, :text_color => 'black'},
  "Leading" =>{:font => 'Times',     :text_size=>24.0, :text_color => 'black'},
  "leading" =>{:font => 'Times',     :text_size=>24.0, :text_color => 'black'},
  "h1"      =>{:font => 'Helvetica', :text_size=>70.0, :text_color => 'black'},
  "h2"      =>{:font => 'Helvetica', :text_size=>36.0, :text_color => 'black'},
  "h3"      =>{:font => 'Helvetica', :text_size=>24.0, :text_color => 'black'},
  "h4"      =>{:font => 'Helvetica', :text_size=>16.0, :text_color => 'black'},
  "h5"      =>{:font => 'Helvetica', :text_size=>16.0, :text_color => 'black'},
  "Head"    =>{:font => 'Helvetica', :text_size=>12.0, :text_color => 'black'},
  "head"    =>{:font => 'Helvetica', :text_size=>12.0, :text_color => 'black'},
  "h6"      =>{:font => 'Helvetica', :text_size=>12.0, :text_color => 'black'},
  "p"       =>{:font => 'Times',     :text_size=>10.0, :text_line_spacing=>5, :text_alignment=>'justified', :text_first_line_head_indent=>10},
  "body"    =>{:font => 'Times',     :text_size=>10.0, :text_line_spacing=>10, :text_color => 'black'},
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
}

NEWS_STYLES={
  "heading_columns" => [1,2,2,2,3,4,4],
  "title"   =>{:font => 'Times',     :text_size=>24.0, :text_color => 'black', :text_alignment=>'center',:text_line_spacing=>10 },
  "subtitle"=>{:font => 'Times',     :text_size=>16.0, :text_color => 'black'},
  "author"  =>{:font => 'Helvetica', :text_size=>10.0, :text_color => 'black', :text_alignment=>'center'},
  "lead"    =>{:font => 'Helvetica', :text_size=>18.0, :text_color => 'black', :text_alignment=>'right'},
  "Leading" =>{:font => 'Times',     :text_size=>18.0, :text_color => 'black'},
  "leading" =>{:font => 'Times',     :text_size=>18.0, :text_color => 'black'},
  "h1"      =>{:font => 'Helvetica', :text_size=>24.0, :text_color => 'black'},
  "h2"      =>{:font => 'Helvetica', :text_size=>20.0, :text_color => 'black'},
  "h3"      =>{:font => 'Helvetica', :text_size=>18.0, :text_color => 'black'},
  "h4"      =>{:font => 'Helvetica', :text_size=>12.0, :text_color => 'black'},
  "h5"      =>{:font => 'Helvetica', :text_size=>12.0, :text_line_spacing=>5, :text_color => 'black'},
  "head"    =>{:font => 'Helvetica', :text_size=>12.0, :text_line_spacing=>5, :text_color => 'black'},
  "h6"      =>{:font => 'Helvetica', :text_size=>10.0, :text_line_spacing=>5, :text_color => 'black'},
  "p"       =>{:font => 'Times',     :text_size=>9.0, :text_line_spacing=>5, :text_alignment=>'justified', :text_color => 'black', :text_alignment=>'justified'},
  "body"    =>{:font => 'Times',     :text_size=>9.0, :text_color => 'black', :text_alignment=>'justified'},
  "caption" =>{:font => 'Times',     :text_size=>8.0, :text_color => 'black', :text_alignment=>'center'},
  "header"  =>{:font => 'Times', :text_size=>8.0, :text_color => 'black'},
  "footer"  =>{:font => 'Times', :text_size=>8.0, :text_color => 'black'},
  "page_number" =>{:font => 'Times', :text_size=>10.0, :text_color => 'black'},
}

HEADING_KIND= %w[h1 h2 h3 h4 title subtitle author lead]
BODY_KIND= %w[h5 h6 p heading1 heading2 heading3 body]

@@current_style_service = nil
class StyleService
  attr_accessor :current_style, :default_style, :chapter_style, :news_style, :magazine_style
  def initialize
    @chapter_style  = CHAPTER_STYLES
    @news_style     = NEWS_STYLES
    @magazine_style = MAGAZINE_STYLES
    @default_style  = DEFAULT_STYLES
    @current_style  = default_style
    self
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
  
  def self.shared_style_service
    @@current_style_service = @@current_style_service || StyleService.new 
  end  
end