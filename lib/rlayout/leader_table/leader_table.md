# BoxTable


LeaderTable is fixed size table.
It is used in Jubo, Toc, Menu.

We can have differnt types of BoxTable
1. leader_table: 
1. simple table with head

Layout is created by given data array.
1. calculate row height
1. calculate the height of the row, and font_size to fit this
1. create cell text and check if the font_size is O.K to fit all rows.
  - if not adjust the font_size
  - if single cell is too big trunkcate the cell text
  
  - body_cell
  - head_cell



BoxTable is used as super class of GroupImage and BoxAd

BoxTable should be given two inputs
table_data and table_style
  
table_data
series of row data in Array

table_style
  graphic_style(shape, and border) for table, 
hash of styles and information for 
heading_row_style
category_row_style
heading_style
row_styles

  
fit mode
fix_to_box_height
grow_box_height
  
What is table category?
Category is a left most column that represent category.
Same catgory title cells are merges into one category cell. 
  
category_level
Sometimes category levels are more than one level deep
category_level is number of categories. 
