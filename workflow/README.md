# PageServer setup 

## install git on the local machine

1. setup name, email for git

## sign-up with GitHub or Bitbucket

## Create your new project on Github
1. folk one of the templates from github/iedit 
1. add iedit@google.com as co-worker who can push and pull
1. clone the folked project to your local machine
	git clone "github project url that you folked"
	cd "new project folder"
	
## Editing
1. Edit contents of this folder as you wish.
1. Replace images with your own images with same file name.
1. Edit layout.rb if you wish to change the layout.

## Saving
When you are done editing, time for you to save it as generate pdf.

1. if you are familiar with git 
    - git add .
	- git commit
	- git push
	
1. if you are not familiar with git,
	- "rake save”
    - "rake push"

## Generating PDF
1. "rake process"

## Finding what Font are available to Use
	If you need to merge PDF's into one single book format.
	"rake font_list"

## Merging PDF
	If you need to merge PDF's into one single book format.
	"rake merge_pdf"
	
## Requesting Printing Service
	"rake print"
	This will open a web page for requesting print.
		- There may be more than one printer for you to choose.
		- take look at price section for prince quote
		- pay
		- wait for delivery or pick it up.
