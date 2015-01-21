# RubyMotion Command Line App VS App
	Now, MacRuby is in questionable state.
	I need an alternative solution to rlayout as DRb service.
	I can write an App or CLI using Rubymotion.
	 
## CLI 
	pros
		Doesn't have to use document based App.
		Triggers from shell
		No need for saved document file
	Cons
		Doesn't stay in memory, has to load the binary every time.
		It would be nice, if I can have it in the memory.
		
## App 
	pros
		Stays in memory
	Cons
		Cocoa Apps have to use document based with document_opening mechanism
		Document type file has to saved document file in order to trigger the job.

# Wait a minute?
## What if we can write an App 
		1. that can trigger from the Ruby(Rails) as CLI with hash argv
		1. that doesn't use document type file.
		1. App that stays in the memory and runs until quit.
If I can do this, it will be fantastic, I think I just fount how to do it.