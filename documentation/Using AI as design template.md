# Using Ai files as Design Template

## We can use AI(Adobe Illustrator) to create our design template.

This has been long desired functionality many ware wishing to have, but was difficult to implement.
Finally we have cracked the code!!!

AI file is extended form of PDF file, So we can use it just like PDF.
We can uncompress, parse and replace some parts of files, then re-index object index. And we are in business.

## variables.yml

We can search the text elements in the PDF and replace it with our variables.
First think popped up was to use ERB. 
But then, I don't want to embed erb marks in the design template, 
so we need a variables.yml to keep the replacing text and Excel data in sync
For example, I can have following variables.yml files and do the same as if we were using ERB. I will look for the following strings in the AI file and replace it with csv content.

name: Min Soo Kim
address1: Seoul
address1: 102-11
zip: 11211

## Limitations
Texts in PDF file starts at certain location, and we are not modifying this location, yet. So, make sure the replacing text doesn't run over the following text.