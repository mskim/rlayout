# MasterPage and Hand tweaking Layout

## MasterPage is used to for automating layout

MasterPage is use to place page_fixtures and graphic containers: 
page_fixtures are
header, footer, page_number, size_bar, which should not be part of story.

We should have general layout rule, starting_left,  starting_right, middle_left, middle_right, ending_left, ending_right pages

FloatGroup is used to layout a page, combination of  images, quotes, heading, leading are layed out on top of TextBox with pre-designed floats layout pattern.

## Hand tweaking the layout.

We also need to hand tweak the layout. And keep this information through out.
layout.rb is used for keeping hand tweaked layout. 
layout.rb is used over the master page once it is generated, And never over ridden by the auto generating processing.

## Flowing floats are place with two options
1. allow_text_jump_over
 