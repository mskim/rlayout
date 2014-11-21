
# TextEdit sample supports vertical text.
# in TextView menu->format-> "Make Layout Vertical" sets the of text to vertical
# 	1. It handles English as side ways as it should
# 	1. It handles punctuation marks as it should?
# which means there are already built in mechanisms in Mac OS X text system
# which means there I can use TextView to draw paragraph, horizontal and vertical.

# I need to dig deeper into NSLayoutManager and NSTypesetter to have more control, rather than using TextView
 
# It rotates view 90 degree clock wise, and rotates text 90 degree counter clock wise
# So I can use TextView to draw vertical paragraph?
# NSTextLayoutOrientation
# orientation= [textView layoutOrientation]
# [textView setLayoutOrientation:orientation];
# 
