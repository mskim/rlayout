TODO List
	- center graphic with width and height
	- draw lines in superview, so the lines don't get cut off
		use transform instead of subview
	- add ShoulderColumn, add footnote_area
	- apply StyleSheet at runtime with default fall back
	- ePub generation
	- Merge Grid and Float
	- image smart fit, best_fit, best_fill
	- support for default and custom Styles
	- Header
		- bleeding page number box
	- AdBox DSL with profile, method_missing
	- should filter markdown file
		- for control characters
		- should break lines for first_line_head_indent to take effect
	- Style
		- merge with base
		- make it yml
		
	- modify kramdown into r_kramdown
		- I am using parsing from Asciidotor  instead of kramdown
		- I am using parsing with part of code from Asciidotor
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
	- parse Hangul or export get retrieve:
	- Tab Leaders, able with leaders
	- master page
	- Nested Styles: Container Objects with customizable styles
	- Tab separated styles(TextRuns)

2015 10 14
	- fix bug: in text_box layout_item duplicating item insert
	- draw inter_column lines
	- custom style support
		heading layout
		q font, size, color, head_indent, tail_indent
		number font, size, color
		choice font, size, color, number_type
		space between q and choices
		space between choices
	- answer sheet
	
2015 10 13
	- grow/shorten graphic height as text height 
	- 'keep_box_height', 'fit_text_to_box', 'adjust_box_height'    
	
2015 10 12
	- QuizMaker
	- fix multi column bug
	
2015 10 7
	- Book, 
	- side_column support
	- image_layout.rb?
	- Document generate document_layout.rb
	- place dummy_image.jpg if no image is present
	
2015 10 6
	- fit_text_to_box
	- ImageGroup
	
2015 10 5
	- Table category cell font size
	- fix text overflow for non-proposed_height 
		it should be 
		range= @layout_manager.glyphRangeForTextContainer @text_container
		if range.length < @att_string.string.length
		
2015 10 3
	- delayed content layout 
		- by calling layout_content
		- Page should call layout_content to nested graphics 
	
2015 10 2
	- categorized Table with category color
	- CategoryRow: group of rows with Text
	- ImageCategoryRow Image as category item. 
	- ImageRow: Row with image cells
	- CustomHead : customizable text
	
2015 10 1
	- table_column_width_array
	- table_column_width_array_average
	- table_column_width_array_longest
	- auto_column_width = off, average, 
	- table_column_align_array 
	
2015 9 30
	- fix: fill_color should not be Text background color 
	- fix: layout_text_lines should have auto adjusting height optional 
	
2015 9 28
	- TextCell vertical fit
	- support toned down color
	- category_level = 1 table
	
2015 9 27
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

2015 9 23
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
	
2015 9 22
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
		
2015 9 20
	- Newspaper
	- NewspaperIssue
	- NewspaperSection
	- made NewsArticle work with story folder
	
2015 9 18
	- NewsArticleMaker bug that heading is not showing
	- def heading in TextBox
	- support \n for new line in text_record
	
2015 9 7
	- Custom Chapter style
	- running float image, bleed
	- HorizontalRule Rule < Line
	- add Heading background
	- add running page insert marker
	
2015 9 6
	- parse image ![]{grid_frame: [0,0,1,1], local_image: "1.jpg"}

2015 9 1
	- error handling when pgscript eval fails
	- show/hide grid rects in TextColumn
	
	
2015 8 31
	- magazine: do not add page when layout, just use as designed 
	- news_article_maker
	
2015 8 30
	- TODO: prevent blocks from executing multiple times
	  once in super and one more time in child class
	  get rid of block processing in Page
	- do not execute blocks in Container
	- do it only at the super class of Container
	
2015 8 28
	- MagazineArticleMaker
	- main_text
	- heading, float_image , quote, leading
		floats using grid_frame

2015 8 27
	- ChapterMaker, MagazineArticleMaker, 
		replace Chapter, MagazineArticle, NewsArticle
	- support custom style loading at rum time
	
2015 8 23
	- class Bar
	- Bar is Container starting as layout_direction set to "horizontal" 
	

2015 8 14
	- fix image fitting in nested pgscript layout
	- add position 
		top_left, top_center, top_right
		middle_left, middle_center, middle_right
		bottom_left, bottom_center, bottom_right
		
2015 8 5
	- support graphic rotation
	- multiple layout templates for selection
	- magazine
	- pgscript manual
	
2015 7 29
	- rjob batch mode

2015 7 7
	- improve text layout
		fix text spacing
	
2015 7 3
	improve PageScript 
	- add profile
	- add place
	- add replace
	- * nested replace

2015 7 2
	- add stroke_sides
	
2015 7 1
	- project_path local_image
	- name, division, job_title, address1, address2
	- en_name, en_division, en_job_title, en_address1, en_address2
	- ch_name, ch_division, ch_job_title, ch_address1, ch_address2
	- heading, text_box, side_bar, image_box, text_bar
	- title, subtitle, author, leading, quate, p, h4, h5, h6
	
2015 6 17
	- news_article add reading image layout info
	- auto fit news_article
	
2015 6 12 
	- add  section_name to section config
	
2015 6 1
	- move grid_frame and grid_size from story metadata to config in section
	- I should hide this info from users, they don't need to see this.
	- create symbolic link after creating pdf and jpg, if newsman server
	 	is set
	- newsman_issue_path: "/User/mskim/..../OurTownNews/-2015-5-20/Sports"
	
2015 5 30
	- save jpg with option jpg: true
	- don't save pdf with pdf: false
	
2015 5 21
	1. NewspaperSection
		- create images folder in section News
		- working_site.html
		- newsman@gmail.com
		- multi-threaded rake, use global rake 
		
2015 5 16
	1. Newspaper
		- float image
		- article type 
		- line decoration
		 
2015 5 15
	1. book
		images, 
		fix line space between paragraph
		
2015 5 13
	1. support for default and custom Styles
		- set body_line_height for textColumn
		- @current_style =StyleService.shared_style_service.current_style

2015 5 12
	1. image_fitting, image_frame
	1. rjob, rnews, rbook, rnamecard, ridcard, rcalendar
	
2015 5 11
	1. draw grid lines
	1. update Text(text_layout_manager) for nsview drawing
	
	
2015 5 10
	1. GraphicViewMac Drawing
		- I was using subviews to present chidren, but it has some problem.
		- strokes that goes beyond the subview frame are cut off. 
		- I decided not to use subviews for children,but use transforms instead
		- I can also implement rotation using transforms
		- in order to use transforms, I have to use bounds instead of frame.
		- for center point rotation, I have to use center point bounds.
2015 5 7
	1. motion rlayout_test app to test in rubymotion environment.
	
2015 5 7
	1. Image fit_type, fit_best, fit_horizontal, fit_vertical
	1. image size detection with mini_magick
	1. image clipping area
	1. NSViewDrawing
	
2015 5 2
	1. change line records to stroke stroke[:color], stroke[:thickness], stroke[:dash]
	1. SVG drawing, Container, Page, Document
	1. Line, LineArrow, Ribbon, RomanDagger, SawTooth
	1. Struct
	
2015 4 17
	1. Graphic drawing
		1. fill_type, 
		1. line_dash, line_type, line_drawing_sides
		1. shape clipping path, shape corner
		
2015 4 16
	1. Add Sojo layout script
	1. remake grid_key pattern 7x12/5, 7x12/H/5, 7x12/HA/5
	1. Add image to story, add auto fit with image resizing, min, max
	1. add filtering to story \'
	
2015 4 13
	1. Newsman integration
	1. Dropbox integration
	1. change_section_layout
	1. change section grid_layout 
	1. support custom grid_key file
	1. synthesize grid_layouts
	1. 7x11, 7x6, 6x11, 6x6
	  
2015 4 11
	1. grid_key with head notation 7x12H/4, 7x12/5
	
2015 4 10
	1. Rakefile for story.pdf, section.pdf, heading.pdf
	1. has_heading
	
2015 4 8
	1. Article, NewsArticle, NewsSection
	1. grid_size with margin, gutter paper_size
	1. put the grid_pattern_with source, no need to save it as file
	1. heading_column for news_article story.
	1. Page with and without Heading 
	1. Save section_info.yml in section folder
	1. Save CSV
	
2015 3 31
	1. Merge grid & float into major feature.
			Update PGScript to make use of it.
			Update PGScript for NewspaperSection

2015 3 30
	I am getting invalid context error, And I can't find the reason why!.
	I am going back to using NSText, from CoreText.
	CTFrameSetter to NSLayoutManager
	I will have to work on proposed lect stuff for illegular shaped containers.
	I will also implement Pure Ruby version of Text so, I can use it on
		1. non Mac EC servervice
		1. Opal on the browser.

	1. Update TextBox for NSText change, Dropcap, Splitted Paragra case

2015 3 23
	- parse adoc format, get the tree info, convert it to para_tree
 	- paragraph should container more information to accommodate node
	- level, context, lines
	- add admonition

2015 2 11
	- rlayout cli using RubyMotion as App
	- setup github and bitbucket
	- rlayout, photo_layout, restaurant

2015 2 9
	- node_tree
	- PhotoBook

2015 2 2
	- add save_jpg
	- save_pdf(path, options={})
2015 1 29
	- fix paragraph height bug
	- align_body_text: true
	- refactor
		update_current_position
		snap_to_grid_rect
		scan_covered_grid_from

2015 1 24
	- set default image grid_frame_as [0,0,1,1,] for text_box

2015 1 21
	- include Utility
	- refine float image layout
	- fix starting line offset bug
	- fix markdown parsing bug . with no text_markup  

2015 1 20
	- float_location: top, middle, bottom
	- float_bleed: false, true

2015 1 19
	- text_box layout_item
		1. make TextColumn starting_point at creation
		1. create path with path_from_current_position
			should handle simple rect, complex rect, and multiple chunked path
		1. layout_ct_make
			for overflow compare the att_strring with last line range

2015 1 16
	- use path for layout_text_lines
	- path_from_current_position
	- I may not need to set starting_position for complex column,
		it could be the top, if I implement the path
	- TextBox should call overlapping can creating at the laout_item

2015 1 15
	- fix layout_items in TextBox
	- fix split paragraph

2015 1 14
	- fix TextColumn room, based on grid_rects
	- fix case when we have hole in the middle of TextColumn

2015 1 13
	- fix float overlapping mechanism with grid_rects in TextColumn
	- fix non-rectangular shaped column
	  	- spliting
		- layout paragraph

2015 1 9
	- fix Kramdown parsing error(done)
	- news_article, text_box,
	- current_style, merge with custom style
	- floats
		when overlapping floats,
		modidify or divide columns into pieces
		body_text unit
	- floats images
		have floats template

2015 1 7
	- fix NewsArticle, TextBox

2014 12 31
	- fix grid,
		- grid co-exists with auto_layout
		- use it with float

2014 12 26
	- fix NewspaperSection(done)
		- heading, 6x12, 7x12

2014 12 26
	- convert cm, mm to pt(done)
		:width=> "16.5cm", :height=>"24.5mm"
	- rlayout news_article project/folder
		- rlayout idcard project/folder
		- rlayout book idcard project/folder
		- rlayout chapter project/folder
		- rlayout magazine_article project/folder

2014 12 20
    - fix auto_layout bug starting_y as bounds_rect, instead of frame_rect

2014 12 19
	- text_fit_to_box
		- set initial font size as 80% of box

2014 12 16
	- text_fit_to_box
	- text_layout_manger layout_lines when relayout is called

2014 12 15
	- add paper_size

2014 12 14
	- remove margin from attr_accessor

2013 12 13
	- idcard
	- text_form
	- text_field
	- variable_document

2013 11 28
    - image handling
	- bleeding
	- caption
	- composite_page

2013 11 25
	- Dropcap

2013 11 24
	- fix split
	- use CoreText instead of NSTextSystem
	- Heading
		- multiple line text support
		- make height align to body text
		- author right_inset
	- Add heading_columns table in Style

2014 11 18
	- text_layout
2014 11 15
	- include Image to Markdown
	- include Image Caption to Markdown
		- caption position bottom, right, left, top, float
	- adjust space before and after Image to body grid
	- adjust Image inset
	- find hosting middleman build static book,
	- BitBalloon, CodeShip, Netlify
2014 11 12
	- auto_layout align top, center, bottom, justified
	- layout non-expanding children column
	- fix set_frame, should reset text layout_size
	
2014 11 10
	- image drawing,
	- update image with frame changes
	- fix left_page header location bug

2014 11 7
	- variable page, variable document
	- DB_Chapter
		control column_count 	from options
		column_gutter 			from options
		Floating Heading		from options
2014 11 6
	- product_box with image
	- product_box with template
2014 11 5
	- fix nested object_item_drawing, non_overlapping_bounds
2014 11 5
    - font with weight support, get the postscript names
	- try smSSMyungjoP-W30, smSSMyungjoP-W35
2014 11 4
	- object_chapter
	- create TextBox for paragraph flow
	- Merge StoryBox with TextBox into one
	- fix left header position
2014 11 3
 	- fix auto_layout bug
2014 11 1
    - Book build web-site, ebook, mobi
	- Dropbox integration
	- Make DRb_server
2014 10 30
	- tracking support #TODO need to test this
2014 10 23
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
2014 10 23
 1. modified columnObject insert item with text_layout_manager
2014 10 22
 1. split paragraph among two different columns, using one layout_manager, one text_storage, two text_containers
 1. applying widow/orphan rule
	{widow: 2, orphan: 2}
2014 10 21
 1. Vertical Text using NSTextView
2014 10 20
 1. text_starts_at anywhere, column, text_box, page, right_page, left_page
 1. text_drop_cap_line_count, text_drop_cap_char_count
 1. text_tracking
 1. text_colors in hex/cmyk/rgb
	- drawRect and text layout in one place, in Model, only
2014 10 19
 1. implement to_hash
2014 10 18
 1. changes from previous RLayout/working
	- No GraphicRecord, make them part of graphics, flatten it, except TextLayoutManger for text, replacement of TextRecord
	- TextlayoutManager: vertical text, FatText(SuperRichText) support
	- Use views and subviews instead of calculating translated coordinate, support graphic rotation
2014 10 12
 1. vertical text for Japanese
 1. breaking paragraph
 1. DropCap
 1. line_edge=[1,1,1,1] or [0,1,0,1] for top and bottom only
 		[0,{line_type: 2, line_color: "red"},0,1]
 1. make CustomStyle as subclass  of  BaseStyles
	- title, subtitle, as methods that return hash values
	- heading,

2014 10 11
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

2014 10 10
 1. get rid of styles category, use @current_style
 1. text_bar.rb
 1. footer page number font is different from footer title text

2014 10 9
 1. fixed Paragraph clipping bug, by adding text_line_spacing to the height.
 1. head1, head2 height should be multiples of body height, and vertically centered

2014 10 8
 1. alignment justify

2014 10 7
 1. chapter heading only header
 1. book title and page number footer on left side
 1. chapter title and page number footer on right side

2014 10 6
 1. Chapter heading should be set with layout_unit_length, not as floats
 1. first line indent

2014 9 23
 Paragraph Object
 TextColumn
 TextBox linking
2014 9 22
 - svg generation for Image
 - svg generation for Container
 - do not wrap into a svg <svg></svg>, do not make it multiple page svg
use rect or graphic shape, fill, and line
2014 9 19
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

## Installation

Add this line to your application's Gemfile:

    gem 'rlayout'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install rlayout

## Usage

TODO: Write usage instructions here

## Contributing

1. Fork it ( https://github.com/[my-github-username]/rlayout/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request


#  Graphic
#    Rectangle
#    Circle
#    RoundRect
#    Text
#    Image
#    Line
#    Polygon
#    Star/Spike
#    Baloon

#  Container
#    Heading
#    ImageBlock
#    Body
#    ObjectBox
#    Matrix
#    SideBox
#    SideBar
#    TextBar
#    Header
#    Footer

#  Page
#    Article
#    NewsArticle
#    BookPage
#    Ad
#    Calendar
#    BusinessCar
#    ProductMatrix
#    Menu
#    CatalogPage
#    ExamPage
#    DirectoryPage

#  Document


# RLayout

$ rlayout new my_article template= article

creates folder "my_article"
cd my_article

$ ls
	my_article
		.rlayout
			layout.yml
		.git
		content.md
		date.csv
		images/
		Preview.pdf
		Preview.html

User edits content in content.md
Open Preview.html
Ad user saves content.md, Preview.html gets updated
Once all is done

$ rlayout pdf

This will generate high resolution PDF

auto_save of/off: This will make it work as REPL
I can save index.html in server folder and broadcast the progress.
