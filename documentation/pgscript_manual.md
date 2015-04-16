
# PageScript Guide

## Class

### Graphic
	fill
		fill_color, fill_type, fill_other_color
	line
		line_color, line_width, line_dash, line_type, line_sides
	shape
		rectange, circle, round_rect, 
	text
		text_string, text_color, text_font, text_size, text_style, text_alignment, text_v_alignment
		
	image
		image_path, image_fit_type, image_rect

### Container < Graphic
	layout 
		layout_expand, layout_length, layout_direction, layout_space
	grid
		grid_base, grid_frame, grid_width, grid_height, grid_gutter, grid_v_gutter
	
### Heading < Container
	layout_length, layout_expand
	
### TextBox < Container
	columns, draw_gutter_line, layout_length, layout_space
	