# LineFragment Layout and in Complex TextContainer

## Simple Container
isSimpleContainer?

## Complex Container

text container have grid_lines for the purpose of keeping the intersections info with floats. And base grid.

## Layout Process
1. Paragraph first layouts lines with given container width
1. if simpleContainer do the same, just layout them out.
1. If container is complex, 
	1. paragraph asks container for new para_line_rect with current para_line_rect
	1. container collects all grid_lines that intersects with given para_line_rect.
	1. make new para_line_rect by shortening para_line_rect from left and right side,
	 	by taking the shortest edges of grid_lines. 

