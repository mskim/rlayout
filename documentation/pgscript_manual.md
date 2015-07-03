
# PageScript Guide

## Class

### Graphic
	fill
		fill_color, fill_type, fill_other_color
	stroke
		stroke_color, stroke_width, stroke_dash, stroke_type, stroke_sides stroke_drawing_sides
	shape
	  shape_type, shape_bezier, shape_corners, shape_corner_type, shape_side_type

	  shape_corners,  shape_corner_type,  shape_bezier_path
		# [1,1,1,1] # 0= no corner, 1=small, 2=medium, 3=large, 4= half of smaller side
	text
		text_string, text_color, font, text_size, text_style, text_alignment, text_v_alignment

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
