
# NSBezierPath Intersection Detection

1. bounds: gives tractangle
	- (NSRect)bounds

1. containsPoint(pt)
	- (BOOL)containsPoint:(NSPoint)aPoint

## Steps

1. get bound of NSBezierPath
	if a grid_line intersect, go into smaller area.
2. divide grid_line into 20 small rects and test if they overlap
	by calling containsPoint for four corners of grid_line, 
	with the result of hit detection, construct a line that is available.

