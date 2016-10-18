Long and short document strategy

markups needed for fine tuneing the layout

	1. markup for empty line 
	1. feed column/break
	1. feed page break
	1. feed text_box break
	
Long Document
	Have part, document, and sub-document
	and pdf_insert markup to indicated the sub-document insert point in document.

Short Document
For short article we would need custom markups, 
so rather than fixing the markups as markdown or asciidoctor, 
why not make it user defined blocks. 
	parsing rule block starting regex
	layout.rb
	styles 
	emphasis style
	column items list
		list of items that we fit into a single column. and force fix to sigle column
	text_train