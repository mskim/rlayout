# Publishing in 2016

## History

1. DTP and WYSIWIG
1. Quark Xpress
1. InDesign
1. HTML
1. ePub

## Word-processor 

1. Use of plain text, avoid Word or Hangul
1. multiple format outputs from same source
1. Markdown

## Collaboration
1. Version Control
1. Git and GitHub

## Problem

1. Most Koreans input text in Hangul. 
1. It is relayed out in InDesign.
1. And this process is repeated for every proofing iteration.
1. This process is very time consuming. This need to be automated. 
1. This gets even worse if the Hangul document contains many tables or math equations.

## Hangul to InDesign Converter

Hangul to InDesign(hwpml to icml)

## DesignScript

Ruby script for creating design layout.
save as PDF or save as InDesign file.

## InDesign to DesignScript

Converts current InDesign File to DesignScript

	InDesing to rlayout
	
## rlayout folder structure

- master_page/
	- master_page.rb
- styles/
	- paragraph_styles.rb
	- char_styles.rb
	- table_styles.rb
- layout.rb
- story.md
- images/
- tables/
- charts/
- math/
- QuickLook/
	- Preview.pdf
