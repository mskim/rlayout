## TODO List
  - add save_rakefile to Book, RDOcument, ColumnArticle 
  - add html folder
### 2022_01_??
  - hwp parse
  - newspaper
    - move_up_if_room in text_style

  - add table support
  - fix cover title text overflow
    - set title_text fit_to_box
    - set layout_length for each element for vertival balance
  - use async to process chapter in parallel
  - foot note support using [^1]
  - index support
  - reference support
  - math suppoert
  - add inline float marking support??
      floats_1
  - OrderedList, UnorderedList
  - add markup: "#", "##", "###" to text_style
  - add char_style for emphasis
      - font, font_color, font_style, prefix, postfix
  - outline_color
  - outline_thickness
  - outline2_color
  - outline2_thickness

  - line_type
  - arrow_type



### 2022_06_04

  -  add header and footer to styleable_doc.rb
  
    @left_footer = 
    @right_footer = 
    @left_header = 
    @right_header  =


### 2022_06_03
  - mark floats as
    - floats_1
    - show image_tag for non-exixting image
      this will  allow to place missing image at right place with right name.
  - apply text_alignment for caption
  - set sef default as 'left'
  - merge NewsImage and ImagePlus

  - ImageWithCaption = NewsImage 
  - add floats floats.yml 
  - add ![image]{position:3, size:'2x2', caption: "this is caption"}

  - list, ordered_list

### 2022_05_31

- right side image and text margin
- caption position

- fix caption
  - reduce image area for caption area
- use new_image caption
  - caption_height
  - use caption style_name
  - rename ImagePlus as ImageWithCaption, merge it with NewsImage
- footer add style_name
- make footer customizable

### 2022_05_27

- fix footer location
  - fix right_side margin
  - make it customazable

### 2022_05_09
  - use Docker bind-mount
  - how to use private gem in Dockerfile
  - how to use private docker image
  - book_plan.md parser
  - create Rakefile to
    - save book_plan.md
    - generate_sample_book
      - update book sample
      - create repo from cli
      - create gh-page branch
### 2022_05_05
  - add fix_text_to_area text_area
    adjust styles to fit into given area
### 2022_05_01
  - book.md single file sample
  - update bookcheego CLI new template with single file
### 2022_04_30

  - add image
    - mutiple images for page
    - should go after ## 
    - no text support for ## to add images on new page
    - {image_path: '1.jpg', position: 3, size: [2,2]}
    - {image_path: '2.jpg', position: 3, size: [2,2]}

### 2022_04_27

  - left_side_bar
  - right_side_bar

```
  ## 내가 살아 가는 법
  {side_image: book_1.jpg}
```

  - fix paragraph layout to handle it
    - when parsing story, add hash to extra_info
  - add {side_image: local_image_path}

  - fix first_line_indent bug
### 2022_04_26
  StyleablePage used content.yml
  - FrontPage < StyleablePage
  - BackPage < StyleablePage

  StyleableArticle used story.md
  - FrontWing <  StyleableArticle
      - profile_image: author.jpg

  - BackWing <  StyleableArticle
    - ## book_promo: book_1

    - book_promo
    - markup with ## profile:
    - markup with ## item:
    - markup with ## table:


  - update namecard with CoverPage and StyleablePage



  - for github pages
    - chnage  docs to _ebook folder
    - create gh-page
### 2022_04_21
  - get rid of gem rqrcode-
  - add wing to ebook front_page
  - book with tables from book.md
### 2022_04_21
  - update book.md from build source
      update book build to source book.md
      \d\d files and book_info.yml into single book.md
  - separate book souce
      separate book.md into \d\d files and book_info.yml
### 2022_04_20
  - StyleablePage
      style_guide_folder
      document_path
      super
      load_layout_rb
      load_text_style
      @page = eval(@layout_rb)
      @page.save_pdf(output_path)

  - paperback rails sample file
### 2022_04_19
  - fix table_row height
  - color_from_string add hexcode color paring
    - cyclical light color
    - category color and light color
  - chapter 
    - merge_story
      - fix chapter title merge


  - add position, size
    - ## table: table_1
    - {possition:3, size:[3,3]}
    - create table folder with default values
      - layout.rb
      - table_style.yml
      - output.pdf
     - ## image: 1.jpg
     - {possition:3, size:[3,3]}

     - ## float_layout: 1

### 2022_04_18
  - newsgo cli
  - bookcheego cli
  - table_area

  - fix image caption layout

  - action mailbox integration
### 2022_04_16
  - NewsArticle top_position
  - NewsHeading, NewsAd

  - image_area
  - text_area


  - DesignPage < Container
### 2022_04_13
  - fix article_bottom_spaces_in_lines to article_bottom_space_in_lines
  - add page_heading to news_page
    - save front_page_heading, odd_page_heading, even_page_heading
    - save front_page_heading_bg.pdf,
    - save odd_page_heading_bg.pdf,
    - save even_page_heading_bg.pdf,

  - add ad to news_page
      create ad folder in publication folder
### 2022_04_13
  - NewsPageParser
  - NewsPageBuilder
  - NewsPageMerger
  - NewsIssuePlan
  - NewsIssueBuilder
  - NewsPublication

### 2022_04_13
  - fix news_article_text_style
  - fix StyleableArticle
    -  news_article_box_style
    -  opinion_style
    -  editorial_style
    -  book_review_style
    -  obituary_style
### 2022_04_11
  - toc style_guide
  - fix prologue not generating pdf
    when parsing create doc folders with \d\d 
  - fix toc h2 first_line_indent
  - get rid of 
    essay_book.rb
    book_with_part
    body_matter_with_part

  - handle poetry if @doc_type = 'poetry'
  - handle multiple md source file    - 

### 2022_04_08
  - fix part_cover text_style layout_rb using CoverPage
  - fix toc not including part_cover
  - fix part_cover always showing part_1 
### 2022_04_06
  - generate book_info.yml from source folder, 
    save or copy it to _build folder
    put it in book.md
  - part_cover
    when parsing book.md, add part heading to book_info.yml
    add default_text_style
    title, layout, 
    add part to book_info
  - add to toc
  - vertical seneca
  - use CoverPage 
    -  predefined text_area
      heading, logo, picture, image
    
    change Area to TextArea
      naming convention
      def name          pgscript

  - CardPage < CoverPage  
    -  predefined text_area
      personal, company, en_personal, en_company

### 2022_03_29
  - style_guide
    toc, seneca, inside_cover, 
    
    add def image to CoverPage

### 2022_03_29
  - remove vips or imagemagik dependency check the status and  choose one.
    read image size with Hexapdf or image-processing
### 2022_03_29
  - fix toc bug, setup rails bookcheego app

### 2022_03_25
  - Container pgscript add Area
    - grid_size?, grid_base?
    - bg_color, fill entire area ,  content_bg_color fill area inside of margin
  - chnage Area < Contrainer
  - change Heading pgscriopt to heading([0,0,6,6])
  - chnage RDocument chapter_layout.rb with heading
  ```ruby
    RLayout::RDocument.new(paper_size: 'A5') do
      page do
        heading([0,0,6,6])
      end
    end
  ```
  - create CoverText < Area

### 2022_03_24
  - style_guide
    - front_page, back_page, seneca, front_wing, back_wing, toc
  - JobgeeGo, for magazine publishing
  - place font under /fonts
  - vips gem ?
### 2022_03_23
  - picture, picture_path, picture_object
  - qrcode, qrcode_path, qrcode_object
  - imposition

### 2022_03_20
  - book
    - _style_guide folder by document_kind with size
    - compile: build pdf without page_number 
      - with mdate dependancy
    - link: add header/footer and generate toc
    - generate print as option
    - generate ebook as option
  - site
  - github-action
  - divide gem by function
    - rlayout
    - bookcheego
    - newsgo
    - namecard

### 2022_03_07
  - namecard
  - magazine
  - email based workflow
  - using async gem in 3.0
    - compile: generate pdf documents without pdf
      - put pdf with source
      - complile only needed document file mtime
    - link: 
      - post process header/footer workflow

### 2022_03_06
  - save front_page_content.yml
  - save back_page_content.yml
### 2022_03_04
  - class FrontPage < StyleableDoc 
  - class BackPage < StyleableDoc 
### 2022_03_2
  - namecard
  - namecard_maker < 
  - def load_text_style
  - def load_layout

  - FrontPage < StyleableDoc
  - FrontWing < StyleableDoc
  - BackPage < StyleableDoc
  - BackWing < StyleableDoc

### 2022_02_28

  - default_layout_rb
  - default_layout_yml
  - def layout_from_yml
  - def layout_to_yml

  - faker_korean 0.0.2
    - company
    - member
### 2022_02_26
  - _style_guide
  change RChapter to Chapter


### 2022_02_25
  - paperback custome_style support
  - save text_style and layout into source folder
    and copy it to build folder
    first make sure source chapter must be in folder, 
    for it to be customr_style chapter.

### 2022_02_21
  - UnitDocument
    a basic unit of PDF document
      chpater, toc, didication, thanks, prologue, foreward, preface, cover_1, cover_4, wing_author, wing_book_prpmo, isbn, part_cover
    UnitDocument has layout.rb, text_style.yml and images
    content.md, story.md,
    TopHeading HeadingContainer?
      - free formatted horizontal heading that is place at the top of page.
      - study_book, newspaper catalog_heading

### 2022_02_25
    - add StyleablePage
    - add CoverPage
    - rename StyleableNewsArticle to StyleableArticle

### 2022_02_16
  - base, global, and local text_style
  - rake save_custom_style
  - replace global style with custom style 
  - replace font name with Global Constant
### 2022_02_15
  - web_githook
    - book_info, 
    - doc_info for each doc
      paper_size:
      doc_type: chapter, prologue, etc ...

  - if book_info cutom_style: true
      save text_style and rake file
  - put self.class name in text_style file name
    - chapter_text_style.yml
    - cover_text_style.yml
    - toc_text_style.yml
    - prologue_text_style.yml
    - isbn_text_style.yml

  - run rake in doc folder
  - line_color
  - ZineGo for Magazine
  - _style
      chapter.yml
      toc.yml
      isbn.yml
      front_matter_doc.yml
      part_cover.yml
      cover.yml
      wing_author.yml
      wing_book_promo.yml



### 2022_02_14
  - add text_style to ColumnArticle
  - TitleText
    space_unit # body_line_height, line_height, cm, mm, inch
    line_spacing, space_above, space_after, line_spacing
  - add pg methods

    heading, 
    height_height_type # natural, quarter, half, full
    fit_type  fit_to_box, 
    v_alingment
    
    title, subtitle, author, quote, leading
    authomatically set text_style

    Seneca
      - direction 
### 2022_02_13
  - apply line_space, space_before_in_line, space_after_in_line
### 2022_02_04

    story.md
    ---
    title: we are the world
    subtile: so lets starting giving


    style.yml
    ---
    layout: |
      Isbn.a4 do
      end
    text_style:
      title: 
        font: Myungjo_B
        font_size: 18
      subtitle: Gothic_M
        font_size: 14

### 2022_02_03

### 2022_02_03
  - custom style
  - author_wing, other_books_wing
### 2022_02_02
  - add test for all sizes
    - paperback_A4, paperback_4x6_16, paperback_A5
    - add paper_size cm
### 2022_01_31
  - add title_A4, title_4x6_16, title_A5
  - add subtitle_A4, subtitle_4x6_16, subtitle_A5
  - add book_title_A4, book_title_4x6_16, book_title_A5
  - add book_subtitle_A4, book_subtitle_4x6_16, book_subtitle_A5
  - add frontmatter_title_A4, frontmatter_title_4x6_16, frontmatter_title_A5
### 2022_01_30
  - fix prologue isbn heading
### 2022_01_28
  - add starting_page_side, :left, :right, :either_side
  - page_type toc_page, inside_cover, column_text, front_matter, chapter, index
### 2022_01_26
  - add layout:custom to metadata to indicate custom layout mode
    - save layout.rb and text_style.yml file to style folder
  - if custom: true
    - save  layout and text_style to style folder, so user can customize desing
### 2022_01_20
  - cover_1, 
  - cover_2, 
  - cover_3, 
  - cover_4,
  - wing_front, 
  - wing_back, 
  - isbn, 
  - inside_cover, 
  - prologue,
  - dedication,
  - toc,
  - part_cover, 
  - chapter,
  - footer_left,  
  - footer_right, 
  - header_left, 
  - header_right

  - save custom text_style in _style folder
    - apply custom_style  if @book_info[:custom_style] = true
### 2022_01_11
  - fix bug: displaying only 24 lines when line_count is 25
  - fix token_width calculation has bug 


  - replace missing glyph with some ? character , instead of crashing
    -filter story file for unsupported chars and replace them
  - set_body_starting_page
  - use pre-made frontmatter
    - book_cover
      - 01
      - 02
      - 03
      - 04
      - seneca
      - spread.jpg
    - 01_title_page
    - 02_info
    - 03_dedication
    - 04_prologue
    - 05_toc.md

### 2022_01_23
  - r_line_fragement set text_alignment  from style_object

### 2022_01_16
  - suppoert pre-made PDF file as class PDFSection

  - fix FrontMatter folder parsing
    01_some_folder
    02_second_doc
    03_second_doc
    
  - suppoert custom styles by provideing "style" folder in book level, and document level
    - text_style.yml, 
    - book_info.yml
      - paper_size
      - 4margins
    - doc_info.yml
      - paper_size
      - 4margins
### 2022_01_14
  - for RLineFragment
    - add content_source and get @style_object from content_source
    - so fix r_paragraph, title_text, text, and TextToken
### 2022_01_09
  - fix footer x position
    - should align it to left and right margin
  - change  footer style
### 2022_01_09
  - front_matter
    - \d\d folder or file
    - add title_page title_page.pdf, jpg, png
    - supprt book_info_page book_info.md
    - add blank_page
    - support pre_made seneca
    - bg_image with bleeding

  - custom_style support
    - style_name
    - toc.erb
    - prolog.erb
    - dedication.erb
    - chapter_heading.erb
    - footer.erb
    - header.erb
    - book_info.erb
    - text_style.yml
      title
      subtitle
      author
      leading
      heading
      quote
      body

      front_matter
        title
        subtitle
        heading
        body
    - 
### 2022_01_07
  - fix bold italic tag as markdown standard
  - support image with markdown standard
### 2022_01_06
  - when creating _print fix order!
    - by sorting pdf_pages
  - fix left side footer showing book title as "untitled"

  - re-define class Line with x1,y1,x2,y2 , stroke
  - test picture support

### 2022_01_04
  - apply smart_pants to story files
  - fix chapter file to handle file or folder
      01_something_folder
      01
      01.md
      01_some_name.md
  - fix parts to handle file or folder
  - create print pdf with cutting lines and marging
      bleed_margin, cutter_margin



### 2022_01_03
  - fix line next_line setting wring line becase of bug in add_new_page

### 2021_12_29
  - add RubyPants gem 
  - gem 'rubypants-unicode'
    gem install rubypants-unicode
    h['title']                = RubyPants.new(title).to_html if title
    if subtitle
      h['subtitle']           = RubyPants.new(subtitle).to_html unless (kind == '사설' || kind == '기고')
    end
    h['boxed_subtitle_text']  = RubyPants.new(boxed_subtitle_text).to_html if boxed_subtitle_type && boxed_subtitle_type.to_i > 0
    h['quote']                = RubyPants.new(quote).to_html  if quote && quote !="" if quote_box_size.to_i > 0
    h['announcement']         = RubyPants.new(announcement_text).to_html  if announcement_column && announcement_column > 0
    h['reporter']             = reporter if reporter &&  reporter !=""
    h['email']                = email

### 2021_12_26
  - clean_previous_generated_books

  - chapter folder
  - .md story file with any name to story.md in _build when coping
  - book title auto fit
  - table
  - auto detect part base or chapter based book

  -  book_type paperback, essey_book, potry_book, picture_book, manual
  -  chapter_type: chapter, poem, essey

### 2021_12_25
  - clean_previous_generated_folders

### 2021_12_21
  - adjust overlapping line text space, or inset image box?

  - delete old page_folder
  - update book folder parsing method
    - chapter file, chapter_folder, part_folder
      - 00.md
      - 00
      - part_00

### 2021_12_14
  - add shape to page_floats
    - Rect, Circle, Path
    
### 2021_12_08
  - fix TOC page_number after prologue
  - picture_book create build folder
  - chnage _ebook to docs folder for github pages
  - update wing, prolog styles
  - custom text_style
  - implement page_floats

  - github webhook
  - github App
  - github Action

### 2021_12_07
  - ebook with svg page?

### 2021_12_04
  - fix paragraph line layout with image placement, 
      - line.next_text_line
  - to_svg for RHeading, ImagePlus, TitleText, Text


### 2021_11_27
  - page.to_svg

### 2021_11_26
  - Container.to_svg_element
  - Container.to_svg
  - Graphic.to_svg_element
  - Graphic.to_svg
  
### 2021_11_24
  - fix empty image box offset error
    - fix caption column in ImagePlus

  - use Struct with keyword_init: true
  - make Line with Struct

### 2021_11_13
  - r_papagraph image
    - image size - body_line_height
    - image_info file name.yml
  - r_papagraph table
    - tables folder

### 2021_11_13
  - redefine Line, path, polygon with Struct

  - class line x1, y1, x2, y2, thichness, color, dash head, tail


### 2021_10_30
  - _ebook, _pdf, _print, _build
  - make all generate folders with _
  - create
    - BodyMatter, BodyMatterWithParts
    - FrontMatter, BodyMatter, RearMatter
  - PartCover
    - part title

### 2021_11_2
  - bookcheego 
    - jumpstartpro
    - user, account, payment, book
    - upload, user_repo, github webhook
    - tailwind

    - book 
      belogns_to user
      book_info
      status
      github_repo
        email_date_slug

### 2021_11_2
  - add ordered list
  - add unordered list

### 2021_11_1
  - picture_book save results in _build folder
    - create, _ebook, _pdf, _print, _build
  - add BodyMatterWihtPictureSpread
  - picture_book has_no_cover_inside_page
    - fix back_page image 4.jpg/png not showing 
    - fix
      cp: #{ENV["HOME"]}/test_data/book/picture_book/book_cover/*.jpg: No such file or directory
      cp: #{ENV["HOME"]}/test_data/book/picture_book/book_cover/front_wing.md: No such file or directory
      cp: #{ENV["HOME"]}/test_data/book/picture_book/book_cover/back_wing.md: No such file or directory

  - localization
    book_cover:표지
    book_info:책정보
    part_info:파트정보
    front_matter:머릿부분
    front_wing:앞날개
    back_wing:뒷날개
    spread.png:양면배경.png
    title:제목
    subtitle:부제목
    author:저자



### 2021_10_28

  - add page_count to chapter kind
    all document kind shoud implement page_count 


### 2021-10-28
  - fix toc for part
  - fix peom starting page_number as h2
  - fix peom starting page_number
  
  - fix part_cover as 2 page, if it start on even page
  - dropbox based workflow


### 2021_10_26
  - Docs
    - PartCover, Poem, Essay

  - PartCover
    - single page
    - double page
  - Book
      Paperback
  - BookWithParts 
      EsseyBook, PoetryBook
  - PictureBook

  - generate ebook_indexe.html 
  
  - TOC with multiple page
  - book_part  set starting_page_number

  - text_style auto generator
      - give font, page_size, margin, body_line_count
  - rakefile for Dropbox
    - paperback, essey, poem
    - bio, picturebook
    - yearbook

### 2021_10_25
  - BookPart
 
### 2021_10_24
  - add toc doc pdf 

### 2021_10_23
  - fix footer in r_chapter, r_page
  - set default toc level to chapter title
  - add custom test_style support
  - fix first chapter heading style differing from the rest of the chapters
  - make rake task for dropbox based workflow
      - drop
      - done
      - error
      - log

### 2021_09_10
  - back_wing, front_wing, left_margin right_margin

  - method_missing in text
    - def 세고딕 GO_LIGHT
    - def 중고딕 GO_MEDIUM
    - def 태고딕 GO_BOLD
    - def 견고딕 GO_EXBOLD

    - def 세명조 MY_LIGHT
    - def 중명조 MY_MEDIUM
    - def 태명조 MY_BOLD
    - def 견명조 MY_EXBOLD


### 2021_09_04
  - rotate seneca 90
  
### 2021_09_04
  - BackWing
  - Seneca
  - fix RColumn line drawing
  - fix Image empty image drawing when x is not 0
  - FrontWing
  - CoverPage

### 2021_07_28
  - add to_yaml and from_yaml to Graphic, Conatiner

### 2021_07_10
  - round_rect 
    - corner_shapes[1,1,1,1] for round_corner
    - corner_shapes[1,0,1,0] for round_corner on left_top, right_bottom
    - corner_shapes[-1,-1,-1,-1] for inverted_round_corner
    
### 2021_06_15
  - GridTable
    - fix fill_color error
    - autofit text size
    - table style
      - color, category_color, line drawing rule, text alignment
    - auto adjust table coloumn width
    - merge category level text

### 2021_06_14
  - GroupImage
  - GroupedCaption

### 2021_06_11
  - create Grid class Grid < Graphic
    - implement relayout!

### 2021_03_08
	- remove stroke_sides in NewsBoxMaker, it should be set by front-end

### 2021_03_18
	- Text pdf drawing

### 2021_03_03
	- update article folders when saving article_info
	- fix bug when auto_ajdust max_height, articles that are shorter than max_height
	- write test

### 2021_03_01
	- Text < Graphic 
		init_text only if self.class == Text

	- add style_string for title_text, a free format style using html inline style
	-@font_size like 
		- "add_size:4;color:red;"

### 2020_10_02
	- put the font in style/font/, instead of /User/Shared 
		this will help if we have to put this on Docker
	- put the text_style in style/text_style.yml
	- in news_box_maker update page PDF if options is to update
	- generate page with actual PDF height, pushing down except the bottom most article

### 2020_6_22
	- fix paragraph layout_line
		we can get rid of many line method, if it is done by paragrph 
		line objects can be simplify
			- no alien_token 
			- no line_type 
			- no set_paragraph_info
			- no place_token
			- no token_union_style
			line should keep 
				- style_name
				- text_area
				- token should have different style_name when mixed
		
### 2020_6_3
	- redo creating RTextToken remove para_style, do it with style_name



### 2020_3_31

  - draw tittle, subtitle, overflow red mark
    
  - rjob from ruby
    - ad_box
    - page_heading
    - opnion
    - profile


### 2020_3_2
	- fix ruby_pdf fit_type 
		- fit_horizontal
		- fit_vertical
		- fit_crop_rect

	- clear crop_rect
	- fix subtitle not showing in page 1 article 1
	- add English hyphenation 
	
### 2020_2_23
	- TextToken should have hyphenation info for English word(for justify alignment)
		- dictionary for each language is needed

### 2020_2_11
	- increse hyphenation room
		- number with , do not break
	- subject head room for boxed

	- overlap article 
		top 2 lines and top line
	- body tracking *** ****
	  기고 사진 욱여넣기 없이
		
	- fix h2 first_text_? detection 2020_2_11 23 3 article 

### 2020_1_23
	- width_of_string with (font, font_size, scale, tracking), instead of just (font, font_size)
	- pdf_ruby
		- implement draw_pdf
	- fix image drawing
	- add pdf_ruby to pillar_layout

### 2020_1_20
	- frame_sides, frame_color, frame_thickness

### 2020_1_3
	- make token proxy to layout in line
	- make token_rep [string, x, style] , ex: ['this', 2.319 , 0]
	- get token with from hexa_pdf
	- def proxy
			[@text_string, @x, style_index]
		end

### 2020_1_2
	일반 발문 사용
	사진 그래픽 

		# 1단 2단 선택
		# 위치
		# 선 없음 추가
		# 상하 

### 2020_1_1
	- do not break token unless alignment is justify
	
### 2019_12_20
	- empty_first_column
	- opinion_writer2
	- quote_box
	- personal_photo_right_side

	
### 2019_12_5
	- fix adjustable_height change
	- do now show overflow text for adjustable_height
	
### 2019_11_30

	- fix paragrap creating line_text with ""
	- adjust_height
		- shift text_lines from colum to column without relayout
		# handle the case when we have half-width personal photo 
		def handle_overflow(number_of_lines)
			def push_up_text_lines_to_previous_column(number_of_lines)
				from second to last
			def move_top_text_lines_to_previous_column(number_of_lines)
			def move_up_text_lines(number_of_lines)

		def handle_underflow(number_of_lines)
			def push_down_text_lines_to_next_column(number_of_lines)
				from first to last
			def move_bottom_text_lines_to_next_column(number_of_lines)
			def move_down_text_lines(number_of_lines)

### 2019_11_26
	- get rid of overflowing red mark for adjustable_height article
	
### 2019_9_25
	- add NewsPillar.rb

	- newsman pillar .

### 2019_9_25
	- article_line_draw_sides
	
### 2019_9_24
	- TextToken
  	- remove height_of_token
	- from Rails save image layout_info
	- replace NewsBoxMaker with NewsArticleBox.open 
		- suppoert custom box stroke 
		- suppoert custom image stroke 
		- pass in NewsArticleBox.open adjustable_height
		- 
	- NewsArticleBox
		- tag, adjustable_height
		- layout_para_lines

  - Printing
		- body printing by paragraph
		- print using Ruby and Mac

### 2019_9_18
	- pillar based layout
	
### 2019_9_17
	- top_covered?, bottom_covered?
	- draw_divider

### 2019_9_5

	- fix heading width same as column
	- fix adjust subtitle to align when image position is above subtitle

### 2019_4_14
- person_image
	position of left or right, and make it float for left side person_image
	
- autofit_with_sibllings
	- do not allow push, if siblling is at the bottom and grid height is only one.

### 2019_4_10
	- image_box bottom_line

	- RubyPDF

### 2019_2_27

### 2019_1_11
	- NewsAdBox unless top_positin make top_margin as body_line_height
	- for head without title, make height as body_line_height

### 2019_1_11
	- update caption_paragraph
		- make separate line for caption_title and caption
	
	- update hypenation algorithm for front, ending rule for more case
		- update rule

### 2019_1_10
	- fix to_pdf

### 2018_12_31
	- token text v_alignment for reporter, caption

### 2018_12_27
  - fix bug column_width for both edge
  - heading_columns for column_count == 7


### 2018_12_26
  - previous_column for overflow_column
  - set overflow_column parent
  - align text height for email, caption 
  
### 2018_12_24
  - # 기자이름^
  - #### 관련기사^
  - 넘친기사에 ^ 경우 수정


### 2018_12_23
  - # 기자이름
  - ## 중간제목
  - ###
  - #### 연결기사

  - *, 디이아몬스 강조 
  - ** 고딕강조 

### 2018_12_21
  - top image_box, no space above
  

### 2018_12_11
  - draw overflow mark with overlap

### 2018_11_23
	- TitleText 
		space_before, space_after


### 2018_11_16
	- add ruby_pdf
		- fill
		- stroke
		- cicle, rectangle, round_rect, path
		
	- test for graphic

### 2018_11_13
	- overflow mark with announcement_box

### 2018_11_12
	- RubyPDF
		- Text
		- Image

		- fill
		- stroke
		- shape

		- multiple font suppoert
		- check color_space
		
	- rails integration
		- generate_pdf without writing layout_rb and story.md, just write PDF

### 2018_11_9
	- 홀짝광고 입력
		name, column, row, page_column, odd_even, x_grid
	- 안내문 넘침박스

	- 면배열표에서 레이아웃 수정/저장/생성

	- image crop
		- zoom_level
		- direction
	- story swap

### 2018_11_8
	- 그래픽 상단 1행 여백 수정
	- 안내문 넘침
	- 안내문 박스 하단 마진
	- 안내문 2단 잘림
	- 부제목 스타일

	- 이미지 상세설정
	- 이미지 줄
	- 이미지/그래픽 하단 행 추가시 및으로 되는것을 

### 2018_11_7
	- 안내문
	- 사진기사
		사진제목 과 설명 간격
		상단 사진기사 align with top title
		및줄치기
		사진설명과 이미지 사이 3pt
	- 사진 포지션 0
	- 사진 7,8,9 grow from bottom

	- 고딕 부제

### 2018_11_6
	- fix news_section_page story_count
		there was a bug when order of ad comes before the story_count
		it cound not display the artice properly
		
### 2018_11_5
	
	- fix caption_column last line alignment to left
	- fix caption_column source overlapping with last line text
	- fix NewsArticle box fill_color to white from clear
### 2018_11_4
	- fix caption_column last line alignment to left

	- align  caption_column v_align text to bottom 

### 2018_10_30
	- add flaot_announcement 안내문
		- background_color
		- prefix
		- alt_font_size


### 2018_10_13
	- TextBox
		- sides
			- sides_with_rect
			- sides_with_margin
			- sides_with_inset

		- column
			- column_offset
			- column_width
			- column_width_array
			- column_gutter_array

		- heading
			- heading_offset
		- profile_image
			- profile_image_at_first_column_top
			- profile_image_at_last_column_bottom
		- image
			image_position
		- quote
			quote_position

### 2018_10_10
 - editorial_with_profile_image

### 2018_9_23
 - merge rjob into newsman so that "cd path && newsman ." would do the same as "cd path && rjob ."
	so we don't have to have twp apps, rjob and newsman app.
	fit_text_to_box
### 2018_9_21

### 2018_9_19
	- text_fit_type: 'fit_text_to_box', 'fit_box_to_height
 	- include rjob fundction into  newsman
 	- fix number of lines error when underflow

### 2018_9_14
 - top_position ad not top_margin

 - paragraph style
 - line
	line_color
	line_thickness
	line_type
	line_position: baseline, bottom, middle, x_mark
	line_range: word, text

### 2018_9_3
  - fix chapter Heading
  - fix chapter first page main_box line count


### 2018_8_31
  - fix line_space of subtitle after two lines

### 2018_8_23
	- fix first_text_line returning Array
	- fix hyphenate_token to check for forbidden first and and
	- fix image color_space conversion with non-existing image

### 2018_8_20

	- fix image cmyk, convert color space except for pdf or eps

### 2018_5_7
		- add . , ! ? add forbidden first line character

### 2018_4_19
	- newsman
		- make_issue
		- make_page
		- make_article
	- create issue_plan by week
		- copy template and do make_issue

### 2018_4_19
	- draw_divider_line
	- fix overflow line count bug
	- improve body text filtering
	- fix page_heading
	- fix editorial image size
	- upload editorial image to graphic storage

### 2018_4_19
	- editorial_with_profile_image
	- fix less than a line overflow not showing

### 2018_4_15
	- not allow . , ? ! and the the beginning of line

### 2018_4_14
	- fix Text < Graphic to Text < Container
		- use pure Ruby, get rid of NSTextLayoutManager

### 2018_4_11
	- create overflow column with very long height
		- so we can calculate exact overflowing lines
		- save article_info
			- save overflowing text line by line
	- extened_line_count
	- pushed_line_count
	- fix page config.yml
	- fix news_section_page to reflect extended and pushed box
	- fix image line drawing when it is empty

### 2018_4_10
	- # in editorial not showing
		-should be larger than other reporter

### 2018_4_5

	- simple_text.rb
		We should make Text as Container Class and remove from Graphic
		We should make Image as Container Class and remove from Graphic

### 2018_4_4
	- fix ## extra blank line, except for when current line is first text line in column
  - fix br definition, include <br/>

### 2018_3_3
	- bottom_edge, rigth_edge

### 2018_2_27
	- # extra space in ##, ### for news_paragraph

	- border line drawing at draw_on_inset, or draw_on_margin

### 2017_11_18
	- text_train
			- automatic
	- max_x  set right most point, grow left side
	- max_y  set bottom most point, grow up side
	- mid_x  set middle point at mid_x

### 2017_11_12
	- editorial_title
	- opinion_title
	- main
### 2017_11_9
	- NewsImage put frame around image
	- put stroke at the bottom of ArticleBox

	- fullpage ad page_heading converted
	- optimize when switching page templates

	- create stroke_style.yml, layout_style
		기사박스    : [0,0,0,1]
  		이미지영역
  		이미지    : [1,1,1,1]
  		켑션    : [0,0,0,0]
		사진박스  : [0,0,0,1], [0,0,0,0]
		  이미지영역
		  이미지 [1,1,1,1], [0,0,0,0]
		  켑션   
		만평박스
		  이미지 [0,0,0,0]
		오피니언박스 [0,1,0,0]
		  프로필이미지 [0,0,0,0]
		사설박스 [1,6,1,1]
		광고박스

### 2017_11_8
	- apply differnt stroke_width on difference sides

	- word_stroke
  - sentence_stroke
  - line_stroke
  - para_stroke

### 2017_11_6
	- on NewsBox
		do not use top_position_filler in ArcileHeadings,
		use top_margin

### 2017_10_31
		- create NewsBpx < Container
				NewsArticleBox  < NewsBpx
				NewsImageBox    < NewsBpx
				NewsComicBox    < NewsBpx
				NewsAdBox       < NewsBpx
		- have config file for each, so that this could be modified by designer.

### 2017_10_24
	- line_fragemnt, text_token align text to the top
	- 제목박스 크기 right_edge 와 다름

### 2017_10_10
	- using trix-editor to save files as story.yml
	- story.yml
		head:
		body:
			- {markup: 'p', para_string: 'some string'}		# 본문

			- {markup: 'h1', para_string: 'some string'}	 # 준간제목
			- {markup: 'code', para_string: 'some string'} # 기자명

	- html2yml


### 2017_9_29
	- create NSUtils, refactor all scattered ns_atts_from_style

### 2017_9_27
	- fix custom style did not getting applied to title text

### 2017_9_18
	- layout_length bug
			- fix layout_expand default value

### 2017_9_15
	- layout_length bug
	- text vertical position
	- use Ruby PDF
		get font width

### 2017_8_27
	- add def mark_overflow in NewsLineFragment

### 2017_8_27
	- Text
	- NSText

	- Magazine
	- Chapter
	- AdBox

### 2017_8_27
	- caption_paragraph
		- source

### 2017_7_5
	- refactor color from all over the place into one module function
	- graphic class Line draw
	- add path

	- support box_style_attributes hash
	- add SVGView class as base
		SvgText, SvgRect, SvgLine, SvgPath, SvgPolygon, SvgImage, SvgG
	- GText, GImage, Container


### 2017_7_1
	- change text_size to font_size to make it work with other naming convention
	- fix NewsArticleBox for correct gutter and divider
	- fix NewsSectionPage for correct gutter and divider
	- fix TextStyle string key to symbol key check
	-
### 2017_7_1
	- make newspaper text_style to use custom style by publication
			when custom_style == true and publication name is given
			on the command line type
			"newsman article . -custom=#{publication.name}"

	- read styles from /Users/Shared/newspaper_text_style/#{publication_name}.yml

### 2017_6_1
	- add custom_style to load
		- if options[:custom_style]
		- if there is "custom_style.yml"

### 2017_6_1
	- add Path Object

### 2017_5_11
	- NewsSection
		- pass gutters_array with divider

### 2017_5_10
	- NewsArticleBox
		- leave one empty line at the bottom
		- draw top line for non-top-position article
		- top_position
			- top_margin == 3 lines
		- top_story
			- mutiple column intelligent subtitle
	- NewsPage
		- add page_heading to page

### 2017_5_5
	- relayout! align justify

### 2017_4_30
	- image, cation_title, caption
		add image_hash, personal_picture, quote to head in story

### 2017_3_28
	- image, subject_head, profile_image, quote

### 2017_3_26
	- add top_subtitle to newspaper style

### 2017_3_24
	- fix top_heading implementation bug
		1. we have two substrings displayed.
		1. position of substrings comes before the title.

### 2017_3_22
	- fix last line alignment of justify mode to align left, when token in too few.

### 2017_3_21
	- space_before_in_lines, text_height_in_lines, space_after_in_lines,
	- bottom_margin_in_lines

### 2017_3_18
	- top_margin_in_lines, bottom_margin_in_lines

### 2017_3_17
	- TextToken hyphenation, token alignment, line ending rule, orphan

### 2017_3_13
	- Korean TextToken hyphenation

### 2017_3_10
	- fix last line of column bug,
	- Fix bug: not printing if text overflow , bug title not showing
	- gutter_line(line_frame_rect, thickness, color)
	- example: gutter_line([4,0,4,10], 0.5, 'black')
	- new paragraph in middle of column expands beyond line
	- style guide
		- subject_head, subject_head_body
		- underline
	- email based workflow
			to: layout_server@naeildesign
			subject: url
			title: this is title
			subtitle: this is sub title
			---
### 2017_2_28
	- we should have news title, subtitle style for large article

### 2017_2_27
	- news_article_box,
	- create overflowing line with red lines
	- fix image size, no heading...

### 2017_2_26
	- news_article_box
	- make body_height_with_given line_count, not font size, 8 lines per one grid? or 10?
	- expand and reduce article box, also update section layout position
	- change dummy image drawing, stroke sides [1,1,1,1,1,1,] for x mark

### 2017_2_25
	- news_article_box
	- new lauyout for newspaper, NewsBoxMaker, NewsArticleBox, RColumn, RParagraph, RLineFragment

### 2017_2_5
	- hexapdf Tj TJ, tm, tlm

	- fix Container bug
		additional container is inserted when processing block
		calling stack was creating another Container, fixed.

### 2017_2_2
	- newsman
		- specify heading_columns when creating NewsArticleBox
		- heading title and subtitle size according to heading_columns
	- Greeking mode
		- fill token with gray box

### 2017_1_2
	- news_section
	- show overflow
	- show box number
	- best_fit
	- try to fit by reducing
		1. image
		2. by heading
		3. as a last resort is to reduce sibling size.
		options
			i: reduce image,  
			h: reduce heading
			s: reduce sibling


### 2017_1_25
	- Use YAML,as design template
	- method_missing, undefined_key for tagged text
	- look for design for method_missing, or use Text as default class

	Stylea are predefined Hash tables
	They can be merged with custom styles at run time,
	making them very flexible components.
	We can define default component and override only what we need at run time.
	We can override content as well as styles.
	Operations can be achieved simply by using Hadh#merge,
	changing only those that are specified in merging Hash(custom element).

### 2017 1 24
	- module_function color, unit, rectangle functions,
	- add bar, stack, g,
	- include RLayout
	- render svg

### 2017 1 17
	1. Fix Chapter for going beyond two page.
		- fix layout_items in TextBox

	1. fix when overflow happens, there is a bug, layout_lines for the second time.
		- fix layout_lines in Paragraph

	1. make continuos page_number from doc_info.yml
		- generate toc
		- add set starting for next chapter page to doc_info.yml
		- set starting page from doc_info.yml
		- add update_toc to book.app command

	1. fix Rakefile to process only changed file.

	1. force chapter starting page to right side only, or left side only.

### 2017_1_14
	book
	1. Fix Chapter for going beyond two page.
	1. make 00_front
		- generate toc
		- add set starting for next chapter page to doc_info.yml
		- set starting page from doc_info.yml

	1. fix Rakefile to process only changed file.

### 2017 1 12
	- add image crop
	- add image caption
	- line
	- jump_to_box
	- 5_dan_tong_6x15_h_4

### 2016 11 22
	- news_heading
	- multiple_story_article

### 2016 11 21
	- fix stroke drawing with extra origin offset value bug

### 2016 11 2
	- fix label font_size*0.8 bug

### 2016 10 23
	- fix bug in MRI RFont String width calculation bug
	- rename ChapterMaker to Chapter
	- cover art
	- chapter
	- update Book
	- add Cover, TOC, Forward, Dedication template
	- update Rakefile to update toc, update starting page_number
	- generate Flipbook
	- add pdf_insert, float_group

### 2016 10 21
	- fix text_box layout_item line overlapping in second page
	- rlayout_core
	- article
	- rjob

### 2016 10 19
	- fix newsman

### 2016 10 18
	- rearrange test
		so that it only loads what is needed

### 2016 10 12
	- add TOCChapter
	- fix left_margin
	- custom toc_chapter_style support

	- Cover, Forward, Preface, Colophone
	- PhotoChapter

	- FakerBook
		title
		author
		- filename_output: true will output pdf with filename.pdf
		  otherwise output.pdf
		- fix footer
		- justify

### 2016 10 11
	- Chapter/Book
	- generate TOC
	- set Starting page
	- grid_layout
		- auto-generate grid_layouts by splitting

### 2016 10 7
	- Rakefile file dependency on either md or layout.rb, not both

### 2016 10 5
	- PDFChapter
		merge pdf files in given folder and archive original files
		actual task is then passed to PDFFile for PDF file processing
	- PDFFile
		process single PDF file.
		generate jpg, preview, doc_info

### 2016 10 4
	- fix list justification
	- Add ImageToken

	- add emphasis style to "p"
	- headingContainer variable line

### 2016 10 3
	- List
	- OrderedList
		fill_color
		indent
		space_before, after

		\n and checkmark
		page_number

	- demo pre
		rake
		  document folder, subdocument folder
		  bookplan
		fill in the data
		  rails rake copy templates
		web flipbook
		ace integration
		PDF download
		Question Bank

### 2016 10 3
	- footer

### 2016 10 1
	- list style paragraph with graphical numbering
	- v align center

  # add list_style to para_style
	list_style => {
		:font=>"Times",
		:text_color=>"Blue",
		:font_size=>16,
		:text_indent=>30
	}

### 2016 9 30
	- box token left_margin, right_margin
	- fix ChapterMaker bug para[:string] to para[:para_string]
	- fix paragraph color support
	- space_before, space_after

	- list_style
		list_type 				# list types are number, lower_alaph, upper_alph, korean_raical, koran_ga_na_da,  roman

	- heading\n by forcing relayout
	- heading background image
	- sub_para_left_indent
	- first_para_top_margin
	- last_para_bottom_margin


	- create cocoa_text cli tool for supporting font and width for mri

	- create meta-data
		- footer

### 2016 9 29
	- HeadingContainer

	- designer_pargraph
		- has starting marker for parsing
			A. B. 1. a. ii.
		- has_sub_paragraphs
		- has_layout_file
		- group_margin

	- typo fine controll
		- Line Space, Space Before, Space After
		- Order indent
		- Head indent
		- Line indent for background color

### 2016 9 28
	- vertically justify items
	- Web based editing, flipbook
	- Rakefile

### 2016 9 26
	- rakefile for book, rakefile for chapters, rake update
	- manual adjustment
		- </br> for manual adjusting space_before and space after
		- </page> for manual adjusting space_before and space after
		- \n for manual new line
		- <<text><color>>

	- implement box, underline token
	- fix text_color for Paragraph
	- style_run
	A problem: There are many cases where we have mixed styles in a
	paragraph. Text could be separated by \t
	And for each segment style_run is used to address this.
	defined in styles, it is a run

### 2016 9 25
	- implement ruby and reverse ruby RubyToken

	- Paragraph fill_color
		all line_fill_color = "Clear"
		all tokne_fill_color = "Clear"
		make token colors as "clear", make line fill_as
	- space_before, space_after in layout_lines


### 2016 9 24
	in document template load current_style with options[:current_style]
	options[:current_style]   = text_style
	options[:layout_style]    = @layout_style
	RLayout::Document.new(options)

### 2016 9 23
	- fix Hex Color
	- fix new line
	- background color in Paragraph
	- Custom Style Support for List

	- HeadingContainer
		We need a mechanism to replace Heading Template text with markup text.
		since markups do not have keys, we need to idetify which maps to which tag,
		this is where @tag_list comes in as pre-defined keys,
		hash = Hash(@tag_list.zip markup_lines)
		we use this hash to look for tags and replace it with values.

		- set_tag_list sets :tag_list to HeadingContainer
			it converts String tags to Symbol tags

	- OrderedList
	- UnrrderedList
	- OrderedSection
	- UpperAlphaList

### 2016 9 22
	- markup2heading key_map
	- style_run
	# runs are separated by \t
	# color_run: ["brown", CMYK=0,0,0,100]
	# size_run: [0, 5] add point size to current size
	# size_run: [0, 10%] add % point size to current size

	# key_map: ["number", "title", "subtitle", "leading"] defined in style of h1
	# = 03
	# Some title
	# some subtitle
	# leading text here

	# above markup and map will be converted to
	# h ={number: "03", title: "Some title", subtitle: "some subtitle", leading: "leading text here"}
	# document.pages[1].heading.set_content(h)
	# above will set the content of HeadingContainer

	# ["title", "subtitle"] defined in style of h2
	# == Some title
	# Answer in page 2

	# ["title", "subtitle"] defined in style of h2 options can be add at the last line
	# == Some title
	# Answer in page 2
	# {allow_multiple_page: true}

### 2016 9 21
	- add pass page_headings options to document
	- this will allow custom heading support
	- add HeadingContainer for complex Heading
	- add SpreadDocument, a two page document with Heading in each page.

### 2016 9 19
	- heading with background image
	- floats
	- remote story
	- remote item
	  QuizBank with collections(images or json)
	  REST API that can receive item collection from remote server.

### 2016 9 18
	- implement OrderedList, UnorderedList

### 2016 9 5
	- fix yaml | with csv
\\	- Prefix
		{prefix: "Chapter:#{number}"}
	- label::
	- ordered list
		.
		..
		...
	- unordered list
		*
		**
		***
	- custom style
		## word ##		emp1
		### word ###	emp2


### 2016 9 1
	- LeaderToken
	- EnglishQuizItem
	- quiz item path/to/quiz_item.yaml

### 2016 8 28
	- TitleText
		- set_text
			text_layout_manager
				- set_text_string
		- set_image_path
		- set_local_image

### 2016 8 28
	- remote_reader

### 2016 8 26
	- pdf to flipbook
	- fix collect_flipbook_data
		- put images by chapter
### 2016 8 26
	- create FlipBook
		- side toc
		- make it jump to chapter
		- create hollow template


### 2016 8 25
	- move templates to rubymotion.app/resouces
	- create new book with given template
		book new my_book template=paperback
		book new my_quiz template=quiz_book
		book new my_magazine template=ourtown_magzine

	- change Book chapter cli to Chapter
	- fix Rakefile tasks in book folder
	- 2r bug when generating font with scale matrix
	- QuizItem
		QuizItem.sample(200)


	- asciidoctor to active_record
		- asciidoctor add on markup
			class Node
				node_type
				name
				parent
				text
				attributes

### 2016 8 22
	- fix layout bug paragraph after space
	- generate doc_info.yml for each book documents
		doc_info[:toc]
		doc_info[:index]
	- add document type in header
		cover, toc, forward, dedication, chapter, index, appendix, glossary
		memo, calendar, pdf_inserts
	- and merge doc_info[:toc] into project/front_matter/toc/doc_info.yml
	- add custom markups to adoc file
	- add forced layout to Rakefile

### 2016 7 29
	- parse adoc quiz format
		. question
		.. choice
		image::drawing1-3.jpg[figure]
		== 3
		=== this is why

	- parse markdown quiz format
		1. question
		 	1. choice
		image::drawing1-3.jpg[figure]
		## 3
		### this is why

	- TextTrain, TextStack, EShape, label

### 2016 7 28
	- fix QuizItem
	- parse QuizItem, using both markdown and hash
	- fix cli, to take local path, not absolute path

### 2016 7 27
	- move read_story to Story and
	  refactor from ChapterMaker, MagazineArticleMaker
	- Create ItemList, something similar to Story but handles itmes

### 2016 7 15
	- add hex color #FF0022
	- make styles similar to css
		- text_align
		- rgb(r,g,b)
		- rgba(r,g,b,a)
		- border, radius

### 2016 7 15
	- hex color
	- Quote, Leading, style

### 2016 7 13
	- float_group
	change ImageGroup to FloatGroup
	[floats]
		image grid_frame
		quote grid_frame
		allow_text_jump_over
	[picture_page]

### 2016 7 5
	- ItemChapterMaker
		- header with Image
		- side_column
		- ItemContainer
		- numbering

### 2016 6 25
	- add :stack for  stack mode

### 2016 6 17
	- fix Paragraph layout_lines(text_column) for complex column
	- fix page numbering in ChapterMaker

### 2016 6 16
	- fix Paragraph layout_lines(text_column)

### 2016 6 13
	- image fit mode 0
	- puts image at origin and make image size as source size

### 2016 6 10
	- create label
	- make default alignment as "left", not "center"
	automaticall set bold for some text followed by :
	sets "T:" part with bolde text "Helvetical-bold" as defualt
	or your can set your own font for "label"
	ex:
	label("T: 010-445-6688")
	label("E: some@gmail.com", label_font: gothic-bold)
	label("M: 010-445-6688", label_text_color: 'gray')

### 2016 5 22
	- make long document grid_based, based on body grid
	- Paragraph
		- first_line_indent
		- left_indent, right_indent

### 2016 5 14
	- Paragraph

### 2016 5 12
	- paragraph text line space ???
	- eliminate empty line between paragraphs

### 2016 5 10
	- FloatGroup
		page_offset
		allow_text_jump_over

### 2016 5 5
	- add long document support
	- add class LongDocument

### 2016 5 4
	- custom style_support
		chapter_style.rb, magazine_style.rb, news_style.rb

### 2016 4 27
	- fix paragraph snapping space skipping, column_layout_space = 0
	- min_y(grid_frame.rect)

### 2016 4 21
	- make parent as options parent
	- relayout image_fit when relayout!

### 2016 2 23
	- Quiz Maker
		- add reading text
		- add answers page
### 2016 2 22
	- heading QuizHeading, NewsHeading

### 2016 2 21
	- refactor grid in Graphic
	    handle grid_frame option, parent_grid_base option
		init_grid should go under container init
	- grid_box

### 2016 2 17
	- MusicChapter
		- put the Header
		- round_rect doesn't do rounding

### 2016 2 15
	- GridBox
	- CompositePage, generate HTML with map

### 2015 12 21
	- parse idml

### 2015 12 20
	- add galley mode printing

### 2015 12 7
	- get rid of Klass, just use class
	- fix memo
	- fix Line

### 2015 12 5
	- add MemoArea

### 2015 12 3
	- custom table style support, named table style
	- master page, chapter, toc, index
	- admonition

### 2015 12 2
	- for articles, support design layouts with different name
	 	as long as they have .rb extension.
	- fix newspaper for new structure

### 2015 12 1
	- import table data from csv
	- make table to grow height, break along liked columns
	- fix TableRow height

### 2015 11 29
	- Admonition, label list, icon
	- synthesised char symbol
	- convert hwpml table to adoc table(psv)

### 2015 11 27
	- parse Hangul hwpml, create hwpml to rlayout folder
		- create layout.rb and Rakefile
		- hwpml korean file name not displayed properly in Mac
		- determine image file types,
		- fix .bmp filetype bug
		- save table info to disk

### 2015 11 25
	- fix hwpml parsing for fragmented paragraph
	- add paragraph level

### 2015 11 24
	- parse hwpml
	- save image
		![Alt text](/path/to/img.jpg)
		![Alt text](/path/to/img.jpg "Optional title")
	- parse table

### 2015 11 13
	- fix ImageBox height calculation bug
	- fix Image shadow bug
	- add ImageBox IMAGE_PATTERNS add rotation, [1,1,1,1,5], [1,1,1,1,-5]
	- ImageBox add image_pattern options

### 2015 11 10
	- fill upto margin_rect I need to fill the entire area with fill

### 2015 11 10
	- fix ImageBox image_style

### 2015 11 9
	- TextTrain, char_train

### 2015 11 7
	- is_anchor: true, from_lelf, from_bottom, width, height
	- class growing_box < Container

### 2015 11 5
	- Graphic
		- fill_image, shadow, rotation
	- process emphasis element _itatic_, *bold*, underline, super, sub,
	- app distribution,
		demo version, validation date check with license server, 		
		installation, auto update
		Documentation

### 2015 11 4
	- text_string_array, text_atts_array

### 2015 11 3
	- flowing_item
		member_item, product_item,
	- anchor

	- center[:vertical, :horizontal]
	- page_count, scale, fit text to text_box

### 2015 11 2
	- image_caption is done with flowing item

### 2015 11 1
	- paragraph
	- prefix_text, prefix_image, prefix_number

### 2015 10 26
	- Magazine save_toc
	- Document save_layout_info option layout_info.yml
		page_count: page_count
		toc
		x_ref
		index

### 2015 10 25
	- Listing
	- BoxAd

### 2015 10 23
	- ObjectBox

### 2015 10 22
	- ImageBox, image_pattern
	-

### 2015 10 19
	- Rakefile, add changes to layout.rb file
	- Guardfile
	- fix grid_rect, set show grid_rect from document

### 2015 10 18
	- set demotion level 4, when parse markdown to para_data

### 2015 10 16
	- fix quiz markup for GeeMoo
	- style
		- add layout info to text styles
			fill_color, fill_type, stroke_sides, stroke_width
		- pass layout_style to document

### 2015 10 15
	- heading text element with "clear" color as default fill_color
	- apply styles to newly creating pages, and TextBoxes
	- master_page
		doc,
		pages
			starting_page_number, middle_page, ending_page
			left_side, right_side
			starting_left_page, starting_right_page,
			middle_left_page, middle_right_page,
			ending_left_page, ending_right_page
		heading
		text_box
			heading
			image_box
			image_collection
			quote_box
			lead_box
			table
			side_column
			make_even_bottom
		header
		footer
		item

### 2015 10 14
	- fix bug: in text_box layout_item duplicating item insert
	- draw inter_column lines
	- custom style support
	- answer sheet

### 2015 10 13
	- grow/shorten graphic height as text height
	- 'keep_box_height', 'fit_text_to_box', 'adjust_box_height'    

### 2015 10 12
	- QuizChapterMaker
	- fix multi column bug

### 2015 10 7
	- Book,
	- side_column support
	- image_layout.rb?
	- Document generate document_layout.rb
	- place dummy_image.jpg if no image is present

### 2015 10 6
	- fit_text_to_box
	- FloatGroup

### 2015 10 5
	- Table category cell font size
	- fix text overflow for non-proposed_height
		it should be
		range= @layout_manager.glyphRangeForTextContainer @text_container
		if range.length < @att_string.string.length

### 2015 10 3
	- delayed content layout
		- by calling layout_content
		- Page should call layout_content to nested graphics

### 2015 10 2
	- categorized Table with category color
	- CategoryRow: group of rows with Text
	- ImageCategoryRow Image as category item.
	- ImageRow: Row with image cells
	- CustomHead : customizable text

### 2015 10 1
	- table_column_width_array
	- table_column_width_array_average
	- table_column_width_array_longest
	- auto_column_width = off, average,
	- table_column_align_array

### 2015 9 30
	- fix: fill_color should not be Text background color
	- fix: layout_lines should have auto adjusting height optional

### 2015 9 28
	- TextCell vertical fit
	- support toned down color
	- category_level = 1 table

### 2015 9 27
	- TextCell font
	- TextCell stroke_sides line drawing
	- default table_style
	- support custom table_style
	- Table Style Keys
		head_row_atts
		head_cell_atts
		body_row_atts
		body_cell_atts
		body_row_colors = body_cell_atts[:cycle_colors]
		category_colors

### 2015 9 23
	- form for complex short table
		- stack, bar, hori, vert
		form do
		 bar do
			"this",
			stack("that", "this"),
			"that"
		 end
		end

	table_text = <<-EOF
	---
	has_head: true
	___

	|this span(d1)| that| more text|
	|             |     | more text|
	EOF

### 2015 9 22
	- table
		bug fix
			- Hangul Support(motion-csv bug)
			- underline drawn at some cells

		- line drawing, # book_mode, book_mode1, news_mode
		- text fitting
		- row width array
		- Heading style, first row style, body cycling

		- table style in Styles
		- custom table style support

		- linked table
		- linked table has_heading
		- multi-column
		- category, category_level
		- head_corner_cell col\row

### 2015 9 20
	- Newspaper
	- NewspaperIssue
	- NewspaperSection
	- made NewsBoxMaker work with story folder

### 2015 9 18
	- NewsBoxMaker bug that heading is not showing
	- def heading in TextBox
	- support \n for new line in text_record

### 2015 9 7
	- Custom Chapter style
	- running float image, bleed
	- HorizontalRule Rule < Line
	- add Heading background
	- add running page insert marker

### 2015 9 6
	- parse image ![]{grid_frame: [0,0,1,1], local_image: "1.jpg"}

### 2015 9 1
	- error handling when pgscript eval fails
	- show/hide grid rects in TextColumn


### 2015 8 31
	- magazine: do not add page when layout, just use as designed
	- news_article_maker

### 2015 8 30
	- TODO: prevent blocks from executing multiple times
	  once in super and one more time in child class
	  get rid of block processing in Page
	- do not execute blocks in Container
	- do it only at the super class of Container

### 2015 8 28
	- MagazineArticleMaker
	- main_text
	- heading, float_image , quote, leading
		floats using grid_frame

### 2015 8 27
	- ChapterMaker, MagazineArticleMaker,
		replace Chapter, MagazineArticle, NewsBoxMaker
	- support custom style loading at rum time


### 2015 8 14
	- fix image fitting in nested pgscript layout
	- add position
		top_left, top_center, top_right
		middle_left, middle_center, middle_right
		bottom_left, bottom_center, bottom_right

### 2015 8 5
	- support graphic rotation
	- multiple layout templates for selection
	- magazine
	- pgscript manual

### 2015 7 29
	- rjob batch mode

### 2015 7 7
	- improve text layout
		fix text spacing

### 2015 7 3
	improve PageScript
	- add profile
	- add place
	- add replace
	- * nested replace

### 2015 7 2
	- add stroke_sides

### 2015 7 1
	- project_path local_image
	- name, division, job_title, address1, address2
	- en_name, en_division, en_job_title, en_address1, en_address2
	- ch_name, ch_division, ch_job_title, ch_address1, ch_address2
	- heading, text_box, side_bar, image_box, text_bar
	- title, subtitle, author, leading, quate, p, h4, h5, h6

### 2015 6 17
	- news_article add reading image layout info
	- auto fit news_article

### 2015 6 12
	- add  section_name to section config

### 2015 6 1
	- move grid_frame and grid_size from story metadata to config in section
	- I should hide this info from users, they don't need to see this.
	- create symbolic link after creating pdf and jpg, if newsman server
	 	is set
	- newsman_issue_path: "/User/mskim/..../OurTownNews/-2015-5-20/Sports"

### 2015 5 30
	- save jpg with option jpg: true
	- don't save pdf with pdf: false

### 2015 5 21
	1. NewspaperSection
		- create images folder in section News
		- working_site.html
		- newsman@gmail.com
		- multi-threaded rake, use global rake

### 2015 5 16
	1. Newspaper
		- float image
		- article type
		- line decoration

### 2015 5 15
	1. book
		images,
		fix line space between paragraph

### 2015 5 13
	1. support for default and custom Styles
		- set body_line_height for textColumn
		- @current_style =StyleService.shared_style_service.current_style

### 2015 5 12
	1. image_fitting, image_frame
	1. rjob, rnews, rbook, rnamecard, ridcard, rcalendar

### 2015 5 11
	1. draw grid lines
	1. update Text(text_layout_manager) for nsview drawing


### 2015 5 10
	1. GraphicViewMac Drawing
		- I was using subviews to present chidren, but it has some problem.
		- strokes that goes beyond the subview frame are cut off.
		- I decided not to use subviews for children,but use transforms instead
		- I can also implement rotation using transforms
		- in order to use transforms, I have to use bounds instead of frame.
		- for center point rotation, I have to use center point bounds.
### 2015 5 7
	1. motion rlayout_test app to test in rubymotion environment.

### 2015 5 7
	1. Image fit_type, fit_best, fit_horizontal, fit_vertical
	1. image size detection with mini_magick
	1. image clipping area
	1. NSViewDrawing

### 2015 5 2
	1. change line records to stroke stroke[:color], stroke[:thickness], stroke[:dash]
	1. SVG drawing, Container, Page, Document
	1. Line, LineArrow, Ribbon, RomanDagger, SawTooth
	1. Struct

### 2015 4 17
	1. Graphic drawing
		1. fill_type,
		1. line_dash, line_type, line_drawing_sides
		1. shape clipping path, shape corner

### 2015 4 16
	1. Add Sojo layout script
	1. remake grid_key pattern 7x12/5, 7x12/H/5, 7x12/HA/5
	1. Add image to story, add auto fit with image resizing, min, max
	1. add filtering to story \'

### 2015 4 13
	1. Newsman integration
	1. Dropbox integration
	1. change_section_layout
	1. change section grid_layout
	1. support custom grid_key file
	1. synthesize grid_layouts
	1. 7x11, 7x6, 6x11, 6x6

### 2015 4 11
	1. grid_key with head notation 7x12H/4, 7x12/5

### 2015 4 10
	1. Rakefile for story.pdf, section.pdf, heading.pdf
	1. has_heading

### 2015 4 8
	1. Article, NewsBoxMaker, NewsSection
	1. grid_size with margin, gutter page_size
	1. put the grid_pattern_with source, no need to save it as file
	1. heading_column for news_article story.
	1. Page with and without Heading
	1. Save section_info.yml in section folder
	1. Save CSV

### 2015 3 31
	1. Merge grid & float into major feature.
			Update PGScript to make use of it.
			Update PGScript for NewspaperSection

### 2015 3 30
	I am getting invalid context error, And I can't find the reason why!.
	I am going back to using NSText, from CoreText.
	CTFrameSetter to NSLayoutManager
	I will have to work on proposed lect stuff for illegular shaped containers.
	I will also implement Pure Ruby version of Text so, I can use it on
		1. non Mac EC servervice
		1. Opal on the browser.

	1. Update TextBox for NSText change, Dropcap, Splitted Paragra case

### 2015 3 23
	- parse adoc format, get the tree info, convert it to para_tree
 	- paragraph should container more information to accommodate node
	- level, context, lines
	- add admonition

### 2015 2 11
	- rlayout cli using RubyMotion as App
	- setup github and bitbucket
	- rlayout, photo_layout, restaurant

### 2015 2 9
	- node_tree
	- PhotoBook

### 2015 2 2
	- add save_jpg
	- save_pdf(path, options={})
### 2015 1 29
	- fix paragraph height bug
	- align_body_text: true
	- refactor
		update_current_position
		snap_to_grid_rect
		scan_covered_grid_from

### 2015 1 24
	- set default image grid_frame_as [0,0,1,1,] for text_box

### 2015 1 21
	- include Utility
	- refine float image layout
	- fix starting line offset bug
	- fix markdown parsing bug . with no text_markup  

### 2015 1 20
	- float_location: top, middle, bottom
	- float_bleed: false, true

### 2015 1 19
	- text_box layout_item
		1. make TextColumn starting_point at creation
		1. create path with path_from_current_position
			should handle simple rect, complex rect, and multiple chunked path
		1. layout_ct_make
			for overflow compare the att_strring with last line range

### 2015 1 16
	- use path for layout_lines
	- path_from_current_position
	- I may not need to set starting_position for complex column,
		it could be the top, if I implement the path
	- TextBox should call overlapping can creating at the laout_item

### 2015 1 15
	- fix layout_items in TextBox
	- fix split paragraph

### 2015 1 14
	- fix TextColumn room, based on grid_rects
	- fix case when we have hole in the middle of TextColumn

### 2015 1 13
	- fix float overlapping mechanism with grid_rects in TextColumn
	- fix non-rectangular shaped column
	  	- spliting
		- layout paragraph

### 2015 1 9
	- fix Kramdown parsing error(done)
	- news_article, text_box,
	- current_style, merge with custom style
	- floats
		when overlapping floats,
		modidify or divide columns into pieces
		body_text unit
	- floats images
		have floats template

### 2015 1 7
	- fix NewsBoxMaker, TextBox

### 2014 12 31
	- fix grid,
		- grid co-exists with auto_layout
		- use it with float

### 2014 12 26
	- fix NewspaperSection(done)
		- heading, 6x12, 7x12

### 2014 12 26
	- convert cm, mm to pt(done)
		:width=> "16.5cm", :height=>"24.5mm"
	- rlayout news_article project/folder
		- rlayout idcard project/folder
		- rlayout book idcard project/folder
		- rlayout chapter project/folder
		- rlayout magazine_article project/folder

### 2014 12 20
    - fix auto_layout bug starting_y as bounds_rect, instead of frame_rect

### 2014 12 19
	- text_fit_to_box
		- set initial font size as 80% of box

### 2014 12 16
	- text_fit_to_box
	- text_layout_manger layout_lines when relayout is called

### 2014 12 15
	- add page_size

### 2014 12 14
	- remove margin from attr_accessor

### 2013 12 13
	- idcard
	- text_form
	- text_field
	- variable_document

### 2013 11 28
    - image handling
	- bleeding
	- caption
	- composite_page

### 2013 11 25
	- Dropcap

### 2013 11 24
	- fix split
	- use CoreText instead of NSTextSystem
	- Heading
		- multiple line text support
		- make height align to body text
		- author right_inset
	- Add heading_columns table in Style

### 2014 11 18
	- text_layout
### 2014 11 15
	- include Image to Markdown
	- include Image Caption to Markdown
		- caption position bottom, right, left, top, float
	- adjust space before and after Image to body grid
	- adjust Image inset
	- find hosting middleman build static book,
	- BitBalloon, CodeShip, Netlify
### 2014 11 12
	- auto_layout align top, center, bottom, justify
	- layout non-expanding children column
	- fix set_frame, should reset text layout_size

### 2014 11 10
	- image drawing,
	- update image with frame changes
	- fix left_page header location bug

### 2014 11 7
	- variable page, variable document
	- DB_Chapter
		control column_count 	from options
		column_gutter 			from options
		Floating Heading		from options
### 2014 11 6
	- product_box with image
	- product_box with template
### 2014 11 5
	- fix nested object_item_drawing, non_overlapping_bounds
### 2014 11 5
    - font with weight support, get the postscript names
	- try smSSMyungjoP-W30, smSSMyungjoP-W35
### 2014 11 4
	- object_chapter
	- create TextBox for paragraph flow
	- Merge StoryBox with TextBox into one
	- fix left header position
### 2014 11 3
 	- fix auto_layout bug
### 2014 11 1
    - Book build web-site, ebook, mobi
	- Dropbox integration
	- Make DRb_server
### 2014 10 30
	- tracking support #TODO need to test this
### 2014 10 23
 1. html generation for chapter
	- book navigation bar
	- book cover page
	- toc
	- file task
	- bootstrap
	- WordPress Import / Naver blog import
 1. rake file for auto template generation
 1. dangling  last line character removable (less than 2 characters at last line is removed by tracking previous line text.)
 1. inserting images in markdown
### 2014 10 23
 1. modified columnObject insert item with text_layout_manager
### 2014 10 22
 1. split paragraph among two different columns, using one layout_manager, one text_storage, two text_containers
 1. applying widow/orphan rule
	{widow: 2, orphan: 2}
### 2014 10 21
 1. Vertical Text using NSTextView
### 2014 10 20
 1. text_starts_at anywhere, column, text_box, page, right_page, left_page
 1. text_drop_cap_line_count, text_drop_cap_char_count
 1.
 1. text_colors in hex/cmyk/rgb
	- drawRect and text layout in one place, in Model, only
### 2014 10 19
 1. implement to_hash
### 2014 10 18
 1. changes from previous RLayout/working
	- No GraphicRecord, make them part of graphics, flatten it, except TextLayoutManger for text, replacement of TextRecord
	- TextlayoutManager: vertical text, FatText(SuperRichText) support
	- Use views and subviews instead of calculating translated coordinate, support graphic rotation
### 2014 10 12
 1. vertical text for Japanese
 1. breaking paragraph
 1. DropCap
 1. line_edge=[1,1,1,1] or [0,1,0,1] for top and bottom only
 		[0,{line_type: 2, line_color: "red"},0,1]
 1. make CustomStyle as subclass  of  BaseStyles
	- title, subtitle, as methods that return hash values
	- heading,

### 2014 10 11
 1. Git based workflow
 1. User downloads the project folder from the site
 1. User makes changes to the content.md or image/
 1. Web_hook for repos,
	- user commits changes, and pushes
	- on the repos, post_commit
		- cd into_users_folder && rake
			- rake pulls
			- triggers DRb
			- DRb generate pdf process_markdown_files
			- after successful pdf generation, push it back to repo
	- once it is in the repo, waits for user to pull
	- users pulls the updated pdf version

 1. rake file markdown2pdf
 1. toc.rb
 1. DRb server
 1. book_config.rb

### 2014 10 10
 1. get rid of styles category, use @current_style
 1. text_bar.rb
 1. footer page number font is different from footer title text

### 2014 10 9
 1. fixed Paragraph clipping bug, by adding text_line_spacing to the height.
 1. head1, head2 height should be multiples of body height, and vertically centered

### 2014 10 8
 1. alignment justify

### 2014 10 7
 1. chapter heading only header
 1. book title and page number footer on left side
 1. chapter title and page number footer on right side

### 2014 10 6
 1. Chapter heading should be set with layout_unit_length, not as floats
 1. first line indent

### 2014 9 23
 Paragraph Object
 TextColumn
 TextBox linking
### 2014 9 22
 - svg generation for Image
 - svg generation for Container
 - do not wrap into a svg <svg></svg>, do not make it multiple page svg
use rect or graphic shape, fill, and line

### (2014) 9 19
 Using DRb
 Using DRb & Git
 Using Git
	setup account at bitbucket or github with user name rlayout
	this account will serve all the clents for the site
	I should setup own with gitlab, but for for time being use bitbucket
	1, have client setup git on local machine
	user sign-in:  take user email and verify email
	create user
	when user download template:  
		1. create a project with user_email, template_name, and add user's email as collaborator to the project
		1. edit downloading templates's git setup, change remote origin to github template project
	rake pdf:
		git add -A, git commit -m'time.now', git push
					at sever side, git hook will trigger and generate PDF
	rake getit:
		git pull will update PDF
	For the free users:
		collaborators are only the user and rlayout
		can only create 10 templates
	For the paid users:
	 	can have own account, and multiple collaborators
		can create more templates depending on the payment plan
Container PageScript Verbs
	split(number=2)	# same as split_v
	split_v(number=2, options=>{})
	split_h(number=2)
	split([1,2,1], :fill_color=>'red')	# if number is an arry, layout_length and the options apply to all of them	# makes the layout mode to vertical
	split_v(number, options=>{})
	split_h(number)						# makes the layout mode to horizontal
	place([1,1,4,4], options=>{})		# makes the layout mode to grid_matrix


## Wish list
	- add ShoulderColumn, add footnote_area
	- Header
		- bleeding page number box
	- AdBox DSL with profile, method_missing		
	- support Asciidotor
	- change Paragraph  
		- ParaStruct(:string, markup, :footnote, :index)
		- parse_para_string2para_data
		- para_data2atts_array
		- atts_array with TextStruct
	- line type, line arrow, line_sides
	- Dagger(rect,depth,sides), Ribbon(rect,depth,sides),
	- CorneredRect(rect,corners, shapes)
	- support Opal
	- add bgcolor, deco_large, deco_medium, deco_small,
	- warning, example,
	- title_box, grid_box
	- convert markdown to story
	- convert ascidoctor to story
	- Tab Leaders, able with leaders
	- master_page
	- Nested Styles: Container Objects with customizable styles
	- Tab separated styles(TextRuns)
	- Image Caption
	- Korean localization
		- title, subtitle, author, lead, quote
		- heading, text_box
		- header, footer
		- table, image, warning, example,
	- text format(use Asciidoctor/Markdown)
		- italic
		- bold
		- underline, strike-through, super, sub
		- custom emp(color)
	- QuickLook options: save QuickLook/Preview.pdf for preview
	- starts_at # new_page, new_text_box, new_column
	- put include RLayout so that users don't have to type RLayout::
	- Use easy to use name for layout file, such as
	- # Chapter.create
	- # News.create
	- # NewsSection.create
	- # Magazine.create
	- redo layout for complex container
	- picture_page/image_group/floats
	- story file tag
		- inline tag
			inline tag starts with def_name()
			this is converted to ruby method call with name
			and arguements and options
			arguments are chained Token or String
			return values are token, so it can be chained
			- def_sub(base, sub)
			- def_sup(base, sup)
			- def_index()
			- def_footnote()
			- def_xref()
			- def_dot()
			- def_ruby()
			- def_box()
			- def_round()
			- def_circle(1)
			- def_undertag(this, s) # undertag
			{{graphic 'text' fill_color: 'red', text_color: 'yellow'}}
			{{emp 'text'}}
			{{emp2 'text'}}
			{{emp3 'text'}}
			{{box 'text'}}
			{{round 'text'}}
			{{circle '1'}}
			{{underline 'choice one'}}
			{{ruby 'text', 'some'}}
			{{undertag 'this', 's'}}
			-
			UTag
			[This] is the some text
			______ __
			s      v

			def_ut([This], s, style: bold) \ut(is)(v)

			- $$math$$
			- $$\over{1}{2}$$
			- $$\qurt{1}{2})

		- block tag
			begin(warning)??
			end(warning)??
			begin(table)??
			end(table)??
			- \warning
			- \notice
			- \table
			- \picture_page
			- \image_group
			- \floats
		- Add font missing message

		- document
			- chapter color
				each chapter can have chapter color
			- start_left, had_cover_spread
				user pre-designed-chapter_cover_spread
			- end_on_right_page
				if the document ends in left page, add a page
				for following chapter to start at the left page

		- QuizBank

		- report_maker
			- cover
			- intro
			- toc
			- chapter
			- chapter
			- index
			- glossary
		- put templates under rubymotion app/resouces/

- Graphic add from_bottom, from_right
		instead of starting from x, or y
		this will create graphic from right_space, and bottom_space
- manual hyphenation with - in the middle of English and number, break at hyphen

## Topic

###  Graphic
###    Rectangle
###    Circle
###    RoundRect
###    Text
###    Image
###    Line
###    Polygon
###    Star/Spike
###    Baloon

###  Container
###    Heading
###    ImageBlock
###    Body
###    ObjectBox
###    Matrix
###    SideBox
###    SideBar
###    TextBar
###    Header
###    Footer

###  Page
###    Article
###    NewsBoxMaker
###    BookPage
###    Ad
###    Calendar
###    BusinessCar
###    ProductMatrix
###    Menu
###    CatalogPage
###    ExamPage
###    DirectoryPage

###  Document


### RLayout
