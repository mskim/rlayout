# Improving Layout

## What is lacking in current batch pdf generating process?

It is lacking ability to tweak layout by hands, which page layout app is able to do.

We can achieve this by saving layout file and let users tweak it manually.
1. The solution is to save pages with layout elements as layout.rb. 
	if document is processed with save_layout: true
1. <br/> for feeding empty line, 
1. space_after:1000 to plush following item to next container.
1. tag to match the content.
	image_1, table_1, math_1
	make the size, fitting, style etc
1. use FLOAT_PATTERNS(pre-designed image layout guide)

We can setup guard to trigger layout each tiem we save.
And have Preview open, it will be similar to running layout program.

### Story file should be one continuos file, not chopped up files for each textFrame.

We should not include decoration texts in story.
Variable text @page_number, @chapter_title, @book_title

### Style should be Hash, we should be able to use it from IDML
	ParagraphStyle
	CharStyes
	TableStyles
	ImageStyles
	TextBoxStyles
	

## RLayout folder structure

name.rlayout
	layout.rb
	story.md
	styles/
		table_styles.rb
		text_styles.rb
	QuickLook
		Preview.pdf
	images

## Component
layout with story

style_name: component_style_1

story = <<-EOF
# this is title

### Am not so sure. 

this sfdsa fdsa fds fdsa
fdadfsa fdsa fdsaf dsa fdsa 
EOF
