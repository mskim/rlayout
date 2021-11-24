# encoding: utf-8

# Chapter
# - Chapter converts given Story into a document.
# - Story is parsed to heading and body. 
# - Each story has heading and body, heding is placed at the top in yaml format.
# - Body part follows the headinng, in markdown format.
# - Body part are converted to series of paragraphs,

## How to place images in long document?
# There are three ways of placing images in the long document.
# 1. inline image markup
# 2. pre-planed separate yaml file containeing image info for page.
# 3. inserting pre-made PDF photo pages with markup at insertion point

### First method is to inline image markup in the text.
# - Image tag will trigger new page except the first page
# - It is recommanded to start with image markup at the beginning of page content
# - and put rest of text after the image markup. 
# - So, the images will be placed into page as floats first, then text will floow arount it.
# - 그림_1(크기:전면)
# - 그림_2(위치:상단, 크기:반)
# - 그림_1(크기:전면)
# - 그림_2(위치:상단, 크기:반)
# - 그림_3(위치:하단, 크기:반), bottom positin of size 1
# - 그림_4 기본은 (위치:상단, 크기:반)
# - 그림_5,

# - We can also puts multiple images in the same page, for this we need to group them as "그림_조합_1"
# - this represents collection of images that will be place in the same page.
# - multiple_image can be placed in a single page by
# - putting using 그림_조합_1 same image info in the same text block
# - should create subfolder 그림_조합_1 folder within images folder
# - staeting with 그림_조합
# - 그림_조합_1
# - 그림_1(3, 1x1)
# - 그림_2(3, 1x1)
# - 그림_3(3, 1x1)
# - it will push down image if multiple images have same positioon
# - this has effoct of vertical alignment

### And second way is to use float_group.
# - Float_group is a floating images layout on top of a page,
# - where text flows aroud those images.
# - Float_group containes position information,
# - such as grid_frame, size, position attributes.
# - New page is triggered with Float_group. pre-desinged layout pattern can also be used.

### And the third method is to use photo_page,
# - photo_page can containe more then one page.
# - New page section is triggered for photo_page.
# - photo_page is pure photo only page, no text flows in the page,
# - no header, no footer, no page number.
# - pre-desinged layout pattern can be pulled from pattern library
# - or positions can be set manually.

### For short documents, such as magazine article,
# - desinger can place image in rlayout file.
# - And image info in specified in meta-data header
# - or design template by designer.


### How to place image caption?
# - File that has same name with extension of .caption?
# - Or have the caption text as file name.jpg

### How to add Image bleeding support


# when we encounter page triggering node, add new page
#    section_1, photo_page, image_group


# LongDocument
# LongDocument is made to handle collection of document parts, for long document.
# Typical LongDocument parts are, title_page, section, photo_page, image_group_page.
# and pdf_insert.

# pdf_insert is pre-made pdf pages that are inserted in the middle of chapter.

# Asciidoctor
# Asciidoctor is used for creating books from Asciidoctor content.
# Asciidoctor content is parsed and broken into parts.
# Broken parts are handed to LongDocument as parts.
# LongDocument is also reponsible for generating TOC, index, and x-ref.

# Story file
# story files are markuped text, with markdown or asciidoctor syntax.
# I am adding some of my own markups to asciidoctor adoc with extension.
# I should transform them into Asciidoctor, LqTex, or markdown format.
# And it should be simple.
# First part is meta-data
# And followed by block data.
# Block data is separated by new empty line.
#

# meta-data
# ---
# yaml format key value pair
# title:
# subtitle:
# quote:
# author:
# book_title:
# chapter_title:
# strting_page:
# page_count:
# ---

# New Page Triggering mark
# [photo_page]
# [image_group]
# [pdf_insert]

# title page marks (in meta-data)
# title:
# subtitle:
# quote:
# leading:
# author:
# description:


# # Section
# ## Section
# ### Section
# #### Section
# ##### Section

# section mark
# = Section
# == Section
# === Section
# ==== Section
# ===== Section

# paragraph mark
# [p]
# [sub_p]
# [subsub_p]
# [dropcap]

# block mark
# [warning]
# [notice]
# [source, ruby]
# [image]
# [table]
# [math]

# block attributes
# :style: my_style1
# :shape: round_rect
# example
# [math]
# :align: true
# :number: true

# inline mark
# _italic_
# *bold*
# underline
# $$math$$
# ^super^
# sub
# {{box}}
# {{base}{ruby}}
# {{base}{reverse_ruby}}

# class String
#   def blank?
#     !include?(/[^[:space:]]/)
#   end
# end

# heading_height_type
#   fixed height: use HeightContent

#   natural, quarter, half, full_page

#   natural: growing height: use Heading

# chapter folder
# config.yml
# images/
# story.md
# output format
# output.pdf
# page_001
# page_002
# page_003

CHAPTER_STYLES=<<EOF
---
body:
  korean_name: 본문명조
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
reporter:
  korean_name: 기자명
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
author:
  korean_name: 저자명
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
linked_story:
  korean_name: 연결기사
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
reporter_editorial:
  korean_name: 논설기자
  font_family: KoPub돋움체_Pro Light
  font: KoPubDotumPL
  font_size: 9.4
  text_color: CMYK=0,0,0,100
  alignment: right
  tracking: 0.0
  space_width: 2.0
  scale: 100.0
  text_line_spacing:
  space_before_in_lines: 1
  space_after_in_lines:
  text_height_in_lines:
  box_attributes: ''
  markup: ''
  graphic_attributes:
    token_union_style:
      stroke_width: 1.5
      stroke_sides:
        - 0
        - 1
        - 0
        - 0
      top_line_space: 3
title_main:
  korean_name: 제목_메인
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
  font_family: KoPub바탕체_Pro Bold
  font: KoPubBatangPB
  font_size: 24.0
  text_color: CMYK=100,0,0,0
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
  font_family: KoPub바탕체_Pro Medium
  font: KoPubBatangPM
  font_size: 18.0
  text_color: CMYK=0,0,0,100
  alignment: left
  tracking: -1.0
  space_width: 6.0
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
  font_family: KoPub돋움체_Pro Medium
  font: KoPubDotumPM
  font_size: 18.0
  text_color: CMYK=0,0,0,100
  alignment: center
  tracking: -1.0
  space_width: 9.0
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
subject_head_editorial:
  korean_name: 문패_12
  font_family: KoPub돋움체_Pro Bold
  font: KoPubDotumPB
  font_size: 12.0
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
  graphic_attributes:
    token_union_style:
      stroke_width: 2
      stroke_sides:
        - 0
        - 1
        - 0
        - 0
      top_line_space: 13.5
editor_note:
  korean_name: 편집자주
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

# adding pictures in chapter
# 1. first way is to insert text markup in md file
# a single line text starting with 그림_1/picture_1 followed by number
# grid 6x12 grid
# 그림_1(1_6x6)
# 그림_2(1_6x6)
# put 그림_3(1_6x6)
# default_image_location: 1
# default_image_size: 6x6
# 2. second way is to create page_image_layut.yml file specifiying page_number and image_name, locatin, size
# 
module RLayout

  class RChapter
    attr_reader :document_path, :story_path
    attr_reader :document, :output_path, :column_count
    attr_reader :doc_info, :toc_content
    attr_reader :book_title, :title, :starting_page, :heading_height_type, :heading
    attr_reader :body_line_count, :body_line_height
    attr_reader :max_page_number, :page_floats
    attr_reader :header_footer, :header_erb, :footer_erb
    attr_reader :belongs_to_part

    # page_by_page is used for page proof reading
    # if page_by_page is true,
    # folders are created for each page, with jpg image and, markdown text for that page
    # this allow the proofer to work on that specific page rather than dealing with entire chapter text.
    # page_pdf options indicates to split docemnt into pages
    # page_folder are 4 digit numbered 0001, 0002, 0003

    attr_reader :page_by_page, :page_pdf, :story_md, :story_by_page, :toc
    attr_reader :belongs_to_part
    attr_reader :grid, :default_image_location, :default_image_size
    attr_reader :local_image_folder
    
    def initialize(options={} ,&block)
      @document_path  = options[:document_path] || options[:chapter_path]
      @local_image_folder = @document_path + "/images"
      @story_path     = @document_path + "/story.md"
      @output_path    = options[:output_path] || @document_path + "/chapter.pdf"
      @story_md       = options[:story_md]
      @layout_rb      = options[:layout_rb]
      @belongs_to_part = options[:belongs_to_part]
      @grid = options[:grid] || [6,12]
      @default_image_location = options[:default_image_location] || 1
      @default_image_size = options[:default_image_size] || [6,6]
      unless @layout_rb
        layout_path = @document_path + "/layout.rb"
        unless File.exist?(layout_path)
          @layout_rb = default_document
        else
          @layout_rb = File.open(layout_path, 'r'){|f| f.read}
        end
      end
      @starting_page  = options[:starting_page] || 1
      @page_by_page   = options[:page_by_page]
      @page_pdf       = options[:page_pdf]
      @story_by_page  = options[:story_by_page]
      @toc            = options[:toc]
      @toc_level      = options[:toc_level] || 'title'
      @header_erb     = options[:header_erb]
      @footer_erb     = options[:footer_erb]
      @document       = eval(@layout_rb)
      if @document.is_a?(SyntaxError)
        puts "SyntaxError in #{@document} !!!!"
        return
      end
      unless @document.kind_of?(RLayout::RDocument)
        puts "Not a @document kind created !!!"
        return
      end
      @document.starting_page = @starting_page
      # place floats to pages
      if options[:page_floats]
        @page_floats      = options.fetch(:page_floats, [])
      else
        read_page_floats 
      end
      if has_page_floats_info?
        @has_page_floats_info = true
        last_floats_page_number = @page_floats.keys.sort.last
        need_page_count = last_floats_page_number - @document.pages.length
        if need_page_count > 0
          need_page_count.times do 
            @document.add_new_page
          end
        end
        @document.pages.each_with_index do |p,i|
          page_floats = @page_floats[i + 1]
          p.add_floats(page_floats) if page_floats
        end
      end

      read_story
      layout_story
      # draw header and footers
      if @footer_erb
        @footer_erb[:right_footer].gsub!("<%= title %>", @title)
      end
      @document.pages.each_with_index do |p,i|
        p.page_number = @starting_page + i
        p.create_header(@header_erb) if @header_erb && @header_erb != {}
        p.create_footer(@footer_erb) if @footer_erb && @footer_erb != {}
      end
      @document.save_pdf(@output_path, page_pdf:@page_pdf) unless options[:no_output]
      save_story_by_page if @story_by_page
      save_toc if @toc
      self
    end

    def has_page_floats_info?
      @page_floats && @page_floats != {}
    end

    def page_count
      @document.pages.length
    end

    def story_by_page_path
      @document_path + "/story_by_page.yml"
    end

    def save_story_by_page
      File.open(story_by_page_path, 'w'){|f| f.write @story_by_page_hash.to_yaml}
    end

    def default_document
      layout =<<~EOF
        RLayout::RDocument.new(page_size:'A5')
      EOF
    end

    def read_page_floats
      unless File.exists?(page_floats_path)
        # puts "Can not find file #{page_floats_path}!!!!"
        # return {}
        @page_floats = {}
      else
        @page_floats = YAML::load_file(page_floats_path)
      end
    end

    def read_story
      if @story_md 
        @story  = Story.new(nil).markdown2para_data(source:@story_md)
      else
        @story  = Story.new(@story_path).markdown2para_data
      end
      @heading  = @story[:heading] || {}
      @title    = @heading[:title] || @heading['title'] || @heading['제목'] || "Untitled"
      if @document.pages[0].has_heading?
        @document.pages[0].get_heading.set_heading_content(@heading)
        @document.pages[0].relayout!
      elsif @first_page = @document.pages[0]
        if @first_page.floats.length == 0
          @heading[:parent] = @first_page
          @heading[:x]      = @first_page.left_margin
          @heading[:y]      = @first_page.top_margin
          @heading[:width]  = @first_page.width - @first_page.left_margin - @first_page.right_margin
          @heading[:is_float] = true
          RHeading.new(@heading)
        elsif @document.pages[0].has_heading?
          @document.pages[0].get_heading.set_heading_content(@heading)
        end
      end
      @paragraphs =[]
      @image_count = 0
      @left_margin = @document.pages[0].left_margin
      @top_margin = @document.pages[0].top_margin
      @width = @document.pages[0].width
      @height = @document.pages[0].height
      @story[:paragraphs].each do |para, i|
        if  para[:markup] == "image"
          @image_count += 1
          float_info = {}
          float_info[:position] = 1
          float_info[:x] = @left_margin
          float_info[:y] = @top_margin
          float_info[:width] = @width - @left_margin*2
          float_info[:height] = (@height - @top_margin*2)/2
          float_info[:image_path] = @local_image_folder + "/#{@image_count}.jpg"
          float_info[:kind] = "image"
          # TODO: fix this ????
          float_info[:image_path] =  Dir.glob("#{@local_image_folder}/#{@image_count}.{jpg,png,pdf}").first
          if float_info[:image_path] && File.exist?(float_info[:image_path])
            extension = File.extname(float_info[:image_path])
            image_info_path = float_info[:image_path].sub("#{extension}", ".yml")
            # binding.pry
            if File.exist?(image_info_path)
              image_info = YAML::load_file(image_info_path)
              float_info.merge!(image_info)
            end
          end

          para_options = {}
          para_options[:markup] = "image"
          para_options[:float_info] = float_info
          @paragraphs << RParagraph.new(para_options)
        elsif  para[:markup] == "table"

        else
          para_options = {}
          para_options[:markup]         = para[:markup]
          para_options[:layout_expand]  = [:width]
          para_options[:para_string]    = para[:para_string]
          @paragraphs << RParagraph.new(para_options)
        end
      end
    end
    
    def layout_story
      current_style = RLayout::StyleService.shared_style_service
      current_style.current_style = CHAPTER_STYLES

      @document.pages.each do |page|
        page.layout_floats
        page.adjust_overlapping_columns
        page.set_overlapping_grid_rect
        page.update_column_areas
      end
      @first_page                 = @document.pages[0]
      @current_line               = @first_page.first_text_line
      @story_by_page_hash         = {} # this is used to capter story_by_page info
      @toc_content                = []
      page_key                    = @current_line.page_number
      current_page_paragraph_list = []

      while @paragraph = @paragraphs.shift

        # capturing paragraph info to save @story_by_page
        @current_line                   = @paragraph.layout_lines(@current_line)
        current_page_paragraph_list     << @paragraph.para_info
        if @toc_level == 'title'
        elsif @paragraph.markup != 'p'
          toc_item = {}
          toc_item[:page] = page_key
          toc_item[:markup] = @paragraph.markup
          toc_item[:para_string] = @paragraph.para_string
          @toc_content << toc_item
        end
        unless @current_line
          @current_line                 = @document.add_new_page
          @story_by_page_hash[page_key] = current_page_paragraph_list
          current_page_paragraph_list   = []
          page_key                      = @current_line.page_number
        end

        if @current_line.page_number != page_key
          @story_by_page_hash[page_key] = current_page_paragraph_list
          current_page_paragraph_list   = []
          # current_page_hash             = {}
          page_key                      = @current_line.page_number
          # current_page_hash[page_key]   = []
        end
      end
    end

    def next_chapter_starting_page
      @starting_page = 1 if @starting_page.nil?
      @page_view_count = 0   if @page_view_count.nil?
      @starting_page + @page_view_count
    end

    def doc_info_path
      @document_path + "/doc_info.yml"
    end

    def page_floats_path
      @document_path + "/page_floats.yml"
    end

    def save_doc_info
      # doc_info_path   = @document_path + "/doc_info.yml"
      @doc_info[:toc] = @toc_content
      File.open(toc_path, 'w') { |f| f.write @doc_info.to_yaml}
    end

    def save_toc
      @document_path  = File.dirname(@output_path)
      toc_path        = @document_path + "/toc.yml"
      if @toc_level == 'title'
        toc_item = {}
        toc_item[:page] = @starting_page
        toc_item[:markup] = 'h1'
        toc_item[:markup] = 'h2' if @belongs_to_part
        toc_item[:para_string] = @title
        @toc_content << toc_item
      end
      File.open(toc_path, 'w') { |f| f.write @toc_content.to_yaml}
    end

  end
end
