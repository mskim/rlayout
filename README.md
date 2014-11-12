TODO List
 	- include Image to Markdown 
	- add ShoulderColumn, add footnote_area
	- apply StyleSheet at runtime with default fall back
	- ePub generation
	- find hosting middleman build static book 
	- Merge Grid and Float
	- image smart fit, best_fit, best_fill

2014 11 12
	- auto_layout align top, center, bottom, justified 
	- layout non-expanding children column
	- fix set_frame, should reset text_layout_area
	
2014 11 10
	- image drawing, 
	- update image with frame changes
	- fix left_page header location bug
	
2014 11 7
	- variable page, variable document
	- DB_Chapter 
		control column_count 	from options
		column_gutter 			from options
		item_space				from options
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
	
2014 10 29
	
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
			- DRb generate pdf markdown2pdf
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

 