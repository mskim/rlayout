# Using PageScript with Asciidoctor 

Asciidoctor-PGScript 

## What is PGScript?
Ruby DSL for producing PDF.
1. Library of commonly used design elements defined as Ruby Objects, using Apple Cocoa Framework.
1. Set of layout rules.
1. Utilities for Importing external files.  
1. Lots of pre-designed ready to use design templates using PGScript.  

Import Asciidoctor or Markdown as flowing contents, which can be poured into series of deisgned pages. And it triggering various design patters

How to use PageScript and Asciidoctor to produce pdf output?
Asciidoctor should be used as common "ContentMarkup" language.
Asciidoctor alone should be enough to produce HTML, but PageScript can turn the same document into a beautiful PDF document, that are comparable to those of Quark or InDesign produced PDF.
And PageScript should be used as "PDF Layout language" 
What make HTML document different from PDF documents generated from DTP, like Quark or InDesign? I will say that the first main difference is laying out floating objects on top of multiple columned flowing text. It is difficult to control running floating objects that ends up in same page with current HTML. And the second difference is almost infinite variation of design patterns for elements, not just couple of CSS. Using PageScript, we can apply a lot richer set of design patters to node elements.

Asciidoctor-PGScript introduces couple of new markups 
	"floats_layout",  "text_jump_over"
	"pdf_inserts"
	"photos_only_page"
	
I from series of pages, 
page has fixtures, main_box
main_box has floats(heading, images, quote, leading)
fixtures are header, footer, side_bar

Asciidoctor elements are series of notes that can be flattened as following
in HTMl document.  

Title
Preamle
Section Level
  Block level markup 
	Inline
More Section Level

What PageScript adds to those html?
Intoducing new makrup 
	floats_layout
	pdf_insert 
attribute 
	text_jump_over = true

I am using a trick called "floats_layout", and "text_jump_over"

Master Page
 left 	starting 
 right 	starting 
 left 	middle  
 right 	middle  
 left 	ending  
 right 	ending
 photo_only

Layout Styles
  p
  h1
  h2

table style


Pre-designed Photo Profiles

## asciidoctor node types

document	
= title
author
preamble


embedded	
TODO

section	
==
===
====
=====
document sections, i.e. headings

include::
include::basics.adoc[]


block_admonition	
an admonition block
TIP: Pro tip...

IMPORTANT: Don't forget...

WARNING: Watch out for...

CAUTION: Ensure that...

block_audio	
an audio block

block_colist	
a code callouts list

block_dlist	
a labeled list (aka definition list) and a Q&A style list

block_example	
an example block

block_floating_title	
a discrete or floating section title

block_image	
an image block

block_listing	
a listing and source code block

block_literal	
a literal block

block_olist	
an ordered list (i.e. numbered list)

block_open	
open blocks, abstract, …

block_outline	
an actual TOC content (i.e. list of links), usually recursively called

block_page_break	
page break

block_paragraph	
a paragraph

block_pass	
a passthrough block

block_preamble	
a preamble, optionally with a TOC

block_quote	
a quote block

block_sidebar	
a sidebar

block_stem	
a STEM block (Science, Technology, Engineering and Math)

block_table	
a table

block_thematic_break	
a thematic break (i.e. horizontal rule)

block_toc	
a TOC macro (i.e. manually placed TOC); This block is used for toc::[] macro only and it’s responsible just for rendering of a the TOC “envelope,” not an actual TOC content.

block_ulist	
an unordered list (aka bullet list) and a checklist (e.g. TODO list)

block_verse	
a verse block

block_video	
a video block

inline_anchor	
anchors (links, cross references and bibliography references)

inline_break	
line break

inline_button	
UI button

inline_callout	
code callout icon/mark inside a code block

inline_footnote	
footnote

inline_image	
inline image and inline icon

inline_kbd	
keyboard shortcut

inline_menu	
menu section

inline_quoted	
text formatting; emphasis, strong, monospaced, superscript, subscript, curved quotes and inline STEM