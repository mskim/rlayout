# BookPlan

BookPlan is a tool for planing and automating book generation.

BookPlan uses spread sheet to organize the structure.
spread sheet is as following.
Each document/sub-document are rlayout project.
Each document/sub-document can be updated automatically.
Some document/sub-document can pull the data from outside souce.
Document can place sub-documents in the middle of the document using pdf_page_insertte.

example paperback:

Parts			Documents		sub_document			Template
front_matter	
				preface									preface
				toc										toc
body_matter		
				01_chapter								chapter
								photo01					photo_page
				02_chapter								chapter
								data on company			table_data
				03_chapter								chapter
				04_chapter								chapter
				05_chapter								chapter
rear_matter
				glossary					glossary
