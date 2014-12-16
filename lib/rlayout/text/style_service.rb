
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
  "style_kind" => "DEFAULT_STYLES",
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
  "Title"   =>{:text_font => 'Times',     :text_size=>24.0, :text_color => 'black', :text_alignment=>'center'},
  "title"   =>{:text_font => 'Times',     :text_size=>24.0, :text_color => 'black', :text_alignment=>'center'},
  "SubTitle"=>{:text_font => 'Times',     :text_size=>20.0, :text_color => 'black'},
  "subtitle"=>{:text_font => 'Times',     :text_size=>20.0, :text_color => 'black'},
  "Author"  =>{:text_font => 'Helvetica', :text_size=>12.0, :text_color => 'green', :text_alignment=>'right'},
  "author"  =>{:text_font => 'Helvetica', :text_size=>12.0, :text_color => 'green', :text_alignment=>'right'},
  "Lead"    =>{:text_font => 'Helvetica', :text_size=>24.0, :text_color => 'black'},
  "lead"    =>{:text_font => 'Helvetica', :text_size=>24.0, :text_color => 'black'},
  "Leading" =>{:text_font => 'Times',     :text_size=>24.0, :text_color => 'black'},
  "leading" =>{:text_font => 'Times',     :text_size=>24.0, :text_color => 'black'},
  "h1"      =>{:text_font => 'Helvetica', :text_size=>70.0, :text_color => 'black'},
  "h2"      =>{:text_font => 'Helvetica', :text_size=>36.0, :text_color => 'black'},
  "h3"      =>{:text_font => 'Helvetica', :text_size=>24.0, :text_color => 'black'},
  "h4"      =>{:text_font => 'Helvetica', :text_size=>16.0, :text_color => 'black'},
  "h5"      =>{:text_font => 'Helvetica', :text_size=>16.0, :text_color => 'black'},
  "Head"    =>{:text_font => 'Helvetica', :text_size=>12.0, :text_color => 'black'},
  "head"    =>{:text_font => 'Helvetica', :text_size=>12.0, :text_color => 'black'},
  "h6"      =>{:text_font => 'Helvetica', :text_size=>12.0, :text_color => 'black'},
  "p"       =>{:text_font => 'Times',     :text_size=>10.0, :text_line_spacing=>5, :text_alignment=>'left', :text_first_line_head_indent=>10},
  "body"    =>{:text_font => 'Times',     :text_size=>10.0, :text_line_spacing=>10, :text_color => 'black'},
  "caption" =>{:text_font => 'Times',     :text_size=>8.0, :text_color => 'black', :text_alignment=>'center'},
  "header"  =>{:text_font => 'Times', :text_size=>8.0, :text_color => 'black'},
  "footer"  =>{:text_font => 'Times', :text_size=>8.0, :text_color => 'black'},
  "page_number" =>{:text_font => 'Times', :text_size=>10.0, :text_color => 'black'},
}

MAGAZINE_STYLES={
  "style_kind" => "MAGAZINE_STYLES",
  "heading_columns" => [1,2,2,2,3,4,4],
  "Title"   =>{:text_font => 'Times',     :text_size=>24.0, :text_color => 'yellow', :text_alignment=>'center'},
  "title"   =>{:text_font => 'Times',     :text_size=>24.0, :text_color => 'black', :text_alignment=>'center'},
  "SubTitle"=>{:text_font => 'Times',     :text_size=>20.0, :text_color => 'black'},
  "subtitle"=>{:text_font => 'Times',     :text_size=>20.0, :text_color => 'black'},
  "Author"  =>{:text_font => 'Helvetica', :text_size=>12.0, :text_color => 'green', :text_alignment=>'right'},
  "author"  =>{:text_font => 'Helvetica', :text_size=>12.0, :text_color => 'green', :text_alignment=>'right'},
  "Lead"    =>{:text_font => 'Helvetica', :text_size=>24.0, :text_color => 'black'},
  "lead"    =>{:text_font => 'Helvetica', :text_size=>24.0, :text_color => 'black'},
  "Leading" =>{:text_font => 'Times',     :text_size=>24.0, :text_color => 'black'},
  "leading" =>{:text_font => 'Times',     :text_size=>24.0, :text_color => 'black'},
  "h1"      =>{:text_font => 'Helvetica', :text_size=>70.0, :text_color => 'black'},
  "h2"      =>{:text_font => 'Helvetica', :text_size=>36.0, :text_color => 'black'},
  "h3"      =>{:text_font => 'Helvetica', :text_size=>24.0, :text_color => 'black'},
  "h4"      =>{:text_font => 'Helvetica', :text_size=>16.0, :text_color => 'black'},
  "h5"      =>{:text_font => 'Helvetica', :text_size=>16.0, :text_color => 'black'},
  "Head"    =>{:text_font => 'Helvetica', :text_size=>12.0, :text_color => 'black'},
  "head"    =>{:text_font => 'Helvetica', :text_size=>12.0, :text_color => 'black'},
  "h6"      =>{:text_font => 'Helvetica', :text_size=>12.0, :text_color => 'black'},
  "p"       =>{:text_font => 'Times',     :text_size=>10.0, :text_line_spacing=>5, :text_alignment=>'justified', :text_first_line_head_indent=>10},
  "body"    =>{:text_font => 'Times',     :text_size=>10.0, :text_line_spacing=>10, :text_color => 'black'},
  "caption" =>{:text_font => 'Times',     :text_size=>8.0, :text_color => 'black', :text_alignment=>'center'},
  "header"  =>{:text_font => 'Times', :text_size=>8.0, :text_color => 'black'},
  "footer"  =>{:text_font => 'Times', :text_size=>8.0, :text_color => 'black', :footer_margin=>30},
  "page_number" =>{:text_font => 'Times', :text_size=>10.0, :text_color => 'black'},
}

CHAPTER_STYLES={
  "style_kind" => "CHAPTER_STYLES",
  "doc_info" => {
    paper_size: "A5", 
    portrait: true,
    double_side: false,
    starts_left: true,
    width: 600,
    height: 800,
    left_margin: 50,
    top_margin: 50,
    right_margin: 50,
    bottom_margin: 100,},
  
  "heading_columns" => [1,2,3,4,4,4,4],
  "title"   =>{:text_font => 'Times',     :text_size=>18.0, :text_color => 'red', :text_alignment=>'center'},
  "subtitle"=>{:text_font => 'Times',     :text_size=>16.0, :text_color => 'black'},
  "author"  =>{:text_font => 'Helvetica', :text_size=>12.0, :text_color => 'green', :text_alignment=>'right'},
  "Lead"    =>{:text_font => 'Helvetica', :text_size=>14.0, :text_color => 'black'},
  "lead"    =>{:text_font => 'Helvetica', :text_size=>14.0, :text_color => 'black'},
  "leading" =>{:text_font => 'Times',     :text_size=>18.0, :text_color => 'black'},
  "h1"      =>{:text_font => 'Helvetica', :text_size=>18.0, :text_color => 'black'},
  "h2"      =>{:text_font => 'Helvetica', :text_size=>18.0, :text_color => 'black'},
  "h3"      =>{:text_font => 'Helvetica', :text_size=>16.0, :text_color => 'black'},
  "h4"      =>{:text_font => 'Helvetica', :text_size=>14.0, :text_color => 'black'},
  "h5"      =>{:text_font => 'Helvetica', :text_size=>12.0, :text_color => 'black', :text_line_spacing=>6, :text_alignment=>'justified', :fill_color=>"lightGray"},
  "head"    =>{:text_font => 'Helvetica', :text_size=>12.0, :text_color => 'black', :text_line_spacing=>6, :text_alignment=>'justified', :fill_color=>"lightGray"},
  "h6"      =>{:text_font => 'Helvetica', :text_size=>12.0, :text_color => 'black', :text_line_spacing=>6, :text_alignment=>'justified', :fill_color=>"lightGray", :text_head_indent=>0, :text_tail_indent=>0},
  # "p"       =>{:text_font => 'SDMyoungjo',     :text_size=>10.0, :text_line_spacing=>10, :text_alignment=>'justified', :text_first_line_head_indent=>10},
  "p"       =>{:text_font => 'smSSMyungjoP-W30',     :text_size=>10.0, :text_line_spacing=>10, :text_alignment=>'justified', :text_first_line_head_indent=>10},
  "body"    =>{:text_font => 'Times',     :text_size=>10.0, :text_line_spacing=>10, :text_alignment=>'justified', :text_first_line_head_indent=>10},
  "caption" =>{:text_font => 'Times',     :text_size=>8.0, :text_color => 'black', :text_alignment=>'center'},
  "header"  =>{:text_font => 'Times',     :text_size=>8.0, :text_color => 'black'},
  "footer"  =>{:text_font => 'Times',     :text_size=>8.0, :text_color => 'black', :footer_margin=>30},
  "page_number" =>{:text_font => 'Times', :text_size=>10.0, :text_color => 'black'},
}

NEWS_STYLES={
  "style_kind" => "NEWS_STYLES",
  "heading_columns" => [1,2,2,2,3,4,4],
  "title"   =>{:text_font => 'Times',     :text_size=>18.0, :text_color => 'gray', :text_alignment=>'center',:text_line_spacing=>10 },
  "subtitle"=>{:text_font => 'Times',     :text_size=>16.0, :text_color => 'black'},
  "author"  =>{:text_font => 'Helvetica', :text_size=>10.0, :text_color => 'black', :text_alignment=>'right'},
  "lead"    =>{:text_font => 'Helvetica', :text_size=>18.0, :text_color => 'black', :text_alignment=>'right'},
  "Leading" =>{:text_font => 'Times',     :text_size=>18.0, :text_color => 'black'},
  "leading" =>{:text_font => 'Times',     :text_size=>18.0, :text_color => 'black'},
  "h1"      =>{:text_font => 'Helvetica', :text_size=>36.0, :text_color => 'black'},
  "h2"      =>{:text_font => 'Helvetica', :text_size=>20.0, :text_color => 'black'},
  "h3"      =>{:text_font => 'Helvetica', :text_size=>18.0, :text_color => 'black'},
  "h4"      =>{:text_font => 'Helvetica', :text_size=>12.0, :text_color => 'black'},
  "h5"      =>{:text_font => 'Helvetica', :text_size=>12.0, :text_color => 'black'},
  "head"    =>{:text_font => 'Helvetica', :text_size=>18.0, :text_color => 'black'},
  "h6"      =>{:text_font => 'Helvetica', :text_size=>16.0, :text_color => 'black'},
  "p"       =>{:text_font => 'Times',     :text_size=>9.0, :text_line_spacing=>5, :text_color => 'black', :text_alignment=>'justified'},
  "body"    =>{:text_font => 'Times',     :text_size=>9.0, :text_color => 'black', :text_alignment=>'justified'},
  "caption" =>{:text_font => 'Times',     :text_size=>8.0, :text_color => 'black', :text_alignment=>'center'},
  "header"  =>{:text_font => 'Times', :text_size=>8.0, :text_color => 'black'},
  "footer"  =>{:text_font => 'Times', :text_size=>8.0, :text_color => 'black'},
  "page_number" =>{:text_font => 'Times', :text_size=>10.0, :text_color => 'black'},
}

HEADING_KIND= %w[h1 h2 h3 h4 title subtitle author lead]
BODY_KIND= %w[h5 h6 p heading1 heading2 heading3 body]
