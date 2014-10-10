
2014 10 10
 1. Fix Paragraph clipping bug, fixed by adding text_line_spacing to the height.
 1. justification justifies the last line, it should align left.(put return char at the end of paragraph)
 1. newline in body text with carriage return
 1. head1, head2 height should be multiples of body height, and vertically centerd
 1. toc.rb
 1. text_bar.rb
 1. footer page number font is different from footer title text

 1. Git based workflow
 1. rake file markdown2pdf
 1. Git repos webhook for triggering DRb
 1. DRb server
 1. book_config.rb
 1. vertical text for Japanese

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
 svg generation Image

svg generation for Container 
do not wrap into a svg <svg></svg>, do not make it multiple page svg
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
		
Container Verbs
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

This will generte high resolution PDF

auto_save of/off: This will make it work as REPL
I can save index.html in server folder and broadcast the progress.

 