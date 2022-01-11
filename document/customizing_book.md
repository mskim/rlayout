# How to customized Book

Book has default layout and text_style, but it can also be customized.

## scoping style 

Custom style can be set with "style" folder.
  - place "style" folder at the root level, and place style related files.
    and add key/value in "text_style.yml file " or "layout_style.yml"
  - text_style.yml
  - layout_style.yml
    - frontmatter:
    - toc_layout:

Styles are scoped to entire book, 
but styles can also be applied only to certain area of the book,
by placing additional style folder to part or document, 
styles will be applied to that particullar area only. 


### Using book_info

add attributes in book_info.yml
- title, subtitle, author
- header footer, 
- left_margin, top_margin, right_margin, bottom_margin
- gripper_margin, bleed_margin, binding_margin
- has_header:true
- left_header, left_header, (using multiline yaml |)
- has_footer:true
- left_footer, right_footer (using multiline yaml |)



### Adding text_style.yml

add text_style.yml at the "style" folder

## Using layout.rb

- add layout.rb at the "chapter" folder folder.
- with layout.rb user can provide custom  page or document

```

h = {}
h[:left_margin] = 200
h[:top_margin] = 500
h[:bottom_margin] = 500
h[:left_margin] = 200
h[:bg_image] = true
RLayout::RPage.new(h) do
  title_text(@title, from_right:0, y:200, width: 400, height: 300, fit_type: 'fit_to_box')
  title_text(@subtitle, from_right:0, y:300, width: 400, height: 300, fit_type: 'fit_to_box')
  title_text(@author, from_right:0, y:500, width: 400, height: 300, fit_type: 'fit_to_box')
end

```

## Using layout.yml

```

title: some_title
subtitle: some_subtitle
author: some_author

left_margin: 200
top_margin: 500
top_margin: 500
bg_image: true

RPage:
  - title_text:
      text: @title
      from_right: 10
  - title_text:
    text: @subtitle
    from_right: 10
  - title_text:
      text: @author
      from_right: 10

```
