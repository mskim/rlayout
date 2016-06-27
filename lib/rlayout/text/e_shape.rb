
module RLayout
	
	# EShape, E Shaped Object
	# It refers to shapes that looks like "E".
	# On the left size with images and on the right side list of texts.
	# Admonition, 
	# Itmes text with Image, 
	# Logo with image, companly name, and web site url
	# EShape
	# stem refers to image box on the left.
	# brances refers to list of text on the right side.
	class EShape < Container
		attr_accessor :stem, :branches, :stem_length, :stem_alignment, :comb_length, :reverse
		def initialize(options={}, &block)
		  @reverse = options.fetch(:reverse, false)
		  create_stem(options)
		  create_branches(options)
		  relayout!
		  self
		end
		
		def create_stem(options={})
		  @stem_length    = options.fetch(:stem_length, 1)
		  @stem_alignment = options.fetch(:stem_alignment, 'top')
		  # creating code here
		end
		
		def create_branches(options)
		  @branches_length = options.fetch(:branches_length, 4)
		  # creating code here
		  
		end
		
	end


	
end