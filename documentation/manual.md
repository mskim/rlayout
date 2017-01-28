
# RLayout

## Graphic
- parent_graphic

### Layout Attributes
Graphic can be placed using x, y, width, height.
Graphic can also be laid out by parent object using auto_layout.

- layout_direction determines the direction. Default direction is vertical. We can also set it to horizontal.

- layout_length  determines the relative length of the object for auto_layout.
default value is 1 for all

- layout_expand determines the direction of expansion.
	- layout_expand: [:width, :height] expand to both directions
	- layout_expand: :width, expand to width only
	- layout_expand: nil, don’t to expand

- layout_space: space between objects when using auto_layout.

### Fill Attributes
- fill_color
- fill_type
- fill_strating_color
- fill_ending_color

### Stroke Attributes
- stroke_width
- stroke_color
- stroke_type
- stroke_corners
- stroke_sides
- stroke_dash

### Shape Attributes
- rectangle
- round_rect
- circle
- polygon

### Text Attributes
- text_string
- font
- text_size
- text_color
- text_alignment
- text_head_indent
- text_first_line_indent
- text_tail_indent

#### PageScript
	text("this is a text.", font: "Times", text_size: 12)
	text("this is a text.", font: "Times", text_size: 12, text_alignment: "center")
	label("T: 02) 446-6688.", label_text_color: "gray")

### Image Attributes
- image_path
- local_image
- image_fit_type
	- IMAGE_FIT_TYPE_ORIGINAL       = 0
	- IMAGE_FIT_TYPE_VERTICAL       = 1
	- IMAGE_FIT_TYPE_HORIZONTAL     = 2
	- IMAGE_FIT_TYPE_KEEP_RATIO     = 3
	- IMAGE_FIT_TYPE_IGNORE_RATIO   = 4
	- IMAGE_FIT_TYPE_REPEAT_MUTIPLE = 5
	- IMAGE_CHANGE_BOX_SIZE         = 6 #change box size to fit image source as is at origin

#### PageScript
	image(image_path: "/Users/somepath/1.jpg", image_fit_type: IMAGE_FIT_TYPE_ORIGINAL)
	image(image_path: "/Users/somepath/1.jpg", image_fit_type: 1, stroke_width: 1)

## Container < Graphic
- graphics
- floats
- grid
	- grid_base
	- grid_frame
- relayout!

## Heading < Container
## TextBox < Container
## TextColumn < Container
## Table < Container
## Header < Container
## Footer < Container
## Paragraph < Container

## Page < Container

## Story

## Document
- paper_size
- pages


# Publications
1. rjob
1. Chaper
1. MagazineArticle
1. Newsman
1. Quiz
1. StepAndRepeat
1. Calendar
1. PhotoBook


## Color
### Named Colors
COLOR_NAMES =%w[black blue brown clear cyan darkGray gray green lightGray magenta orange purple red white yellow]

### RGB Colors
	"RGB=100,60,0" "RGB=100,60,0"

### CMYK Colors
    "CMYK=100,60,0,20"


## Units
### point
	any integer or float will be treated as point
	12
### mm
	string ending with "cm" will be considered as centimeter
	"12mm"
### cm
	string ending with "cm" will be considered as centimeter
	"12.3cm"
### inch
	string ending with "inch" will be considered as inch
	"12inch"
