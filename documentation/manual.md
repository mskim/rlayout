
# RLayout

## Graphic
- parent_graphic

### layout
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

### Fill
- fill_color
- fill_type
- fill_strating_color
- fill_ending_color

### Stroke
- stroke_width
- stroke_color
- stroke_type
- stroke_corners
- stroke_sides
- stroke_dash

### Shape
- rectangle
- round_rect
- circle
- polygon

### Text
- text_string
- font
- text_size
- text_alignment
- text_head_indent
- text_first_line_indent
- text_tail_indent

### Image
- image_path
- local_image
- image_fit_type

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

## Page < Container

## Document
- paper_size
- pages

## Story
## Paragraph

# Publications
1. rjob
1. Chaper
1. MagazineArticle
1. NewsArticle
1. Quiz
1. StepAndRepeat
1. Calendar
1. PhotoBook