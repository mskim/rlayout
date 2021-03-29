# LeaderTable


LeaderTable is fixed size table for Jubo, Toc, and Menu.

LeaderRow is a special row that inserts LeaderCell between TextCells. to make it look like following.

starting_text ............................ ending_text
starting_text ........ middle_text ....... ending_text
starting_text ........ middle_text ....... ending_text
starting_text ............................ ending_text
starting_text ............................ ending_text
starting_text ............................ ending_text
starting_text ........ middle_text ....... ending_text
starting_text ........ middle_text ....... ending_text
starting_text ............................ ending_text
starting_text ............................ ending_text




Layout is created by given data array.
1. calculate row height
1. calculate the height of the row, and font_size to fit this
1. create cell text and check if the font_size is O.K to fit all rows.
  - if not adjust the font_size
  - if single cell is too big trunkcate the cell text
  
  - body_cell
  - head_cell

