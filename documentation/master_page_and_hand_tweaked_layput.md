# MasterPage and Hand tweaking Layout

## MasterPage is used to for automating layout

MasterPage is use to place page_fixtures and graphic containers: 
page_fixtures are
header, footer, page_number, size_bar, which should be part of story.

We should have general layout rule, starting_left,  starting_right, middle_left, middle_right, ending_left, ending_right pages

## Hand tweaking the layout.

We also need to hand tweak the layout. And keep this information through out.
layout.rb is used for keeping hand tweaked layout. 
layout.rb is used over the master page once it is generated, And never over ridden by the auto generating processing.

## Flowing floats are place in two phases

1. first layout content as they appear
1. When over sided floats appear, place them as requested size and place.
1. In the second pass, push intersection text content. And resolve conflicting floats.  
 