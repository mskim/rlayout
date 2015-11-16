# PageScript User Guide

  PageScript is Ruby DSL for creating PDF pages. PageScript is an attempt to improve page layout process. PageScript improves automating processes, over using WYSIWIG Page Layout App. 
PageScript assumes that there are three different tasks done by three different groups of people.
 
	1. layout
	1. style
	1. content

1. layout
	Layout is pre-definded structure for different types of publication, usually by programmers or consultants. Using PageScript Ruby DSL.
	
1. style
	style is changes by the designers for the publication, similar to css
	
1. Content 
	Content is written by the writers for each publication, using markdown, or asciidoctor.
	
PageScript serves to merge three resources and output for multiple medium, print, web, and mobile.



## Class

### Graphic
	- position
		x, y, width, height
		margin, left_margin, top_margin, right_margin, bottom_margin
		inset, left_inset, top_inset, right_inset, bottom_inset
		
	- fill
		fill_type
			plain, gradient, radial
		fill_color
			"red", "blue"
			"#ff0000", "#0000ff"
			"rgb(30,30,100)"
			"cmyk(30,30,100,0)"
			
	- stroke
		stroke_color
		stroke_thickness
		stroke_type
			#single, double, tripple
		dash
			[2,0,1,1]
		join
		sides
			[1,1,1,1]   stroke left, top, right, bottom sides
			[1,0,1,0]   stroke left, right sides only
		stroke_position  
			middle, inside, outside
			
	- shape
		rectangle, 
		round_rect, 
		cirlce, 
		ellipse, 
		polygon
		star
		bubble
	- raotation
		rotation
		rotation_point # center, top_left, bottom_left, top_right, botton_right
		
	- shdow
		shdow
		shdow_color
		shdow_offset
		shdow_bluer_radius
		
	- text_record
		text_string, text_color, font, text_size, 
		text_alignment, text_v_alignment, 
		markup, 
		text_layout_manager
		
	- image_record
		image_path
		local_image
		image_fit_type

### Graphic Subclass
	1. Rectangle < Graphic
	1. RoundRect < Graphic
	1. Text < Graphic
	1. Circle < Graphic

```ruby

Rectangle.new(nil, width:200, height:500, fill_color: 'red')

```

### Container
	- auto_layout
		layout_direction
		layout_length
		layout_space
		layout_expand
		
	- grid
		grid_base
		grid_frame(children)
	
	- graphics
	- floats
	
### Container Subclass
	- Heading
	- TextBox
	- Header
	- Footer
	- SideBar
	- SideBox
	- Page
	
### Page
	- Heading
	- TextBox
	- Header
	- Footer
	- SideBar
	- SideBox
	
### CompositePage
	- Mart
	- NewspaperSection
	- Jubo
	
### Story
	- heading
		title
		subtitle
		leading
		quote
		author
		images
	- body
	
### Paragraph
	- markup
	- text_string
	
### Document
	- paper_size 	# A4, A3, Tabloid, NAMECARD,
	- portrait   	# true, false
	- doulbe_side 	# true, false
	- starts_left 	# true, false
	- margin
	- pages

### Document Subclass
	Chapter
	MagazineArticle
	NewspaperArticle
	NameCard
	Calendar

