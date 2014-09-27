# RLayout Server

## How does it work?

### RLayout Client
1. Sign-in with email
	create git repo folder for user in the Git user folder
	create git working folder for user in Shared(or under /public? ) folder
	
1. Download template from a site
	Server should create git folder with the project name
	template should contain remote origin setup as project in .git config
	so the client can just type "git push"
	
1. Edit content 
	- edit content.md and content.csv
	- change images
	
1. add, commit ,and Push to server
	- this updates the repos
	- git-hook triggers a rendering automation script 
		- pull into working area and trigger RDb, this updating PDF
		- push the results back to the repo
	
1. User Pull updated result with new PDF