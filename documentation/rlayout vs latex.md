# RLayout

RLayout resources are divided into two files, layout and story.
It is meant be edited by two different types of participating group.
The idea is to separate the task for different people to do their own thing. 
Let designers work on prepare the templates and let the writers fill the content,
unlike LaTeX, where the write should know the programming syntax,
and unlike InDesign or Xpress, where designer is forced to handle the layout and content. 
Both of above cases, bottlenecks are created.
 
Goals are
	1. separate the design and content.
	1. eliminate the role of mundane operators.
	1. accomplish one source multiple medium publishing.
	
So, the workflow would be as following.
	1. pre-design flexible template for different types of sections(document).
	1. create the content
	1. auto merge them to produce PDF.
	1. each participating members refine their own stuff separately.
	1. PageServer, Github, Dropbox, Slack would be a nice combination for working group.

There multiple section is not allowed in a single file. Sections should be in different files.
html conversion 
 title is conveted to h1
 subtitle is conveted to h2
 author is conveted to h3
 leading is conveted to block text
 quote is conveted to quote
 # is conveted to h4

## layout format

```ruby
MagazieArticle.new do
	page.new do
	  heading
	  texbox do
	   image
	   image
	  end
	end
	
	page.new do
	  texbox

	end
end
```

## story format

---

title: Interview with Min Soo Kim
author: Jimmy Carter
leading: There has been a revolution in publishing industry.

---

# Preamble

Preamble comes first in meta-data area. It is in yaml format that is parsed as an Hash. 
Rest of the syntax is similar to markdown
# is converted to section
## is converted to subsection
### is converted to subsubsection
p is converted with inline head

Each definition is followed by options as

# First Section 
	toc: false
	bg_image: hotdog.jpg

We have added couple of markups
such as :image, :image_layer, :image_box, :grid_box, :table, :item, $$latex
it has .story extension, it can be converted to markdown with another pre-processor.

:image 1.jpg

:image_layer
	image_path: school.jpg
	image_path: dog.jpg
	image_path: cat.jpg

:image_box pattern: "5/3x2"
	image_path: group_picture_1   // look for pictures in images/group_picture_1 folder
	
:warning 
	Warning message goes here
	
:table 
	source: "data-1.csv"
	style: "spring"

:grid_box
	:item
	  title: "this is item title"
	  image: 123.jpg
	  description: "some more description about the item goes here." 
	:item
	
	:item
	
:grid_box_end

$$latex
$$end   //needed if there are empty lines between them

$$asciimath
$$end

$$eq
$$end

## Subsection {background_image: @section_number.jpg}

Hash is is used for extra attributes, that are different from the default

\empty // empty line 

	
## Another subsection

:p inline paragraph title
and the rest of them are plain text

### Another Subsubsection