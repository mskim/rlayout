
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

DEFAULT_STYLES=<<EOF
---
body:
  korean_name: 본문명조
  category:
  font_family: Shinmoon
  font: Shinmoon
  font_size: 9.8
  text_color: CMYK=0,0,0,100
  alignment: justified
  tracking: -0.4
  space_width: 3.0
  scale: 98.0
  text_line_spacing:
  space_before_in_lines:
  space_after_in_lines:
  text_height_in_lines:
  box_attributes: ''
  markup: ''
  graphic_attributes: ''
body_gothic:
  korean_name: 본문고딕
  category:
  font_family: KoPub돋움체_Pro Light
  font: KoPubDotumPL
  font_size: 9.6
  text_color: CMYK=0,0,0,100
  alignment: justified
  tracking: -0.2
  space_width: 3.0
  scale: 100.0
  first_line_indent: 0
  text_line_spacing:
  space_before_in_lines:
  space_after_in_lines:
  text_height_in_lines:
  box_attributes: ''
  markup: ''
  graphic_attributes: ''
running_head:
  korean_name: 본문중제
  category:
  font_family: KoPub돋움체_Pro Medium
  font: KoPubDotumPM
  font_size: 9.6
  text_color: CMYK=0,0,0,100
  alignment: left
  tracking: -0.2
  space_width: 3.0
  scale: 100.0
  text_line_spacing:
  space_before_in_lines: 1
  space_after_in_lines:
  text_height_in_lines:
  box_attributes: ''
  markup: ''
  graphic_attributes: ''
quote:
  korean_name: 발문
  category:
  font_family: KoPub바탕체_Pro Medium
  font: KoPubBatangPM
  font_size: 12.0
  text_color: CMYK=0,0,0,100
  alignment: left
  tracking: -0.5
  space_width: 6.0
  scale: 100.0
  text_line_spacing: 2
  space_before_in_lines: 2
  space_after_in_lines: 0
  text_height_in_lines: 1
  box_attributes: ''
  markup: ''
  graphic_attributes: ''
announcement_1:
  korean_name: 안내문1단
  category:
  font: KoPubDotumPM
  font_size: 12.0
  text_color: CMYK=0,0,0,0
  alignment: left
  tracking: -0.5
  space_width: 6.0
  scale: 100.0
  text_line_spacing:
  space_before_in_lines: 2
  space_after_in_lines: 0
  text_height_in_lines: 1
  box_attributes: ''
  markup: ''
  graphic_attributes: ''
announcement_2:
  korean_name: 안내문2단
  category:
  font: KoPubDotumPM
  font_size: 9.6
  text_color: CMYK=0,0,0,0
  alignment: left
  tracking: -0.5
  space_width: 6.0
  scale: 100.0
  text_line_spacing:
  space_before_in_lines: 2
  space_after_in_lines: 0
  text_height_in_lines: 1
  box_attributes: ''
  markup: ''
  graphic_attributes: ''
  publication_id: 1s
related_story:
  korean_name: 관련기사
  category:
  font_family: KoPub돋움체_Pro Medium
  font: KoPubDotumPM
  font_size: 9.0
  text_color: CMYK=0,0,0,100
  alignment: right
  tracking: -0.5
  space_width: 3.0
  scale: 100.0
  text_line_spacing:
  space_before_in_lines:
  space_after_in_lines:
  text_height_in_lines:
  box_attributes: ''
  markup: ''
  graphic_attributes: ''
caption_title:
  korean_name: 사진제목
  category:
  font_family: KoPub돋움체_Pro Bold
  font: KoPubDotumPB
  font_size: 9.0
  text_color: CMYK=0,0,0,100
  alignment: left
  tracking: -0.2
  space_width: 2.0
  scale: 100.0
  text_line_spacing:
  space_before_in_lines:
  space_after_in_lines:
  text_height_in_lines:
  box_attributes: ''
  markup: ''
  graphic_attributes: ''
caption:
  korean_name: 사진설명
  category:
  font_family: KoPub돋움체_Pro Light
  font: KoPubDotumPL
  font_size: 7.5
  text_color: CMYK=0,0,0,100
  alignment: justified
  tracking: -0.5
  space_width: 1.0
  scale: 100.0
  text_line_spacing:
  space_before_in_lines:
  space_after_in_lines:
  text_height_in_lines:
  box_attributes: ''
  markup: ''
  graphic_attributes: ''
source:
  korean_name: 사진출처
  category:
  font_family: KoPub돋움체_Pro Light
  font: KoPubDotumPL
  font_size: 7.5
  text_color: CMYK=0,0,0,100
  alignment: right
  tracking: -0.2
  space_width: 2.0
  scale: 70.0
  text_line_spacing:
  space_before_in_lines:
  space_after_in_lines:
  text_height_in_lines:
  box_attributes: ''
  markup: ''
  graphic_attributes: ''
author:
  korean_name: 저자명
  category:
  font_family: KoPub돋움체_Pro Light
  font: KoPubDotumPL
  font_size: 10.0
  text_color: CMYK=0,0,0,100
  alignment: right
  tracking: 0.0
  space_width: 2.0
  scale: 100.0
  text_line_spacing:
  space_before_in_lines: 0
  space_after_in_lines:
  text_height_in_lines:
  box_attributes: ''
  markup: ''
  graphic_attributes: ''
linked_story:
  korean_name: 연결기사
  category:
  font_family: KoPub돋움체_Pro Light
  font: KoPubDotumPL
  font_size: 7.0
  text_color: CMYK=0,0,0,100
  alignment: right
  tracking: 0.0
  space_width: 2.0
  scale: 100.0
  text_line_spacing:
  space_before_in_lines: 0
  space_after_in_lines:
  text_height_in_lines:
  box_attributes: ''
  markup: ''
  graphic_attributes: ''
  publication_id: 1s
title_main:
  korean_name: 제목_메인
  category:
  font_family: KoPub바탕체_Pro Bold
  font: KoPubBatangPB
  font_size: 42.0
  text_color: CMYK=0,0,0,100
  alignment: left
  tracking: -1.0
  space_width: 10.0
  scale: 100.0
  text_line_spacing: 0
  space_before_in_lines: 0.5
  space_after_in_lines: 0.5
  text_height_in_lines: 3
  box_attributes: ''
  markup: ''
  graphic_attributes: ''
title_4_5:
  korean_name: 제목_4-5단
  category:
  font_family: KoPub바탕체_Pro Medium
  font: KoPubBatangPM
  font_size: 32.0
  text_color: CMYK=0,0,0,100
  alignment: left
  tracking: -1.5
  space_width: 10.0
  scale: 100.0
  text_line_spacing:
  space_before_in_lines: 1
  space_after_in_lines: 2
  text_height_in_lines: 2
  box_attributes: ''
  markup: ''
  graphic_attributes: ''
title_4:
  korean_name: 제목_4단
  category:
  font_family: KoPub바탕체_Pro Medium
  font: KoPubBatangPM
  font_size: 30.0
  text_color: CMYK=0,0,0,100
  alignment: left
  tracking: -2.0
  space_width: 7.0
  scale: 100.0
  text_line_spacing:
  space_before_in_lines: 1
  space_after_in_lines: 2
  text_height_in_lines: 2
  box_attributes: ''
  markup: ''
  graphic_attributes: ''
title_3:
  korean_name: 제목_3단
  category:
  font_family: KoPub바탕체_Pro Medium
  font: KoPubBatangPM
  font_size: 27.0
  text_color: CMYK=0,0,0,100
  alignment: left
  tracking: -2.0
  space_width: 4.0
  scale: 100.0
  text_line_spacing:
  space_before_in_lines: 1
  space_after_in_lines: 2
  text_height_in_lines: 2
  box_attributes: ''
  markup: ''
  graphic_attributes: ''
title_2:
  korean_name: 제목_2단
  category:
  font_family: KoPub바탕체_Pro Medium
  font: KoPubBatangPM
  font_size: 23.0
  text_color: CMYK=0,0,0,100
  alignment: left
  tracking: -2.0
  space_width: 4.0
  scale: 100.0
  text_line_spacing:
  space_before_in_lines: 1
  space_after_in_lines: 2
  text_height_in_lines: 2
  box_attributes: ''
  markup: ''
  graphic_attributes: ''
title_1:
  korean_name: 제목_1단
  category:
  font_family: KoPub바탕체_Pro Medium
  font: KoPubBatangPM
  font_size: 18.0
  text_color: CMYK=0,0,0,100
  alignment: left
  tracking: -2.0
  space_width: 4.0
  scale: 100.0
  text_line_spacing:
  space_before_in_lines: 1
  space_after_in_lines: 1
  text_height_in_lines: 2
  box_attributes: ''
  markup: ''
  graphic_attributes: ''
title:
  korean_name: 제목_메인
  category:
  font_family: KoPub바탕체_Pro Bold
  font: KoPubBatangPB
  font_size: 28.0
  text_color: CMYK=0,0,0,100
  alignment: left
  tracking: -1.0
  space_width: 10.0
  scale: 100.0
  text_line_spacing: 0
  space_before_in_lines: 0
  space_after_in_lines: 0
  text_height_in_lines: 3
  box_attributes: ''
  markup: ''
  graphic_attributes: ''
subtitle_main:
  korean_name: 부제_메인
  category:
  font_family: KoPub바탕체_Pro Medium
  font: KoPubBatangPM
  font_size: 18.0
  text_color: CMYK=0,0,0,100
  alignment: left
  tracking: -1.0
  space_width: 5.0
  scale: 100.0
  text_line_spacing: 6.0
  space_before_in_lines: 1
  space_after_in_lines: 2
  text_height_in_lines: 2
  box_attributes: ''
  markup: ''
  graphic_attributes: ''
subtitle_M:
  korean_name: 부제_14
  category:
  font_family: KoPub바탕체_Pro Medium
  font: KoPubBatangPM
  font_size: 14.0
  text_color: CMYK=0,0,0,100
  alignment: left
  tracking: -1.0
  space_width: 5.0
  scale: 100.0
  text_line_spacing: 7.0
  space_before_in_lines: 0
  space_after_in_lines: 1
  text_height_in_lines: 2
  box_attributes: ''
  markup: ''
  graphic_attributes: ''
subtitle_S:
  korean_name: 부제_12
  category:
  font_family: KoPub바탕체_Pro Medium
  font: KoPubBatangPM
  font_size: 12.0
  text_color: CMYK=0,0,0,100
  alignment: left
  tracking: -1.0
  space_width: 4.0
  scale: 100.0
  text_line_spacing: 6.0
  space_before_in_lines: 0
  space_after_in_lines: 1
  text_height_in_lines: 2
  box_attributes: ''
  markup: ''
  graphic_attributes: ''
subtitle:
  korean_name: 부제_12_고딕
  category:
  font_family: KoPub돋움체_Pro Medium
  font: KoPubDotumPM
  font_size: 18.0
  text_color: CMYK=100,0,0,100
  alignment: center
  tracking: -1.0
  space_width: 6.0
  scale: 100.0
  text_line_spacing: 6.0
  space_before_in_lines: 0.5
  space_after_in_lines: 0.5
  text_height_in_lines: 1
  box_attributes: ''
  markup: ''
  graphic_attributes: ''
news_line_title:
  korean_name: 뉴스라인_제목
  category:
  font_family: KoPub돋움체_Pro Medium
  font: KoPubDotumPM
  font_size: 13.0
  text_color: CMYK=0,0,0,100
  alignment: left
  tracking: -0.5
  space_width: 3.0
  scale: 100.0
  text_line_spacing:
  space_before_in_lines:
  space_after_in_lines:
  text_height_in_lines:
  box_attributes: ''
  markup: ''
  graphic_attributes: ''
brand_name:
  korean_name: 애드_브랜드명
  category:
  font_family: KoPub돋움체_Pro Medium
  font: KoPubDotumPM
  font_size: 13.0
  text_color: CMYK=0,0,0,100
  alignment: center
  tracking: -0.5
  space_width: 3.0
  scale: 100.0
  text_line_spacing:
  space_before_in_lines:
  space_after_in_lines:
  text_height_in_lines:
  box_attributes: ''
  markup: ''
  graphic_attributes: ''
subject_head_L:
  korean_name: 문패_18
  category:
  font_family: KoPub돋움체_Pro Bold
  font: KoPubDotumPB
  font_size: 18.0
  text_color: CMYK=100,50,0,0
  alignment: left
  tracking: -0.5
  space_width: 0.0
  scale: 100.0
  text_line_spacing:
  space_before_in_lines:
  space_after_in_lines:
  text_height_in_lines:
  box_attributes: ''
  markup: ''
  graphic_attributes:
    token_union_style:
      stroke_width: 2
      stroke_sides:
        - 0
        - 1
        - 0
        - 0
      top_line_space: 5
subject_head_M:
  korean_name: 문패_14
  category:
  font_family: KoPub돋움체_Pro Bold
  font: KoPubDotumPB
  font_size: 14.0
  text_color: CMYK=0,0,0,100
  alignment: left
  tracking: -0.5
  space_width: 3.0
  scale: 100.0
  text_line_spacing:
  space_before_in_lines:
  space_after_in_lines:
  text_height_in_lines:
  box_attributes: ''
  markup: ''
  graphic_attributes: ''
editor_note:
  korean_name: 편집자주
  category:
  font_family: KoPub돋움체_Pro Medium
  font: KoPubDotumPM
  font_size: 8.8
  text_color: CMYK=0,0,0,80
  alignment: left
  tracking: -0.3
  space_width: 3.0
  scale: 100.0
  text_line_spacing:
  space_before_in_lines:
  space_after_in_lines:
  text_height_in_lines:
  box_attributes: ''
  markup: ''
  graphic_attributes: ''
title_opinion:
  korean_name: 기고 제목
  category:
  font_family: KoPub바탕체_Pro Medium
  font: KoPubBatangPM
  font_size: 22.0
  text_color: CMYK=0,0,0,100
  alignment: left
  tracking: -1.5
  space_width: 7.0
  scale: 100.0
  text_line_spacing:
  space_before_in_lines: 1
  space_after_in_lines: 2
  text_height_in_lines: 2
  box_attributes: ''
  markup: ''
  graphic_attributes: ''
title_editorial:
  korean_name: 사설 제목
  category:
  font_family: KoPub바탕체_Pro Medium
  font: KoPubBatangPM
  font_size: 19.0
  text_color: CMYK=0,0,0,100
  alignment: left
  tracking: -1.5
  space_width: 5.0
  scale: 100.0
  text_line_spacing:
  space_before_in_lines: 0
  space_after_in_lines: 1
  text_height_in_lines: 2
  box_attributes: ''
  markup: ''
  graphic_attributes: ''
title_7:
  korean_name: 제목_7단
  category:
  font_family: KoPub바탕체_Pro Medium
  font: KoPubBatangPM
  font_size: 36.0
  text_color: ''
  alignment: left
  tracking: -2.0
  space_width: 7.0
  scale: 100.0
  text_line_spacing:
  space_before_in_lines: 1
  space_after_in_lines: 2
  text_height_in_lines: 2
  box_attributes: ''
  markup: ''
  graphic_attributes: ''
title_6:
  korean_name: 제목_6단
  category:
  font_family: KoPub바탕체_Pro Medium
  font: KoPubBatangPM
  font_size: 34.0
  text_color: ''
  alignment: left
  tracking: -2.0
  space_width: 7.0
  scale: 100.0
  text_line_spacing:
  space_before_in_lines: 1
  space_after_in_lines: 2
  text_height_in_lines: 2
  box_attributes: ''
  markup: ''
  graphic_attributes: ''
title_5:
  korean_name: 제목_5단
  category:
  font_family: KoPub바탕체_Pro Medium
  font: KoPubBatangPM
  font_size: 32.0
  text_color: ''
  alignment: left
  tracking: -2.0
  space_width: 7.0
  scale:
  text_line_spacing:
  space_before_in_lines: 1
  space_after_in_lines: 2
  text_height_in_lines: 2
  box_attributes: ''
  markup: ''
  graphic_attributes: ''
title_main_7:
  korean_name: 제목_메인_7
  category:
  font_family: KoPub바탕체_Pro Bold
  font: KoPubBatangPB
  font_size: 45.0
  text_color: ''
  alignment: left
  tracking: -1.0
  space_width: 10.0
  scale: 100.0
  text_line_spacing:
  space_before_in_lines: 1
  space_after_in_lines: 0
  text_height_in_lines: 3
  box_attributes: ''
  markup: ''
  graphic_attributes: ''
title_main_6:
  korean_name: 제목_메인_6
  category:
  font_family: KoPub바탕체_Pro Bold
  font: KoPubBatangPB
  font_size: 45.0
  text_color: ''
  alignment: left
  tracking: -1.0
  space_width: 10.0
  scale: 100.0
  text_line_spacing:
  space_before_in_lines: 1
  space_after_in_lines: 0
  text_height_in_lines: 3
  box_attributes: ''
  markup: ''
  graphic_attributes: ''
title_main_5:
  korean_name: 제목_메인_5
  category:
  font_family: KoPub바탕체_Pro Bold
  font: KoPubBatangPB
  font_size: 42.0
  text_color: ''
  alignment: left
  tracking: -1.0
  space_width: 10.0
  scale: 100.0
  text_line_spacing:
  space_before_in_lines: 1
  space_after_in_lines: 0
  text_height_in_lines: 3
  box_attributes: ''
  markup: ''
  graphic_attributes: ''

EOF


MAGAZINE_STYLES={
  "heading_columns" => [1,2,2,2,3,4,4],
  "title"   =>{:font => 'KoPubBatangPM',     :font_size=>24.0, :text_color => 'black', :text_alignment=>'center'},
  "subtitle"=>{:font => 'KoPubBatangPM',     :font_size=>20.0, :text_color => 'black'},
  "author"  =>{:font => 'KoPubDotumPM', :font_size=>12.0, :text_color => 'green', :text_alignment=>'right'},
  "lead"    =>{:font => 'KoPubDotumPM', :font_size=>24.0, :text_color => 'black'},
  "leading" =>{:font => 'KoPubBatangPM',     :font_size=>24.0, :text_color => 'black'},
  "h1"      =>{:font => 'KoPubDotumPM', :font_size=>70.0, :text_color => 'black'},
  "h2"      =>{:font => 'KoPubDotumPM', :font_size=>36.0, :text_color => 'black'},
  "h3"      =>{:font => 'KoPubDotumPM', :font_size=>24.0, :text_color => 'black'},
  "h4"      =>{:font => 'KoPubDotumPM', :font_size=>16.0, :text_color => 'darkGray'},
  "h5"      =>{:font => 'KoPubDotumPM', :font_size=>16.0, :text_color => 'darkGray'},
  "Head"    =>{:font => 'KoPubDotumPM', :font_size=>12.0, :text_color => 'black'},
  "head"    =>{:font => 'KoPubDotumPM', :font_size=>12.0, :text_color => 'black'},
  "h6"      =>{:font => 'KoPubDotumPM', :font_size=>12.0, :text_color => 'black'},
  "p"       =>{:font => 'KoPubBatangPM',     :font_size=>10.0, :text_line_spacing=>5, :text_alignment=>'justified', :text_first_line_head_indent=>10},
  "body"    =>{:font => 'KoPubBatangPM',     :font_size=>10.0, :text_line_spacing=>5, :text_alignment=>'justified', :text_first_line_head_indent=>10},
  "caption" =>{:font => 'KoPubBatangPM',     :font_size=>8.0, :text_color => 'black', :text_alignment=>'center'},
  "header"  =>{:font => 'KoPubBatangPM', :font_size=>8.0, :text_color => 'black'},
  "footer"  =>{:font => 'KoPubBatangPM', :font_size=>8.0, :text_color => 'black', :footer_margin=>30},
  "page_number" =>{:font => 'KoPubBatangPM', :font_size=>10.0, :text_color => 'black'},
}

NEWS_STYLES={
  "title"   =>{:font => 'KoPubBatangPM',     :font_size=>36.0, :text_color => 'black', :text_alignment=>'center',:text_line_spacing=>10 },
  "subtitle"=>{:font => 'KoPubBatangPM',     :font_size=>36.0, :text_color => 'black'},
  "author"  =>{:font => 'KoPubDotumPM', :font_size=>10.0, :text_color => 'black', :text_alignment=>'center'},
  "lead"    =>{:font => 'KoPubDotumPM', :font_size=>24.0, :text_color => 'black', :text_alignment=>'right'},
  "Leading" =>{:font => 'KoPubBatangPM',     :font_size=>24.0, :text_color => 'black'},
  "leading" =>{:font => 'KoPubBatangPM',     :font_size=>24.0, :text_color => 'black'},
  "h1"      =>{:font => 'KoPubDotumPM', :font_size=>24.0, :text_color => 'black'},
  "h2"      =>{:font => 'KoPubDotumPM', :font_size=>20.0, :text_color => 'black'},
  "h3"      =>{:font => 'KoPubDotumPM', :font_size=>18.0, :text_color => 'black'},
  "h4"      =>{:font => 'KoPubDotumPM', :font_size=>12.0, :text_color => 'black'},
  "h5"      =>{:font => 'KoPubDotumPM', :font_size=>12.0, :text_line_spacing=>5, :text_color => 'black'},
  "head"    =>{:font => 'KoPubDotumPM', :font_size=>12.0, :text_line_spacing=>5, :text_color => 'black'},
  "h6"      =>{:font => 'KoPubDotumPM', :font_size=>10.0, :text_line_spacing=>5, :text_color => 'black'},
  "p"       =>{:font => 'KoPubBatangPM',     :font_size=>10.0, :text_line_spacing=>5, :text_alignment=>'justified', :text_color => 'black'},
  "body"    =>{:font => 'KoPubBatangPM',     :font_size=>10.0, :text_line_spacing=>5, :text_alignment=>'justified', :text_color => 'black', :text_first_line_head_indent=>9},
  "caption" =>{:font => 'KoPubBatangPM',     :font_size=>8.0, :text_color => 'black', :text_alignment=>'center'},
  "header"  =>{:font => 'KoPubBatangPM', :font_size=>8.0, :text_color => 'black'},
  "footer"  =>{:font => 'KoPubBatangPM', :font_size=>8.0, :text_color => 'black'},
  "page_number" =>{:font => 'KoPubBatangPM', :font_size=>10.0, :text_color => 'black'},
  "ordered_list"  =>{:font => 'KoPubDotumPM', :font_size=>12.0, :text_line_spacing=>5, :text_color => 'black'},
  "unordered_list"=>{:font => 'KoPubDotumPM', :font_size=>12.0, :text_line_spacing=>5, :text_color => 'black'},
  "ordered_section" =>{:font => 'KoPubDotumPM', :font_size=>12.0, :text_line_spacing=>5, :text_color => 'black'},
  "upper_alpha_list"=>{:font => 'KoPubDotumPM', :font_size=>12.0, :text_line_spacing=>5, :text_color => 'black'},
  "ordered_list_item"=>{:font => 'KoPubDotumPM', :font_size=>0.0, :text_line_spacing=>5, :text_color => 'black'},
  "unordered_list_item"=>{:font => 'KoPubDotumPM', :font_size=>0.0, :text_line_spacing=>5, :text_color => 'black'},
}

POEM_STYLES={
  "title"   =>{:font => 'KoPubBatangPM',     :font_size=>16.0, :text_color => 'black', :text_alignment=>'left',:text_line_spacing=>10 },
  "subtitle"=>{:font => 'KoPubBatangPM',     :font_size=>14.0, :text_color => 'black'},
  "author"  =>{:font => 'KoPubDotumPM', :font_size=>10.0, :text_color => 'black', :text_alignment=>'right'},
  "body"    =>{:font => 'KoPubBatangPM',     :font_size=>10.0, :text_line_spacing=>5, :text_alignment=>'left', :text_color => 'black', :text_first_line_head_indent=>9},
  "caption" =>{:font => 'KoPubBatangPM',     :font_size=>8.0, :text_color => 'black', :text_alignment=>'center'},
  "header"  =>{:font => 'KoPubBatangPM', :font_size=>8.0, :text_color => 'black'},
  "footer"  =>{:font => 'KoPubBatangPM', :font_size=>8.0, :text_color => 'black'},
  "page_number" =>{:font => 'KoPubBatangPM', :font_size=>10.0, :text_color => 'black'},
  "ordered_list"  =>{:font => 'KoPubDotumPM', :font_size=>12.0, :text_line_spacing=>5, :text_color => 'black'},
  "unordered_list"=>{:font => 'KoPubDotumPM', :font_size=>12.0, :text_line_spacing=>5, :text_color => 'black'},
  "ordered_section" =>{:font => 'KoPubDotumPM', :font_size=>12.0, :text_line_spacing=>5, :text_color => 'black'},
  "upper_alpha_list"=>{:font => 'KoPubDotumPM', :font_size=>12.0, :text_line_spacing=>5, :text_color => 'black'},
  "ordered_list_item"=>{:font => 'KoPubDotumPM', :font_size=>0.0, :text_line_spacing=>5, :text_color => 'black'},
  "unordered_list_item"=>{:font => 'KoPubDotumPM', :font_size=>0.0, :text_line_spacing=>5, :text_color => 'black'},
}

HEADING_KIND  = %w[h1 h2 h3 h4 title subtitle author lead]
BODY_KIND     = %w[h5 h6 p heading1 heading2 heading3 body]
LIST_KIND     = %w[ordered_list ordered_list_item unordered_list unordered_list_item ordered_section upper_alpha_list]

module RLayout
  class StyleService
    attr_accessor :current_style, :default_style, :chapter_style, :news_style, :magazine_style, :quiz_item_style
    attr_accessor :custom_style, :pdf_doc, :font_wrappers, :canvas
    def initialize
      @custom_style   = nil
      @current_style  = DEFAULT_STYLES
      @chapter_style  = CHAPTER_STYLES
      @poem_style  = POEM_STYLES

      # @chapter_style_path = "/Users/Shared/SoftwareLab/article_template/chapter_style.rb"
      # if File.exist?(@chapter_style_path)
      #   @chapter_style = eval(File.open(@chapter_style_path,'r'){|f| f.read})
      # end
      @news_style     = NEWS_STYLES
      # @news_style_path = "/Users/Shared/SoftwareLab/article_template/news_style.rb"
      # if File.exist?(@news_style_path)
      #   @news_style = eval(File.open(@news_style_path,'r'){|f| f.read})
      # end
      @magazine_style = MAGAZINE_STYLES
      @magazine_style_path = "/Users/Shared/SoftwareLab/article_template/magazine_style.rb"
      if File.exist?(@magazine_style_path)
        @magazine_style = eval(File.open(@magazine_style_path,'r'){|f| f.read})
      end
      @quiz_style_path = "/Users/Shared/SoftwareLab/article_template/quiz_style.rb"
      if File.exist?(@quiz_style_path)
        @quiz_item_style = eval(File.open(@quiz_style_path,'r'){|f| f.read})
      end

      # if RUBY_ENGINE != 'rubymotion'
      #   @pdf_doc ||= HexaPDF::Document.new
      #   load_fonts(@pdf_doc)
      # end
      self
    end

    def set_chapter_style
      @current_style = @chapter_style
    end

    def set_poem_style
      @current_style = @poem_style
    end

    def current_style_font_list
      font_list = []
      @current_style = YAML::load(DEFAULT_STYLES)
      @current_style.each do |style|
        font_name = style[1]['font']
        font_list << font_name unless font_list.include?(font_name)
      end
      font_list
    end

    def para_style(style_name)
      @current_style[style_name]
    end
    
    def space_width(style_name, adjust_size)
      style = @current_style[style_name]
      space_width = style['space_width']
      font_size  = style['font_size'] 

      if space_width.nil?
         font_size += adjust_size if adjust_size
        return font_size/2
      elsif adjust_size && adjust_size != 0
        space_width*(font_size + adjust_size)/font_size
      end
      space_width
    end

    ########### ruby_pdf ##############

    def set_canvas_text_style(canvas, style_name, options={})
      style_name    = 'body' unless style_name
      @current_style  = YAML::load(@current_style) if @current_style.class == String
      style         = @current_style[style_name]
      style         = Hash[style.map{ |k, v| [k.to_sym, v] }]
      font_name     = style[:font]
      #TODO
      # find font_wapper with font_name
      # font_wapper  = @pdf_doc.fonts.loaded_fonts_cache[style_name]
      # unless font_wapper
        font_folder  = "/Users/Shared/SoftwareLab/font_width"
        font_file     = font_folder + "/#{font_name}.ttf"
        font_wapper   = @pdf_doc.fonts.add(font_file)
      # end
      font_size = style[:font_size]
      font_size += options[:adjust_size] if options[:adjust_size]
      canvas.font(font_wapper, size: font_size)
      canvas.character_spacing(style[:tracking])    if style[:tracking] && style[:tracking]!= 0
      canvas.horizontal_scaling(style[:scale])      if style[:scale] && style[:scale] != 100
    end

    def style_object(style_name, options={})
      if @current_style.class == String
        @current_style = YAML::load(@current_style)
      end
      style = @current_style[style_name]
      style = @current_style['body'] unless style
      style = Hash[style.map{ |k, v| [k.to_sym, v] }]
      @pdf_doc      ||= HexaPDF::Document.new
      font_folder   = "/Users/Shared/SoftwareLab/font_width"
      font_name     = style[:font]
      font_file     = font_folder + "/#{font_name}.ttf"
      font_wrapper = @pdf_doc.fonts.add(font_file)
      h = {}
      h[:font]                = font_wrapper
      h[:font_size]           = style[:font_size]
      h[:font_size]           += options[:adjust_size]  if options[:adjust_size]
      h[:character_spacing]   = style[:tracking]        if style[:tracking] && style[:tracking] != 0
      h[:horizontal_scaling]  = style[:scale]           if style[:scale] && style[:scale] != 100
      h
      style_object = HexaPDF::Layout::Style.new(h)
      return style_object, font_wrapper
    end

    def style_object_from_para_style(para_style, options={})
      @pdf_doc      ||= HexaPDF::Document.new
      font_folder   = "/Users/Shared/SoftwareLab/font_width"
      font_name     = para_style[:font]
      font_file     = font_folder + "/#{font_name}.ttf"
      font_wrapper = @pdf_doc.fonts.add(font_file)
      h = {}
      h[:font]                = font_wrapper
      h[:font_size]           = para_style[:font_size]
      h[:font_size]           += options[:adjust_size]  if options[:adjust_size]
      h[:character_spacing]   = para_style[:tracking]        if para_style[:tracking] && para_style[:tracking] != 0
      h[:horizontal_scaling]  = para_style[:scale]           if para_style[:scale] && para_style[:scale] != 100
      h
      style_object = HexaPDF::Layout::Style.new(h)
      return style_object, font_wrapper
    end

    def width_of_string(style_name, string, adjust_size)
      style = @current_style[style_name]
      style = @current_style['body'] unless style
      style = Hash[style.map{ |k, v| [k.to_sym, v] }]
      style[:font_size] += adjust_size if adjust_size
      if RUBY_ENGINE == "rubymotion"
        atts = NSUtils.ns_atts_from_style(style)
        att_string     = NSAttributedString.alloc.initWithString(string, attributes: atts)
        return att_string.size.width
      end
      rfont = RLayout::RFont.new(style[:font], style[:font_size])
      rfont.string_width(string)
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
