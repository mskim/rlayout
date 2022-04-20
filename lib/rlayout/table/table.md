# Tables

## table types

There are several types of table
Table, SimpleTable, ParaTable, LeaderTable

### table

Table < Container
category level supported
cycle color supported
auto column size calculation supported
Table cell use TitleText, 
multi line text supported
multi text style text supported, 
  - italic, bolde, mixed color and soom


### LeaderTable

LeaderTable is used for toc service, and menu
LeaderRow is used
It has leader cell where leading character fills cell as following.

first_chapgter ......... 10
second_chapgter ........ 10


 
### SimpleTable

All table cells have uniform char style, no mixed style in a cell italic, bold. All cells are single line text.
SimpleTableRow used

### ParaTable

ParaTable runs through multipe linked columns similar to paragraphs.
ParaTableRow is used
